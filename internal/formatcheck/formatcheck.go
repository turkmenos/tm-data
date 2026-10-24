// Package formatcheck validates the encoding, syntax, and record uniqueness of
// JSON, JSONL, GeoJSON, and CSV dataset files.
package formatcheck

import (
	"bufio"
	"bytes"
	"crypto/sha256"
	"encoding/csv"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"unicode/utf8"
)

// Problem kinds reported by ValidateFile.
const (
	KindRead      = "read"
	KindUTF8      = "utf8"
	KindSyntax    = "syntax"
	KindDuplicate = "duplicate_record"
)

var supportedExtensions = map[string]bool{
	".csv":     true,
	".geojson": true,
	".json":    true,
	".jsonl":   true,
}

var excludedDirectories = map[string]bool{
	".git":         true,
	".venv":        true,
	"node_modules": true,
	"__pycache__":  true,
}

// Problem describes one validation failure in a file.
type Problem struct {
	Path    string
	Kind    string
	Message string
}

type record struct {
	collection string
	position   string
	value      any
}

// DiscoverFiles returns the sorted supported files found under paths.
func DiscoverFiles(paths []string) ([]string, error) {
	files := make(map[string]bool)
	for _, root := range paths {
		info, err := os.Stat(root)
		if err != nil {
			return nil, err
		}
		if !info.IsDir() {
			if supportedExtensions[strings.ToLower(filepath.Ext(root))] {
				files[filepath.Clean(root)] = true
			}
			continue
		}

		err = filepath.WalkDir(root, func(path string, entry os.DirEntry, walkErr error) error {
			if walkErr != nil {
				return walkErr
			}
			if entry.IsDir() && path != root && excludedDirectories[entry.Name()] {
				return filepath.SkipDir
			}
			if !entry.IsDir() && supportedExtensions[strings.ToLower(filepath.Ext(path))] {
				files[filepath.Clean(path)] = true
			}
			return nil
		})
		if err != nil {
			return nil, err
		}
	}

	result := make([]string, 0, len(files))
	for path := range files {
		result = append(result, path)
	}
	sort.Strings(result)
	return result, nil
}

// ValidateFile checks one file and returns its problems.
func ValidateFile(path string) []Problem {
	switch strings.ToLower(filepath.Ext(path)) {
	case ".json", ".geojson":
		return validateJSON(path)
	case ".jsonl":
		return validateJSONL(path)
	case ".csv":
		return validateCSV(path)
	default:
		return nil
	}
}

func readUTF8(path string) ([]byte, *Problem) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, &Problem{path, KindRead, err.Error()}
	}
	if !utf8.Valid(data) {
		return nil, &Problem{path, KindUTF8, "invalid UTF-8"}
	}
	return data, nil
}

func validateJSON(path string) []Problem {
	data, readProblem := readUTF8(path)
	if readProblem != nil {
		return []Problem{*readProblem}
	}
	value, err := decodeJSON(data)
	if err != nil {
		return []Problem{{path, KindSyntax, "invalid JSON: " + err.Error()}}
	}

	var records []record
	collectRecords(value, "$", &records)
	return duplicateProblems(path, records)
}

func validateJSONL(path string) []Problem {
	data, readProblem := readUTF8(path)
	if readProblem != nil {
		return []Problem{*readProblem}
	}

	var problems []Problem
	var records []record
	scanner := bufio.NewScanner(bytes.NewReader(data))
	buffer := make([]byte, 64*1024)
	scanner.Buffer(buffer, 16*1024*1024)
	lineNumber := 0
	for scanner.Scan() {
		lineNumber++
		line := bytes.TrimSpace(scanner.Bytes())
		if len(line) == 0 {
			continue
		}
		value, decodeErr := decodeJSON(line)
		if decodeErr != nil {
			problems = append(problems, Problem{path, KindSyntax, fmt.Sprintf("invalid JSONL at line %d: %v", lineNumber, decodeErr)})
			continue
		}
		records = append(records, record{"$", fmt.Sprintf("line %d", lineNumber), value})
	}
	if err := scanner.Err(); err != nil {
		problems = append(problems, Problem{path, KindSyntax, "invalid JSONL: " + err.Error()})
	}
	return append(problems, duplicateProblems(path, records)...)
}

func validateCSV(path string) []Problem {
	data, readProblem := readUTF8(path)
	if readProblem != nil {
		return []Problem{*readProblem}
	}

	reader := csv.NewReader(bytes.NewReader(data))
	header, err := reader.Read()
	if errors.Is(err, io.EOF) {
		return []Problem{{path, KindSyntax, "invalid CSV: missing header row"}}
	}
	if err != nil {
		return []Problem{{path, KindSyntax, "invalid CSV: " + err.Error()}}
	}

	seenHeaders := make(map[string]bool)
	for _, name := range header {
		if seenHeaders[name] {
			return []Problem{{path, KindSyntax, fmt.Sprintf("duplicate CSV header %q", name)}}
		}
		seenHeaders[name] = true
	}

	var records []record
	for lineNumber := 2; ; lineNumber++ {
		row, readErr := reader.Read()
		if errors.Is(readErr, io.EOF) {
			break
		}
		if readErr != nil {
			return []Problem{{path, KindSyntax, fmt.Sprintf("invalid CSV near line %d: %v", lineNumber, readErr)}}
		}
		values := make(map[string]string, len(header))
		for index, name := range header {
			values[name] = row[index]
		}
		records = append(records, record{"$", fmt.Sprintf("line %d", lineNumber), values})
	}
	return duplicateProblems(path, records)
}

func decodeJSON(data []byte) (any, error) {
	decoder := json.NewDecoder(bytes.NewReader(data))
	decoder.UseNumber()
	value, err := decodeJSONValue(decoder)
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

func decodeJSONValue(decoder *json.Decoder) (any, error) {
	token, err := decoder.Token()
	if err != nil {
		return nil, err
	}
	delimiter, isDelimiter := token.(json.Delim)
	if !isDelimiter {
		return token, nil
	}

	switch delimiter {
	case '{':
		object := make(map[string]any)
		for decoder.More() {
			keyToken, keyErr := decoder.Token()
			if keyErr != nil {
				return nil, keyErr
			}
			key, ok := keyToken.(string)
			if !ok {
				return nil, errors.New("JSON object key is not a string")
			}
			if _, exists := object[key]; exists {
				return nil, fmt.Errorf("duplicate JSON key %q", key)
			}
			value, valueErr := decodeJSONValue(decoder)
			if valueErr != nil {
				return nil, valueErr
			}
			object[key] = value
		}
		_, err = decoder.Token()
		return object, err
	case '[':
		var array []any
		for decoder.More() {
			value, valueErr := decodeJSONValue(decoder)
			if valueErr != nil {
				return nil, valueErr
			}
			array = append(array, value)
		}
		_, err = decoder.Token()
		return array, err
	default:
		return nil, fmt.Errorf("unexpected JSON delimiter %q", delimiter)
	}
}

func collectRecords(value any, location string, records *[]record) {
	switch typed := value.(type) {
	case []any:
		recordLike := false
		for _, item := range typed {
			switch item.(type) {
			case map[string]any, []any:
				recordLike = true
			}
		}
		for index, item := range typed {
			position := fmt.Sprintf("%s[%d]", location, index)
			if recordLike {
				*records = append(*records, record{location, position, item})
			}
			collectRecords(item, position, records)
		}
	case map[string]any:
		for key, item := range typed {
			collectRecords(item, location+"."+key, records)
		}
	}
}

func duplicateProblems(path string, records []record) []Problem {
	seen := make(map[string]string)
	var problems []Problem
	for _, item := range records {
		canonical, err := json.Marshal(item.value)
		if err != nil {
			problems = append(problems, Problem{path, KindSyntax, "cannot serialize record: " + err.Error()})
			continue
		}
		digest := sha256.Sum256(canonical)
		identity := item.collection + ":" + hex.EncodeToString(digest[:])
		if first, exists := seen[identity]; exists {
			problems = append(problems, Problem{path, KindDuplicate, fmt.Sprintf("duplicate record at %s; first seen at %s", item.position, first)})
		} else {
			seen[identity] = item.position
		}
	}
	return problems
}
