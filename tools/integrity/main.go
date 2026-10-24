package main

import (
	"fmt"
	"os"

	"github.com/turkmenos/tm-data/internal/integrity"
)

func main() {
	rulesPath := "tools/integrity/rules.json"
	if len(os.Args) == 3 && os.Args[1] == "-rules" {
		rulesPath = os.Args[2]
	} else if len(os.Args) != 1 {
		fmt.Fprintln(os.Stderr, "usage: integrity [-rules path]")
		os.Exit(2)
	}

	rules, err := integrity.LoadConfig(rulesPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR %s: %v\n", rulesPath, err)
		os.Exit(2)
	}

	cache := make(map[string][]map[string]any)
	var issues []integrity.Issue
	for _, rule := range rules.Datasets {
		records, loadErr := integrity.LoadRecords(rule.Path)
		if loadErr != nil {
			issues = append(issues, integrity.Issue{Path: rule.Path, Kind: integrity.KindLoad, Message: loadErr.Error()})
			continue
		}
		cache[rule.Path] = records
		issues = append(issues, integrity.ValidateDataset(rule, records)...)
	}
	issues = append(issues, integrity.ValidateReferences(rules.References, cache)...)

	for _, item := range issues {
		location := item.Path
		if item.Record > 0 {
			location += fmt.Sprintf(" record %d", item.Record)
		}
		fmt.Printf("ERROR %s: %s\n", location, item.Message)
	}
	if len(issues) > 0 {
		fmt.Printf("Failed: %d integrity problem(s).\n", len(issues))
		os.Exit(1)
	}
	fmt.Printf("Passed: %d dataset schemas and %d reference rule(s).\n", len(rules.Datasets), len(rules.References))
}
