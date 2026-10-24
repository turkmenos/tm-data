package formatcheck

import (
	"os"
	"path/filepath"
	"testing"
)

func TestValidateFileKinds(t *testing.T) {
	dir := t.TempDir()
	for _, test := range []struct {
		name, content, kind string
	}{
		{"valid.json", `[{"a":1},{"a":2}]`, ""},
		{"duplicate.json", `[{"a":1},{"a":1}]`, KindDuplicate},
		{"key.json", `{"a":1,"a":2}`, KindSyntax},
		{"binary.json", "[\"\xff\"]", KindUTF8},
		{"lines.jsonl", "{}\n{\n", KindSyntax},
		{"header.csv", "x,x\n1,2\n", KindSyntax},
		{"rows.csv", "x,y\n1,2\n1,2\n", KindDuplicate},
	} {
		path := filepath.Join(dir, test.name)
		if err := os.WriteFile(path, []byte(test.content), 0o644); err != nil {
			t.Fatal(err)
		}
		problems := ValidateFile(path)
		if test.kind == "" {
			if len(problems) != 0 {
				t.Errorf("%s: unexpected problems %+v", test.name, problems)
			}
			continue
		}
		if len(problems) != 1 || problems[0].Kind != test.kind {
			t.Errorf("%s: want one %s problem, got %+v", test.name, test.kind, problems)
		}
	}
}

func TestDiscoverFilesSkipsExcludedDirectories(t *testing.T) {
	dir := t.TempDir()
	for _, name := range []string{"b.json", "a.csv", "notes.txt", "node_modules/x.json", ".git/y.json"} {
		path := filepath.Join(dir, name)
		if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(path, []byte("[]"), 0o644); err != nil {
			t.Fatal(err)
		}
	}
	files, err := DiscoverFiles([]string{dir})
	if err != nil {
		t.Fatal(err)
	}
	if len(files) != 2 || filepath.Base(files[0]) != "a.csv" || filepath.Base(files[1]) != "b.json" {
		t.Fatalf("unexpected files %q", files)
	}
}
