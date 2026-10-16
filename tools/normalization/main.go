package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"unicode/utf8"

	"golang.org/x/text/unicode/norm"
)

type fixtures struct {
	SchemaVersion string `json:"schema_version"`
	RulesFile     string `json:"rules_file"`
	TestCases     []struct {
		ID       string `json:"id"`
		Input    string `json:"input"`
		Expected string `json:"expected"`
	} `json:"test_cases"`
}

func main() {
	text := flag.String("text", "", "text to normalize")
	file := flag.String("file", "", "UTF-8 file to normalize")
	check := flag.Bool("check", false, "validate the rules and all conformance fixtures")
	flag.Parse()
	selected := 0
	if *text != "" {
		selected++
	}
	if *file != "" {
		selected++
	}
	if *check {
		selected++
	}
	if selected != 1 {
		fmt.Fprintln(os.Stderr, "usage: normalization -text <text> | -file <path> | --check")
		os.Exit(2)
	}
	if *check {
		if err := checkFixtures(); err != nil {
			fmt.Fprintln(os.Stderr, "ERROR:", err)
			os.Exit(1)
		}
		fmt.Println("Passed: normalization rules and fixtures are valid.")
		return
	}
	data := []byte(*text)
	if *file != "" {
		var err error
		data, err = os.ReadFile(*file)
		if err != nil {
			fmt.Fprintln(os.Stderr, "ERROR:", err)
			os.Exit(1)
		}
	}
	output, err := normalize(data)
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(1)
	}
	os.Stdout.Write(output)
}

func normalize(input []byte) ([]byte, error) {
	if !utf8.Valid(input) {
		return nil, errors.New("input is not valid UTF-8")
	}
	input = bytes.TrimPrefix(input, []byte{0xef, 0xbb, 0xbf})
	input = bytes.ReplaceAll(input, []byte("\r\n"), []byte("\n"))
	input = bytes.ReplaceAll(input, []byte("\r"), []byte("\n"))
	return norm.NFC.Bytes(input), nil
}

func checkFixtures() error {
	root, err := repositoryRoot()
	if err != nil {
		return err
	}
	rulesPath := filepath.Join(root, "utils", "normalization", "rules.json")
	rules, err := os.ReadFile(rulesPath)
	if err != nil {
		return err
	}
	var metadata map[string]any
	if err := json.Unmarshal(rules, &metadata); err != nil {
		return fmt.Errorf("rules.json: %w", err)
	}
	if metadata["schema_version"] != "1.0.0" || metadata["encoding"] != "UTF-8" || metadata["profile"] != "storage" {
		return errors.New("rules.json: unsupported metadata")
	}
	fixtureData, err := os.ReadFile(filepath.Join(root, "utils", "normalization", "test_cases.json"))
	if err != nil {
		return err
	}
	var values fixtures
	if err := json.Unmarshal(fixtureData, &values); err != nil {
		return fmt.Errorf("test_cases.json: %w", err)
	}
	seen := map[string]bool{}
	for _, test := range values.TestCases {
		if test.ID == "" || seen[test.ID] {
			return fmt.Errorf("empty or duplicate test id %q", test.ID)
		}
		seen[test.ID] = true
		got, err := normalize([]byte(test.Input))
		if err != nil {
			return fmt.Errorf("%s: %w", test.ID, err)
		}
		if string(got) != test.Expected {
			return fmt.Errorf("%s: got %q, want %q", test.ID, got, test.Expected)
		}
	}
	if len(values.TestCases) == 0 {
		return errors.New("no normalization fixtures")
	}
	return nil
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
			return "", errors.New("repository root not found")
		}
	}
}
