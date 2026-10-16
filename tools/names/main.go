// Command names generates the unified Turkmen given-names dataset.
package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"sort"
)

type sourceFile struct{ Path, Gender string }

var sourceFiles = []sourceFile{
	{"utils/names/man-names.json", "male"},
	{"utils/names/woman-names.json", "female"},
	{"utils/names/unisex-names.json", "unisex"},
}

type legacyName struct {
	Name         string   `json:"name"`
	Origin       any      `json:"origin,omitempty"`
	Variants     []string `json:"variants,omitempty"`
	Description  string   `json:"description"`
	Note         *string  `json:"note,omitempty"`
	OriginNote   *string  `json:"origin_note,omitempty"`
	Original     *string  `json:"original,omitempty"`
	RelatedNames []string `json:"related_names,omitempty"`
}

type nameRecord struct {
	Name               string   `json:"name"`
	Gender             string   `json:"gender"`
	Meaning            *string  `json:"meaning"`
	Origins            []string `json:"origins"`
	Variants           []string `json:"variants"`
	RelatedNames       []string `json:"related_names"`
	OriginalForm       *string  `json:"original_form"`
	Note               *string  `json:"note"`
	OriginNote         *string  `json:"origin_note"`
	SourceIDs          []string `json:"source_ids"`
	VerificationStatus string   `json:"verification_status"`
}

type dataset struct {
	SchemaVersion string       `json:"schema_version"`
	Language      string       `json:"language"`
	LanguageCode  string       `json:"language_code"`
	RecordCount   int          `json:"record_count"`
	GeneratedFrom []string     `json:"generated_from"`
	Sources       []any        `json:"sources"`
	Provenance    provenance   `json:"provenance"`
	Names         []nameRecord `json:"names"`
}

type provenance struct {
	Status string `json:"status"`
	Note   string `json:"note"`
}

func main() {
	check := flag.Bool("check", false, "fail if given-names.json is missing or stale")
	flag.Parse()
	root, err := repositoryRoot()
	if err == nil {
		var output []byte
		output, err = generate(root)
		if err == nil {
			target := filepath.Join(root, "utils", "names", "given-names.json")
			if *check {
				var existing []byte
				existing, err = os.ReadFile(target)
				if err == nil && !bytes.Equal(existing, output) {
					err = errors.New("utils/names/given-names.json is stale; run go run ./tools/names")
				}
			} else {
				err = os.WriteFile(target, output, 0o644)
			}
		}
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(1)
	}
	if *check {
		fmt.Println("Passed: unified given-names dataset matches its source files.")
	} else {
		fmt.Println("Generated utils/names/given-names.json")
	}
}

func generate(root string) ([]byte, error) {
	result := dataset{
		SchemaVersion: "1.0.0", Language: "Turkmen", LanguageCode: "tk",
		GeneratedFrom: []string{}, Sources: []any{},
		Provenance: provenance{Status: "source_unknown", Note: "The legacy files do not identify an author, publication, URL, retrieval date, or redistribution terms. Records remain unverified until sources are supplied."},
		Names:      []nameRecord{},
	}
	seen := map[string]string{}
	for _, source := range sourceFiles {
		data, err := os.ReadFile(filepath.Join(root, filepath.FromSlash(source.Path)))
		if err != nil {
			return nil, err
		}
		var values []legacyName
		decoder := json.NewDecoder(bytes.NewReader(data))
		decoder.DisallowUnknownFields()
		if err := decoder.Decode(&values); err != nil {
			return nil, fmt.Errorf("%s: %w", source.Path, err)
		}
		result.GeneratedFrom = append(result.GeneratedFrom, source.Path)
		for _, item := range values {
			if item.Name == "" {
				return nil, fmt.Errorf("%s: name is required", source.Path)
			}
			if previous, exists := seen[item.Name]; exists {
				return nil, fmt.Errorf("duplicate name %q in %s and %s", item.Name, previous, source.Path)
			}
			seen[item.Name] = source.Path
			origins, err := stringList(item.Origin)
			if err != nil {
				return nil, fmt.Errorf("%s name %q origin: %w", source.Path, item.Name, err)
			}
			var meaning *string
			if item.Description != "" {
				meaning = &item.Description
			}
			result.Names = append(result.Names, nameRecord{
				Name: item.Name, Gender: source.Gender, Meaning: meaning, Origins: origins,
				Variants: nonNil(item.Variants), RelatedNames: nonNil(item.RelatedNames), OriginalForm: item.Original,
				Note: item.Note, OriginNote: item.OriginNote, SourceIDs: []string{}, VerificationStatus: "unverified",
			})
		}
	}
	sort.SliceStable(result.Names, func(i, j int) bool { return result.Names[i].Name < result.Names[j].Name })
	result.RecordCount = len(result.Names)
	data, err := json.MarshalIndent(result, "", "  ")
	if err != nil {
		return nil, err
	}
	return append(data, '\n'), nil
}

func nonNil(value []string) []string {
	if value == nil {
		return []string{}
	}
	return value
}

func stringList(value any) ([]string, error) {
	if value == nil {
		return []string{}, nil
	}
	switch value := value.(type) {
	case string:
		return []string{value}, nil
	case []any:
		result := make([]string, len(value))
		for i, item := range value {
			text, ok := item.(string)
			if !ok {
				return nil, errors.New("expected string or array of strings")
			}
			result[i] = text
		}
		return result, nil
	default:
		return nil, errors.New("expected string or array of strings")
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
			return "", errors.New("repository root not found")
		}
	}
}
