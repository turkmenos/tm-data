package main

import "testing"

func TestNormalize(t *testing.T) {
	got, err := normalize(append([]byte{0xef, 0xbb, 0xbf}, []byte("A\u0308new\r\niki\r")...))
	if err != nil {
		t.Fatal(err)
	}
	if want := "Änew\niki\n"; string(got) != want {
		t.Fatalf("got %q, want %q", got, want)
	}
}

func TestNormalizeRejectsInvalidUTF8(t *testing.T) {
	if _, err := normalize([]byte{0xff}); err == nil {
		t.Fatal("accepted invalid UTF-8")
	}
}
