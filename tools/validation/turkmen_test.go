package main

import "testing"

func TestValidTurkmenText(t *testing.T) {
	values := []string{
		"Türkmenistan",
		"Aşgabat",
		"Daşoguz",
		"Magtymguly Pyragy",
		"Gökdepe",
		"Ä Ç Ň Ö Ş Ü Ý Ž ä ç ň ö ş ü ý ž",
	}
	for _, value := range values {
		if err := validateTurkmenText(value); err != nil {
			t.Errorf("validateTurkmenText(%q): %v", value, err)
		}
	}
}

func TestUnexpectedCharacter(t *testing.T) {
	err := validateTurkmenText("Aшgabat")
	if err == nil {
		t.Fatal("expected Cyrillic character to be rejected")
	}
}

func TestInvalidUTF8(t *testing.T) {
	if err := validateUTF8([]byte{0xff, 0xfe}); err == nil {
		t.Fatal("expected invalid UTF-8 to be rejected")
	}
}
