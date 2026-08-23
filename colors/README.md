# Turkmen Colors Dataset

[← Main page](../README.md)

A small dataset of Turkmen color names with English translations, approximate HEX values, and categories.

## Contents and schema

The dataset contains **49** records.

| Column | Type | Description |
| --- | --- | --- |
| `id` | `BIGINT UNSIGNED` | Auto-incrementing primary key |
| `name_tm` | `VARCHAR(255)` | Unique Turkmen name |
| `name_en` | `VARCHAR(255)` | English translation or gloss |
| `hex_code` | `CHAR(7)` | Approximate RGB/HEX representation when available |
| `category` | `VARCHAR(100)` | `basic`, `shade`, `metallic`, `modifier`, or `pattern` |

Concepts in the `modifier` and `pattern` categories may not represent a single color, so their `hex_code` can be `NULL`. Translations and HEX values may also vary by context.

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

## Sources and contributions

This directory does not currently include a dedicated source list. Independently verify the data against a reliable dictionary before production or research use. Contributions should document their source, semantic distinctions, and the approximate nature of any assigned HEX value.
