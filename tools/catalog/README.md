# Dataset catalog

[`catalog.json`](../../catalog.json) is the central UTF-8 JSON inventory. It is
generated from the repository's dataset files using Go. No external data is
downloaded or changed. SQLite row counting uses the `sqlite3` command-line
program in read-only mode.

Run from the repository root:

```sh
go run ./tools/catalog
go run ./tools/catalog --check
go test ./tools/catalog
```

Regenerate after adding, removing, renaming, or editing data files or adding
source documentation. Commit the resulting catalog with the change. `--check`
is read-only and exits with status 1 for missing, malformed, or stale catalogs,
invalid UTF-8 text, or malformed JSON source files (including duplicate keys).
It regenerates the expected inventory in memory and compares it byte for byte,
so altered counts, duplicate entries, invalid fields, and missing locations fail.

## Structure and versioning

All paths are case-sensitive repository-relative paths with `/` separators,
not URLs. All fields below are required unless explicitly described otherwise.

| Field | Meaning |
| --- | --- |
| `schema_version` | Catalog schema version, currently `1.0.0` |
| `datasets` | Array of datasets; one per top-level dataset directory or immediate `utils` subdirectory containing data |
| `datasets[].id` | Unique directory-derived identifier, with `/` replaced by `-`; keep directory names stable |
| `title` | Display label derived from the directory name |
| `location` | Dataset directory |
| `version` | `sha256:` content fingerprint of the ordered resource path/hash manifest |
| `formats` | Sorted unique resource formats |
| `documentation` | Existing Markdown files in the dataset directory tree |
| `provenance.references` | Documentation paths, falling back to `SOURCES.md` when no dataset documentation exists |
| `provenance.note` | Limitations of these provenance references |
| `resources` | Sorted array of files, each appearing once in the catalog |
| `resources[].path` | Exact file location, preserving Unicode and spaces |
| `resources[].format` | `json`, `sql`, `sqlite`, `text`, `csv`, `jsonl`, `parquet`, or `geojson` |
| `resources[].version` | `sha256:` fingerprint of the exact file bytes |
| `resources[].record_count` | Nonnegative integer, or `null` when unknown |
| `resources[].record_unit` | Counting unit below, or `null` when unknown |
| `resources[].count_note` | Present only when the count is unknown |

Dataset versions identify content snapshots, not upstream release numbers or
publication dates. They change on data edits, additions, removals, or renames;
documentation-only edits do not change them. The ordered path/version manifest
is serialized as compact UTF-8 JSON before hashing. Catalog schema versions are
maintained separately in the generator;
breaking schema changes require a major version increment.

## Counts and coverage

JSON arrays count as `records`; recognized object collections count as `pages`,
`poems`, `proverbs`, `test_cases`, or `words`. Dictionary lookup objects count
`search_keys`, not definitions or homonymous entries. Counts come from actual
collections, not declared count metadata. Transliteration rules count both directional mappings and contextual rules as
`mappings_and_rules`. SQLite databases are opened read-only and count rows in
all user tables as `table_rows`, excluding views and SQLite internal tables;
these totals can include metadata rows and are not page counts. CSV and JSONL
count `records`; GeoJSON feature collections count `features`.
Other object schemas, SQL scripts, text extracts, and Parquet have unknown counts. Zero
means a recognized empty collection; `null` never means zero.

Every supported data file beneath `dictionary`, `geo`, `poetry`, `stories`, and
immediate `utils` subdirectories is included, including legacy exports, text
layouts, and transliteration test fixtures. Tools, images, and Markdown files
are not data resources. SQL dialect and import instructions remain in linked
dataset guides. There is deliberately no summed record count: exports overlap,
and pages, poems, lookup keys, and other records are different units. This
inventory does not assert that alternate exports contain identical records.

## Provenance and validation limits

Catalog metadata is derived locally from file paths, bytes, JSON collections,
and existing Markdown documentation. Dataset source attribution and rights
remain in those references and embedded source fields. Missing provenance is
not inferred; the stopword guide explicitly records unknown provenance,
and some existing documentation has incomplete sources or stale paths. The
root source guide is a fallback policy reference, not evidence of an external
source. The catalog grants no additional redistribution rights.

The catalog check verifies inventory metadata, not the factual accuracy or
uniqueness of underlying dataset records. Run the existing duplicate and
integrity validators as appropriate; existing data problems are not repaired
by catalog generation.

## Automated checks

The repository's `Validate datasets` GitHub Actions workflow runs the catalog
unit tests and freshness check on pull requests and pushes to `main`. Tests
cover changed content, renamed and removed resources, invalid JSON/UTF-8,
SQLite read-only counting, tabular counters, and rejection of tampered counts.
