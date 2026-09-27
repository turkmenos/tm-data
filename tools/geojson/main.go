// Command geojson generates GeoJSON from the canonical SQLite geography import.
package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

const query = `
SELECT r.slug, p.slug AS parent_slug, r.name_tm, r.name_en, r.name_ru,
       r.type, r.latitude, r.longitude, r.country_code,
       r.verification_status, r.source_url, r.source_date
FROM regions r
LEFT JOIN regions p ON p.id = r.parent_id
ORDER BY r.id;`

type row struct {
	Slug               string   `json:"slug"`
	ParentSlug         *string  `json:"parent_slug"`
	NameTM             string   `json:"name_tm"`
	NameEN             string   `json:"name_en"`
	NameRU             *string  `json:"name_ru"`
	Type               string   `json:"type"`
	Latitude           *float64 `json:"latitude"`
	Longitude          *float64 `json:"longitude"`
	CountryCode        string   `json:"country_code"`
	VerificationStatus string   `json:"verification_status"`
	SourceURL          *string  `json:"source_url"`
	SourceDate         *string  `json:"source_date"`
}

type featureCollection struct {
	Type     string    `json:"type"`
	Features []feature `json:"features"`
}

type feature struct {
	Type       string         `json:"type"`
	ID         string         `json:"id"`
	Geometry   *geometry      `json:"geometry"`
	Properties map[string]any `json:"properties"`
}

type geometry struct {
	Type        string     `json:"type"`
	Coordinates [2]float64 `json:"coordinates"`
}

func main() {
	check := flag.Bool("check", false, "fail if regions.geojson is missing or stale")
	flag.Parse()
	root, err := repositoryRoot()
	if err == nil {
		var output []byte
		output, err = generate(root)
		if err == nil {
			target := filepath.Join(root, "geo", "geojson", "regions.geojson")
			if *check {
				var existing []byte
				existing, err = os.ReadFile(target)
				if err == nil && !bytes.Equal(existing, output) {
					err = errors.New("geo/geojson/regions.geojson is stale; run go run ./tools/geojson")
				}
			} else {
				err = os.MkdirAll(filepath.Dir(target), 0o755)
				if err == nil {
					err = os.WriteFile(target, output, 0o644)
				}
			}
		}
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(1)
	}
	if *check {
		fmt.Println("Passed: GeoJSON matches the canonical geography import.")
	} else {
		fmt.Println("Generated geo/geojson/regions.geojson")
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

func generate(root string) ([]byte, error) {
	input, err := os.ReadFile(filepath.Join(root, "geo", "sql", "sqlite", "import.sql"))
	if err != nil {
		return nil, err
	}
	temporary, err := os.CreateTemp("", "tm-data-geo-*.sqlite")
	if err != nil {
		return nil, err
	}
	path := temporary.Name()
	if err := temporary.Close(); err != nil {
		return nil, err
	}
	defer os.Remove(path)
	command := exec.Command("sqlite3", path)
	command.Stdin = bytes.NewReader(input)
	if output, err := command.CombinedOutput(); err != nil {
		return nil, fmt.Errorf("import geography: %w: %s", err, output)
	}
	output, err := exec.Command("sqlite3", "-readonly", "-json", path, query).Output()
	if err != nil {
		return nil, fmt.Errorf("query geography: %w", err)
	}
	var rows []row
	if err := json.Unmarshal(output, &rows); err != nil {
		return nil, fmt.Errorf("decode geography: %w", err)
	}
	return render(rows)
}

func render(rows []row) ([]byte, error) {
	collection := featureCollection{Type: "FeatureCollection", Features: make([]feature, 0, len(rows))}
	seen := make(map[string]bool, len(rows))
	for _, item := range rows {
		if item.Slug == "" || seen[item.Slug] {
			return nil, fmt.Errorf("empty or duplicate slug %q", item.Slug)
		}
		seen[item.Slug] = true
		if (item.Latitude == nil) != (item.Longitude == nil) {
			return nil, fmt.Errorf("%s has incomplete coordinates", item.Slug)
		}
		var point *geometry
		if item.Latitude != nil {
			if *item.Latitude < -90 || *item.Latitude > 90 || *item.Longitude < -180 || *item.Longitude > 180 {
				return nil, fmt.Errorf("%s has invalid coordinates", item.Slug)
			}
			point = &geometry{Type: "Point", Coordinates: [2]float64{*item.Longitude, *item.Latitude}}
		}
		properties := map[string]any{
			"slug": item.Slug, "parent_slug": item.ParentSlug, "name_tm": item.NameTM,
			"name_en": item.NameEN, "name_ru": item.NameRU, "type": item.Type,
			"country_code": item.CountryCode, "verification_status": item.VerificationStatus,
			"source_url": item.SourceURL, "source_date": item.SourceDate,
		}
		collection.Features = append(collection.Features, feature{Type: "Feature", ID: item.Slug, Geometry: point, Properties: properties})
	}
	data, err := json.MarshalIndent(collection, "", "  ")
	if err != nil {
		return nil, err
	}
	return append(data, '\n'), nil
}
