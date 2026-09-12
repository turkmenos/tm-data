# Data Format

[← Main page](README.md)

Shared conventions for new datasets and exports in `tm-data`. Existing datasets have different schemas; their own README files and actual data define their current structure. These conventions do not imply that existing files have been migrated or validated automatically.

## Current structures

| Dataset | Structure | Documentation |
| --- | --- | --- |
| Geography | Database-specific SQL schemas and import scripts | [Geography](geo/README.md) |
| Dictionary | JSON object with `meta` and a `words` lookup; each search key maps to an array of entries | [Dictionary](dictionary/README.md) |
| Stories | JSON document with metadata and a `pages` array; SQLite and MySQL exports are also available for some works | [Stories](stories/README.md) |
| Calendar | JSON arrays using `tm`, `en`, and an identifier such as `number`, `iso`, or `id` | [Calendar](utils/calendar/README.md) |
| Names | JSON arrays containing `name` and `description` | [Names](utils/names/README.md) |
| Postal codes | JSON records with string-valued source fields, including codes and coordinates | [Postal codes](utils/postal-codes/README.md) |

Consult each dataset before assuming a top-level array, identifier type, or naming convention. For example, dictionary fields include `generatedAt` and `partOfSpeech`, while story fields include `created_at` and `page_number`.

## Files and encoding

- Use UTF-8 for text files. Prefer no byte-order mark, LF line endings, and a final newline for new files.
- Preserve Turkmen characters: `ä`, `ç`, `ň`, `ö`, `ş`, `ü`, `ý`, and `ž`, including their uppercase forms.
- Prefer lowercase, hyphenated names for new directories and files, such as `time-units.json`.
- Keep each dataset with a README describing its schema, sources, available formats, and limitations.
- Identify the canonical source and the regeneration procedure for derived exports. Edit the source and regenerate outputs rather than editing generated files independently.

## Fields and identifiers

- Prefer English `snake_case` field names for new schemas. Preserve established field names when extending an existing dataset.
- Use stable identifiers when records need references. Document their type, uniqueness scope, and meaning; do not derive persistent IDs from array positions.
- Keep postal codes, telephone codes, and similar identifiers as strings to preserve leading zeros.
- Use JSON numbers for quantities and booleans for true/false values in new schemas. Do not silently convert string-valued fields in existing source exports.
- Document required fields, optional fields, allowed values, units, and relationships in the dataset README.

For new schemas, use `null` for an unknown scalar value and `[]` for a known empty collection. Omit fields only when the schema permits it. Avoid placeholder strings such as `"N/A"`; document any inherited empty-string or missing-value conventions.

## Language and text

Use `tk` for Turkmen in new language-code fields, `tr` for Turkish, and `en` for English. Existing `tm` label fields, such as those in calendar data, remain part of their dataset schemas. Country-code fields may use `TM` for Turkmenistan; country and language codes serve different purposes.

Preserve original spelling, punctuation, and meaningful line breaks in source text. Store translations, transliterations, aliases, and search-normalized text in separate documented fields. For newly curated text, prefer Unicode NFC normalization; retain raw extraction text when normalization or cleanup is applied to a derived field.

## Dates and times

| Value | Convention | Example |
| --- | --- | --- |
| Complete date | `YYYY-MM-DD` | `2026-09-12` |
| Timestamp | Date and time with `Z` or an explicit UTC offset | `2026-09-12T09:00:00+05:00` |
| Year only | A separate integer year field | `2010` |
| Annual recurring date | Separate integer `month` and `day` fields | `1` and `1` |

Do not invent missing months, days, or time zones. Distinguish publication dates, retrieval dates, and export-generation timestamps. Document the calendar and any rules needed for variable holiday dates.

## JSON

Use valid JSON with double-quoted keys and strings, no comments, no trailing commas, and no duplicate keys. Prefer two-space indentation for new files; preserve existing formatting for focused corrections.

Small lookup datasets may use a top-level array. Datasets needing metadata may use a documented object containing metadata and records. There is no mandatory repository-wide wrapper.

This example follows the existing calendar month schema:

```json
[
  {
    "number": 1,
    "tm": "Ýanwar",
    "en": "January"
  }
]
```

If adding JSONL, write one complete JSON object per line without an enclosing array. Escape line breaks inside string values; renaming a JSON file does not convert it to JSONL.

## CSV

For new CSV exports:

- Include a header row and use a consistent column order with a comma delimiter.
- Quote values containing commas, double quotes, or line breaks; escape embedded double quotes by doubling them.
- Document column types and the representation of null values, including how null differs from an empty string.
- Document how nested arrays or objects are represented, such as JSON-encoded cells or separate related files.
- Preserve identifier strings during import; spreadsheet software may otherwise strip leading zeros.

## SQL and SQLite

Document the database engine, minimum supported version, tables, keys, indexes, and import command. SQL scripts are engine-specific unless explicitly documented otherwise; `.db` files are SQLite databases rather than SQL text.

Preserve Unicode with the engine's supported text types and encoding settings, including `utf8mb4` for MySQL. Explain whether an import can be repeated and whether it drops or replaces existing tables. Document foreign-key relationships and validate referenced records where applicable.

## Sources and metadata

Record source titles, authors or organizations, URLs when available, retrieval dates, and redistribution terms in the dataset README or a nearby `SOURCES.md`. Use record-level source references when records come from different sources and need individual attribution.

Document extraction or transformation methods and known limitations. If using a verification-status field, define its allowed values and what each status means. Unknown source or rights information should be identified as unknown. See [SOURCES.md](SOURCES.md) for provenance guidance.

## Consistency and schema changes

Exports of the same dataset should preserve the same records, identifiers, text, and relationships. Document any deliberate differences, such as SQL-only helper columns or flattened CSV fields. Count the same work once even when it has several export formats.

Before submitting data, check that files parse, required fields and types match the documented schema, identifiers are unique within their scope, references resolve, and counts match the records they describe. Check duplicate records without removing legitimate repeated text or distinct entries sharing a spelling.

Explain field renames, type changes, and removals in the pull request, update affected documentation and exports, and provide migration notes for consumers. Follow [CONTRIBUTING.md](CONTRIBUTING.md) for contribution requirements.
