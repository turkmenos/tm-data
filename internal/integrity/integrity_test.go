package integrity

import (
	"encoding/json"
	"strings"
	"testing"
)

func records(t *testing.T, data string) []map[string]any {
	t.Helper()
	var result []map[string]any
	decoder := json.NewDecoder(strings.NewReader(data))
	decoder.UseNumber()
	if err := decoder.Decode(&result); err != nil {
		t.Fatal(err)
	}
	return result
}

func kinds(issues []Issue) map[string]int {
	result := map[string]int{}
	for _, issue := range issues {
		result[issue.Kind]++
	}
	return result
}

func TestValidateDatasetKinds(t *testing.T) {
	rule := Dataset{
		Path:          "a.json",
		Required:      map[string]string{"id": "string"},
		NonEmpty:      []string{"id"},
		Unique:        [][]string{{"id"}},
		AllowedValues: map[string][]string{"type": {"x"}},
		Ranges:        map[string]numRange{"n": {Min: 1, Max: 2}},
		AnyRequired:   [][]string{{"day", "rule"}},
	}
	got := kinds(ValidateDataset(rule, records(t, `[
		{"id":"a","type":"x","n":1,"day":1},
		{"id":"a","type":"y","n":5,"rule":"r"},
		{"id":7,"day":1},
		{"type":"x"}
	]`)))
	want := map[string]int{KindUnique: 1, KindAllowedValue: 1, KindRange: 1, KindType: 1, KindRequired: 1, KindNonEmpty: 1, KindAnyRequired: 1}
	for kind, count := range want {
		if got[kind] != count {
			t.Errorf("%s: want %d, got %d (%v)", kind, count, got[kind], got)
		}
	}
}

func TestValidateReferences(t *testing.T) {
	cache := map[string][]map[string]any{
		"to.json":   records(t, `[{"id":"a"}]`),
		"from.json": records(t, `[{"ref":"a"},{"ref":"b"},{"ref":null}]`),
	}
	issues := ValidateReferences([]Reference{{FromPath: "from.json", FromField: "ref", ToPath: "to.json", ToField: "id"}}, cache)
	if len(issues) != 1 || issues[0].Kind != KindReference || issues[0].Record != 2 {
		t.Fatalf("unexpected issues %+v", issues)
	}
}

func TestNullOptionalValuesAreSkipped(t *testing.T) {
	rule := Dataset{
		Path:          "a.json",
		AllowedValues: map[string][]string{"status": {"unreviewed"}},
		Ranges:        map[string]numRange{"n": {Min: 0, Max: 4}},
	}
	issues := ValidateDataset(rule, records(t, `[{"status":null,"n":null},{"status":"x","n":9}]`))
	if got := kinds(issues); len(issues) != 2 || got[KindAllowedValue] != 1 || got[KindRange] != 1 || issues[0].Record != 2 {
		t.Fatalf("unexpected issues %+v", issues)
	}
}
