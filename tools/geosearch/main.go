// Command geosearch generates a derived index or searches it without changing sources.
package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"sort"
	"strings"
	"unicode"
	"unicode/utf8"

	"golang.org/x/text/cases"
	"golang.org/x/text/unicode/norm"
)

type Region struct {
	Slug       string  `json:"slug"`
	Parent     *string `json:"parent_slug"`
	Name       string  `json:"name_tm"`
	English    string  `json:"name_en"`
	Russian    *string `json:"name_ru"`
	Type       string  `json:"type"`
	Status     string  `json:"verification_status"`
	SourceURL  string  `json:"source_url"`
	SourceDate string  `json:"source_date"`
}
type Alias struct {
	Slug     string `json:"region_slug,omitempty"`
	Text     string `json:"alias"`
	Language string `json:"language"`
	Kind     string `json:"alias_type"`
	Key      string `json:"key"`
	ASCII    string `json:"ascii_key"`
}
type Entry struct {
	Slug       string  `json:"slug"`
	Parent     *string `json:"parent_slug"`
	Name       string  `json:"name"`
	Type       string  `json:"type"`
	Status     string  `json:"verification_status"`
	SourceURL  string  `json:"source_url"`
	SourceDate string  `json:"source_date"`
	Aliases    []Alias `json:"aliases"`
}
type Query struct {
	Query        string `json:"query"`
	Limit        int    `json:"limit"`
	Type         string `json:"type"`
	Parent       string `json:"parent_slug"`
	Prefix       bool   `json:"prefix"`
	Fuzzy        bool   `json:"fuzzy"`
	VerifiedOnly bool   `json:"verified_only"`
}
type Result struct {
	Entry
	MatchedAlias string `json:"matched_alias"`
	Match        string `json:"match"`
	Distance     int    `json:"distance"`
	rank         int
}

func key(s string) string { return norm.NFC.String(cases.Fold().String(strings.TrimSpace(s))) }
func ascii(s string) string {
	var b strings.Builder
	for _, r := range norm.NFD.String(key(s)) {
		if unicode.Is(unicode.Mn, r) {
			continue
		}
		switch r {
		case 'ı':
			r = 'i'
		case 'ł':
			r = 'l'
		}
		b.WriteRune(r)
	}
	return norm.NFC.String(b.String())
}
func read(path string, v any) error {
	b, e := os.ReadFile(path)
	if e != nil {
		return e
	}
	if !utf8.Valid(b) {
		return fmt.Errorf("invalid UTF-8: %s", path)
	}
	return json.Unmarshal(b, v)
}
func build(regions []Region, aliases []Alias) ([]Entry, error) {
	out := make([]Entry, 0, len(regions))
	ids := map[string]int{}
	for _, r := range regions {
		if r.Slug == "" || r.Name == "" {
			return nil, fmt.Errorf("missing slug or name")
		}
		if _, ok := ids[r.Slug]; ok {
			return nil, fmt.Errorf("duplicate slug %s", r.Slug)
		}
		ids[r.Slug] = len(out)
		out = append(out, Entry{r.Slug, r.Parent, r.Name, r.Type, r.Status, r.SourceURL, r.SourceDate, []Alias{}})
	}
	seen := map[string]bool{}
	add := func(i int, a Alias) {
		id := out[i].Slug + "\x00" + a.Text
		if a.Text == "" || seen[id] {
			return
		}
		seen[id] = true
		a.Slug = ""
		a.Key = key(a.Text)
		a.ASCII = ascii(a.Text)
		out[i].Aliases = append(out[i].Aliases, a)
	}
	for i, r := range regions {
		if r.Parent != nil {
			if _, ok := ids[*r.Parent]; !ok {
				return nil, fmt.Errorf("unknown parent %s", *r.Parent)
			}
		}
		add(i, Alias{Text: r.Name, Language: "tm", Kind: "canonical"})
	}
	for _, a := range aliases {
		i, ok := ids[a.Slug]
		if !ok {
			return nil, fmt.Errorf("orphan alias %s", a.Slug)
		}
		add(i, a)
	}
	for i, r := range regions {
		add(i, Alias{Text: r.English, Language: "en", Kind: "transliteration"})
		if r.Russian != nil {
			add(i, Alias{Text: *r.Russian, Language: "ru", Kind: "transliteration"})
		}
	}
	for i := range out {
		sort.Slice(out[i].Aliases, func(a, b int) bool { return out[i].Aliases[a].Text < out[i].Aliases[b].Text })
	}
	sort.Slice(out, func(i, j int) bool { return out[i].Slug < out[j].Slug })
	return out, nil
}
func distance(a, b string) int {
	x, y := []rune(a), []rune(b)
	row := make([]int, len(y)+1)
	for j := range row {
		row[j] = j
	}
	for i, r := range x {
		prev := row[0]
		row[0] = i + 1
		for j, s := range y {
			old := row[j+1]
			cost := 0
			if r != s {
				cost = 1
			}
			row[j+1] = min(row[j+1]+1, row[j]+1, prev+cost)
			prev = old
		}
	}
	return row[len(y)]
}
func search(index []Entry, q Query) ([]Result, error) {
	if !utf8.ValidString(q.Query) {
		return nil, fmt.Errorf("query must be UTF-8")
	}
	k := key(q.Query)
	a := ascii(q.Query)
	if k == "" {
		return nil, fmt.Errorf("query must not be empty")
	}
	if utf8.RuneCountInString(k) > 256 {
		return nil, fmt.Errorf("query exceeds 256 characters")
	}
	if q.Limit < 0 || q.Limit > 1000 {
		return nil, fmt.Errorf("limit must be 0..1000")
	}
	if q.Limit == 0 {
		q.Limit = 10
	}
	types := map[string]bool{}
	parents := map[string]*string{}
	for _, e := range index {
		types[e.Type] = true
		parents[e.Slug] = e.Parent
	}
	if q.Type != "" && !types[q.Type] {
		return nil, fmt.Errorf("unknown type %s", q.Type)
	}
	if q.Parent != "" {
		if _, ok := parents[q.Parent]; !ok {
			return nil, fmt.Errorf("unknown parent %s", q.Parent)
		}
	}
	under := func(e Entry) bool {
		seen := map[string]bool{}
		p := e.Parent
		for p != nil && !seen[*p] {
			if *p == q.Parent {
				return true
			}
			seen[*p] = true
			p = parents[*p]
		}
		return false
	}
	results := []Result{}
	for _, e := range index {
		if q.Type != "" && e.Type != q.Type || q.Parent != "" && !under(e) || q.VerifiedOnly && e.Status != "verified" {
			continue
		}
		best := Result{Entry: e, rank: 99}
		for _, alias := range e.Aliases {
			rank, d, kind := 99, 0, ""
			switch {
			case alias.Key == k:
				rank, kind = 0, "exact"
			case alias.ASCII == a:
				rank, kind = 1, "normalized"
			case q.Prefix && (strings.HasPrefix(alias.Key, k) || strings.HasPrefix(alias.ASCII, a)):
				rank, kind = 2, "prefix"
			case q.Fuzzy:
				d = min(distance(k, alias.Key), distance(a, alias.ASCII))
				if d <= 1 {
					rank, kind = 3, "fuzzy"
				}
			}
			if rank < best.rank || rank == best.rank && d < best.Distance {
				best.MatchedAlias = alias.Text
				best.Match = kind
				best.Distance = d
				best.rank = rank
			}
		}
		if best.rank < 99 {
			results = append(results, best)
		}
	}
	sort.Slice(results, func(i, j int) bool {
		a, b := results[i], results[j]
		if a.rank != b.rank {
			return a.rank < b.rank
		}
		if a.Distance != b.Distance {
			return a.Distance < b.Distance
		}
		return a.Slug < b.Slug
	})
	if len(results) > q.Limit {
		results = results[:q.Limit]
	}
	return results, nil
}
func run() error {
	check := flag.Bool("check", false, "check index freshness")
	query := flag.String("query", "", "search text")
	request := flag.String("request", "", "JSON search request")
	limit := flag.Int("limit", 10, "maximum results")
	typ := flag.String("type", "", "administrative type")
	parent := flag.String("parent", "", "ancestor slug")
	prefix := flag.Bool("prefix", false, "enable prefix matches")
	fuzzy := flag.Bool("fuzzy", false, "allow edit distance one")
	verified := flag.Bool("verified-only", false, "only verified regions")
	flag.Parse()
	if flag.NArg() != 0 {
		return fmt.Errorf("unexpected positional arguments")
	}
	path := "geo/search/index.json"
	if *query != "" || *request != "" {
		if *check {
			return fmt.Errorf("--check cannot be combined with search")
		}
		var index []Entry
		if e := read(path, &index); e != nil {
			return e
		}
		q := Query{*query, *limit, *typ, *parent, *prefix, *fuzzy, *verified}
		if *request != "" {
			q = Query{}
			dec := json.NewDecoder(strings.NewReader(*request))
			dec.DisallowUnknownFields()
			if e := dec.Decode(&q); e != nil {
				return e
			}
			var raw any
			if e := json.Unmarshal([]byte(*request), &raw); e != nil {
				return e
			}
		}
		results, e := search(index, q)
		if e != nil {
			return e
		}
		enc := json.NewEncoder(os.Stdout)
		enc.SetIndent("", "  ")
		return enc.Encode(struct {
			Results []Result `json:"results"`
		}{results})
	}
	var regions []Region
	var aliases []Alias
	if e := read("geo/json/regions.json", &regions); e != nil {
		return e
	}
	if e := read("geo/json/region_aliases.json", &aliases); e != nil {
		return e
	}
	index, e := build(regions, aliases)
	if e != nil {
		return e
	}
	b, e := json.MarshalIndent(index, "", "  ")
	if e != nil {
		return e
	}
	b = append(b, '\n')
	if *check {
		old, e := os.ReadFile(path)
		if e != nil {
			return e
		}
		if !bytes.Equal(old, b) {
			return fmt.Errorf("stale index: run go run ./tools/geosearch")
		}
		return nil
	}
	return os.WriteFile(path, b, 0644)
}
func main() {
	if e := run(); e != nil {
		fmt.Fprintln(os.Stderr, e)
		os.Exit(1)
	}
}
