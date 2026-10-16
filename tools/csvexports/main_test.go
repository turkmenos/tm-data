package main

import (
	"os"
	"path/filepath"
	"testing"
)

func TestGenerateQuotesUTF8AndPreservesNumbers(t *testing.T) {
	path := filepath.Join(t.TempDir(), "data.json")
	if err := os.WriteFile(path, []byte(`[{"id":"001","name":"Aşgabat, şäher","active":true}]`), 0o644); err != nil {
		t.Fatal(err)
	}
	got, err := generate(path, specification{JSON: "data.json", Columns: []string{"id", "name", "active"}})
	if err != nil {
		t.Fatal(err)
	}
	want := "id,name,active\n001,\"Aşgabat, şäher\",true\n"
	if string(got) != want {
		t.Fatalf("got %q, want %q", got, want)
	}
}

func TestGenerateRejectsUnmappedFields(t *testing.T) {
	path := filepath.Join(t.TempDir(), "data.json")
	if err := os.WriteFile(path, []byte(`[{"id":1,"extra":2}]`), 0o644); err != nil {
		t.Fatal(err)
	}
	if _, err := generate(path, specification{JSON: "data.json", Columns: []string{"id"}}); err == nil {
		t.Fatal("accepted unmapped field")
	}
}
