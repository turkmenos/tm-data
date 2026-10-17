// Command morphology checks the curated analyses; it is not an open-vocabulary analyzer.
package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"time"
	"unicode/utf8"

	"golang.org/x/text/unicode/norm"
)

type reference struct {
	SourceID string `json:"source_id"`
	Locator  string `json:"locator"`
}
type source struct {
	ID              string `json:"id"`
	Title           string `json:"title"`
	Creator         string `json:"creator"`
	PublicationYear *int   `json:"publication_year"`
	URL             string `json:"url"`
	AccessedOn      string `json:"accessed_on"`
	Rights          string `json:"rights"`
	Note            string `json:"note"`
}
type variant struct {
	Value    string `json:"value"`
	Backness string `json:"backness"`
	After    string `json:"after"`
	Rounded  *bool  `json:"rounded,omitempty"`
}
type suffix struct {
	ID               string            `json:"id"`
	POS              string            `json:"pos"`
	Slot             int               `json:"slot"`
	Features         map[string]string `json:"features"`
	Harmony          string            `json:"harmony"`
	Variants         []variant         `json:"variants"`
	RequiresPrevious []string          `json:"requires_previous"`
	Excludes         []string          `json:"excludes"`
	Status           string            `json:"verification_status"`
	References       []reference       `json:"references"`
}
type parameters struct {
	Front              []string `json:"front,omitempty"`
	Back               []string `json:"back,omitempty"`
	Rounded            []string `json:"rounded,omitempty"`
	MaxStemVowels      int      `json:"max_stem_vowels,omitempty"`
	SuffixHarmony      string   `json:"suffix_harmony,omitempty"`
	POS                string   `json:"pos,omitempty"`
	Slots              []int    `json:"slots,omitempty"`
	RequiredSlot       int      `json:"required_slot,omitempty"`
	BlockedPredecessor string   `json:"blocked_predecessor,omitempty"`
	BlockedSlot        int      `json:"blocked_slot,omitempty"`
	ExceptionKind      string   `json:"exception_kind,omitempty"`
	Trigger            string   `json:"trigger,omitempty"`
	Examples           []string `json:"examples,omitempty"`
	Representation     string   `json:"representation,omitempty"`
}
type rule struct {
	ID          string      `json:"id"`
	Kind        string      `json:"kind"`
	Description string      `json:"description"`
	Parameters  parameters  `json:"parameters"`
	Status      string      `json:"verification_status"`
	References  []reference `json:"references"`
}
type exception struct {
	ID          string      `json:"id"`
	Kind        string      `json:"kind"`
	Root        string      `json:"root"`
	Stem        string      `json:"stem"`
	POS         string      `json:"pos"`
	Trigger     string      `json:"trigger"`
	SuffixIDs   []string    `json:"suffix_ids"`
	ExampleWord string      `json:"example_word"`
	Note        string      `json:"note"`
	Status      string      `json:"verification_status"`
	References  []reference `json:"references"`
}
type segment struct {
	SuffixID string `json:"suffix_id"`
	Value    string `json:"value"`
}
type example struct {
	ID           string      `json:"id"`
	Word         string      `json:"word"`
	Root         string      `json:"root"`
	Stem         string      `json:"stem"`
	POS          string      `json:"pos"`
	Segments     []segment   `json:"segments"`
	Meaning      string      `json:"meaning_en"`
	ExceptionIDs []string    `json:"exception_ids"`
	Status       string      `json:"verification_status"`
	References   []reference `json:"references"`
}
type dataset struct {
	Sources    []source
	Suffixes   []suffix
	Rules      []rule
	Exceptions []exception
	Examples   []example
}

func main() {
	dir := flag.String("dir", "language/morphology", "dataset directory (run from repository root)")
	flag.Parse()
	if flag.NArg() != 0 {
		fmt.Fprintln(os.Stderr, "usage: morphology [-dir path]")
		os.Exit(2)
	}
	d, err := load(*dir)
	if err == nil {
		err = validate(d)
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(1)
	}
	fmt.Printf("Passed: %d suffix families, %d rules, %d examples, %d exceptions.\n", len(d.Suffixes), len(d.Rules), len(d.Examples), len(d.Exceptions))
}
func load(dir string) (dataset, error) {
	var d dataset
	for _, file := range []struct {
		name   string
		target any
	}{{"sources.json", &d.Sources}, {"suffixes.json", &d.Suffixes}, {"rules.json", &d.Rules}, {"exceptions.json", &d.Exceptions}, {"examples.json", &d.Examples}} {
		b, err := os.ReadFile(filepath.Join(dir, file.name))
		if err != nil {
			return d, err
		}
		if !utf8.Valid(b) || !norm.NFC.IsNormal(b) {
			return d, fmt.Errorf("%s must be NFC UTF-8", file.name)
		}
		if err := checkShape(b, reflect.TypeOf(file.target).Elem(), file.name); err != nil {
			return d, err
		}
		dec := json.NewDecoder(bytes.NewReader(b))
		dec.DisallowUnknownFields()
		if err := dec.Decode(file.target); err != nil {
			return d, fmt.Errorf("%s: %w", file.name, err)
		}
		if err := dec.Decode(new(any)); err != io.EOF {
			return d, fmt.Errorf("%s: trailing JSON", file.name)
		}
	}
	return d, nil
}

// Go's decoder accepts missing fields and null scalars. Check presence separately
// so a removed false/zero/null field cannot silently change the schema contract.
func checkShape(raw json.RawMessage, typ reflect.Type, path string) error {
	if bytes.Equal(bytes.TrimSpace(raw), []byte("null")) {
		if strings.HasSuffix(path, ".publication_year") {
			return nil
		}
		return fmt.Errorf("%s: null is not allowed", path)
	}
	if typ.Kind() == reflect.Pointer {
		return checkShape(raw, typ.Elem(), path)
	}
	switch typ.Kind() {
	case reflect.Struct:
		var obj map[string]json.RawMessage
		if err := json.Unmarshal(raw, &obj); err != nil {
			return fmt.Errorf("%s: %w", path, err)
		}
		for i := 0; i < typ.NumField(); i++ {
			field := typ.Field(i)
			tag := strings.Split(field.Tag.Get("json"), ",")
			value, ok := obj[tag[0]]
			if !ok {
				if !has(tag, "omitempty") {
					return fmt.Errorf("%s: missing required field %s", path, tag[0])
				}
				continue
			}
			if err := checkShape(value, field.Type, path+"."+tag[0]); err != nil {
				return err
			}
		}
	case reflect.Slice:
		var values []json.RawMessage
		if err := json.Unmarshal(raw, &values); err != nil {
			return fmt.Errorf("%s: %w", path, err)
		}
		for i, value := range values {
			if err := checkShape(value, typ.Elem(), fmt.Sprintf("%s[%d]", path, i)); err != nil {
				return err
			}
		}
	case reflect.Map:
		var values map[string]json.RawMessage
		if err := json.Unmarshal(raw, &values); err != nil {
			return fmt.Errorf("%s: %w", path, err)
		}
		for key, value := range values {
			if err := checkShape(value, typ.Elem(), path+"."+key); err != nil {
				return err
			}
		}
	}
	return nil
}

func has[T comparable](values []T, v T) bool {
	for _, x := range values {
		if x == v {
			return true
		}
	}
	return false
}
func checkID(seen map[string]bool, id string) error {
	if strings.TrimSpace(id) == "" || seen[id] {
		return fmt.Errorf("empty or duplicate id %q", id)
	}
	seen[id] = true
	return nil
}
func checkRefs(refs []reference, sources map[string]bool) error {
	if len(refs) == 0 {
		return fmt.Errorf("missing references")
	}
	for _, r := range refs {
		if !sources[r.SourceID] || strings.TrimSpace(r.Locator) == "" {
			return fmt.Errorf("invalid source/locator: %+v", r)
		}
	}
	return nil
}
func validate(d dataset) error {
	if len(d.Sources) == 0 || len(d.Suffixes) == 0 || len(d.Rules) == 0 || len(d.Exceptions) == 0 || len(d.Examples) == 0 {
		return fmt.Errorf("all five collections must be non-empty")
	}
	sources := map[string]bool{}
	for _, s := range d.Sources {
		if err := checkID(sources, s.ID); err != nil {
			return err
		}
		if s.Title == "" || s.Creator == "" || s.Rights == "" || s.Note == "" || !strings.HasPrefix(s.URL, "https://") {
			return fmt.Errorf("%s: incomplete source", s.ID)
		}
		if _, err := time.Parse("2006-01-02", s.AccessedOn); err != nil {
			return fmt.Errorf("%s: invalid access date", s.ID)
		}
	}
	rules := map[string]rule{}
	seen := map[string]bool{}
	for _, r := range d.Rules {
		if err := checkID(seen, r.ID); err != nil {
			return err
		}
		if r.Description == "" || !has([]string{"harmony", "ordering", "compatibility", "alternation", "exception", "scope"}, r.Kind) || r.Status != "source_checked" {
			return fmt.Errorf("%s: invalid rule", r.ID)
		}
		if err := checkRefs(r.References, sources); err != nil {
			return fmt.Errorf("%s: %w", r.ID, err)
		}
		rules[r.ID] = r
	}
	for _, id := range []string{"vowel-backness", "written-rounding", "noun-order", "verb-order", "possessive-case-buffer", "lexical-stem-voicing", "mixed-vowel-roots", "orthography-not-speech"} {
		if _, ok := rules[id]; !ok {
			return fmt.Errorf("missing rule %s", id)
		}
	}
	harmony := rules["vowel-backness"].Parameters
	if strings.Join(harmony.Front, "") != "äeiöü" || strings.Join(harmony.Back, "") != "aouy" {
		return fmt.Errorf("invalid vowel classes")
	}
	rounding := rules["written-rounding"].Parameters
	if strings.Join(rounding.Rounded, "") != "oöuü" || rounding.MaxStemVowels != 1 || rounding.SuffixHarmony != "second_syllable_high" {
		return fmt.Errorf("invalid written rounding rule")
	}
	for _, pos := range []string{"noun", "verb"} {
		p := rules[pos+"-order"].Parameters
		if p.POS != pos || len(p.Slots) != 3 || p.Slots[0] != 10 || p.Slots[1] != 20 || p.Slots[2] != 30 {
			return fmt.Errorf("invalid %s ordering", pos)
		}
	}
	if rules["verb-order"].Parameters.RequiredSlot != 20 {
		return fmt.Errorf("verb order must require tense/mood/infinitive")
	}
	buffer := rules["possessive-case-buffer"].Parameters
	if buffer.BlockedPredecessor != "noun-poss-3" || buffer.BlockedSlot != 30 {
		return fmt.Errorf("invalid possessive case compatibility rule")
	}
	suffixes := map[string]suffix{}
	seen = map[string]bool{}
	for _, s := range d.Suffixes {
		if err := checkID(seen, s.ID); err != nil {
			return err
		}
		if !has([]string{"noun", "verb"}, s.POS) || !has(rules[s.POS+"-order"].Parameters.Slots, s.Slot) || len(s.Features) == 0 || len(s.Variants) == 0 || s.RequiresPrevious == nil || s.Excludes == nil || s.Status != "source_checked" || !has([]string{"none", "backness", "second_syllable_high"}, s.Harmony) {
			return fmt.Errorf("%s: invalid suffix schema", s.ID)
		}
		if err := checkRefs(s.References, sources); err != nil {
			return fmt.Errorf("%s: %w", s.ID, err)
		}
		allowedFeatures := map[string][]string{
			"number": {"singular", "plural"}, "possessor_number": {"singular", "plural", "unspecified"},
			"person": {"1", "2", "3"}, "possessor_person": {"1", "2", "3"},
			"case":     {"genitive", "dative", "accusative", "locative", "ablative"},
			"polarity": {"negative"}, "verb_form": {"infinitive"}, "tense": {"past", "present", "future"}, "mood": {"intentional", "conditional"},
		}
		for key, value := range s.Features {
			if !has(allowedFeatures[key], value) {
				return fmt.Errorf("%s: unknown feature %s=%s", s.ID, key, value)
			}
		}
		variants := map[string]bool{}
		for _, v := range s.Variants {
			if v.Value == "" || variants[v.Value] || !has([]string{"back", "front", "any"}, v.Backness) || !has([]string{"vowel", "consonant", "any"}, v.After) || (v.Rounded != nil && s.Harmony != "second_syllable_high") {
				return fmt.Errorf("%s: invalid variant %+v", s.ID, v)
			}
			variants[v.Value] = true
		}
		suffixes[s.ID] = s
	}
	for _, s := range d.Suffixes {
		for _, id := range append(append([]string{}, s.RequiresPrevious...), s.Excludes...) {
			if _, ok := suffixes[id]; !ok {
				return fmt.Errorf("%s: unknown compatibility reference %s", s.ID, id)
			}
		}
	}
	exceptions := map[string]exception{}
	seen = map[string]bool{}
	for _, e := range d.Exceptions {
		if err := checkID(seen, e.ID); err != nil {
			return err
		}
		if e.Root == "" || e.Stem == "" || e.Note == "" || e.ExampleWord == "" || e.Status != "source_checked" || !has([]string{"noun", "verb"}, e.POS) || e.SuffixIDs == nil {
			return fmt.Errorf("%s: invalid exception", e.ID)
		}
		if e.Kind == "stem_alternation" {
			if e.Root == e.Stem || !has([]string{"vowel_initial_suffix", "suffix_ids"}, e.Trigger) || (e.Trigger == "suffix_ids" && len(e.SuffixIDs) == 0) {
				return fmt.Errorf("%s: invalid alternation", e.ID)
			}
		} else if e.Kind != "mixed_vowel_root" || e.Root != e.Stem || e.Trigger != "last_vowel" {
			return fmt.Errorf("%s: invalid exception kind/trigger", e.ID)
		}
		if err := checkRefs(e.References, sources); err != nil {
			return fmt.Errorf("%s: %w", e.ID, err)
		}
		for _, id := range e.SuffixIDs {
			if _, ok := suffixes[id]; !ok {
				return fmt.Errorf("%s: unknown suffix %s", e.ID, id)
			}
		}
		exceptions[e.ID] = e
	}
	seen = map[string]bool{}
	words := map[string]bool{}
	covered := map[string]bool{}
	for _, e := range d.Examples {
		if err := checkID(seen, e.ID); err != nil {
			return err
		}
		if e.Word == "" || e.Root == "" || e.Stem == "" || e.Meaning == "" || words[e.Word] || e.ExceptionIDs == nil || len(e.Segments) == 0 || !has([]string{"noun", "verb"}, e.POS) || !has([]string{"attested", "rule_checked"}, e.Status) {
			return fmt.Errorf("%s: invalid example schema or duplicate word", e.ID)
		}
		words[e.Word] = true
		if err := checkRefs(e.References, sources); err != nil {
			return fmt.Errorf("%s: %w", e.ID, err)
		}
		if err := checkExample(e, suffixes, exceptions, rules, covered); err != nil {
			return fmt.Errorf("%s: %w", e.ID, err)
		}
	}
	for id := range suffixes {
		if !covered[id] {
			return fmt.Errorf("suffix %s has no example", id)
		}
	}
	for _, x := range d.Exceptions {
		found := false
		for _, e := range d.Examples {
			if e.Word == x.ExampleWord && e.Root == x.Root {
				if x.Kind == "mixed_vowel_root" || has(e.ExceptionIDs, x.ID) {
					found = true
				}
			}
		}
		if !found {
			return fmt.Errorf("%s: exception lacks matching example", x.ID)
		}
	}
	return nil
}
func vowelInfo(stem string, p parameters) (string, int, bool) {
	backness := ""
	n := 0
	endsVowel := false
	for _, r := range stem {
		endsVowel = false
		if has(p.Front, string(r)) {
			backness = "front"
			n++
			endsVowel = true
		}
		if has(p.Back, string(r)) {
			backness = "back"
			n++
			endsVowel = true
		}
	}
	return backness, n, endsVowel
}
func checkExample(e example, suffixes map[string]suffix, exceptions map[string]exception, rules map[string]rule, covered map[string]bool) error {
	if len(e.Segments) == 0 || e.Segments[0].Value == "" {
		return fmt.Errorf("empty first segment")
	}
	vowel := rules["vowel-backness"].Parameters
	rounding := rules["written-rounding"].Parameters
	seenExceptions := map[string]bool{}
	alternations := 0
	for _, id := range e.ExceptionIDs {
		if seenExceptions[id] {
			return fmt.Errorf("duplicate exception %s", id)
		}
		seenExceptions[id] = true
		x, ok := exceptions[id]
		if !ok || x.Root != e.Root || x.POS != e.POS {
			return fmt.Errorf("unknown or mismatched exception %s", id)
		}
		if x.Kind == "stem_alternation" {
			alternations++
			if x.Stem != e.Stem {
				return fmt.Errorf("stem does not match exception")
			}
			first := e.Segments[0]
			if x.Trigger == "vowel_initial_suffix" {
				_, _, isVowel := vowelInfo(string([]rune(first.Value)[0]), vowel)
				if !isVowel {
					return fmt.Errorf("voicing before consonant-initial suffix")
				}
			} else if !has(x.SuffixIDs, first.SuffixID) {
				return fmt.Errorf("alternation not licensed for suffix")
			}
		}
	}
	if (e.Root != e.Stem && alternations != 1) || (e.Root == e.Stem && alternations != 0) {
		return fmt.Errorf("unlicensed stem change")
	}
	surface := e.Stem
	lastSlot := 0
	previous := ""
	used := []string{}
	hasRequiredSlot := false
	for _, seg := range e.Segments {
		s, ok := suffixes[seg.SuffixID]
		if !ok {
			return fmt.Errorf("unknown suffix %s", seg.SuffixID)
		}
		if s.POS != e.POS || s.Slot <= lastSlot {
			return fmt.Errorf("invalid suffix POS/order: %s", s.ID)
		}
		if len(s.RequiresPrevious) > 0 && !has(s.RequiresPrevious, previous) {
			return fmt.Errorf("incompatible predecessor for %s", s.ID)
		}
		for _, id := range used {
			if has(s.Excludes, id) || has(suffixes[id].Excludes, s.ID) {
				return fmt.Errorf("incompatible suffix pair %s/%s", id, s.ID)
			}
		}
		buffer := rules["possessive-case-buffer"].Parameters
		if previous == buffer.BlockedPredecessor && s.Slot == buffer.BlockedSlot {
			return fmt.Errorf("third-person possessive case outside supported subset")
		}
		backness, n, endsVowel := vowelInfo(surface, vowel)
		if n == 0 {
			return fmt.Errorf("stem has no Turkmen vowel")
		}
		attachment := "consonant"
		if endsVowel {
			attachment = "vowel"
		}
		rounded := false
		if n <= rounding.MaxStemVowels {
			for _, r := range surface {
				if has(rounding.Rounded, string(r)) {
					rounded = true
				}
			}
		}
		match := false
		for _, v := range s.Variants {
			if v.Value == seg.Value && (v.Backness == "any" || v.Backness == backness) && (v.After == "any" || v.After == attachment) && (v.Rounded == nil || *v.Rounded == rounded) {
				match = true
			}
		}
		if !match {
			return fmt.Errorf("invalid allomorph %q for %s after %q", seg.Value, s.ID, surface)
		}
		surface += seg.Value
		lastSlot = s.Slot
		previous = s.ID
		used = append(used, s.ID)
		covered[s.ID] = true
		if s.Slot == rules[e.POS+"-order"].Parameters.RequiredSlot {
			hasRequiredSlot = true
		}
	}
	if e.POS == "verb" && !hasRequiredSlot {
		return fmt.Errorf("missing tense/mood/infinitive")
	}
	if surface != e.Word {
		return fmt.Errorf("segments reconstruct %q, expected %q", surface, e.Word)
	}
	return nil
}
