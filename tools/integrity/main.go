package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"os"
	"strings"
	"unicode/utf8"
)

type config struct {
	Version    int         `json:"version"`
	Datasets   []dataset   `json:"datasets"`
	References []reference `json:"references"`
}

type dataset struct {
	Path          string              `json:"path"`
	Required      map[string]string   `json:"required"`
	NonEmpty      []string            `json:"non_empty"`
	Unique        [][]string          `json:"unique"`
	AllowedValues map[string][]string `json:"allowed_values"`
	Ranges        map[string]numRange `json:"ranges"`
	AnyRequired   [][]string          `json:"any_required"`
}

type numRange struct {
	Min float64 `json:"min"`
	Max float64 `json:"max"`
}

type reference struct {
	FromPath  string `json:"from_path"`
	FromField string `json:"from_field"`
	ToPath    string `json:"to_path"`
	ToField   string `json:"to_field"`
}

type issue struct {
	Path    string
	Record  int
	Message string
}

func main() {
	rulesPath := "tools/integrity/rules.json"
	if len(os.Args) == 3 && os.Args[1] == "-rules" {
		rulesPath = os.Args[2]
	} else if len(os.Args) != 1 {
		fmt.Fprintln(os.Stderr, "usage: integrity [-rules path]")
		os.Exit(2)
	}

	rules, err := loadConfig(rulesPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR %s: %v\n", rulesPath, err)
		os.Exit(2)
	}

	cache := make(map[string][]map[string]any)
	var issues []issue
	for _, rule := range rules.Datasets {
		records, loadErr := loadRecords(rule.Path)
		if loadErr != nil {
			issues = append(issues, issue{rule.Path, 0, loadErr.Error()})
			continue
		}
		cache[rule.Path] = records
		issues = append(issues, validateDataset(rule, records)...)
	}
	issues = append(issues, validateReferences(rules.References, cache)...)

	for _, item := range issues {
		location := item.Path
		if item.Record > 0 {
			location += fmt.Sprintf(" record %d", item.Record)
		}
		fmt.Printf("ERROR %s: %s\n", location, item.Message)
	}
	if len(issues) > 0 {
		fmt.Printf("Failed: %d integrity problem(s).\n", len(issues))
		os.Exit(1)
	}
	fmt.Printf("Passed: %d dataset schemas and %d reference rule(s).\n", len(rules.Datasets), len(rules.References))
}

func loadConfig(path string) (config, error) {
	var result config
	data, err := os.ReadFile(path)
	if err != nil {
		return result, err
	}
	if !utf8.Valid(data) {
		return result, errors.New("rules are not valid UTF-8")
	}
	decoder := json.NewDecoder(strings.NewReader(string(data)))
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(&result); err != nil {
		return result, fmt.Errorf("invalid rules: %w", err)
	}
	if result.Version != 1 {
		return result, fmt.Errorf("unsupported rules version %d", result.Version)
	}
	if len(result.Datasets) == 0 {
		return result, errors.New("rules contain no datasets")
	}
	return result, nil
}

func loadRecords(path string) ([]map[string]any, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	if !utf8.Valid(data) {
		return nil, errors.New("file is not valid UTF-8")
	}
	var records []map[string]any
	decoder := json.NewDecoder(strings.NewReader(string(data)))
	decoder.UseNumber()
	if err := decoder.Decode(&records); err != nil {
		return nil, fmt.Errorf("expected a JSON array of objects: %w", err)
	}
	if len(records) == 0 {
		return nil, errors.New("dataset contains no records")
	}
	return records, nil
}

func validateDataset(rule dataset, records []map[string]any) []issue {
	var issues []issue
	seen := make([]map[string]int, len(rule.Unique))
	for index := range seen {
		seen[index] = make(map[string]int)
	}

	for index, record := range records {
		recordNumber := index + 1
		for field, expectedType := range rule.Required {
			value, exists := record[field]
			if !exists || value == nil {
				issues = append(issues, issue{rule.Path, recordNumber, fmt.Sprintf("missing required field %q", field)})
				continue
			}
			if !hasType(value, expectedType) {
				issues = append(issues, issue{rule.Path, recordNumber, fmt.Sprintf("field %q must be %s", field, expectedType)})
			}
		}

		for _, field := range rule.NonEmpty {
			if value, exists := record[field]; !exists || isEmpty(value) {
				issues = append(issues, issue{rule.Path, recordNumber, fmt.Sprintf("field %q must not be empty", field)})
			}
		}

		for _, alternatives := range rule.AnyRequired {
			found := false
			for _, field := range alternatives {
				if value, exists := record[field]; exists && !isEmpty(value) {
					found = true
					break
				}
			}
			if !found {
				issues = append(issues, issue{rule.Path, recordNumber, "one of these fields is required: " + strings.Join(alternatives, ", ")})
			}
		}

		for field, values := range rule.AllowedValues {
			value, exists := record[field]
			if !exists {
				continue
			}
			actual, ok := value.(string)
			if !ok || !contains(values, actual) {
				issues = append(issues, issue{rule.Path, recordNumber, fmt.Sprintf("field %q has unsupported value %v", field, value)})
			}
		}

		for field, limits := range rule.Ranges {
			value, exists := record[field]
			if !exists {
				continue
			}
			number, ok := asNumber(value)
			if !ok || number < limits.Min || number > limits.Max {
				issues = append(issues, issue{rule.Path, recordNumber, fmt.Sprintf("field %q must be between %v and %v", field, limits.Min, limits.Max)})
			}
		}

		for keyIndex, fields := range rule.Unique {
			key, complete := compositeKey(record, fields)
			if !complete {
				continue
			}
			if first, exists := seen[keyIndex][key]; exists {
				issues = append(issues, issue{rule.Path, recordNumber, fmt.Sprintf("duplicate unique key (%s); first seen at record %d", strings.Join(fields, ", "), first)})
			} else {
				seen[keyIndex][key] = recordNumber
			}
		}
	}
	return issues
}

func validateReferences(rules []reference, cache map[string][]map[string]any) []issue {
	var issues []issue
	for _, rule := range rules {
		targets := make(map[string]bool)
		for _, record := range cache[rule.ToPath] {
			if value, exists := record[rule.ToField]; exists && !isEmpty(value) {
				targets[fmt.Sprint(value)] = true
			}
		}
		for index, record := range cache[rule.FromPath] {
			value, exists := record[rule.FromField]
			if !exists || isEmpty(value) {
				continue
			}
			if !targets[fmt.Sprint(value)] {
				issues = append(issues, issue{rule.FromPath, index + 1, fmt.Sprintf("broken reference: %s=%v not found in %s.%s", rule.FromField, value, rule.ToPath, rule.ToField)})
			}
		}
	}
	return issues
}

func hasType(value any, expected string) bool {
	switch expected {
	case "string":
		_, ok := value.(string)
		return ok
	case "number":
		_, ok := asNumber(value)
		return ok
	case "boolean":
		_, ok := value.(bool)
		return ok
	case "object":
		_, ok := value.(map[string]any)
		return ok
	case "array":
		_, ok := value.([]any)
		return ok
	default:
		return false
	}
}

func asNumber(value any) (float64, bool) {
	number, ok := value.(json.Number)
	if !ok {
		return 0, false
	}
	parsed, err := number.Float64()
	return parsed, err == nil && !math.IsNaN(parsed) && !math.IsInf(parsed, 0)
}

func isEmpty(value any) bool {
	switch typed := value.(type) {
	case nil:
		return true
	case string:
		return strings.TrimSpace(typed) == ""
	case []any:
		return len(typed) == 0
	case map[string]any:
		return len(typed) == 0
	default:
		return false
	}
}

func contains(values []string, target string) bool {
	for _, value := range values {
		if value == target {
			return true
		}
	}
	return false
}

func compositeKey(record map[string]any, fields []string) (string, bool) {
	parts := make([]string, 0, len(fields))
	for _, field := range fields {
		value, exists := record[field]
		if !exists || isEmpty(value) {
			return "", false
		}
		encoded, err := json.Marshal(value)
		if err != nil {
			return "", false
		}
		parts = append(parts, string(encoded))
	}
	return strings.Join(parts, "\x00"), true
}
