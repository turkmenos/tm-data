package main

import (
	"fmt"
	"os"
	"strings"
	"unicode"
	"unicode/utf8"
)

const turkmenAlphabet = "ABCÇDEÄFGHIJŽKLMNŇOÖPRSŞTUÜWYÝZ" + "abcçdeäfghijžklmnňoöprsştuüwyýz"

func validateUTF8(data []byte) error {
	if !utf8.Valid(data) {
		return fmt.Errorf("data is not valid UTF-8")
	}
	return nil
}

func validateTurkmenText(s string) error {
	if !utf8.ValidString(s) {
		return fmt.Errorf("text is not valid UTF-8")
	}
	for _, r := range s {
		if isAllowedTurkmenRune(r) {
			continue
		}
		return fmt.Errorf(
			"unexpected character %q (U+%04X)",
			r,
			r,
		)
	}
	return nil
}

func isAllowedTurkmenRune(r rune) bool {
	if strings.ContainsRune(turkmenAlphabet, r) {
		return true
	}
	if unicode.IsSpace(r) {
		return true
	}
	if unicode.IsDigit(r) {
		return true
	}
	switch r {
	case '-', '\'', '’', '.', ',', ':', ';', '!', '?', '(', ')', '"':
		return true
	}
	return false
}

func validateTurkmenFile(path string) error {
	data, err := os.ReadFile(path)
	if err != nil {
		return fmt.Errorf("read %s: %w", path, err)
	}
	if err := validateUTF8(data); err != nil {
		return fmt.Errorf("%s: %w", path, err)
	}
	if err := validateTurkmenText(string(data)); err != nil {
		return fmt.Errorf("%s: %w", path, err)
	}
	return nil
}
