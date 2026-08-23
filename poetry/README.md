# Turkmen Poetry Dataset

[← Main page](../README.md)

A collection of Turkmen poetry prepared in SQL format for databases, applications, research, educational tools, and digital archives.

## Current contents

| Poet | Records | Import file |
| --- | ---: | --- |
| Bahargül Mejidowa | 24 | [`sql/bahargul-mejidova/poetry.sql`](sql/bahargul-mejidova/poetry.sql) |
| Gara Seýitliýew | 98 | [`sql/gara-seyitliyev/poetry.sql`](sql/gara-seyitliyev/poetry.sql) |
| Kerim Gurbannepesow | 250 | [`sql/kerim-gurbannepesov/poetry.sql`](sql/kerim-gurbannepesov/poetry.sql) |
| Mollanepes | 26 | [`sql/mollanepes/poetry.sql`](sql/mollanepes/poetry.sql) |
| Nobatguly Rejepow | 48 | [`sql/nobatguly-rejepov/poetry.sql`](sql/nobatguly-rejepov/poetry.sql) |
| Magtymguly Pyragy | 130 | [`sql/pyragy/pyragy.sql`](sql/pyragy/pyragy.sql) |
| Seýdi | 29 | [`sql/seydi/poetry.sql`](sql/seydi/poetry.sql) |
| **Total** | **605** | |

Counts are based on the `poems` records present in the SQL files.

## Requirements and import

The files target MySQL 8+ and use `utf8mb4`. To import one poet:

```sh
mysql --default-character-set=utf8mb4 -u USER -p DATABASE_NAME \
  < sql/pyragy/pyragy.sql
```

Run each file separately to import every poet. All files create the same `poets` and `poems` tables with `IF NOT EXISTS`. Poet records are reused by name, but poems have no unique constraint. Running the same file more than once can therefore create duplicate poem records.

## Schema

### `poets`

| Column | Type | Description |
| --- | --- | --- |
| `id` | `BIGINT UNSIGNED` | Auto-incrementing primary key |
| `name` | `VARCHAR(255)` | Unique poet name |

### `poems`

| Column | Type | Description |
| --- | --- | --- |
| `id` | `BIGINT UNSIGNED` | Auto-incrementing primary key |
| `poet_id` | `BIGINT UNSIGNED` | Foreign key referencing `poets.id` |
| `title` | `VARCHAR(500)` | Title of the poem or record |
| `text` | `LONGTEXT` | Full text with line breaks preserved |
| `source` | `VARCHAR(1000)` | Source information when available |

Example query:

```sql
SELECT p.name, poem.title, poem.text, poem.source
FROM poems AS poem
JOIN poets AS p ON p.id = poem.poet_id
WHERE p.name = 'Magtymguly Pyragy'
ORDER BY poem.title;
```

## Known limitations

- Some `source` values are empty, so publication metadata is incomplete.
- Text converted from print or PDF may retain page numbers, form-feed characters, or OCR errors.
- Record boundaries depend on the source layout; some long records may contain a collection rather than one poem.
- An open SQL structure does not imply that every literary work is free of copyright. Verify the rights for each work, particularly works by modern authors, before redistribution.

## Contributing

When adding a poet or correction, include the canonical author name, one record per poem where the source permits it, complete bibliographic information, and the text-verification status. Preserve Turkmen characters in UTF-8.
