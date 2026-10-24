package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"os"
	"path"
	"path/filepath"
	"sort"
	"strings"
	"unicode/utf8"

	"github.com/turkmenos/tm-data/internal/formatcheck"
	"github.com/turkmenos/tm-data/internal/integrity"
)

const (
	schemaVersion = "1.0.0"
	maxFindings   = 100

	statusPassed        = "passed"
	statusWarning       = "warning"
	statusError         = "error"
	checkPassed         = "passed"
	checkFailed         = "failed"
	checkNotConfigured  = "not_configured"
	defaultOutput       = "reports/quality/summary.json"
	defaultConfig       = "tools/quality/config.json"
	defaultRules        = "tools/integrity/rules.json"
	defaultCatalog      = "catalog.json"
	repositoryRootError = "repository root not found"
)

type options struct {
	CatalogPath string
	ConfigPath  string
	RulesPath   string
	OutputPath  string
}

type config struct {
	Version  int             `json:"version"`
	Datasets []datasetConfig `json:"datasets"`
}

type datasetConfig struct {
	ID              string         `json:"id"`
	RecordResources []selector     `json:"record_resources"`
	Metrics         []metricConfig `json:"metrics"`
}

type selector struct {
	Pattern string `json:"pattern"`
	Format  string `json:"format"`
}

type metricConfig struct {
	Path             string        `json:"path"`
	RecordsKey       string        `json:"records_key"`
	Verification     *verification `json:"verification"`
	SourceFields     []string      `json:"source_fields"`
	CoordinateFields []string      `json:"coordinate_fields"`
}

type verification struct {
	Field    string   `json:"field"`
	Verified []string `json:"verified"`
}

type catalog struct {
	Datasets []catalogDataset `json:"datasets"`
}

type catalogDataset struct {
	ID        string            `json:"id"`
	Title     string            `json:"title"`
	Location  string            `json:"location"`
	Version   string            `json:"version"`
	Resources []catalogResource `json:"resources"`
}

type catalogResource struct {
	Path        string  `json:"path"`
	Format      string  `json:"format"`
	RecordCount *int    `json:"record_count"`
	RecordUnit  *string `json:"record_unit"`
}

type report struct {
	SchemaVersion string           `json:"schema_version"`
	Status        string           `json:"status"`
	Inputs        inputs           `json:"inputs"`
	Totals        totals           `json:"totals"`
	Datasets      []datasetReport  `json:"datasets"`
	Repository    repositoryReport `json:"repository"`
	Limitations   []string         `json:"limitations"`
}

type inputs struct {
	Catalog        string `json:"catalog"`
	Config         string `json:"config"`
	IntegrityRules string `json:"integrity_rules"`
}

type totals struct {
	Datasets int `json:"datasets"`
	Passed   int `json:"passed"`
	Warning  int `json:"warning"`
	Error    int `json:"error"`
	Errors   int `json:"errors"`
	Warnings int `json:"warnings"`
}

type datasetReport struct {
	Dataset     string    `json:"dataset"`
	Title       string    `json:"title"`
	Location    string    `json:"location"`
	Version     string    `json:"version"`
	RecordCount *int      `json:"record_count"`
	RecordUnit  *string   `json:"record_unit"`
	Status      string    `json:"status"`
	Checks      checks    `json:"checks"`
	Metrics     metrics   `json:"metrics"`
	ErrorCount  int       `json:"error_count"`
	Errors      []finding `json:"errors"`
	Warnings    []string  `json:"warnings"`
}

type checks struct {
	UTF8       string `json:"utf8"`
	Syntax     string `json:"syntax"`
	Duplicates string `json:"duplicates"`
	Schema     string `json:"schema"`
	References string `json:"references"`
	Metrics    string `json:"metrics"`
}

type metrics struct {
	FilesChecked               int  `json:"files_checked"`
	InvalidUTF8Files           int  `json:"invalid_utf8_files"`
	SyntaxErrors               int  `json:"syntax_errors"`
	DuplicateRecords           int  `json:"duplicate_records"`
	MissingRequiredFields      *int `json:"missing_required_fields"`
	SchemaViolations           *int `json:"schema_violations"`
	ReferentialIntegrityErrors *int `json:"referential_integrity_errors"`
	UnverifiedRecords          *int `json:"unverified_records"`
	MissingSources             *int `json:"missing_sources"`
	MissingCoordinates         *int `json:"missing_coordinates"`
}

type finding struct {
	Path    string `json:"path"`
	Record  int    `json:"record,omitempty"`
	Check   string `json:"check"`
	Kind    string `json:"kind"`
	Message string `json:"message"`
}

type repositoryReport struct {
	Status       string    `json:"status"`
	FilesChecked int       `json:"files_checked"`
	ErrorCount   int       `json:"error_count"`
	Errors       []finding `json:"errors"`
}

var limitations = []string{
	"Checks are structural: passing does not prove factual accuracy, source reliability, or redistribution rights.",
	"Schema and reference checks cover only the files registered in tools/integrity/rules.json; other datasets report not_configured.",
	"Record-level metrics are null when tools/quality/config.json does not configure them for a dataset; null means unknown, not zero.",
	"Record counts come from catalog.json and are null when any selected resource has no supported counter.",
	"Error lists are truncated to the first 100 findings per dataset; error_count holds the full total.",
}

func main() {
	check := flag.Bool("check", false, "fail if the report file is stale instead of writing it")
	output := flag.String("output", defaultOutput, "report path relative to the repository root")
	flag.Parse()
	if flag.NArg() != 0 {
		fmt.Fprintln(os.Stderr, "usage: quality [--check] [--output path]")
		os.Exit(2)
	}

	root, err := repositoryRoot()
	if err == nil {
		err = os.Chdir(root)
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(2)
	}

	opts := options{CatalogPath: defaultCatalog, ConfigPath: defaultConfig, RulesPath: defaultRules, OutputPath: filepath.ToSlash(filepath.Clean(*output))}
	value, err := build(opts)
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(2)
	}
	encoded, err := render(value)
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(2)
	}

	printSummary(value)
	if *check {
		actual, readErr := os.ReadFile(opts.OutputPath)
		if readErr != nil || !bytes.Equal(actual, encoded) {
			fmt.Fprintf(os.Stderr, "ERROR: %s is missing or stale; run go run ./tools/quality\n", opts.OutputPath)
			os.Exit(1)
		}
		fmt.Printf("Passed: %s matches the current validation results.\n", opts.OutputPath)
	} else {
		if err := os.MkdirAll(filepath.Dir(opts.OutputPath), 0o755); err != nil {
			fmt.Fprintln(os.Stderr, "ERROR:", err)
			os.Exit(2)
		}
		if err := os.WriteFile(opts.OutputPath, encoded, 0o644); err != nil {
			fmt.Fprintln(os.Stderr, "ERROR:", err)
			os.Exit(2)
		}
		fmt.Printf("Generated %s\n", opts.OutputPath)
	}
	if value.Status == statusError {
		fmt.Printf("Failed: %d error(s) in the quality report.\n", value.Totals.Errors)
		os.Exit(1)
	}
}

func repositoryRoot() (string, error) {
	working, err := os.Getwd()
	if err != nil {
		return "", err
	}
	for current := working; ; current = filepath.Dir(current) {
		if _, err := os.Stat(filepath.Join(current, "go.mod")); err == nil {
			return current, nil
		}
		if filepath.Dir(current) == current {
			return "", errors.New(repositoryRootError)
		}
	}
}

// build validates the repository in the current directory. All paths in opts
// and in the input files are relative to it.
func build(opts options) (report, error) {
	var cat catalog
	if err := readStrictJSON(opts.CatalogPath, &cat, false); err != nil {
		return report{}, fmt.Errorf("%s: %w", opts.CatalogPath, err)
	}
	var cfg config
	if err := readStrictJSON(opts.ConfigPath, &cfg, true); err != nil {
		return report{}, fmt.Errorf("%s: %w", opts.ConfigPath, err)
	}
	if cfg.Version != 1 {
		return report{}, fmt.Errorf("%s: unsupported config version %d", opts.ConfigPath, cfg.Version)
	}
	rules, err := integrity.LoadConfig(opts.RulesPath)
	if err != nil {
		return report{}, fmt.Errorf("%s: %w", opts.RulesPath, err)
	}

	configs, err := indexConfigs(cfg, cat)
	if err != nil {
		return report{}, fmt.Errorf("%s: %w", opts.ConfigPath, err)
	}

	datasets := make([]*datasetReport, len(cat.Datasets))
	for index, item := range cat.Datasets {
		datasets[index] = newDatasetReport(item)
	}
	owner := func(file string) *datasetReport {
		var best *datasetReport
		for _, item := range datasets {
			if strings.HasPrefix(file, item.Location+"/") && (best == nil || len(item.Location) > len(best.Location)) {
				best = item
			}
		}
		return best
	}

	repo := repositoryReport{Errors: []finding{}}
	files, err := formatcheck.DiscoverFiles([]string{"."})
	if err != nil {
		return report{}, err
	}
	for _, file := range files {
		file = filepath.ToSlash(file)
		// Generated reports are outputs, not inputs; skipping them keeps the
		// report identical whether it is written in place or elsewhere.
		if file == opts.OutputPath || file == defaultOutput {
			continue
		}
		target := owner(file)
		if target == nil {
			repo.FilesChecked++
		} else {
			target.Metrics.FilesChecked++
		}
		for _, problem := range formatcheck.ValidateFile(file) {
			item := finding{Path: filepath.ToSlash(problem.Path), Kind: problem.Kind, Message: problem.Message, Check: formatCheckName(problem.Kind)}
			if target == nil {
				repo.Errors = append(repo.Errors, item)
				continue
			}
			switch item.Check {
			case "utf8":
				target.Metrics.InvalidUTF8Files++
				target.Checks.UTF8 = checkFailed
			case "syntax":
				target.Metrics.SyntaxErrors++
				target.Checks.Syntax = checkFailed
			case "duplicates":
				target.Metrics.DuplicateRecords++
				target.Checks.Duplicates = checkFailed
			}
			target.Errors = append(target.Errors, item)
		}
	}

	applyIntegrity(rules, owner, &repo)

	for _, item := range cat.Datasets {
		target := owner(item.Location + "/")
		dc, configured := configs[item.ID]
		if !configured {
			target.Warnings = append(target.Warnings, "dataset has no entry in tools/quality/config.json; record count and record-level metrics are unknown")
			continue
		}
		target.RecordCount, target.RecordUnit = recordCount(item, dc.RecordResources)
		if len(dc.Metrics) > 0 {
			applyMetrics(target, dc.Metrics)
		}
	}

	result := report{
		SchemaVersion: schemaVersion,
		Inputs:        inputs{Catalog: opts.CatalogPath, Config: opts.ConfigPath, IntegrityRules: opts.RulesPath},
		Datasets:      make([]datasetReport, 0, len(datasets)),
		Limitations:   limitations,
	}
	for _, item := range datasets {
		finalizeDataset(item)
		result.Datasets = append(result.Datasets, *item)
		result.Totals.Datasets++
		result.Totals.Errors += item.ErrorCount
		result.Totals.Warnings += len(item.Warnings)
		switch item.Status {
		case statusError:
			result.Totals.Error++
		case statusWarning:
			result.Totals.Warning++
		default:
			result.Totals.Passed++
		}
	}
	sortFindings(repo.Errors)
	repo.ErrorCount = len(repo.Errors)
	repo.Errors = truncate(repo.Errors)
	repo.Status = statusPassed
	if repo.ErrorCount > 0 {
		repo.Status = statusError
	}
	result.Repository = repo
	result.Totals.Errors += repo.ErrorCount

	switch {
	case result.Totals.Error > 0 || repo.ErrorCount > 0:
		result.Status = statusError
	case result.Totals.Warning > 0:
		result.Status = statusWarning
	default:
		result.Status = statusPassed
	}
	return result, nil
}

func readStrictJSON(path string, target any, disallowUnknown bool) error {
	data, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	if !utf8.Valid(data) {
		return errors.New("file is not valid UTF-8")
	}
	decoder := json.NewDecoder(bytes.NewReader(data))
	if disallowUnknown {
		decoder.DisallowUnknownFields()
	}
	return decoder.Decode(target)
}

func indexConfigs(cfg config, cat catalog) (map[string]datasetConfig, error) {
	known := make(map[string]catalogDataset, len(cat.Datasets))
	for _, item := range cat.Datasets {
		known[item.ID] = item
	}
	result := make(map[string]datasetConfig, len(cfg.Datasets))
	for _, item := range cfg.Datasets {
		dataset, exists := known[item.ID]
		if !exists {
			return nil, fmt.Errorf("dataset %q is not in the catalog", item.ID)
		}
		if _, duplicate := result[item.ID]; duplicate {
			return nil, fmt.Errorf("dataset %q is configured more than once", item.ID)
		}
		if len(item.RecordResources) == 0 {
			return nil, fmt.Errorf("dataset %q has no record_resources", item.ID)
		}
		for _, sel := range item.RecordResources {
			if len(selectResources(dataset, sel)) == 0 {
				return nil, fmt.Errorf("dataset %q: record_resources selector %+v matches no catalog resource", item.ID, sel)
			}
		}
		for _, metric := range item.Metrics {
			if !strings.HasPrefix(metric.Path, dataset.Location+"/") {
				return nil, fmt.Errorf("dataset %q: metrics path %q is outside %s", item.ID, metric.Path, dataset.Location)
			}
			if metric.Verification == nil && len(metric.SourceFields) == 0 && len(metric.CoordinateFields) == 0 {
				return nil, fmt.Errorf("dataset %q: metrics for %q configure nothing", item.ID, metric.Path)
			}
			if metric.Verification != nil && metric.Verification.Field == "" {
				return nil, fmt.Errorf("dataset %q: verification for %q has no field", item.ID, metric.Path)
			}
		}
		result[item.ID] = item
	}
	return result, nil
}

func newDatasetReport(item catalogDataset) *datasetReport {
	return &datasetReport{
		Dataset:  item.ID,
		Title:    item.Title,
		Location: item.Location,
		Version:  item.Version,
		Checks: checks{
			UTF8: checkPassed, Syntax: checkPassed, Duplicates: checkPassed,
			Schema: checkNotConfigured, References: checkNotConfigured, Metrics: checkNotConfigured,
		},
		Errors:   []finding{},
		Warnings: []string{},
	}
}

func formatCheckName(kind string) string {
	switch kind {
	case formatcheck.KindUTF8:
		return "utf8"
	case formatcheck.KindDuplicate:
		return "duplicates"
	default:
		return "syntax"
	}
}

func applyIntegrity(rules integrity.Config, owner func(string) *datasetReport, repo *repositoryReport) {
	cache := make(map[string][]map[string]any)
	var issues []integrity.Issue
	for _, rule := range rules.Datasets {
		if target := owner(rule.Path); target != nil {
			target.Checks.Schema = checkPassed
			if target.Metrics.MissingRequiredFields == nil {
				target.Metrics.MissingRequiredFields = new(int)
				target.Metrics.SchemaViolations = new(int)
			}
		}
		records, err := integrity.LoadRecords(rule.Path)
		if err != nil {
			issues = append(issues, integrity.Issue{Path: rule.Path, Kind: integrity.KindLoad, Message: err.Error()})
			continue
		}
		cache[rule.Path] = records
		issues = append(issues, integrity.ValidateDataset(rule, records)...)
	}
	for _, rule := range rules.References {
		if target := owner(rule.FromPath); target != nil {
			target.Checks.References = checkPassed
			if target.Metrics.ReferentialIntegrityErrors == nil {
				target.Metrics.ReferentialIntegrityErrors = new(int)
			}
		}
	}
	issues = append(issues, integrity.ValidateReferences(rules.References, cache)...)

	for _, issue := range issues {
		item := finding{Path: issue.Path, Record: issue.Record, Kind: issue.Kind, Message: issue.Message}
		target := owner(issue.Path)
		switch issue.Kind {
		case integrity.KindReference:
			item.Check = "references"
		case integrity.KindUnique:
			item.Check = "duplicates"
		default:
			item.Check = "schema"
		}
		if target == nil {
			repo.Errors = append(repo.Errors, item)
			continue
		}
		switch item.Check {
		case "references":
			target.Checks.References = checkFailed
			*target.Metrics.ReferentialIntegrityErrors++
		case "duplicates":
			target.Checks.Duplicates = checkFailed
			target.Metrics.DuplicateRecords++
		default:
			target.Checks.Schema = checkFailed
			*target.Metrics.SchemaViolations++
			switch issue.Kind {
			case integrity.KindRequired, integrity.KindNonEmpty, integrity.KindAnyRequired:
				*target.Metrics.MissingRequiredFields++
			}
		}
		target.Errors = append(target.Errors, item)
	}
}

func selectResources(item catalogDataset, sel selector) []catalogResource {
	var result []catalogResource
	for _, resource := range item.Resources {
		if sel.Format != "" && resource.Format != sel.Format {
			continue
		}
		if sel.Pattern != "" {
			if matched, err := path.Match(sel.Pattern, resource.Path); err != nil || !matched {
				continue
			}
		}
		result = append(result, resource)
	}
	return result
}

func recordCount(item catalogDataset, selectors []selector) (*int, *string) {
	seen := map[string]bool{}
	total := 0
	var unit *string
	mixedUnits := false
	for _, sel := range selectors {
		for _, resource := range selectResources(item, sel) {
			if seen[resource.Path] {
				continue
			}
			seen[resource.Path] = true
			if resource.RecordCount == nil || resource.RecordUnit == nil {
				return nil, nil
			}
			total += *resource.RecordCount
			if unit == nil {
				unit = resource.RecordUnit
			} else if *unit != *resource.RecordUnit {
				mixedUnits = true
			}
		}
	}
	if mixedUnits {
		mixed := "mixed"
		unit = &mixed
	}
	return &total, unit
}

func applyMetrics(target *datasetReport, configs []metricConfig) {
	target.Checks.Metrics = checkPassed
	for _, metric := range configs {
		records, err := loadMetricRecords(metric)
		if err != nil {
			target.Checks.Metrics = checkFailed
			target.Errors = append(target.Errors, finding{Path: metric.Path, Check: "metrics", Kind: "load", Message: err.Error()})
			continue
		}
		if metric.Verification != nil {
			count := 0
			for _, record := range records {
				status, _ := record[metric.Verification.Field].(string)
				if !contains(metric.Verification.Verified, status) {
					count++
				}
			}
			target.Metrics.UnverifiedRecords = add(target.Metrics.UnverifiedRecords, count)
			if count > 0 {
				target.Warnings = append(target.Warnings, fmt.Sprintf("%d of %d records in %s are not verified (%s)", count, len(records), metric.Path, metric.Verification.Field))
			}
		}
		if len(metric.SourceFields) > 0 {
			count := 0
			for _, record := range records {
				if !anyPresent(record, metric.SourceFields) {
					count++
				}
			}
			target.Metrics.MissingSources = add(target.Metrics.MissingSources, count)
			if count > 0 {
				target.Warnings = append(target.Warnings, fmt.Sprintf("%d of %d records in %s have no source metadata (%s)", count, len(records), metric.Path, strings.Join(metric.SourceFields, ", ")))
			}
		}
		if len(metric.CoordinateFields) > 0 {
			count := 0
			for _, record := range records {
				if !allPresent(record, metric.CoordinateFields) {
					count++
				}
			}
			target.Metrics.MissingCoordinates = add(target.Metrics.MissingCoordinates, count)
			if count > 0 {
				target.Warnings = append(target.Warnings, fmt.Sprintf("%d of %d records in %s have no coordinates (%s)", count, len(records), metric.Path, strings.Join(metric.CoordinateFields, ", ")))
			}
		}
	}
}

func loadMetricRecords(metric metricConfig) ([]map[string]any, error) {
	if metric.RecordsKey == "" {
		return integrity.LoadRecords(metric.Path)
	}
	data, err := os.ReadFile(metric.Path)
	if err != nil {
		return nil, err
	}
	if !utf8.Valid(data) {
		return nil, errors.New("file is not valid UTF-8")
	}
	var wrapper map[string]json.RawMessage
	if err := json.Unmarshal(data, &wrapper); err != nil {
		return nil, fmt.Errorf("expected a JSON object: %w", err)
	}
	raw, exists := wrapper[metric.RecordsKey]
	if !exists {
		return nil, fmt.Errorf("missing records key %q", metric.RecordsKey)
	}
	var records []map[string]any
	decoder := json.NewDecoder(bytes.NewReader(raw))
	decoder.UseNumber()
	if err := decoder.Decode(&records); err != nil {
		return nil, fmt.Errorf("%q must be an array of objects: %w", metric.RecordsKey, err)
	}
	return records, nil
}

func finalizeDataset(item *datasetReport) {
	sortFindings(item.Errors)
	sort.Strings(item.Warnings)
	item.ErrorCount = len(item.Errors)
	item.Errors = truncate(item.Errors)
	switch {
	case item.ErrorCount > 0:
		item.Status = statusError
	case len(item.Warnings) > 0:
		item.Status = statusWarning
	default:
		item.Status = statusPassed
	}
}

func sortFindings(items []finding) {
	sort.Slice(items, func(i, j int) bool {
		a, b := items[i], items[j]
		if a.Path != b.Path {
			return a.Path < b.Path
		}
		if a.Record != b.Record {
			return a.Record < b.Record
		}
		if a.Check != b.Check {
			return a.Check < b.Check
		}
		return a.Message < b.Message
	})
}

func truncate(items []finding) []finding {
	if len(items) > maxFindings {
		return items[:maxFindings]
	}
	return items
}

func add(current *int, value int) *int {
	if current == nil {
		return &value
	}
	sum := *current + value
	return &sum
}

func present(value any) bool {
	switch typed := value.(type) {
	case nil:
		return false
	case string:
		return strings.TrimSpace(typed) != ""
	case []any:
		return len(typed) > 0
	case map[string]any:
		return len(typed) > 0
	default:
		return true
	}
}

func anyPresent(record map[string]any, fields []string) bool {
	for _, field := range fields {
		if present(record[field]) {
			return true
		}
	}
	return false
}

func allPresent(record map[string]any, fields []string) bool {
	for _, field := range fields {
		if !present(record[field]) {
			return false
		}
	}
	return true
}

func contains(values []string, target string) bool {
	for _, value := range values {
		if value == target {
			return true
		}
	}
	return false
}

func render(value report) ([]byte, error) {
	var buffer bytes.Buffer
	encoder := json.NewEncoder(&buffer)
	encoder.SetEscapeHTML(false)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(value); err != nil {
		return nil, err
	}
	return buffer.Bytes(), nil
}

func printSummary(value report) {
	for _, item := range value.Datasets {
		fmt.Printf("%-24s %-7s errors=%d warnings=%d\n", item.Dataset, item.Status, item.ErrorCount, len(item.Warnings))
		for _, problem := range item.Errors {
			printFinding(problem)
		}
	}
	for _, problem := range value.Repository.Errors {
		printFinding(problem)
	}
	fmt.Printf("Overall: %s (%d error(s), %d warning(s) across %d dataset(s)).\n", value.Status, value.Totals.Errors, value.Totals.Warnings, value.Totals.Datasets)
}

func printFinding(item finding) {
	location := item.Path
	if item.Record > 0 {
		location += fmt.Sprintf(" record %d", item.Record)
	}
	fmt.Printf("  ERROR %s [%s]: %s\n", location, item.Check, item.Message)
}
