# Poetry — JSON exports

[← Poetry dataset](../README.md) · [← Main page](../../README.md)

This directory holds one JSON file per poet, generated directly from the SQL files in [`../sql`](../sql). For the full schema, import instructions, and known data-quality notes, see the [Poetry dataset README](../README.md) — this file is a short index of what lives here.

## Files

| Poet | Records | File |
| --- | ---: | --- |
| AnnaSoltan Kekilowa | 25 | [`annasoltan-kekilowa---omruzaya-yyldyzym/poetry.json`](annasoltan-kekilowa---omruzaya-yyldyzym/poetry.json) |
| Bahargül Mejidowa | 24 | [`bahargul-mejidova/poetry.json`](bahargul-mejidova/poetry.json) |
| ÇARY ÝEGENMYRADOW | 89 | [`chary-yegenmyradov/poetry.json`](chary-yegenmyradov/poetry.json) |
| Gara Seýitliýew | 98 | [`gara-seyitliyev/poetry.json`](gara-seyitliyev/poetry.json) |
| Kerim Gurbannepesow | 250 | [`kerim-gurbannepesov/poetry.json`](kerim-gurbannepesov/poetry.json) |
| Mollanepes | 26 | [`mollanepes/poetry.json`](mollanepes/poetry.json) |
| Nobatguly Rejepow | 48 | [`nobatguly-rejepov/poetry.json`](nobatguly-rejepov/poetry.json) |
| Magtymguly Pyragy | 130 | [`pyragy/poetry.json`](pyragy/poetry.json) |
| Seýdi | 29 | [`seydi/poetry.json`](seydi/poetry.json) |
| Zelili | 34 | [`zelili/poetry.json`](zelili/poetry.json) |
| Mataji | 31 | [`mataji/poetry.json`](mataji/poetry.json) |
| Magrupy | 36 | [`magrupy/poetry.json`](magrupy/poetry.json) |
| Kemine | 35 | [`kemine/poetry.json`](kemine/poetry.json) |
| **Total** | **855** | |

## Format at a glance

Each file is a single JSON object, not a flat array:

```json
{
  "poet": "string",
  "source_file": "sql/<path>.sql",
  "poem_count": 0,
  "poems": [
    { "id": 1, "title": "string", "text": "string", "source": null }
  ]
}
```

`poems[].id` is a 1-based position matching the order of `INSERT` statements in the SQL file, not the SQL `poems.id` auto-increment value. Full field descriptions are in the [Poetry dataset README](../README.md#json-files).

## Regenerating

These files are generated, not hand-edited. To make a change, edit the corresponding SQL file under [`../sql`](../sql) and regenerate its JSON file so the two stay in sync.

## Validating

```sh
go run ../../tools/validate/main.go .
```

These files use a nested `poems` array rather than a flat top-level array, so they are validated by `tools/validate/main.go` (which recurses into nested arrays) rather than `tools/integrity`, which only supports flat top-level arrays. See the [Poetry dataset README](../README.md#json-files) for why.

## Not included here

`sql/annasoltan-kekilowa---omruzaya-yyldyzym/` and `sql/chary-yegenmyradov/` each also contain an older, differently-shaped `.json` file next to their `.sql` file, predating this directory. Those are unrelated to the files here — see the note in the [Poetry dataset README](../README.md#a-note-on-sqlannasoltan-kekilowa---omruzaya-yyldyzym-and-sqlchary-yegenmyradov) for details.
