# Dataset change reports

Each `<from>..<to>.json` file is a machine-readable change report produced by
[`tools/changelog`](../tools/changelog/README.md) for one entry in
[`CHANGELOG.md`](../CHANGELOG.md). File names use the first 12 characters of
the compared commits. Do not edit these files by hand.

## Versioning rules

- **Dataset versions** are the `sha256:` content fingerprints in
  [`catalog.json`](../catalog.json). They change whenever a data file of the
  dataset is added, removed, renamed, or edited; documentation-only edits do
  not change them. There are no separate release numbers.
- **Stable identifiers** must not be reused for a different record. Datasets
  with a configured `key` (for example `slug` in geography, `id` in morphology,
  `code` in country names) are matched by that key across revisions.
- **Breaking changes** are any of:
  - a dataset, data file, or format removed;
  - a field removed from a data file's records or CSV header;
  - a record with a stable identifier deleted.
- **Non-breaking changes** are new datasets, files, formats, fields, or
  records, edits to existing records, and metadata or documentation changes.
- Breaking changes must be explained in the pull request that introduces them;
  the generated report lists them under `breaking`.
- A version change without any file content change (for example when files
  are first added to a stale catalog or the fingerprint method changes) is
  reported as metadata, not as a data change.

## Report structure

| Field | Meaning |
| --- | --- |
| `schema_version` | Report schema version, currently `1.0.0` |
| `from`, `to` | `revision` as given, full `commit`, and commit `date` (YYYY-MM-DD) |
| `summary.datasets_changed` | Number of datasets in `datasets` |
| `summary.changes` | Total `added`, `modified`, `deleted` records |
| `summary.breaking` | `true` when any dataset lists a breaking change |
| `datasets[]` | Changed datasets, sorted by `dataset` id |

Each `datasets[]` entry:

| Field | Meaning |
| --- | --- |
| `dataset`, `title` | Catalog identifier and title |
| `status` | `added`, `removed`, or `changed` |
| `from_version`, `to_version` | Catalog versions; `null` when the dataset did not exist on that side |
| `changes` | Record totals over tracked record files |
| `resources` | Data file paths `added`, `removed`, `modified` |
| `formats` | Catalog formats `added`, `removed` |
| `records[]` | Per file: `identity` (`key: …`, `object key`, or `content`), counts, up to 20 `added_ids`, `modified_ids`, `deleted_ids`, and an optional `note` |
| `schema[]` | Per file: `added_fields`, `removed_fields` |
| `metadata[]` | Human-readable catalog and file metadata changes |
| `breaking[]` | Human-readable breaking changes |
