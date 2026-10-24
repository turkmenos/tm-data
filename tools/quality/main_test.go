package main

import (
	"bytes"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

const testCatalog = `{"schema_version":"1.0.0","datasets":[
 {"id":"geo","title":"Geo","location":"geo","version":"sha256:geo","resources":[
  {"path":"geo/regions.json","format":"json","version":"sha256:a","record_count":3,"record_unit":"records"},
  {"path":"geo/aliases.json","format":"json","version":"sha256:b","record_count":1,"record_unit":"records"}]},
 {"id":"utils-words","title":"Utils Words","location":"utils/words","version":"sha256:words","resources":[
  {"path":"utils/words/words.json","format":"json","version":"sha256:c","record_count":2,"record_unit":"records"},
  {"path":"utils/words/words.txt","format":"text","version":"sha256:d","record_count":null,"record_unit":null}]}]}`

const testRules = `{"version":1,"datasets":[
 {"path":"geo/regions.json","required":{"slug":"string","name":"string"},"non_empty":["slug"],"unique":[["slug"]]},
 {"path":"geo/aliases.json","required":{"region_slug":"string"}}],
 "references":[{"from_path":"geo/aliases.json","from_field":"region_slug","to_path":"geo/regions.json","to_field":"slug"}]}`

const testConfig = `{"version":1,"datasets":[
 {"id":"geo","record_resources":[{"pattern":"geo/regions.json"}],"metrics":[
  {"path":"geo/regions.json","verification":{"field":"status","verified":["verified"]},
   "source_fields":["source_url"],"coordinate_fields":["lat","lon"]}]},
 {"id":"utils-words","record_resources":[{"format":"json"}]}]}`

const testRegions = `[
 {"slug":"a","name":"Aşgabat","status":"verified","source_url":"https://example.org","lat":37.9,"lon":58.4},
 {"slug":"b","name":"Mary","status":"verification_required","source_url":"https://example.org","lat":null,"lon":null},
 {"slug":"c","name":"Daşoguz","status":"verified","source_url":"","lat":41.8,"lon":59.9}]`

func writeRepository(t *testing.T, files map[string]string) {
	t.Helper()
	root := t.TempDir()
	base := map[string]string{
		"catalog.json":               testCatalog,
		"tools/integrity/rules.json": testRules,
		"tools/quality/config.json":  testConfig,
		"geo/regions.json":           testRegions,
		"geo/aliases.json":           `[{"region_slug":"a"}]`,
		"utils/words/words.json":     `["bir","iki"]`,
		"utils/words/words.txt":      "bir\niki\n",
	}
	for name, content := range files {
		base[name] = content
	}
	for name, content := range base {
		path := filepath.Join(root, filepath.FromSlash(name))
		if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(path, []byte(content), 0o644); err != nil {
			t.Fatal(err)
		}
	}
	previous, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	if err := os.Chdir(root); err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = os.Chdir(previous) })
}

func testOptions() options {
	return options{CatalogPath: defaultCatalog, ConfigPath: defaultConfig, RulesPath: defaultRules, OutputPath: defaultOutput}
}

func buildReport(t *testing.T) report {
	t.Helper()
	value, err := build(testOptions())
	if err != nil {
		t.Fatal(err)
	}
	return value
}

func dataset(t *testing.T, value report, id string) datasetReport {
	t.Helper()
	for _, item := range value.Datasets {
		if item.Dataset == id {
			return item
		}
	}
	t.Fatalf("dataset %q not in report", id)
	return datasetReport{}
}

func TestWarningsAndNullableMetrics(t *testing.T) {
	writeRepository(t, nil)
	value := buildReport(t)
	if value.Status != statusWarning || value.Totals.Errors != 0 || value.Totals.Warning != 1 || value.Totals.Passed != 1 {
		t.Fatalf("unexpected totals: %s %+v", value.Status, value.Totals)
	}

	geo := dataset(t, value, "geo")
	if geo.Status != statusWarning || *geo.RecordCount != 3 || *geo.RecordUnit != "records" {
		t.Fatalf("unexpected geo report: %+v", geo)
	}
	m := geo.Metrics
	if *m.UnverifiedRecords != 1 || *m.MissingSources != 1 || *m.MissingCoordinates != 1 {
		t.Fatalf("unexpected geo metrics: %+v", m)
	}
	if *m.SchemaViolations != 0 || *m.ReferentialIntegrityErrors != 0 || geo.Checks.Schema != checkPassed || geo.Checks.References != checkPassed {
		t.Fatalf("unexpected geo checks: %+v %+v", geo.Checks, m)
	}
	if len(geo.Warnings) != 3 {
		t.Fatalf("expected 3 warnings, got %q", geo.Warnings)
	}

	words := dataset(t, value, "utils-words")
	if words.Status != statusPassed || *words.RecordCount != 2 || words.Metrics.FilesChecked != 1 {
		t.Fatalf("unexpected words report: %+v", words)
	}
	if words.Checks.Schema != checkNotConfigured || words.Metrics.SchemaViolations != nil || words.Metrics.UnverifiedRecords != nil {
		t.Fatalf("unconfigured checks must be null: %+v %+v", words.Checks, words.Metrics)
	}
	encoded, err := render(value)
	if err != nil || !bytes.Contains(encoded, []byte(`"unverified_records": null`)) {
		t.Fatalf("render: %v", err)
	}
}

func TestErrorsAreClassified(t *testing.T) {
	writeRepository(t, map[string]string{
		"geo/regions.json":       `[{"slug":"a","name":1},{"slug":"a","name":"B"},{"name":"C"}]`,
		"geo/aliases.json":       `[{"region_slug":"missing"}]`,
		"utils/words/words.json": "[\"bir\",\"bir\"]",
		"utils/words/extra.json": "[\"\xff\"]",
		"stray.json":             `{"a":1,"a":2}`,
	})
	value := buildReport(t)
	if value.Status != statusError {
		t.Fatalf("expected error status, got %s", value.Status)
	}

	geo := dataset(t, value, "geo")
	if geo.Checks.Schema != checkFailed || geo.Checks.References != checkFailed || geo.Checks.Duplicates != checkFailed {
		t.Fatalf("unexpected geo checks: %+v", geo.Checks)
	}
	if *geo.Metrics.MissingRequiredFields != 2 || *geo.Metrics.SchemaViolations != 3 || *geo.Metrics.ReferentialIntegrityErrors != 1 || geo.Metrics.DuplicateRecords != 1 {
		t.Fatalf("unexpected geo metrics: %+v", geo.Metrics)
	}

	words := dataset(t, value, "utils-words")
	if words.Checks.UTF8 != checkFailed || words.Checks.Duplicates != checkPassed || words.Metrics.InvalidUTF8Files != 1 || words.Metrics.DuplicateRecords != 0 {
		t.Fatalf("unexpected words checks: %+v %+v", words.Checks, words.Metrics)
	}

	if value.Repository.Status != statusError || value.Repository.ErrorCount != 1 || value.Repository.Errors[0].Check != "syntax" {
		t.Fatalf("unexpected repository report: %+v", value.Repository)
	}
	if value.Totals.Errors != geo.ErrorCount+words.ErrorCount+1 {
		t.Fatalf("totals do not add up: %+v", value.Totals)
	}
}

func TestDeterministicAndSkipsOwnOutput(t *testing.T) {
	writeRepository(t, nil)
	first, err := render(buildReport(t))
	if err != nil {
		t.Fatal(err)
	}
	if err := os.MkdirAll(filepath.Dir(defaultOutput), 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(defaultOutput, first, 0o644); err != nil {
		t.Fatal(err)
	}
	second, err := render(buildReport(t))
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(first, second) {
		t.Fatal("report changed after writing it; output must be excluded and ordering deterministic")
	}
}

func TestDataSourcesAreNotModified(t *testing.T) {
	writeRepository(t, nil)
	before, err := os.ReadFile("geo/regions.json")
	if err != nil {
		t.Fatal(err)
	}
	buildReport(t)
	after, err := os.ReadFile("geo/regions.json")
	if err != nil || !bytes.Equal(before, after) {
		t.Fatal("source dataset was modified")
	}
}

func TestInvalidConfig(t *testing.T) {
	for name, cfg := range map[string]string{
		"unknown dataset": `{"version":1,"datasets":[{"id":"nope","record_resources":[{"format":"json"}]}]}`,
		"empty selector":  `{"version":1,"datasets":[{"id":"geo","record_resources":[{"pattern":"geo/none.json"}]}]}`,
		"outside path":    `{"version":1,"datasets":[{"id":"geo","record_resources":[{"format":"json"}],"metrics":[{"path":"utils/words/words.json","source_fields":["x"]}]}]}`,
		"unknown field":   `{"version":1,"datasets":[],"extra":true}`,
		"bad version":     `{"version":2,"datasets":[]}`,
	} {
		t.Run(name, func(t *testing.T) {
			writeRepository(t, map[string]string{"tools/quality/config.json": cfg})
			if _, err := build(testOptions()); err == nil {
				t.Fatal("accepted invalid config")
			}
		})
	}
}

func TestUnconfiguredDatasetWarns(t *testing.T) {
	writeRepository(t, map[string]string{"tools/quality/config.json": `{"version":1,"datasets":[]}`})
	words := dataset(t, buildReport(t), "utils-words")
	if words.Status != statusWarning || words.RecordCount != nil || !strings.Contains(words.Warnings[0], "config.json") {
		t.Fatalf("unexpected report: %+v", words)
	}
}

func TestRecordsKeyAndMixedUnits(t *testing.T) {
	writeRepository(t, map[string]string{
		"catalog.json": strings.Replace(testCatalog, `"record_count":1,"record_unit":"records"`, `"record_count":1,"record_unit":"names"`, 1),
		"tools/quality/config.json": `{"version":1,"datasets":[
		 {"id":"geo","record_resources":[{"format":"json"}],"metrics":[{"path":"geo/wrapped.json","records_key":"names","verification":{"field":"status","verified":[]}}]}]}`,
		"geo/wrapped.json": `{"names":[{"status":"unverified"},{"status":null}]}`,
	})
	geo := dataset(t, buildReport(t), "geo")
	if *geo.RecordCount != 4 || *geo.RecordUnit != "mixed" || *geo.Metrics.UnverifiedRecords != 2 {
		t.Fatalf("unexpected report: %+v", geo)
	}
}

func TestRepositoryHasNoQualityErrors(t *testing.T) {
	root, err := repositoryRoot()
	if err != nil {
		t.Fatal(err)
	}
	previous, _ := os.Getwd()
	if err := os.Chdir(root); err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = os.Chdir(previous) })
	value, err := build(testOptions())
	if err != nil {
		t.Fatal(err)
	}
	if value.Status == statusError {
		t.Fatalf("repository has %d quality error(s)", value.Totals.Errors)
	}
}
