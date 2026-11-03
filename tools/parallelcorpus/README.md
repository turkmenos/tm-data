# Parallel corpus tool

Validates [`language/parallel-corpus`](../../language/parallel-corpus/README.md)
and writes its deterministic JSON and CSV exports. It reads only local files
and adds no external data.

```sh
go run ./tools/parallelcorpus          # validate, then rewrite sentences.json and sentences.csv
go run ./tools/parallelcorpus --check  # validate only; exit 1 if an export is stale
go test ./tools/parallelcorpus
```

The tool exits with status 1 on any of these: invalid UTF-8, non-NFC text,
unknown fields, duplicate identifiers or Turkmen sentences, non-Turkmen letters
in `tk` text, mismatched sentence-final punctuation or numerals, unknown
categories or statuses, unresolved or unused sources, or stale exports.
`sentences.json` is canonical, and the CSV is derived from it.
