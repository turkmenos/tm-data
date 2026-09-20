package main

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

var supportedExtensions = map[string]bool{
	".csv":   true,
	".json":  true,
	".jsonl": true,
}

var excludedDirectories = map[string]bool{
	".git":         true,
	".venv":        true,
	"node_modules": true,
	"__pycache__":  true,
}

type problem struct {
	path    string
	message string
}

type record struct {
	collection string
	position   string
	value      any
}

func main() {
	paths := os.Args[1:]
	if len(paths) == 0 {
		paths = []string{"."}
	}

	for _, path := range paths {
		if _, err := os.Stat(path); err != nil {
			fmt.Fprintf(os.Stderr, "ERROR %s: path does not exist\n", path)
			os.Exit(2)
		}
	}

	files, err := discoverFiles(paths)
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: %v\n", err)
		os.Exit(2)
	}

	var problems []problem
	for _, path := range files {
		problems = append(problems, validateFile(path)...)
	}

	for _, item := range problems {
		fmt.Printf("ERROR %s: %s\n", item.path, item.message)
	}
	if len(problems) > 0 {
		fmt.Printf("Failed: %d problem(s) in %d file(s).\n", len(problems), len(files))
		os.Exit(1)
	}

	fmt.Printf("Passed: no duplicate or invalid records in %d file(s).\n", len(files))
}

func discoverFiles(paths []string) ([]string, error) {
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

func validateFile(path string) []problem {
	switch strings.ToLower(filepath.Ext(path)) {
	case ".json":
		return validateJSON(path)
	case ".jsonl":
		return validateJSONL(path)
	case ".csv":
		return validateCSV(path)
	default:
		return nil
	}
}

func readUTF8(path string) ([]byte, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	if !utf8.Valid(data) {
		return nil, errors.New("invalid UTF-8")
	}
	return data, nil
}

func validateJSON(path string) []problem {
	data, err := readUTF8(path)
	if err != nil {
		return []problem{{path, err.Error()}}
	}
	value, err := decodeJSON(data)
	if err != nil {
		return []problem{{path, "invalid JSON: " + err.Error()}}
	}

	var records []record
	collectRecords(value, "$", &records)
	return duplicateProblems(path, records)
}

func validateJSONL(path string) []problem {
	data, err := readUTF8(path)
	if err != nil {
		return []problem{{path, err.Error()}}
	}

	var problems []problem
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
			problems = append(problems, problem{path, fmt.Sprintf("invalid JSONL at line %d: %v", lineNumber, decodeErr)})
			continue
		}
		records = append(records, record{"$", fmt.Sprintf("line %d", lineNumber), value})
	}
	if err := scanner.Err(); err != nil {
		problems = append(problems, problem{path, "invalid JSONL: " + err.Error()})
	}
	return append(problems, duplicateProblems(path, records)...)
}

func validateCSV(path string) []problem {
	data, err := readUTF8(path)
	if err != nil {
		return []problem{{path, err.Error()}}
	}

	reader := csv.NewReader(bytes.NewReader(data))
	header, err := reader.Read()
	if errors.Is(err, io.EOF) {
		return []problem{{path, "invalid CSV: missing header row"}}
	}
	if err != nil {
		return []problem{{path, "invalid CSV: " + err.Error()}}
	}

	seenHeaders := make(map[string]bool)
	for _, name := range header {
		if seenHeaders[name] {
			return []problem{{path, fmt.Sprintf("duplicate CSV header %q", name)}}
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
			return []problem{{path, fmt.Sprintf("invalid CSV near line %d: %v", lineNumber, readErr)}}
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

func duplicateProblems(path string, records []record) []problem {
	seen := make(map[string]string)
	var problems []problem
	for _, item := range records {
		canonical, err := json.Marshal(item.value)
		if err != nil {
			problems = append(problems, problem{path, "cannot serialize record: " + err.Error()})
			continue
		}
		digest := sha256.Sum256(canonical)
		identity := item.collection + ":" + hex.EncodeToString(digest[:])
		if first, exists := seen[identity]; exists {
			problems = append(problems, problem{path, fmt.Sprintf("duplicate record at %s; first seen at %s", item.position, first)})
		} else {
			seen[identity] = item.position
		}
	}
	return problems
}
