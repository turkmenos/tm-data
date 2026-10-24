# Dataset quality reports

`tools/quality` combines the repository's existing validators into one
machine-readable report, [`reports/quality/summary.json`](../../reports/quality/README.md).
It reuses the same code as `go run ./tools/validate/main.go` (encoding, syntax,
duplicate records) and `go run ./tools/integrity` (schema, uniqueness, and
reference rules), both of which live in `internal/`. It reads data files only;
source datasets are never modified.

## Usage

Run from anywhere inside the repository:

```sh
go run ./tools/quality                 # regenerate reports/quality/summary.json
go run ./tools/quality --check         # fail if the committed report is stale
go run ./tools/quality --output out.json
go test ./tools/quality ./internal/...
```

Exit status:

| Status | Meaning |
| --- | --- |
| `0` | No errors; warnings may be present |
| `1` | At least one error, or `--check` found a missing or stale report |
| `2` | Invalid usage, catalog, integrity rules, or quality configuration |

Regenerate the report and commit it whenever dataset files, `catalog.json`,
`tools/integrity/rules.json`, or `tools/quality/config.json` change. The output
contains no timestamps, so identical inputs always produce identical bytes.

## Errors and warnings

**Errors** fail CI. They are produced by:

- invalid UTF-8, malformed JSON/JSONL/CSV, or duplicate JSON keys and CSV headers;
- duplicate records and duplicate unique keys;
- missing required fields, wrong field types, disallowed values, or out-of-range numbers;
- broken cross-file references;
- a configured metric file that cannot be loaded.

**Warnings** never fail CI. They describe known, documented gaps:

- records whose verification status is not in the configured `verified` list;
- records without any configured source field;
- records missing any configured coordinate field;
- datasets with no entry in `config.json`.

Problems in files that belong to no catalog dataset (for example tool rule
files) are reported under `repository` and are errors.

## Configuration

[`config.json`](config.json) is reviewed like data. Each entry names a catalog
dataset `id` and declares:

| Field | Meaning |
| --- | --- |
| `record_resources` | Selectors (`pattern` using `path.Match` on catalog paths, and/or `format`) whose catalog `record_count` values are summed into the dataset `record_count` |
| `metrics[].path` | JSON file inside the dataset holding records |
| `metrics[].records_key` | Optional key when records are wrapped in an object |
| `metrics[].verification` | `field` and the list of values that count as `verified`; any other value, `null`, or a missing field counts as unverified |
| `metrics[].source_fields` | A record has source metadata when at least one of these fields is non-empty |
| `metrics[].coordinate_fields` | A record has coordinates only when all of these fields are non-empty |

Configuration errors (unknown dataset, selector matching nothing, metric path
outside the dataset) exit with status `2`. Schema and reference checks are
configured in [`tools/integrity/rules.json`](../integrity/README.md), not here.

## CI

The `Validate datasets` workflow generates a fresh report, uploads it as the
`dataset-quality-report` artifact even when other steps fail, checks that the
committed report is up to date, and fails the job when the report has errors.
