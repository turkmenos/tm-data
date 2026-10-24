package main

import (
	"fmt"
	"os"

	"github.com/turkmenos/tm-data/internal/formatcheck"
)

func main() {
	paths := os.Args[1:]
	if len(paths) == 0 {
		paths = []string{"."}
	}

	for _, path := range paths {
		if _, err := os.Stat(path); err != nil {
			fmt.Fprintf(os.Stderr, "ERROR %s: path does not exist\n", path)
			os.Exit(2)
		}
	}

	files, err := formatcheck.DiscoverFiles(paths)
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: %v\n", err)
		os.Exit(2)
	}

	var problems []formatcheck.Problem
	for _, path := range files {
		problems = append(problems, formatcheck.ValidateFile(path)...)
	}

	for _, item := range problems {
		fmt.Printf("ERROR %s: %s\n", item.Path, item.Message)
	}
	if len(problems) > 0 {
		fmt.Printf("Failed: %d problem(s) in %d file(s).\n", len(problems), len(files))
		os.Exit(1)
	}

	fmt.Printf("Passed: no duplicate or invalid records in %d file(s).\n", len(files))
}
