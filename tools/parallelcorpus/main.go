// Command parallelcorpus validates the Turkmen–Turkish–English parallel corpus
// and generates its deterministic JSON and CSV exports.
package main

import (
	"bytes"
	"encoding/csv"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"unicode"
	"unicode/utf8"

	"golang.org/x/text/unicode/norm"
)

const directory = "language/parallel-corpus"

// turkmenAlphabet is the modern Turkmen Latin alphabet, matching tools/validation.
const turkmenAlphabet = "ABCÇDEÄFGHIJŽKLMNŇOÖPRSŞTUÜWYÝZ" + "abcçdeäfghijžklmnňoöprsştuüwyýz"

var (
	idPattern     = regexp.MustCompile(`^sentence-[0-9]{6}$`)
	digitPattern  = regexp.MustCompile(`[0-9]+`)
	categories    = []string{"greetings", "daily_life", "food", "travel", "weather", "education", "numbers_time"}
	statuses      = []string{"unverified", "human_reviewed"}
	sourceTypes   = []string{"original", "publication", "website", "corpus"}
	csvColumns    = []string{"id", "tk", "tr", "en", "category", "verification_status", "source"}
	languageNames = map[string]string{"tk": "Turkmen", "tr": "Turkish", "en": "English"}
)

type translations struct {
	TK string  `json:"tk"`
	TR *string `json:"tr,omitempty"`
	EN *string `json:"en,omitempty"`
}

type sentence struct {
	ID                 string       `json:"id"`
	Translations       translations `json:"translations"`
	Category           string       `json:"category"`
	VerificationStatus string       `json:"verification_status"`
	Source             string       `json:"source"`
}

type source struct {
	ID              string `json:"id"`
	Type            string `json:"type"`
	Title           string `json:"title"`
	Creator         string `json:"creator"`
	CreatedYear     *int   `json:"created_year,omitempty"`
	URL             string `json:"url,omitempty"`
	AccessDate      string `json:"access_date,omitempty"`
	License         string `json:"license"`
	Rights          string `json:"rights"`
	MachineAssisted bool   `json:"machine_assisted"`
	Note            string `json:"note"`
}

type corpus struct {
	Sentences []sentence
	Sources   []source
}

func main() {
	check := flag.Bool("check", false, "fail if the corpus is invalid or an export is stale, without writing files")
	flag.Parse()
	root, err := repositoryRoot()
	if err == nil {
		err = run(filepath.Join(root, filepath.FromSlash(directory)), *check)
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(1)
	}
}

func run(dir string, check bool) error {
	c, err := load(dir)
	if err != nil {
		return err
	}
	if err := validate(c); err != nil {
		return err
	}
	jsonOutput, err := renderJSON(c.Sentences)
	if err != nil {
		return err
	}
	csvOutput, err := renderCSV(c.Sentences)
	if err != nil {
		return err
	}
	outputs := []struct {
		name string
		data []byte
	}{{"sentences.json", jsonOutput}, {"sentences.csv", csvOutput}}
	for _, output := range outputs {
		target := filepath.Join(dir, output.name)
		if check {
			existing, err := os.ReadFile(target)
			if err != nil {
				return err
			}
			if !bytes.Equal(existing, output.data) {
				return fmt.Errorf("%s/%s is not in canonical form; run go run ./tools/parallelcorpus", directory, output.name)
			}
		} else if err := os.WriteFile(target, output.data, 0o644); err != nil {
			return err
		}
	}
	if check {
		fmt.Printf("Passed: %d aligned sentence records; JSON and CSV exports are canonical.\n", len(c.Sentences))
	} else {
		fmt.Printf("Validated %d aligned sentence records and wrote JSON and CSV exports.\n", len(c.Sentences))
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

func load(dir string) (corpus, error) {
	var c corpus
	if err := readStrict(filepath.Join(dir, "sentences.json"), &c.Sentences); err != nil {
		return c, err
	}
	if err := readStrict(filepath.Join(dir, "sources.json"), &c.Sources); err != nil {
		return c, err
	}
	return c, nil
}

// readStrict decodes a UTF-8 JSON file, rejecting unknown fields and trailing data.
func readStrict(path string, target any) error {
	data, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	name := filepath.Base(path)
	if !utf8.Valid(data) {
		return fmt.Errorf("%s: invalid UTF-8", name)
	}
	if bytes.HasPrefix(data, []byte("\xef\xbb\xbf")) {
		return fmt.Errorf("%s: byte-order mark is not allowed", name)
	}
	decoder := json.NewDecoder(bytes.NewReader(data))
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(target); err != nil {
		return fmt.Errorf("%s: %w", name, err)
	}
	if decoder.More() {
		return fmt.Errorf("%s: unexpected data after the top-level array", name)
	}
	return nil
}

func validate(c corpus) error {
	var problems []string
	report := func(format string, args ...any) { problems = append(problems, fmt.Sprintf(format, args...)) }

	sources := map[string]source{}
	for i, s := range c.Sources {
		label := fmt.Sprintf("sources.json[%d]", i)
		for field, value := range map[string]string{"id": s.ID, "type": s.Type, "title": s.Title, "creator": s.Creator, "license": s.License, "rights": s.Rights, "note": s.Note} {
			if strings.TrimSpace(value) == "" {
				report("%s: %s is required and must be nonempty", label, field)
			}
		}
		if s.Type != "" && !contains(sourceTypes, s.Type) {
			report("%s: unknown source type %q", label, s.Type)
		}
		if s.Type != "original" && s.URL == "" {
			report("%s: external sources need a url", label)
		}
		if _, ok := sources[s.ID]; ok {
			report("%s: duplicate source id %q", label, s.ID)
		}
		sources[s.ID] = s
	}

	if len(c.Sentences) == 0 {
		report("sentences.json: no records")
	}
	ids := map[string]bool{}
	seenTurkmen := map[string]string{}
	used := map[string]bool{}
	for i, s := range c.Sentences {
		label := fmt.Sprintf("sentences.json[%d] (%s)", i, s.ID)
		if !idPattern.MatchString(s.ID) {
			report("%s: id must match sentence-NNNNNN", label)
		}
		if ids[s.ID] {
			report("%s: duplicate id", label)
		}
		ids[s.ID] = true
		if i > 0 && s.ID <= c.Sentences[i-1].ID {
			report("%s: records must be in ascending id order", label)
		}
		if !contains(categories, s.Category) {
			report("%s: unknown category %q", label, s.Category)
		}
		if !contains(statuses, s.VerificationStatus) {
			report("%s: unknown verification_status %q", label, s.VerificationStatus)
		}
		if _, ok := sources[s.Source]; !ok {
			report("%s: source %q is not defined in sources.json", label, s.Source)
		}
		used[s.Source] = true

		texts := languages(s.Translations)
		if s.Translations.TR == nil && s.Translations.EN == nil {
			report("%s: needs a Turkish or English translation", label)
		}
		for _, code := range []string{"tk", "tr", "en"} {
			text, ok := texts[code]
			if !ok {
				continue
			}
			if problem := checkText(text); problem != "" {
				report("%s: %s %s", label, languageNames[code], problem)
			}
		}
		for _, r := range s.Translations.TK {
			if unicode.IsLetter(r) && !strings.ContainsRune(turkmenAlphabet, r) {
				report("%s: Turkmen text has non-Turkmen letter %q (U+%04X)", label, r, r)
			}
		}
		// Alignment heuristics: sentence type and numerals must agree across languages.
		tkEnd, tkDigits := terminal(s.Translations.TK), digits(s.Translations.TK)
		for code, text := range texts {
			if code == "tk" {
				continue
			}
			if terminal(text) != tkEnd {
				report("%s: %s ends with %q but Turkmen ends with %q", label, languageNames[code], terminal(text), tkEnd)
			}
			if digits(text) != tkDigits {
				report("%s: %s numerals %q differ from Turkmen %q", label, languageNames[code], digits(text), tkDigits)
			}
		}
	}
	for i, s := range c.Sentences {
		key := duplicateKey(s.Translations.TK)
		if first, ok := seenTurkmen[key]; ok {
			report("sentences.json[%d] (%s): duplicate Turkmen sentence; first seen in %s", i, s.ID, first)
		} else {
			seenTurkmen[key] = s.ID
		}
	}
	for _, s := range c.Sources {
		if !used[s.ID] {
			report("sources.json: source %q is not referenced by any sentence", s.ID)
		}
	}
	if len(problems) > 0 {
		return fmt.Errorf("%d problem(s):\n  %s", len(problems), strings.Join(problems, "\n  "))
	}
	return nil
}

func languages(t translations) map[string]string {
	result := map[string]string{"tk": t.TK}
	if t.TR != nil {
		result["tr"] = *t.TR
	}
	if t.EN != nil {
		result["en"] = *t.EN
	}
	return result
}

func checkText(text string) string {
	switch {
	case strings.TrimSpace(text) == "":
		return "sentence is empty"
	case strings.TrimSpace(text) != text:
		return "sentence has leading or trailing whitespace"
	case strings.Contains(text, "  "):
		return "sentence has repeated spaces"
	case !norm.NFC.IsNormalString(text):
		return "sentence is not in Unicode NFC form"
	}
	for _, r := range text {
		if unicode.IsControl(r) {
			return fmt.Sprintf("sentence has control character U+%04X", r)
		}
	}
	return ""
}

func terminal(text string) string {
	last, _ := utf8.DecodeLastRuneInString(text)
	if strings.ContainsRune(".?!", last) {
		return string(last)
	}
	return ""
}

func digits(text string) string {
	return strings.Join(digitPattern.FindAllString(text, -1), " ")
}

// duplicateKey folds case, punctuation, and spacing so near-identical sentences collide.
func duplicateKey(text string) string {
	var b strings.Builder
	for _, word := range strings.FieldsFunc(text, func(r rune) bool { return !unicode.IsLetter(r) && !unicode.IsDigit(r) }) {
		if b.Len() > 0 {
			b.WriteByte(' ')
		}
		b.WriteString(strings.ToLower(word))
	}
	return b.String()
}

func renderJSON(sentences []sentence) ([]byte, error) {
	var output bytes.Buffer
	encoder := json.NewEncoder(&output)
	encoder.SetEscapeHTML(false)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(sentences); err != nil {
		return nil, err
	}
	return output.Bytes(), nil
}

func renderCSV(sentences []sentence) ([]byte, error) {
	var output bytes.Buffer
	writer := csv.NewWriter(&output)
	if err := writer.Write(csvColumns); err != nil {
		return nil, err
	}
	for _, s := range sentences {
		texts := languages(s.Translations)
		if err := writer.Write([]string{s.ID, texts["tk"], texts["tr"], texts["en"], s.Category, s.VerificationStatus, s.Source}); err != nil {
			return nil, err
		}
	}
	writer.Flush()
	return output.Bytes(), writer.Error()
}

func contains(values []string, value string) bool {
	for _, v := range values {
		if v == value {
			return true
		}
	}
	return false
}
