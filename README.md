# tm-data

Open, machine-readable datasets related to Turkmenistan.

`tm-data` collects, organizes, and shares Turkmen data for use in software, research, data analysis, education, and machine learning.

## Datasets

| Dataset | Contents | Format | Documentation |
| --- | --- | --- | --- |
| Geography | Administrative divisions, settlements, alternative names, and search helpers | PostgreSQL, MySQL, SQLite, SQL Server | [Guide](geo/README.md) |
| Poetry | 855 works by 13 Turkmen poets | MySQL 8+ SQL, JSON — see [Guide](poetry/README.md) | [Guide](poetry/README.md) |
| Stories | Page-level text extracted from Turkmen stories and prose | JSON, SQLite, MySQL SQL | [Guide](stories/README.md) |
| Colors | Turkmen color names, English translations, HEX values, and categories | MySQL 8+ SQL, JSON | [Guide](utils/colors/README.md) |
| Dictionary | 18,674 searchable Turkmen headwords with pronunciations, definitions, and examples | JSON | [Guide](dictionary/README.md) |

Each dataset documents its structure, import process, limitations, and available sources in its own directory.

See [DATA_FORMAT.md](DATA_FORMAT.md) for shared encoding, field naming, date, and export conventions.

## Machine-readable catalog

[`catalog.json`](catalog.json) lists all dataset directories and data files,
available formats, content-based versions, per-file record counts (or `null`
when unknown), and documentation/provenance references. See the
[catalog guide](tools/catalog/README.md) for the schema and counting rules.

After changing datasets, regenerate and verify the inventory:

```sh
python3 tools/catalog/main.py
python3 tools/catalog/main.py --check
```

## Data quality checks

Repository-wide duplicate and format validation is available in
[`tools/validate/main.go`](tools/validate/main.go). It checks JSON, JSONL, and
CSV datasets using only the Go standard library:

```sh
go run ./tools/validate/main.go
```

Specific files or directories can be passed as arguments. The validator exits
with status `1` when it finds duplicate records, duplicate JSON keys, invalid
UTF-8, or malformed JSON, JSONL, or CSV. It is original repository tooling,
uses only the Go standard library, and does not contain or download external
data; dataset provenance remains documented with each dataset.

Strict UTF-8 and modern Turkmen Latin alphabet validation is available in
[`tools/validation`](tools/validation/README.md):

```sh
go run ./tools/validation -text "Türkmenistanyň paýtagty Aşgabat."
```

Schema, required-field, uniqueness, range, and cross-file reference checks are
defined in [`tools/integrity/rules.json`](tools/integrity/rules.json) and run with:

```sh
go run ./tools/integrity
```

## Usage

Clone the repository:

```sh
git clone https://github.com/turkmenos/tm-data.git
cd tm-data
```

Follow the import instructions for the dataset you want to use. SQL files use UTF-8; choose a connection encoding and collation that preserve Turkmen characters such as `ä`, `ç`, `ň`, `ö`, `ş`, `ü`, `ý`, and `ž`.

## Contributing

Contributions may include new datasets, corrections, sources, translations, or additional export formats.

1. Place data in an appropriately named directory and use a clear, machine-readable structure.
2. Document the source URL, retrieval date, and redistribution rights.
3. Describe the schema, format, import steps, and known limitations in the dataset README.
4. Preserve the Turkmen alphabet in UTF-8 and check for duplicates where possible.
5. Do not include private, sensitive, or non-redistributable data.


## Roadmap

See [ROADMAP.md](ROADMAP.md) for the planned datasets, data quality improvements, export formats, and usage documentation.

### Ideas for future datasets

- Proverbs, sayings, and riddles with topic labels
- Turkmen given names with gender, meaning, and origin
- District codes, postal codes, and telephone codes
- Holidays, historical dates, and cultural heritage sites
- Thematic vocabulary for animals, plants, food, occupations, and family relationships
- Turkmen stop words, suffixes, transliteration rules, and text-normalization data
- GeoJSON and CSV exports for geography, plus JSON and CSV exports for other datasets
- Automated schema, encoding, duplicate, and integrity checks

For any new dataset, reliable provenance, redistribution rights, and verification status are more important than record count alone.

## Sources and license

General provenance guidelines are available in [SOURCES.md](SOURCES.md). Detailed sources are documented within each dataset when available.

The repository's original code and independently created material are provided under the [MIT License](LICENSE). External data, source material, and literary works may have separate licenses or copyright restrictions. Review each dataset's documentation before use or redistribution.
