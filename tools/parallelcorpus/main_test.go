package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func fixture(t *testing.T) corpus {
	t.Helper()
	c, err := load("../../language/parallel-corpus")
	if err != nil {
		t.Fatal(err)
	}
	return c
}

func text(s string) *string { return &s }

func TestCuratedCorpus(t *testing.T) {
	if err := run("../../language/parallel-corpus", true); err != nil {
		t.Fatal(err)
	}
}

func TestRejectsInvalidRecords(t *testing.T) {
	tests := []struct {
		name, want string
		mutate     func(*corpus)
	}{
		{"duplicate id", "duplicate id", func(c *corpus) { c.Sentences[1].ID = c.Sentences[0].ID }},
		{"order", "ascending id order", func(c *corpus) { c.Sentences[0], c.Sentences[1] = c.Sentences[1], c.Sentences[0] }},
		{"id format", "sentence-NNNNNN", func(c *corpus) { c.Sentences[0].ID = "sentence-1" }},
		{"duplicate Turkmen", "duplicate Turkmen sentence", func(c *corpus) { c.Sentences[1].Translations.TK = "salam   NÄHILI" }},
		{"missing translation", "Turkish or English", func(c *corpus) { c.Sentences[0].Translations.TR, c.Sentences[0].Translations.EN = nil, nil }},
		{"empty", "sentence is empty", func(c *corpus) { c.Sentences[0].Translations.EN = text("") }},
		{"whitespace", "trailing whitespace", func(c *corpus) { c.Sentences[0].Translations.TR = text("Merhaba, nasılsın? ") }},
		{"non-NFC", "NFC", func(c *corpus) { c.Sentences[0].Translations.TK = "Salam, nähili?" }},
		{"Turkish letter in Turkmen", "non-Turkmen letter", func(c *corpus) { c.Sentences[0].Translations.TK = "Salam, nasılsın?" }},
		{"Cyrillic in Turkmen", "non-Turkmen letter", func(c *corpus) { c.Sentences[0].Translations.TK = "Салам?" }},
		{"misaligned punctuation", "ends with", func(c *corpus) { c.Sentences[0].Translations.EN = text("Hello.") }},
		{"misaligned numerals", "numerals", func(c *corpus) { c.Sentences[0].Translations.EN = text("Hello 2 you?") }},
		{"category", "unknown category", func(c *corpus) { c.Sentences[0].Category = "misc" }},
		{"status", "unknown verification_status", func(c *corpus) { c.Sentences[0].VerificationStatus = "verified" }},
		{"unknown source", "not defined in sources.json", func(c *corpus) { c.Sentences[0].Source = "unknown" }},
		{"empty rights", "rights is required", func(c *corpus) { c.Sources[0].Rights = "" }},
		{"external without url", "need a url", func(c *corpus) { c.Sources[0].Type = "website" }},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			c := fixture(t)
			test.mutate(&c)
			err := validate(c)
			if err == nil || !strings.Contains(err.Error(), test.want) {
				t.Fatalf("got %v, want error containing %q", err, test.want)
			}
		})
	}
}

func TestPairRecordsExportEmptyCells(t *testing.T) {
	c := fixture(t)
	c.Sentences = c.Sentences[:1]
	c.Sentences[0].Translations.EN = nil
	if err := validate(c); err != nil {
		t.Fatal(err)
	}
	got, err := renderCSV(c.Sentences)
	if err != nil {
		t.Fatal(err)
	}
	want := "id,tk,tr,en,category,verification_status,source\nsentence-000001,\"Salam, nähili?\",\"Merhaba, nasılsın?\",,greetings,unverified,tm-data-original-2026\n"
	if string(got) != want {
		t.Fatalf("got %q, want %q", got, want)
	}
	rendered, err := renderJSON(c.Sentences)
	if err != nil {
		t.Fatal(err)
	}
	if strings.Contains(string(rendered), `"en"`) {
		t.Fatalf("absent translation rendered: %s", rendered)
	}
}

func TestLoadRejectsMalformedFiles(t *testing.T) {
	tests := map[string]string{
		"unknown field":    `[{"id":"sentence-000001","translations":{"tk":"Salam.","de":"Hallo."},"category":"greetings","verification_status":"unverified","source":"s"}]`,
		"invalid UTF-8":    "[\"\xff\"]",
		"trailing content": `[] []`,
	}
	for name, content := range tests {
		t.Run(name, func(t *testing.T) {
			dir := t.TempDir()
			if err := os.WriteFile(filepath.Join(dir, "sentences.json"), []byte(content), 0o644); err != nil {
				t.Fatal(err)
			}
			if err := os.WriteFile(filepath.Join(dir, "sources.json"), []byte(`[]`), 0o644); err != nil {
				t.Fatal(err)
			}
			if _, err := load(dir); err == nil {
				t.Fatal("accepted malformed file")
			}
		})
	}
}

func TestCheckDetectsStaleExport(t *testing.T) {
	dir := t.TempDir()
	for _, name := range []string{"sentences.json", "sentences.csv", "sources.json"} {
		data, err := os.ReadFile(filepath.Join("../../language/parallel-corpus", name))
		if err != nil {
			t.Fatal(err)
		}
		if name == "sentences.csv" {
			data = append(data, '\n')
		}
		if err := os.WriteFile(filepath.Join(dir, name), data, 0o644); err != nil {
			t.Fatal(err)
		}
	}
	if err := run(dir, true); err == nil || !strings.Contains(err.Error(), "sentences.csv") {
		t.Fatalf("got %v, want stale CSV error", err)
	}
}
