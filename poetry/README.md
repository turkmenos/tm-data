# Turkmen Poetry Dataset

[← Main page](../README.md)

A collection of Turkmen poetry prepared in SQL format for databases, applications, research, educational tools, and digital archives. JSON exports, generated directly from the SQL source, are available for every poet.

## Current contents

| Poet | Records | SQL file | JSON file |
| --- | ---: | --- | --- |
| AnnaSoltan Kekilowa | 25 | [`sql/annasoltan-kekilowa---omruzaya-yyldyzym/annasoltan_kekilowa_-_omruzaya_yyldyzym.sql`](sql/annasoltan-kekilowa---omruzaya-yyldyzym/annasoltan_kekilowa_-_omruzaya_yyldyzym.sql) | [`json/annasoltan-kekilowa---omruzaya-yyldyzym/poetry.json`](json/annasoltan-kekilowa---omruzaya-yyldyzym/poetry.json) |
| Bahargül Mejidowa | 24 | [`sql/bahargul-mejidova/poetry.sql`](sql/bahargul-mejidova/poetry.sql) | [`json/bahargul-mejidova/poetry.json`](json/bahargul-mejidova/poetry.json) |
| ÇARY ÝEGENMYRADOW | 89 | [`sql/chary-yegenmyradov/gunler-geçip-baryar.sql`](sql/chary-yegenmyradov/gunler-geçip-baryar.sql) | [`json/chary-yegenmyradov/poetry.json`](json/chary-yegenmyradov/poetry.json) |
| Gara Seýitliýew | 98 | [`sql/gara-seyitliyev/poetry.sql`](sql/gara-seyitliyev/poetry.sql) | [`json/gara-seyitliyev/poetry.json`](json/gara-seyitliyev/poetry.json) |
| Kerim Gurbannepesow | 250 | [`sql/kerim-gurbannepesov/poetry.sql`](sql/kerim-gurbannepesov/poetry.sql) | [`json/kerim-gurbannepesov/poetry.json`](json/kerim-gurbannepesov/poetry.json) |
| Mollanepes | 26 | [`sql/mollanepes/poetry.sql`](sql/mollanepes/poetry.sql) | [`json/mollanepes/poetry.json`](json/mollanepes/poetry.json) |
| Nobatguly Rejepow | 48 | [`sql/nobatguly-rejepov/poetry.sql`](sql/nobatguly-rejepov/poetry.sql) | [`json/nobatguly-rejepov/poetry.json`](json/nobatguly-rejepov/poetry.json) |
| Magtymguly Pyragy | 130 | [`sql/pyragy/pyragy.sql`](sql/pyragy/pyragy.sql) | [`json/pyragy/poetry.json`](json/pyragy/poetry.json) |
| Seýdi | 29 | [`sql/seydi/poetry.sql`](sql/seydi/poetry.sql) | [`json/seydi/poetry.json`](json/seydi/poetry.json) |
| Zelili | 34 | [`sql/zelili/yedigen_zelili.sql`](sql/zelili/yedigen_zelili.sql) | [`json/zelili/poetry.json`](json/zelili/poetry.json) |
| Mataji | 31 | [`sql/mataji/yedigen_mataji.sql`](sql/mataji/yedigen_mataji.sql) | [`json/mataji/poetry.json`](json/mataji/poetry.json) |
| Magrupy | 36 | [`sql/magrupy/yedigen_magrupy.sql`](sql/magrupy/yedigen_magrupy.sql) | [`json/magrupy/poetry.json`](json/magrupy/poetry.json) |
| Kemine | 35 | [`sql/kemine/kemine.sql`](sql/kemine/kemine.sql) | [`json/kemine/poetry.json`](json/kemine/poetry.json) |
| **Total** | **855** | | |

Counts are based on the `poems` records present in each SQL file, cross-checked against `poem_count` in the corresponding JSON file.

### A note on `sql/annasoltan-kekilowa---omruzaya-yyldyzym/` and `sql/chary-yegenmyradov/`

These two poet directories already contained a `.json` file alongside their `.sql` file before this JSON export effort (`annasoltan_kekilowa_-_omruzaya_yyldyzym.json` and `gunler-geçip-baryar.json`). Those files use a different, older schema — `{ "poet", "source", "poems": [{ "title", "text" }] }`, with no `id`, `poem_count`, `source_file`, or per-poem `source` — and live next to the SQL file rather than under `json/`. They are left in place untouched. The files under `json/annasoltan-kekilowa---omruzaya-yyldyzym/poetry.json` and `json/chary-yegenmyradov/poetry.json` are newly generated from the SQL to match the schema and location used by every other poet in this dataset (see [JSON files](#json-files) below); use those for consistency with the rest of the dataset.

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

## JSON files

Each `json/<poet>/poetry.json` file is a single JSON object generated directly from the corresponding SQL file — edit the SQL and regenerate the JSON rather than editing it by hand:

```json
{
  "poet": "Bahargül Mejidowa",
  "source_file": "sql/bahargul-mejidova/poetry.sql",
  "poem_count": 24,
  "poems": [
    {
      "id": 1,
      "title": "GÜÝZ HOŞLAŞYP BARÝAR",
      "text": "Gyzyl, sary, ýaşyl öwsüp,\nGüýz hoşlaşyp gidip barýar.\n...",
      "source": null
    }
  ]
}
```

| Field | Type | Description |
| --- | --- | --- |
| `poet` | string | Poet name, taken verbatim from the SQL `poets.name` value |
| `source_file` | string | Path to the SQL file this JSON was generated from, relative to `poetry/` |
| `poem_count` | number | Number of entries in `poems` |
| `poems[].id` | number | 1-based position within this file, in the same order as the SQL `INSERT` statements. This is **not** the SQL `poems.id` (which is an auto-increment value assigned at import time and not stored in the SQL text); it exists only so a poem can be referenced within this JSON file. |
| `poems[].title` | string | Same as `poems.title` |
| `poems[].text` | string | Same as `poems.text`, with `\n` line breaks preserved |
| `poems[].source` | string \| null | Same as `poems.source`; `null` where the SQL value is `NULL` or an empty string |

A single JSON file per poet (rather than one combined file, or one file per poem) keeps each file's size close to its source SQL file and keeps the diff for future corrections limited to one poet. See [`json/README.md`](json/README.md) for a summary of this directory on its own.

This structure is a JSON object containing a nested `poems` array rather than a flat top-level array, matching how the Dictionary and Stories datasets are already documented in [`DATA_FORMAT.md`](../DATA_FORMAT.md). Because [`tools/integrity/rules.json`](../tools/integrity/rules.json) only supports flat top-level arrays, these files are not (and, for the same reason, neither are Dictionary or Stories) covered by `tools/integrity`. They are covered by [`tools/validate/main.go`](../tools/validate/main.go), which checks nested arrays for duplicate or invalid records:

```sh
go run ./tools/validate/main.go poetry/json
```

## Known data notes

These are characteristics of the source SQL, preserved as-is rather than silently corrected, per the guidance in [`CONTRIBUTING.md`](../CONTRIBUTING.md).

- **`Seydi` vs `Seýdi`** — the SQL source spells this poet's name without `ý` (`sql/seydi/poetry.sql`), while this README and other documentation use `Seýdi`. `json/seydi/poetry.json` preserves the SQL spelling (`Seydi`). This discrepancy predates this JSON export and should be resolved at the SQL source if a maintainer can confirm the correct spelling.
- **`ÇARY ÝEGENMYRADOW` casing** — the SQL source (`sql/chary-yegenmyradov/gunler-geçip-baryar.sql`) gives this poet's name in all capitals, unlike every other poet in the table above, which use title case. `json/chary-yegenmyradov/poetry.json` preserves this as `ÇARY ÝEGENMYRADOW`. Worth normalizing at the SQL source if a maintainer confirms the intended form.

### Record-boundary quality note for Gara Seýitliýew, Kerim Gurbannepesow, Magtymguly Pyragy, and AnnaSoltan Kekilowa

For most poets in this dataset, each SQL `INSERT` produces one poem-length record (roughly 500–2,000 characters of text). For the four poets below, a share of records are far larger than that:

| Poet | Records over 20,000 characters | Largest single record |
| --- | ---: | ---: |
| Gara Seýitliýew | 33 of 98 | 288,826 characters |
| Kerim Gurbannepesow | 71 of 250 | 375,551 characters |
| Magtymguly Pyragy | 7 of 130 | 153,403 characters |
| AnnaSoltan Kekilowa | 1 of 25 | 29,273 characters |

Inspecting these confirms they are not a parsing artifact: each is one well-formed, syntactically valid SQL string, verified by counting each file's raw single-quote characters against the number expected from its record count (including the poet name's second appearance in the `SET @poet_id = (SELECT id FROM poets WHERE name = '...')` line), and by confirming no other quote character falls inside the record's span. Concretely, one record in `gara-seyitliyev/poetry.sql` (`NÄZLI TEBIP`) contains what reads as dozens of subsequent poems concatenated together, followed by what appears to be the source book's table of contents (poem titles with page numbers). In `pyragy.sql`, the oversized records (e.g. `Gerek`, titled after the poem's refrain word, a common convention in classical Magtymguly editions) instead read as several distinct ghazals — each ending in Magtymguly's own name, as is traditional — concatenated one after another under a single title. The one oversized record in `annasoltan_kekilowa_-_omruzaya_yyldyzym.sql` (`Ýaňlan aýdymym`) shows the same pattern as Gara Seýitliýew's: several poems followed by embedded page numbers and form-feed characters.

This JSON export reproduces all of these records exactly as the SQL contains them — it does not attempt to split them into individual poems, since doing so would require editorial judgment about where one poem ends and the next begins, which is outside the scope of a mechanical SQL→JSON conversion. Anyone consuming `poems[].text` for these four poets should be aware that a single entry may span more than one poem, or include front/back matter, rather than assuming one entry is always one poem.

## Known limitations

- Some `source` values are empty, so publication metadata is incomplete.
- Text converted from print or PDF may retain page numbers, form-feed characters, or OCR errors. These are preserved as-is in the JSON `text` field.
- Record boundaries depend on the source layout; some long records may contain a collection rather than one poem. This is unchanged in the JSON export — it reproduces the SQL record boundaries exactly. See the record-boundary quality note above for quantified examples.
- An open SQL structure does not imply that every literary work is free of copyright. Verify the rights for each work, particularly works by modern authors, before redistribution.

## Contributing

When adding a poet or correction, include the canonical author name, one record per poem where the source permits it, complete bibliographic information, and the text-verification status. Preserve Turkmen characters in UTF-8. If you add a poet's SQL file, also add its `json/<poet>/poetry.json` counterpart following the schema documented above, generated programmatically from the SQL rather than transcribed by hand.
