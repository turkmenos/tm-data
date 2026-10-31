// Package integrity validates dataset invariants declared in a rules file:
// required fields, types, uniqueness, allowed values, ranges, and references.
package integrity

import (
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"os"
	"strings"
	"unicode/utf8"
)

// Issue kinds reported by ValidateDataset and ValidateReferences. KindLoad is
// for callers that fail to load a dataset file.
const (
	KindLoad         = "load"
	KindRequired     = "required"
	KindType         = "type"
	KindNonEmpty     = "non_empty"
	KindAnyRequired  = "any_required"
	KindAllowedValue = "allowed_value"
	KindRange        = "range"
	KindUnique       = "unique"
	KindReference    = "reference"
)

// Config is the integrity rules file structure.
type Config struct {
	Version    int         `json:"version"`
	Datasets   []Dataset   `json:"datasets"`
	References []Reference `json:"references"`
}

// Dataset holds the rules for one JSON array of objects.
type Dataset struct {
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

// Reference relates a source field to a target field.
type Reference struct {
	FromPath  string `json:"from_path"`
	FromField string `json:"from_field"`
	ToPath    string `json:"to_path"`
	ToField   string `json:"to_field"`
}

// Issue is one integrity problem. Record is 1-based; 0 means the whole file.
type Issue struct {
	Path    string
	Record  int
	Kind    string
	Message string
}

// LoadConfig reads and checks a rules file.
func LoadConfig(path string) (Config, error) {
	var result Config
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

// LoadRecords reads a UTF-8 JSON array of objects.
func LoadRecords(path string) ([]map[string]any, error) {
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

// ValidateDataset applies one dataset rule to its records.
func ValidateDataset(rule Dataset, records []map[string]any) []Issue {
	var issues []Issue
	seen := make([]map[string]int, len(rule.Unique))
	for index := range seen {
		seen[index] = make(map[string]int)
	}

	for index, record := range records {
		recordNumber := index + 1
		for field, expectedType := range rule.Required {
			value, exists := record[field]
			if !exists || value == nil {
				issues = append(issues, Issue{rule.Path, recordNumber, KindRequired, fmt.Sprintf("missing required field %q", field)})
				continue
			}
			if !hasType(value, expectedType) {
				issues = append(issues, Issue{rule.Path, recordNumber, KindType, fmt.Sprintf("field %q must be %s", field, expectedType)})
			}
		}

		for _, field := range rule.NonEmpty {
			if value, exists := record[field]; !exists || isEmpty(value) {
				issues = append(issues, Issue{rule.Path, recordNumber, KindNonEmpty, fmt.Sprintf("field %q must not be empty", field)})
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
				issues = append(issues, Issue{rule.Path, recordNumber, KindAnyRequired, "one of these fields is required: " + strings.Join(alternatives, ", ")})
			}
		}

		for field, values := range rule.AllowedValues {
			value, exists := record[field]
			if !exists || value == nil {
				continue
			}
			actual, ok := value.(string)
			if !ok || !contains(values, actual) {
				issues = append(issues, Issue{rule.Path, recordNumber, KindAllowedValue, fmt.Sprintf("field %q has unsupported value %v", field, value)})
			}
		}

		for field, limits := range rule.Ranges {
			value, exists := record[field]
			if !exists || value == nil {
				continue
			}
			number, ok := asNumber(value)
			if !ok || number < limits.Min || number > limits.Max {
				issues = append(issues, Issue{rule.Path, recordNumber, KindRange, fmt.Sprintf("field %q must be between %v and %v", field, limits.Min, limits.Max)})
			}
		}

		for keyIndex, fields := range rule.Unique {
			key, complete := compositeKey(record, fields)
			if !complete {
				continue
			}
			if first, exists := seen[keyIndex][key]; exists {
				issues = append(issues, Issue{rule.Path, recordNumber, KindUnique, fmt.Sprintf("duplicate unique key (%s); first seen at record %d", strings.Join(fields, ", "), first)})
			} else {
				seen[keyIndex][key] = recordNumber
			}
		}
	}
	return issues
}

// ValidateReferences checks cross-file references among loaded records.
func ValidateReferences(rules []Reference, cache map[string][]map[string]any) []Issue {
	var issues []Issue
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
				issues = append(issues, Issue{rule.FromPath, index + 1, KindReference, fmt.Sprintf("broken reference: %s=%v not found in %s.%s", rule.FromField, value, rule.ToPath, rule.ToField)})
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
