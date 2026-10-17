package main

import (
	"encoding/json"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func fixture(t *testing.T) dataset {
	t.Helper()
	d, err := load("../../language/morphology")
	if err != nil {
		t.Fatal(err)
	}
	return d
}
func TestCuratedDataset(t *testing.T) {
	if err := validate(fixture(t)); err != nil {
		t.Fatal(err)
	}
}
func TestRejectsBrokenAnalyses(t *testing.T) {
	tests := []struct {
		name, want string
		mutate     func(*dataset)
	}{
		{"reconstruction", "segments reconstruct", func(d *dataset) { d.Examples[0].Word = "kitaplarymyz" }},
		{"wrong harmony", "invalid allomorph", func(d *dataset) { d.Examples[0].Segments[0].Value = "ler" }},
		{"wrong order", "POS/order", func(d *dataset) { e := &d.Examples[0]; e.Segments[0], e.Segments[1] = e.Segments[1], e.Segments[0] }},
		{"unknown suffix", "unknown suffix", func(d *dataset) { d.Examples[0].Segments[0].SuffixID = "missing" }},
		{"unknown source", "invalid source", func(d *dataset) { d.Suffixes[0].References[0].SourceID = "missing" }},
		{"undocumented alternation", "unlicensed stem change", func(d *dataset) { d.Examples[0].Stem = "kitab" }},
		{"incompatible agreement", "incompatible predecessor", func(d *dataset) {
			for i := range d.Examples {
				if d.Examples[i].ID == "past-run-1sg" {
					d.Examples[i].Segments[1] = segment{"verb-present-1sg", "yn"}
				}
			}
		}},
		{"future negation", "incompatible suffix pair", func(d *dataset) {
			for i := range d.Examples {
				if d.Examples[i].ID == "future-read" {
					d.Examples[i].Segments = append([]segment{{"verb-negative", "ma"}}, d.Examples[i].Segments...)
				}
			}
		}},
		{"rounded allomorph", "invalid allomorph", func(d *dataset) {
			for i := range d.Examples {
				if d.Examples[i].ID == "past-be-1sg" {
					d.Examples[i].Segments[0].Value = "dy"
				}
			}
		}},
		{"third person buffer", "outside supported subset", func(d *dataset) {
			for i := range d.Examples {
				if d.Examples[i].ID == "their-father" {
					d.Examples[i].Segments = append(d.Examples[i].Segments, segment{"noun-locative", "da"})
				}
			}
		}},
		{"unknown exception", "unknown or mismatched exception", func(d *dataset) { d.Examples[0].ExceptionIDs = []string{"missing"} }},
		{"unlicensed voicing", "voicing before consonant", func(d *dataset) {
			for i := range d.Examples {
				if d.Examples[i].ID == "my-book" {
					d.Examples[i].Segments[0] = segment{"noun-plural", "lar"}
				}
			}
		}},
		{"empty alternation suffix", "empty first segment", func(d *dataset) {
			for i := range d.Examples {
				if d.Examples[i].ID == "my-book" {
					d.Examples[i].Segments[0].Value = ""
				}
			}
		}},
	}
	base := fixture(t)
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			b, _ := json.Marshal(base)
			var d dataset
			if err := json.Unmarshal(b, &d); err != nil {
				t.Fatal(err)
			}
			tt.mutate(&d)
			if err := validate(d); err == nil || !strings.Contains(err.Error(), tt.want) {
				t.Fatalf("wanted %q, got %v", tt.want, err)
			}
		})
	}
}

func TestLoadingRequiresSchemaFields(t *testing.T) {
	for _, tt := range []struct{ name, old, replacement, want string }{
		{"missing root", `"root": "kitap",`, "", "missing required field root"},
		{"null root", `"root": "kitap"`, `"root": null`, "null is not allowed"},
		{"unknown field", `"root": "kitap"`, `"unexpected": true, "root": "kitap"`, "unknown field"},
		{"missing empty list", `"exception_ids": [],`, "", "missing required field exception_ids"},
	} {
		t.Run(tt.name, func(t *testing.T) {
			dir := t.TempDir()
			for _, name := range []string{"sources.json", "suffixes.json", "rules.json", "exceptions.json", "examples.json"} {
				b, err := os.ReadFile(filepath.Join("../../language/morphology", name))
				if err != nil {
					t.Fatal(err)
				}
				if name == "examples.json" {
					b = []byte(strings.Replace(string(b), tt.old, tt.replacement, 1))
				}
				if err := os.WriteFile(filepath.Join(dir, name), b, 0o644); err != nil {
					t.Fatal(err)
				}
			}
			if _, err := load(dir); err == nil || !strings.Contains(err.Error(), tt.want) {
				t.Fatalf("wanted %q, got %v", tt.want, err)
			}
		})
	}
}
