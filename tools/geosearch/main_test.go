package main

import (
	"encoding/json"
	"os"
	"reflect"
	"testing"
)

func fixture(t *testing.T) []Entry {
	t.Helper()
	p := "root"
	regions := []Region{{Slug: "root", Name: "Türkmenistan", Type: "country"}, {Slug: "a", Parent: &p, Name: "Aşgabat", English: "Ashgabat", Type: "independent_city", Status: "verified", SourceURL: "source", SourceDate: "2022-12-20"}, {Slug: "b", Parent: &p, Name: "Aşgabat", Type: "village", Status: "verification_required"}}
	index, e := build(regions, []Alias{{Slug: "a", Text: "Ашхабад", Language: "ru", Kind: "historical"}})
	if e != nil {
		t.Fatal(e)
	}
	return index
}
func TestSearch(t *testing.T) {
	index := fixture(t)
	tests := []struct {
		name        string
		q           Query
		want        int
		slug, match string
	}{
		{"canonical", Query{Query: "Aşgabat"}, 2, "a", "exact"},
		{"case", Query{Query: "ASHGABAT"}, 1, "a", "exact"},
		{"ascii", Query{Query: "asgabat"}, 2, "a", "normalized"},
		{"decomposed", Query{Query: "As\u0327gabat"}, 2, "a", "exact"},
		{"cyrillic", Query{Query: "АШХАБАД"}, 1, "a", "exact"},
		{"prefix", Query{Query: "ash", Prefix: true}, 1, "a", "prefix"},
		{"no prefix by default", Query{Query: "ash"}, 0, "", ""},
		{"fuzzy", Query{Query: "ashgabatx", Fuzzy: true}, 1, "a", "fuzzy"},
		{"no fuzzy by default", Query{Query: "ashgabatx"}, 0, "", ""},
		{"type", Query{Query: "Aşgabat", Type: "village"}, 1, "b", "exact"},
		{"parent", Query{Query: "Aşgabat", Parent: "root"}, 2, "a", "exact"},
		{"verified", Query{Query: "Aşgabat", VerifiedOnly: true}, 1, "a", "exact"},
		{"limit", Query{Query: "Aşgabat", Limit: 1}, 1, "a", "exact"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, e := search(index, tt.q)
			if e != nil {
				t.Fatal(e)
			}
			if len(got) != tt.want {
				t.Fatalf("got %d want %d", len(got), tt.want)
			}
			if len(got) > 0 && (got[0].Slug != tt.slug || got[0].Match != tt.match) {
				t.Fatalf("unexpected result %+v", got[0])
			}
		})
	}
	for _, q := range []Query{{Query: " "}, {Query: "a", Limit: -1}, {Query: "a", Type: "bad"}, {Query: "a", Parent: "bad"}} {
		if _, e := search(index, q); e == nil {
			t.Fatalf("expected invalid request: %+v", q)
		}
	}
}
func TestGeneration(t *testing.T) {
	var regions []Region
	var aliases []Alias
	if e := read("../../geo/json/regions.json", &regions); e != nil {
		t.Fatal(e)
	}
	if e := read("../../geo/json/region_aliases.json", &aliases); e != nil {
		t.Fatal(e)
	}
	before, _ := json.Marshal(regions)
	abefore, _ := json.Marshal(aliases)
	index, e := build(regions, aliases)
	if e != nil {
		t.Fatal(e)
	}
	after, _ := json.Marshal(regions)
	aafter, _ := json.Marshal(aliases)
	if string(before) != string(after) || string(abefore) != string(aafter) {
		t.Fatal("source mutated")
	}
	b, _ := json.MarshalIndent(index, "", "  ")
	b = append(b, '\n')
	disk, e := os.ReadFile("../../geo/search/index.json")
	if e != nil {
		t.Fatal(e)
	}
	if string(b) != string(disk) {
		t.Fatal("stale generated index")
	}
	if len(index) != len(regions) {
		t.Fatal("lost regions")
	}
	byID := map[string]Entry{}
	for _, entry := range index {
		byID[entry.Slug] = entry
	}
	for _, r := range regions {
		e := byID[r.Slug]
		if e.Name != r.Name || e.Status != r.Status || e.SourceURL != r.SourceURL || e.SourceDate != r.SourceDate || !reflect.DeepEqual(e.Parent, r.Parent) {
			t.Fatalf("metadata lost: %s", r.Slug)
		}
	}
	for _, a := range aliases {
		found := false
		for _, v := range byID[a.Slug].Aliases {
			if v.Text == a.Text {
				found = true
			}
		}
		if !found {
			t.Fatalf("lost alias %+v", a)
		}
	}
	got, e := search(index, Query{Query: "Ashgabat"})
	if e != nil || len(got) == 0 || got[0].Slug != "turkmenistan-asgabat" {
		t.Fatalf("Ashgabat: %+v %v", got, e)
	}
}
func TestInvalidSources(t *testing.T) {
	for _, tt := range []struct {
		r []Region
		a []Alias
	}{
		{[]Region{{Slug: "a", Name: "A"}, {Slug: "a", Name: "B"}}, nil},
		{[]Region{{Slug: "a", Name: "A"}}, []Alias{{Slug: "missing", Text: "B"}}},
	} {
		if _, e := build(tt.r, tt.a); e == nil {
			t.Fatal("expected source integrity error")
		}
	}
}
func TestRuneDistance(t *testing.T) {
	if distance("ä", "a") != 1 || distance("ş", "s") != 1 {
		t.Fatal("distance must count runes")
	}
}
