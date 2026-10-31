package main

import (
	"encoding/json"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

type fixture struct {
	t    *testing.T
	repo repository
}

func newFixture(t *testing.T) *fixture {
	t.Helper()
	f := &fixture{t: t, repo: repository{dir: t.TempDir()}}
	f.run("init", "-q")
	return f
}

func (f *fixture) run(args ...string) string {
	f.t.Helper()
	cmd := exec.Command("git", append([]string{"-c", "user.name=Test", "-c", "user.email=test@example.org", "-c", "commit.gpgsign=false"}, args...)...)
	cmd.Dir = f.repo.dir
	out, err := cmd.CombinedOutput()
	if err != nil {
		f.t.Fatalf("git %v: %v\n%s", args, err, out)
	}
	return strings.TrimSpace(string(out))
}

// commit writes files (nil content removes a file), regenerates a minimal
// catalog from the given datasets, and returns the new commit.
func (f *fixture) commit(files map[string]*string, datasets []catalogDataset) string {
	f.t.Helper()
	for name, content := range files {
		path := filepath.Join(f.repo.dir, filepath.FromSlash(name))
		if content == nil {
			if err := os.Remove(path); err != nil {
				f.t.Fatal(err)
			}
			continue
		}
		if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
			f.t.Fatal(err)
		}
		if err := os.WriteFile(path, []byte(*content), 0o644); err != nil {
			f.t.Fatal(err)
		}
	}
	encoded, err := json.Marshal(catalog{Datasets: datasets})
	if err != nil {
		f.t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(f.repo.dir, "catalog.json"), encoded, 0o644); err != nil {
		f.t.Fatal(err)
	}
	f.run("add", "-A")
	f.run("commit", "-q", "-m", "update")
	return f.run("rev-parse", "HEAD")
}

func text(value string) *string { return &value }

func testConfig(t *testing.T) config {
	t.Helper()
	path := filepath.Join(t.TempDir(), "config.json")
	data := `{"version":1,"resources":[
		{"pattern":"geo/regions.json","key":["slug"]},
		{"pattern":"stories/**.json","records":"pages","key":["page_number"]},
		{"pattern":"utils/words/words.json"}]}`
	if err := os.WriteFile(path, []byte(data), 0o644); err != nil {
		t.Fatal(err)
	}
	cfg, err := loadConfig(path)
	if err != nil {
		t.Fatal(err)
	}
	return cfg
}

func geo(version string, resources ...catalogResource) catalogDataset {
	return catalogDataset{ID: "geo", Title: "Geo", Version: version, Formats: []string{"json"}, Documentation: []string{"geo/README.md"}, Resources: resources}
}

func find(t *testing.T, value report, id string) datasetChange {
	t.Helper()
	for _, item := range value.Datasets {
		if item.Dataset == id {
			return item
		}
	}
	t.Fatalf("dataset %q not in report", id)
	return datasetChange{}
}

func TestKeyedRecordChanges(t *testing.T) {
	f := newFixture(t)
	from := f.commit(map[string]*string{
		"geo/regions.json": text(`[{"slug":"a","name":"Aşgabat"},{"slug":"b","name":"Mary"},{"slug":"c","name":"Lebap"}]`),
	}, []catalogDataset{geo("v1", catalogResource{"geo/regions.json", "json", "r1"})})
	to := f.commit(map[string]*string{
		"geo/regions.json": text(`[{"slug":"a","name":"Aşgabat"},{"slug":"b","name":"Mary şäheri"},{"slug":"d","name":"Daşoguz"},{"slug":"e","name":"Balkan"}]`),
	}, []catalogDataset{geo("v2", catalogResource{"geo/regions.json", "json", "r2"})})

	value, err := build(f.repo, testConfig(t), from, to)
	if err != nil {
		t.Fatal(err)
	}
	item := find(t, value, "geo")
	if item.Changes != (counts{Added: 2, Modified: 1, Deleted: 1}) || value.Summary.Changes != item.Changes {
		t.Fatalf("unexpected counts %+v / %+v", item.Changes, value.Summary)
	}
	record := item.Records[0]
	if record.Identity != "key: slug" || strings.Join(record.AddedIDs, ",") != "d,e" || record.ModifiedIDs[0] != "b" || record.DeletedIDs[0] != "c" {
		t.Fatalf("unexpected record change %+v", record)
	}
	if *item.FromVersion != "v1" || *item.ToVersion != "v2" || item.Status != statusChanged {
		t.Fatalf("versions not taken from catalog: %+v", item)
	}
	if !value.Summary.Breaking || len(item.Breaking) != 1 || !strings.Contains(item.Breaking[0], "deleted") {
		t.Fatalf("deleting a keyed record must be breaking: %q", item.Breaking)
	}
	markdown := renderMarkdown(value)
	for _, want := range []string{"2 records in `geo/regions.json`", "1 record updated", "1 record from `geo/regions.json`", "#### Breaking changes"} {
		if !strings.Contains(markdown, want) {
			t.Errorf("markdown lacks %q:\n%s", want, markdown)
		}
	}
}

func TestSchemaFormatAndResourceChanges(t *testing.T) {
	f := newFixture(t)
	from := f.commit(map[string]*string{
		"geo/regions.json": text(`[{"slug":"a","name":"A","old":1}]`),
		"geo/regions.sql":  text("select 1;"),
	}, []catalogDataset{{ID: "geo", Title: "Geo", Version: "v1", Formats: []string{"json", "sql"}, Documentation: []string{"geo/README.md"},
		Resources: []catalogResource{{"geo/regions.json", "json", "r1"}, {"geo/regions.sql", "sql", "s1"}}}})
	to := f.commit(map[string]*string{
		"geo/regions.json": text(`[{"slug":"a","name":"A","new":1}]`),
		"geo/regions.sql":  nil,
		"geo/regions.csv":  text("slug,name\na,A\n"),
	}, []catalogDataset{{ID: "geo", Title: "Geography", Version: "v2", Formats: []string{"csv", "json"}, Documentation: []string{"geo/README.md", "geo/NOTES.md"},
		Resources: []catalogResource{{"geo/regions.csv", "csv", "c1"}, {"geo/regions.json", "json", "r2"}}}})

	value, err := build(f.repo, testConfig(t), from, to)
	if err != nil {
		t.Fatal(err)
	}
	item := find(t, value, "geo")
	if strings.Join(item.Formats.Added, ",") != "csv" || strings.Join(item.Formats.Removed, ",") != "sql" {
		t.Fatalf("unexpected formats %+v", item.Formats)
	}
	if strings.Join(item.Resources.Added, ",") != "geo/regions.csv" || strings.Join(item.Resources.Removed, ",") != "geo/regions.sql" {
		t.Fatalf("unexpected resources %+v", item.Resources)
	}
	if len(item.Schema) != 1 || item.Schema[0].AddedFields[0] != "new" || item.Schema[0].RemovedFields[0] != "old" {
		t.Fatalf("unexpected schema %+v", item.Schema)
	}
	if item.Changes != (counts{Modified: 1}) {
		t.Fatalf("unexpected counts %+v", item.Changes)
	}
	joined := strings.Join(item.Metadata, "\n")
	if !strings.Contains(joined, "title changed") || !strings.Contains(joined, "documentation added: geo/NOTES.md") {
		t.Fatalf("unexpected metadata %q", item.Metadata)
	}
	breaking := strings.Join(item.Breaking, "\n")
	for _, want := range []string{"format sql", "resource geo/regions.sql removed", `field "old" removed`} {
		if !strings.Contains(breaking, want) {
			t.Errorf("breaking lacks %q: %q", want, item.Breaking)
		}
	}
}

func TestDatasetAddedRemovedAndContentComparison(t *testing.T) {
	f := newFixture(t)
	words := catalogDataset{ID: "utils-words", Title: "Words", Version: "w1", Formats: []string{"json"}, Resources: []catalogResource{{"utils/words/words.json", "json", "w1"}}}
	from := f.commit(map[string]*string{
		"geo/regions.json":       text(`[{"slug":"a"}]`),
		"utils/words/words.json": text(`["bir","iki","iki"]`),
	}, []catalogDataset{geo("v1", catalogResource{"geo/regions.json", "json", "r1"}), words})
	words.Version, words.Resources[0].Version = "w2", "w2"
	stories := catalogDataset{ID: "stories", Title: "Stories", Version: "s1", Formats: []string{"json"}, Resources: []catalogResource{{"stories/a/b/book.json", "json", "b1"}}}
	to := f.commit(map[string]*string{
		"geo/regions.json":       nil,
		"utils/words/words.json": text(`["bir","iki","üç"]`),
		"stories/a/b/book.json":  text(`{"source_file":"book.pdf","pages":[{"page_number":1,"text":"A"},{"page_number":2,"text":"B"}]}`),
	}, []catalogDataset{stories, words})

	value, err := build(f.repo, testConfig(t), from, to)
	if err != nil {
		t.Fatal(err)
	}
	if removed := find(t, value, "geo"); removed.Status != statusRemoved || removed.Changes.Deleted != 1 || removed.ToVersion != nil || removed.Breaking[0] != "dataset removed" {
		t.Fatalf("unexpected removed dataset %+v", removed)
	}
	if added := find(t, value, "stories"); added.Status != statusAdded || added.Changes.Added != 2 || added.FromVersion != nil {
		t.Fatalf("unexpected added dataset (nested ** pattern) %+v", added)
	}
	changed := find(t, value, "utils-words")
	if changed.Changes != (counts{Added: 1, Deleted: 1}) || changed.Records[0].Identity != identityContent || !strings.Contains(changed.Records[0].Note, "without stable identifiers") {
		t.Fatalf("unexpected content comparison %+v", changed.Records)
	}
	if len(changed.Breaking) != 0 {
		t.Fatalf("content-only deletions are not breaking: %q", changed.Breaking)
	}
}

func TestStaleCatalogUsesGitContent(t *testing.T) {
	f := newFixture(t)
	// The file exists in the first commit, but that commit's catalog omits it.
	from := f.commit(map[string]*string{"geo/regions.json": text(`[{"slug":"a"}]`)},
		[]catalogDataset{geo("v1")})
	to := f.commit(map[string]*string{"geo/regions.json": text(`[{"slug":"a"},{"slug":"b"}]`)},
		[]catalogDataset{geo("v2", catalogResource{"geo/regions.json", "json", "r2"})})
	value, err := build(f.repo, testConfig(t), from, to)
	if err != nil {
		t.Fatal(err)
	}
	item := find(t, value, "geo")
	if item.Changes != (counts{Added: 1}) || len(item.Resources.Added) != 0 || item.Resources.Modified[0] != "geo/regions.json" {
		t.Fatalf("stale catalog misreported changes: %+v %+v", item.Changes, item.Resources)
	}
	if !strings.Contains(strings.Join(item.Metadata, ""), "missing from the previous catalog") {
		t.Fatalf("expected stale catalog note, got %q", item.Metadata)
	}
}

func TestDuplicateKeysFallBackToContent(t *testing.T) {
	f := newFixture(t)
	from := f.commit(map[string]*string{"geo/regions.json": text(`[{"slug":"a","n":1}]`)},
		[]catalogDataset{geo("v1", catalogResource{"geo/regions.json", "json", "r1"})})
	to := f.commit(map[string]*string{"geo/regions.json": text(`[{"slug":"a","n":1},{"slug":"a","n":2}]`)},
		[]catalogDataset{geo("v2", catalogResource{"geo/regions.json", "json", "r2"})})
	value, err := build(f.repo, testConfig(t), from, to)
	if err != nil {
		t.Fatal(err)
	}
	record := find(t, value, "geo").Records[0]
	if record.Identity != identityContent || record.Added != 1 || !strings.Contains(record.Note, "not unique") {
		t.Fatalf("unexpected fallback %+v", record)
	}
}

func TestUnchangedAndRecomputedVersions(t *testing.T) {
	f := newFixture(t)
	from := f.commit(map[string]*string{"geo/regions.json": text(`[{"slug":"a"}]`)},
		[]catalogDataset{geo("v1", catalogResource{"geo/regions.json", "json", "r1"})})
	same := f.commit(map[string]*string{"notes.txt": text("x")},
		[]catalogDataset{geo("v1", catalogResource{"geo/regions.json", "json", "r1"})})
	value, err := build(f.repo, testConfig(t), from, same)
	if err != nil {
		t.Fatal(err)
	}
	if len(value.Datasets) != 0 || !strings.Contains(renderMarkdown(value), "No dataset changes.") {
		t.Fatalf("expected no changes, got %+v", value.Datasets)
	}
	recomputed := f.commit(map[string]*string{"notes.txt": text("y")},
		[]catalogDataset{geo("v9", catalogResource{"geo/regions.json", "json", "r1"})})
	value, err = build(f.repo, testConfig(t), from, recomputed)
	if err != nil {
		t.Fatal(err)
	}
	if item := find(t, value, "geo"); !strings.Contains(strings.Join(item.Metadata, ""), "without any file content change") {
		t.Fatalf("expected recomputed note, got %q", item.Metadata)
	}
}

func TestDeterministicReportAndChangelogUpdate(t *testing.T) {
	f := newFixture(t)
	from := f.commit(map[string]*string{"geo/regions.json": text(`[{"slug":"a"}]`)},
		[]catalogDataset{geo("v1", catalogResource{"geo/regions.json", "json", "r1"})})
	to := f.commit(map[string]*string{"geo/regions.json": text(`[{"slug":"a"},{"slug":"b"},{"slug":"c"}]`)},
		[]catalogDataset{geo("v2", catalogResource{"geo/regions.json", "json", "r2"})})
	first, _ := build(f.repo, testConfig(t), from, to)
	second, _ := build(f.repo, testConfig(t), from, to)
	a, _ := renderJSON(first)
	b, _ := renderJSON(second)
	if string(a) != string(b) {
		t.Fatal("report is not deterministic")
	}

	path := filepath.Join(t.TempDir(), "CHANGELOG.md")
	if err := os.WriteFile(path, []byte("# Changelog\n\n"+entriesMarker+"\n\nOlder entry\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	for range 2 {
		if err := updateChangelog(path, first); err != nil {
			t.Fatal(err)
		}
	}
	data, _ := os.ReadFile(path)
	content := string(data)
	if strings.Count(content, rangeMarker(first)) != 1 || !strings.HasSuffix(content, "Older entry\n") || strings.Index(content, "2 records") > strings.Index(content, "Older entry") {
		t.Fatalf("changelog entry not inserted once above older entries:\n%s", content)
	}
}

func TestInvalidInputs(t *testing.T) {
	f := newFixture(t)
	head := f.commit(map[string]*string{"geo/regions.json": text(`[]`)}, []catalogDataset{geo("v1")})
	if _, err := build(f.repo, testConfig(t), "no-such-revision", head); err == nil {
		t.Fatal("accepted unknown revision")
	}
	path := filepath.Join(t.TempDir(), "config.json")
	if err := os.WriteFile(path, []byte(`{"version":1,"resources":[{"pattern":"a.json","map":true,"key":["id"]}]}`), 0o644); err != nil {
		t.Fatal(err)
	}
	if _, err := loadConfig(path); err == nil {
		t.Fatal("accepted map collection with key")
	}
}

func TestGlobPattern(t *testing.T) {
	for _, test := range []struct {
		pattern, path string
		want          bool
	}{
		{"poetry/json/*/poetry.json", "poetry/json/kemine/poetry.json", true},
		{"poetry/json/*/poetry.json", "poetry/json/a/b/poetry.json", false},
		{"stories/**.json", "stories/a/b/c d/Ödäýew.json", true},
		{"utils/calendar/*.json", "utils/calendar/months.csv", false},
	} {
		if got := globPattern(test.pattern).MatchString(test.path); got != test.want {
			t.Errorf("%s ~ %s: got %v", test.pattern, test.path, got)
		}
	}
}
