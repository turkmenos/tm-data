package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {
	text := flag.String("text", "", "Turkmen text to validate")
	file := flag.String("file", "", "UTF-8 Turkmen text file to validate")
	flag.Parse()

	if (*text == "" && *file == "") || (*text != "" && *file != "") {
		fmt.Fprintln(os.Stderr, "usage: validation -text <text> | -file <path>")
		os.Exit(2)
	}

	var err error
	if *file != "" {
		err = validateTurkmenFile(*file)
	} else {
		err = validateTurkmenText(*text)
	}
	if err != nil {
		fmt.Fprintf(os.Stderr, "validation failed: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("Passed: valid UTF-8 Turkmen text.")
}
