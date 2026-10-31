# Dataset changelog generator

`tools/changelog` compares datasets between two Git revisions and reports
added, modified, and deleted records, schema, format, and metadata changes,
and breaking changes. It reads files directly from Git objects (`git cat-file`),
so the working tree is never modified, and it reuses the content-based dataset
versions in [`catalog.json`](../../catalog.json).

## Usage

Run from anywhere inside the repository (Git 2.36 or later):

```sh
# Machine-readable report (default) or Markdown summary
go run ./tools/changelog --from main~1 --to main
go run ./tools/changelog --from <base> --to HEAD --format markdown

# Write the report to a file
go run ./tools/changelog --from <base> --to HEAD --output report.json

# Add an entry to CHANGELOG.md and write changes/<from>..<to>.json
go run ./tools/changelog --from <previous-commit> --to <commit> --changelog

go test ./tools/changelog
```

`--to` defaults to `HEAD`. Both revisions must contain `catalog.json`.
Re-running `--changelog` for the same range replaces that entry instead of
duplicating it. Output is deterministic: identical inputs produce identical bytes.

## How changes are detected

1. Datasets are matched by catalog `id`; a dataset only in the target revision
   is `added`, only in the base revision `removed`, otherwise `changed`.
   Unchanged datasets are omitted.
2. Every file listed in either catalog is compared by Git object ID, so a file
   that already existed but was missing from a stale catalog is still compared
   correctly and noted under `metadata`.
3. For files matched in [`config.json`](config.json), records are compared:
   - **Keyed** (`key` fields, or `map: true` for objects keyed by headword):
     records are matched by stable identifier, so edits count as `modified`.
   - **Content** (no key, or the key is missing or duplicated in a revision):
     records are compared as a multiset of canonical JSON values; an edited
     record appears as one deletion and one addition, and a note says so.
4. For changed JSON and CSV files, the set of field names (CSV headers, or
   top-level keys of record objects) is compared for schema changes. For
   wrapped files (`records` key), other top-level fields are compared as
   file metadata.
5. Catalog-level metadata is compared: title, documentation files, provenance,
   and dataset formats.

Only tracked record files contribute to the `added`/`modified`/`deleted`
totals, so derived exports (CSV, GeoJSON, search index, SQL) are not counted
twice; they are listed as changed files instead.

## Configuration

Entries in [`config.json`](config.json) are checked in order and the first
matching `pattern` wins. `*` matches within one path segment and `**` across
segments.

| Field | Meaning |
| --- | --- |
| `pattern` | Repository-relative glob |
| `records` | Optional top-level key holding the record collection |
| `map` | Records are the members of an object; the member name is the identifier |
| `key` | Fields that together form a stable record identifier |

Prefer adding a stable `key` for new datasets. See the
[versioning rules](../../changes/README.md#versioning-rules) for how keys
relate to breaking changes.

## Limitations

- Files that are not listed in either revision's catalog are not compared.
  `go run ./tools/catalog --check` in CI keeps the catalog complete from now on.
- SQL, SQLite, text, and GeoJSON files are compared at file level only.
- Up to 20 identifiers are listed per change type and file; counts are complete.
