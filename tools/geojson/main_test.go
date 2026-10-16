package main

import (
	"bytes"
	"testing"
)

func TestRenderPointAndNullGeometry(t *testing.T) {
	lat, lon := 37.96, 58.32
	rows := []row{
		{Slug: "asgabat", NameTM: "Aşgabat", NameEN: "Ashgabat", Type: "city", Latitude: &lat, Longitude: &lon, CountryCode: "TM", VerificationStatus: "verified"},
		{Slug: "ahal", NameTM: "Ahal", NameEN: "Ahal", Type: "welayat", CountryCode: "TM", VerificationStatus: "verified"},
	}
	got, err := render(rows)
	if err != nil {
		t.Fatal(err)
	}
	for _, expected := range [][]byte{[]byte(`"coordinates": [`), []byte(`58.32`), []byte(`"geometry": null`), []byte(`Aşgabat`)} {
		if !bytes.Contains(got, expected) {
			t.Fatalf("output does not contain %q", expected)
		}
	}
}

func TestRenderRejectsDuplicateAndIncompleteCoordinates(t *testing.T) {
	base := row{Slug: "same", NameTM: "A", NameEN: "A", Type: "city", CountryCode: "TM", VerificationStatus: "verified"}
	if _, err := render([]row{base, base}); err == nil {
		t.Fatal("accepted duplicate slug")
	}
	lat := 1.0
	base.Latitude = &lat
	if _, err := render([]row{base}); err == nil {
		t.Fatal("accepted incomplete coordinates")
	}
}
