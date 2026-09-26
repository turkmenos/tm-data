package main

import (
	"bufio"
	"bytes"
	"crypto/sha256"
	"encoding/csv"
	"encoding/hex"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"unicode/utf8"
)

var formats = map[string]string{
	".json": "json", ".sql": "sql", ".db": "sqlite", ".txt": "text",
	".csv": "csv", ".jsonl": "jsonl", ".parquet": "parquet", ".geojson": "geojson",
}

type catalog struct {
	SchemaVersion string    `json:"schema_version"`
	Datasets      []dataset `json:"datasets"`
}

type dataset struct {
	ID            string     `json:"id"`
	Title         string     `json:"title"`
	Location      string     `json:"location"`
	Version       string     `json:"version"`
	Formats       []string   `json:"formats"`
	Documentation []string   `json:"documentation"`
	Provenance    provenance `json:"provenance"`
	Resources     []resource `json:"resources"`
}

type provenance struct {
	References []string `json:"references"`
	Note       string   `json:"note"`
}

type resource struct {
	Path        string  `json:"path"`
	Format      string  `json:"format"`
	Version     string  `json:"version"`
	RecordCount *int    `json:"record_count"`
	RecordUnit  *string `json:"record_unit"`
	CountNote   string  `json:"count_note,omitempty"`
}

func main() {
	check := flag.Bool("check", false, "fail if catalog.json is stale or invalid")
	flag.Parse()
	root, err := repositoryRoot()
	if err == nil {
		var value catalog
		value, err = build(root)
		if err == nil {
			var expected []byte
			expected, err = render(value)
			if err == nil {
				path := filepath.Join(root, "catalog.json")
				if *check {
					err = checkCatalog(path, expected)
				} else {
					err = os.WriteFile(path, expected, 0o644)
					if err == nil {
						fmt.Println("Generated catalog.json")
					}
				}
			}
		}
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
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
		parent := filepath.Dir(current)
		if parent == current {
			return "", errors.New("repository root not found")
		}
	}
}

func build(root string) (catalog, error) {
	folders := []string{"dictionary", "geo", "poetry", "stories"}
	entries, err := os.ReadDir(filepath.Join(root, "utils"))
	if err != nil {
		return catalog{}, err
	}
	for _, entry := range entries {
		if entry.IsDir() {
			folders = append(folders, filepath.Join("utils", entry.Name()))
		}
	}
	sort.Strings(folders[4:])
	result := catalog{SchemaVersion: "1.0.0", Datasets: []dataset{}}
	seen := map[string]bool{}
	for _, location := range folders {
		item, ok, err := buildDataset(root, filepath.ToSlash(location))
		if err != nil {
			return catalog{}, err
		}
		if !ok {
			continue
		}
		if seen[item.ID] {
			return catalog{}, fmt.Errorf("duplicate dataset identifier %q", item.ID)
		}
		seen[item.ID] = true
		result.Datasets = append(result.Datasets, item)
	}
	return result, nil
}

func buildDataset(root, location string) (dataset, bool, error) {
	var resources []resource
	var docs []string
	err := filepath.WalkDir(filepath.Join(root, filepath.FromSlash(location)), func(path string, entry os.DirEntry, walkErr error) error {
		if walkErr != nil {
			return walkErr
		}
		if entry.IsDir() {
			return nil
		}
		relative, err := filepath.Rel(root, path)
		if err != nil {
			return err
		}
		relative = filepath.ToSlash(relative)
		if strings.EqualFold(filepath.Ext(path), ".md") {
			docs = append(docs, relative)
			return nil
		}
		format, supported := formats[strings.ToLower(filepath.Ext(path))]
		if !supported {
			return nil
		}
		data, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		if format != "sqlite" && format != "parquet" && !utf8.Valid(data) {
			return fmt.Errorf("%s: invalid UTF-8", relative)
		}
		count, unit, err := countFile(path, relative, data, format)
		if err != nil {
			return fmt.Errorf("%s: %w", relative, err)
		}
		r := resource{Path: relative, Format: format, Version: digest(data), RecordCount: count, RecordUnit: unit}
		if count == nil {
			r.CountNote = "No supported record counter; count is unknown, not zero."
		}
		resources = append(resources, r)
		return nil
	})
	if err != nil {
		return dataset{}, false, err
	}
	if len(resources) == 0 {
		return dataset{}, false, nil
	}
	sort.Slice(resources, func(i, j int) bool { return resources[i].Path < resources[j].Path })
	sort.Strings(docs)
	formatSet := map[string]bool{}
	manifest := make([][2]string, len(resources))
	for i, r := range resources {
		formatSet[r.Format] = true
		manifest[i] = [2]string{r.Path, r.Version}
	}
	availableFormats := make([]string, 0, len(formatSet))
	for format := range formatSet {
		availableFormats = append(availableFormats, format)
	}
	sort.Strings(availableFormats)
	manifestJSON, _ := json.Marshal(manifest)
	references := append([]string(nil), docs...)
	if len(references) == 0 {
		references = []string{"SOURCES.md"}
	}
	name := filepath.Base(location)
	return dataset{
		ID: strings.ReplaceAll(location, "/", "-"), Title: title(name), Location: location,
		Version: digest(manifestJSON), Formats: availableFormats, Documentation: docs,
		Provenance: provenance{References: references, Note: "Repository documentation and embedded source metadata; coverage and redistribution rights may be incomplete."},
		Resources:  resources,
	}, true, nil
}

func countFile(path, relative string, data []byte, format string) (*int, *string, error) {
	switch format {
	case "json", "geojson":
		value, err := parseJSON(data)
		if err != nil {
			return nil, nil, err
		}
		if format == "geojson" {
			if object, ok := value.(map[string]any); ok {
				if rows, ok := object["features"].([]any); ok {
					return count(len(rows), "features")
				}
			}
		}
		return countRecords(value, relative)
	case "jsonl":
		total := 0
		scanner := bufio.NewScanner(bytes.NewReader(data))
		scanner.Buffer(make([]byte, 64*1024), 16*1024*1024)
		for scanner.Scan() {
			if len(bytes.TrimSpace(scanner.Bytes())) > 0 {
				if _, err := parseJSON(scanner.Bytes()); err != nil {
					return nil, nil, err
				}
				total++
			}
		}
		if err := scanner.Err(); err != nil {
			return nil, nil, err
		}
		return count(total, "records")
	case "csv":
		reader := csv.NewReader(bytes.NewReader(data))
		reader.FieldsPerRecord = -1
		rows, err := reader.ReadAll()
		if err != nil {
			return nil, nil, err
		}
		if len(rows) == 0 {
			return nil, nil, errors.New("missing CSV header")
		}
		seen := map[string]bool{}
		for _, field := range rows[0] {
			if seen[field] {
				return nil, nil, errors.New("duplicate CSV header")
			}
			seen[field] = true
		}
		for _, row := range rows[1:] {
			if len(row) != len(rows[0]) {
				return nil, nil, errors.New("inconsistent CSV row width")
			}
		}
		return count(len(rows)-1, "records")
	case "sqlite":
		return countSQLite(path)
	default:
		return nil, nil, nil
	}
}

func countRecords(value any, path string) (*int, *string, error) {
	if rows, ok := value.([]any); ok {
		return count(len(rows), "records")
	}
	object, ok := value.(map[string]any)
	if !ok {
		return nil, nil, nil
	}
	if path == "utils/transliteration/rules.json" {
		total := 0
		for _, direction := range []string{"latin_to_cyrillic", "cyrillic_to_latin"} {
			groups, ok := object[direction].(map[string]any)
			if !ok {
				return nil, nil, errors.New("invalid transliteration rules")
			}
			for _, group := range groups {
				switch values := group.(type) {
				case map[string]any:
					total += len(values)
				case []any:
					total += len(values)
				default:
					return nil, nil, errors.New("invalid transliteration rule group")
				}
			}
		}
		return count(total, "mappings_and_rules")
	}
	for _, candidate := range [][2]string{{"pages", "pages"}, {"poems", "poems"}, {"proverbs", "proverbs"}, {"test_cases", "test_cases"}} {
		if rows, ok := object[candidate[0]].([]any); ok {
			return count(len(rows), candidate[1])
		}
	}
	if words, ok := object["words"].([]any); ok {
		return count(len(words), "words")
	}
	if words, ok := object["words"].(map[string]any); ok {
		return count(len(words), "search_keys")
	}
	if strings.HasPrefix(path, "dictionary/") {
		for _, value := range object {
			if _, ok := value.([]any); !ok {
				return nil, nil, nil
			}
		}
		return count(len(object), "search_keys")
	}
	return nil, nil, nil
}

func countSQLite(path string) (*int, *string, error) {
	query := "SELECT COALESCE(SUM(n),0) FROM (SELECT 0 AS n"
	names, err := exec.Command("sqlite3", "-readonly", path, "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name;").Output()
	if err != nil {
		return nil, nil, fmt.Errorf("sqlite3 table discovery failed: %w", err)
	}
	for _, name := range strings.Split(strings.TrimSpace(string(names)), "\n") {
		if name != "" {
			query += " UNION ALL SELECT COUNT(*) FROM \"" + strings.ReplaceAll(name, "\"", "\"\"") + "\""
		}
	}
	query += ")"
	output, err := exec.Command("sqlite3", "-readonly", path, query).Output()
	if err != nil {
		return nil, nil, fmt.Errorf("sqlite3 row count failed: %w", err)
	}
	total, err := strconv.Atoi(strings.TrimSpace(string(output)))
	if err != nil {
		return nil, nil, err
	}
	return count(total, "table_rows")
}

func parseJSON(data []byte) (any, error) {
	if !utf8.Valid(data) {
		return nil, errors.New("invalid UTF-8")
	}
	decoder := json.NewDecoder(bytes.NewReader(data))
	decoder.UseNumber()
	value, err := decodeValue(decoder)
	if err != nil {
		return nil, err
	}
	if _, err = decoder.Token(); !errors.Is(err, io.EOF) {
		if err == nil {
			return nil, errors.New("multiple top-level JSON values")
		}
		return nil, err
	}
	return value, nil
}

func decodeValue(decoder *json.Decoder) (any, error) {
	token, err := decoder.Token()
	if err != nil {
		return nil, err
	}
	delim, ok := token.(json.Delim)
	if !ok {
		return token, nil
	}
	switch delim {
	case '{':
		object := map[string]any{}
		for decoder.More() {
			keyToken, err := decoder.Token()
			if err != nil {
				return nil, err
			}
			key := keyToken.(string)
			if _, exists := object[key]; exists {
				return nil, fmt.Errorf("duplicate JSON key %q", key)
			}
			value, err := decodeValue(decoder)
			if err != nil {
				return nil, err
			}
			object[key] = value
		}
		_, err = decoder.Token()
		return object, err
	case '[':
		array := []any{}
		for decoder.More() {
			value, err := decodeValue(decoder)
			if err != nil {
				return nil, err
			}
			array = append(array, value)
		}
		_, err = decoder.Token()
		return array, err
	}
	return nil, fmt.Errorf("unexpected JSON delimiter %q", delim)
}

func render(value catalog) ([]byte, error) {
	data, err := json.MarshalIndent(value, "", "  ")
	if err != nil {
		return nil, err
	}
	return append(data, '\n'), nil
}
func checkCatalog(path string, expected []byte) error {
	actual, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	if _, err = parseJSON(actual); err != nil {
		return err
	}
	if !bytes.Equal(actual, expected) {
		return errors.New("catalog.json is stale or invalid; run go run ./tools/catalog")
	}
	fmt.Println("Passed: catalog matches dataset files, counts, versions, and documentation.")
	return nil
}
func count(number int, unit string) (*int, *string, error) { return &number, &unit, nil }
func digest(data []byte) string {
	sum := sha256.Sum256(data)
	return "sha256:" + hex.EncodeToString(sum[:])
}
func title(value string) string {
	words := strings.Split(strings.ReplaceAll(value, "-", " "), " ")
	for i := range words {
		if words[i] != "" {
			words[i] = strings.ToUpper(words[i][:1]) + words[i][1:]
		}
	}
	return strings.Join(words, " ")
}
