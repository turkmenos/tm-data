// Command csvexports generates the repository's CSV exports from canonical JSON files.
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
	"reflect"
)

type specification struct {
	JSON    string
	CSV     string
	Root    string
	Columns []string
}

var specifications = []specification{
	{"utils/calendar/day-periods.json", "utils/calendar/day-periods.csv", "", []string{"id", "tm", "en"}},
	{"utils/calendar/months.json", "utils/calendar/months.csv", "", []string{"number", "tm", "en"}},
	{"utils/calendar/seasons.json", "utils/calendar/seasons.csv", "", []string{"id", "tm", "en"}},
	{"utils/calendar/time-units.json", "utils/calendar/time-units.csv", "", []string{"id", "tm", "en"}},
	{"utils/calendar/weekdays.json", "utils/calendar/weekdays.csv", "", []string{"iso", "tm", "en"}},
	{"utils/colors/colors.json", "utils/colors/colors.csv", "", []string{"id", "name_tm", "name_en", "hex_code", "category"}},
	{"utils/country-names/countries.json", "utils/country-names/countries.csv", "", []string{"code", "tm", "en"}},
	{"utils/holidays/holidays.json", "utils/holidays/holidays.csv", "", []string{"name", "month", "day", "start_day", "end_day", "rule", "type", "day_off"}},
	{"utils/postal-codes/places.json", "utils/postal-codes/places.csv", "", []string{"iso", "country", "language", "id", "region1", "region2", "region3", "region4", "locality", "postcode", "suburb", "latitude", "longitude", "elevation", "iso2", "fips", "nuts", "hasc", "stat", "timezone", "utc", "dst", "locality_type", "is_postal", "is_business", "is_po_box", "post_town"}},
	{"utils/postal-codes/regions.json", "utils/postal-codes/regions.csv", "", []string{"iso", "country", "language", "level", "type", "name", "region1", "region2", "region3", "region4", "iso2", "fips", "nuts", "hasc", "stat"}},
	{"utils/proverbs/nakyllar.json", "utils/proverbs/nakyllar.csv", "proverbs", []string{"proverb"}},
	{"utils/stopword/stopwords.json", "utils/stopword/stopwords.csv", "words", []string{"word"}},
}

func main() {
	check := flag.Bool("check", false, "fail if an export is missing or stale")
	flag.Parse()
	root, err := repositoryRoot()
	if err == nil {
		for _, spec := range specifications {
			var output []byte
			output, err = generate(filepath.Join(root, filepath.FromSlash(spec.JSON)), spec)
			if err != nil {
				break
			}
			target := filepath.Join(root, filepath.FromSlash(spec.CSV))
			if *check {
				var existing []byte
				existing, err = os.ReadFile(target)
				if err == nil && !bytes.Equal(existing, output) {
					err = fmt.Errorf("%s is stale; run go run ./tools/csvexports", spec.CSV)
				}
			} else {
				err = os.WriteFile(target, output, 0o644)
			}
			if err != nil {
				break
			}
		}
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(1)
	}
	if *check {
		fmt.Printf("Passed: %d CSV exports match their JSON sources.\n", len(specifications))
	} else {
		fmt.Printf("Generated %d CSV exports.\n", len(specifications))
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

func generate(path string, spec specification) ([]byte, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	decoder := json.NewDecoder(bytes.NewReader(data))
	decoder.UseNumber()
	var value any
	if err := decoder.Decode(&value); err != nil {
		return nil, err
	}
	if spec.Root != "" {
		object, ok := value.(map[string]any)
		if !ok {
			return nil, fmt.Errorf("%s: expected JSON object", spec.JSON)
		}
		value = object[spec.Root]
	}
	var records []map[string]any
	switch values := value.(type) {
	case []any:
		for _, item := range values {
			if object, ok := item.(map[string]any); ok {
				records = append(records, object)
			} else if len(spec.Columns) == 1 {
				records = append(records, map[string]any{spec.Columns[0]: item})
			} else {
				return nil, fmt.Errorf("%s: expected object records", spec.JSON)
			}
		}
	default:
		return nil, fmt.Errorf("%s: expected JSON array at %q", spec.JSON, spec.Root)
	}
	var output bytes.Buffer
	writer := csv.NewWriter(&output)
	if err := writer.Write(spec.Columns); err != nil {
		return nil, err
	}
	allowed := make(map[string]bool, len(spec.Columns))
	for _, column := range spec.Columns {
		allowed[column] = true
	}
	for _, record := range records {
		for key := range record {
			if !allowed[key] {
				return nil, fmt.Errorf("%s: undocumented field %q", spec.JSON, key)
			}
		}
		row := make([]string, len(spec.Columns))
		for i, column := range spec.Columns {
			row[i], err = cell(record[column])
			if err != nil {
				return nil, fmt.Errorf("%s field %q: %w", spec.JSON, column, err)
			}
		}
		if err := writer.Write(row); err != nil {
			return nil, err
		}
	}
	writer.Flush()
	return output.Bytes(), writer.Error()
}

func cell(value any) (string, error) {
	if value == nil {
		return "", nil
	}
	switch value := value.(type) {
	case string:
		return value, nil
	case json.Number:
		return value.String(), nil
	case bool:
		if value {
			return "true", nil
		}
		return "false", nil
	default:
		return "", fmt.Errorf("unsupported CSV value of type %s", reflect.TypeOf(value))
	}
}
