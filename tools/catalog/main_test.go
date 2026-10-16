package main

import (
	"bytes"
	"os"
	"path/filepath"
	"testing"
)

func TestCountsUseCollections(t *testing.T) {
	value, err := parseJSON([]byte(`{"page_count":999,"pages":[{},{}]}`))
	if err != nil {
		t.Fatal(err)
	}
	got, unit, err := countRecords(value, "stories/a.json")
	if err != nil || got == nil || *got != 2 || unit == nil || *unit != "pages" {
		t.Fatalf("got %v %v %v", got, unit, err)
	}
}

func TestRejectsInvalidJSON(t *testing.T) {
	for _, data := range [][]byte{[]byte(`{"a":1,"a":2}`), []byte(`NaN`), {'"', 0xff, '"'}} {
		if _, err := parseJSON(data); err == nil {
			t.Errorf("accepted invalid JSON %q", data)
		}
	}
}

func TestAdditionalFormats(t *testing.T) {
	for _, test := range []struct {
		name, data, format string
		want               int
	}{{"a.csv", "name\n\"A,B\"\n", "csv", 1}, {"a.jsonl", "{}\n\n{}\n", "jsonl", 2}} {
		got, _, err := countFile(test.name, test.name, []byte(test.data), test.format)
		if err != nil || got == nil || *got != test.want {
			t.Fatalf("%s: got %v, %v", test.name, got, err)
		}
	}
	if _, _, err := countFile("a.csv", "a.csv", []byte("a,b\n1\n"), "csv"); err == nil {
		t.Fatal("accepted inconsistent CSV")
	}
}

func TestInventoryAndVersions(t *testing.T) {
	root := t.TempDir()
	for _, name := range []string{"dictionary", "geo", "poetry", "stories", "utils/colors"} {
		if err := os.MkdirAll(filepath.Join(root, name), 0o755); err != nil {
			t.Fatal(err)
		}
	}
	path := filepath.Join(root, "utils/colors/colors.json")
	if err := os.WriteFile(path, []byte(`[{"name":"Ýaşyl"}]`), 0o644); err != nil {
		t.Fatal(err)
	}
	first, err := build(root)
	if err != nil {
		t.Fatal(err)
	}
	if len(first.Datasets) != 1 || *first.Datasets[0].Resources[0].RecordCount != 1 {
		t.Fatalf("unexpected catalog: %#v", first)
	}
	encoded, err := render(first)
	if err != nil || !bytes.Contains(encoded, []byte("colors.json")) {
		t.Fatalf("render: %v", err)
	}
	if err := os.WriteFile(path, []byte(`[{"name":"Gök"}]`), 0o644); err != nil {
		t.Fatal(err)
	}
	second, err := build(root)
	if err != nil {
		t.Fatal(err)
	}
	if first.Datasets[0].Version == second.Datasets[0].Version {
		t.Fatal("content change did not change version")
	}
	newPath := filepath.Join(filepath.Dir(path), "renamed.json")
	if err := os.Rename(path, newPath); err != nil {
		t.Fatal(err)
	}
	third, err := build(root)
	if err != nil {
		t.Fatal(err)
	}
	if second.Datasets[0].Version == third.Datasets[0].Version {
		t.Fatal("rename did not change version")
	}
}
