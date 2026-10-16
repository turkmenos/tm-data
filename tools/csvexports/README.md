# CSV exports

The CSV files in `utils/calendar`, `utils/colors`, `utils/country-names`,
`utils/holidays`, `utils/postal-codes`, `utils/proverbs`, and `utils/stopword`
are deterministic UTF-8 derivatives of the adjacent JSON files. They preserve
record order and scalar values and add no external data.

Regenerate and verify them from the repository root:

```sh
go run ./tools/csvexports
go run ./tools/csvexports --check
go test ./tools/csvexports
```

CSV files use comma delimiters, one header row, LF line endings, RFC 4180-style
quoting, and no byte-order mark. Empty cells represent a missing JSON field or
JSON `null`; an empty JSON string has the same CSV representation. Boolean
values are `true` or `false`. Numeric-looking source strings—including postal
codes and identifiers—remain strings, although spreadsheet software may still
coerce them unless columns are imported as text.

The JSON files remain canonical. Their dataset READMEs document schemas,
limitations, and provenance. No CSV is produced for nested datasets when a
flat representation would lose structure or require ambiguous encoding.
