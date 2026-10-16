package main

import (
	"encoding/json"
	"os"
	"path/filepath"
	"testing"
)

func TestGenerateAddsGenderAndProvenance(t *testing.T) {
	root := t.TempDir()
	for _, source := range sourceFiles {
		path := filepath.Join(root, filepath.FromSlash(source.Path))
		if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
			t.Fatal(err)
		}
		name := map[string]string{"male": "M", "female": "F", "unisex": "U"}[source.Gender]
		if err := os.WriteFile(path, []byte(`[{"name":"`+name+`","description":"meaning"}]`), 0o644); err != nil {
			t.Fatal(err)
		}
	}
	output, err := generate(root)
	if err != nil {
		t.Fatal(err)
	}
	var got dataset
	if err := json.Unmarshal(output, &got); err != nil {
		t.Fatal(err)
	}
	if got.RecordCount != 3 || len(got.Names) != 3 || got.Provenance.Status != "source_unknown" {
		t.Fatalf("unexpected dataset: %#v", got)
	}
	for _, item := range got.Names {
		if item.Gender == "" || item.VerificationStatus != "unverified" || item.SourceIDs == nil {
			t.Fatalf("incomplete record: %#v", item)
		}
	}
}

func TestGenerateRejectsCrossFileDuplicate(t *testing.T) {
	root := t.TempDir()
	for _, source := range sourceFiles {
		path := filepath.Join(root, filepath.FromSlash(source.Path))
		if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(path, []byte(`[{"name":"Same","description":"meaning"}]`), 0o644); err != nil {
			t.Fatal(err)
		}
	}
	if _, err := generate(root); err == nil {
		t.Fatal("accepted duplicate name")
	}
}
