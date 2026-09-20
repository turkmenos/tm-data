# Dataset integrity validation

This tool validates documented invariants that cannot be inferred safely from
JSON syntax alone. Rules are stored in [`rules.json`](rules.json), keeping the
schema contract reviewable and separate from the Go implementation.

The validator checks:

- required fields and JSON value types;
- non-empty fields;
- single-field and composite uniqueness constraints;
- allowed values and numeric ranges;
- alternative required fields;
- references between datasets;
- UTF-8 encoding and non-empty top-level record arrays.

## Usage

Run from the repository root:

```sh
go run ./tools/integrity
```

To validate with another compatible rules file:

```sh
go run ./tools/integrity -rules path/to/rules.json
```

The command exits with status `0` when every rule passes, `1` for dataset
integrity errors, and `2` for invalid command usage or rules configuration.

## Rule structure

Each item in `datasets` identifies a JSON array and may define `required`,
`non_empty`, `unique`, `allowed_values`, `ranges`, and `any_required` rules.
The top-level `references` array relates a source field to a target field.
Paths are relative to the repository root.

## Scope and provenance

The initial rules describe the repository's calendar, country-name, holiday,
name, and postal-code schemas. They were derived from the structures documented
in each dataset README; no external data was added or downloaded. Dataset
sources and redistribution terms remain documented beside the corresponding
data files.
