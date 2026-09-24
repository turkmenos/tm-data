# Turkmen Colors Dataset

[← Main page](../README.md)

A small dataset of Turkmen color names with English translations, approximate HEX values, and categories.

## Available formats

| Format | File |
| --- | --- |
| MySQL 8+ SQL | [`import.sql`](import.sql) |
| JSON | [`colors.json`](colors.json) |

Both formats represent the same 49 records. `colors.json` is generated from `import.sql`; edit `import.sql` and regenerate `colors.json` rather than editing it independently.

## Contents and schema

The dataset contains **49** records.

| Column / field | SQL type | JSON type | Description |
| --- | --- | --- | --- |
| `id` | `BIGINT UNSIGNED` | number | Primary key. In `import.sql` this is an auto-incrementing column assigned on import; in `colors.json` it is a stable 1-based position matching the row order in `import.sql`, provided so records can be referenced across formats. |
| `name_tm` | `VARCHAR(255)` | string | Unique Turkmen name |
| `name_en` | `VARCHAR(255)` | string \| null | English translation or gloss |
| `hex_code` | `CHAR(7)` | string \| null | Approximate RGB/HEX representation when available |
| `category` | `VARCHAR(100)` | string | `basic`, `shade`, `metallic`, `modifier`, or `pattern` |

Concepts in the `modifier` and `pattern` categories may not represent a single color, so their `hex_code` can be `NULL` (SQL) / `null` (JSON). Translations and HEX values may also vary by context.

## Import

The import file targets MySQL 8+:

```sh
mysql --default-character-set=utf8mb4 -u USER -p DATABASE_NAME < import.sql
```

`import.sql` creates the table without `IF NOT EXISTS`. Run it in a database that does not already contain a table named `colors`.

Example query:

```sql
SELECT name_tm, name_en, hex_code
FROM colors
WHERE category = 'basic'
ORDER BY name_tm;
```

## Using the JSON file

`colors.json` is a top-level JSON array of 49 objects, UTF-8 encoded with no byte-order mark:

```json
[
  {
    "id": 1,
    "name_tm": "ak",
    "name_en": "white",
    "hex_code": "#FFFFFF",
    "category": "basic"
  }
]
```

Validated with the repository-wide checks in [`tools/validate/main.go`](../../tools/validate/main.go) (no duplicate or invalid records) and the schema/uniqueness/allowed-value rules in [`tools/integrity/rules.json`](../../tools/integrity/rules.json).

## Sources and contributions

This directory does not currently include a dedicated source list. Independently verify the data against a reliable dictionary before production or research use. Contributions should document their source, semantic distinctions, and the approximate nature of any assigned HEX value.
