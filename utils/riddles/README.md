# Turkmen Riddles Dataset

[← Main page](../../README.md)

This directory contains a small starter collection of original Turkmen-language
riddles (`matallar`). It is **not** a transcription of traditional folklore.

## Files

| File | Format | Description |
| --- | --- | --- |
| [`riddles.json`](riddles.json) | UTF-8 JSON | 10 riddles with answers, categories, and source references |
| [`sources.json`](sources.json) | UTF-8 JSON | Source and rights information |

`riddles.json` is a top-level array. Every record has the same required fields:

```json
{
  "id": "riddle-001",
  "text": "Gündiz asmanda şöhle saçýar, gije görünmeýär. Bu näme?",
  "answer": "Gün",
  "category": "asman",
  "source_id": "tm-data-original-2026",
  "verification_status": "unreviewed"
}
```

| Field | Meaning |
| --- | --- |
| `id` | Stable, unique record identifier; do not renumber existing records |
| `text` | Riddle in modern Turkmen Latin script |
| `answer` | Intended short answer in Turkmen |
| `category` | One of `asman` (sky), `tebigat` (nature), `esbaplar` (objects), `wagt` (time), or `ses` (sound) |
| `source_id` | Identifier in `sources.json` |
| `verification_status` | `unreviewed` until a Turkmen-language reviewer checks the wording and answer |

All six fields are required and nonempty. `id` and `text` must each be unique.
`source_id` must resolve to an entry in `sources.json`. New categories or
verification states require updates to the integrity rules and this guide.

Source entries have a unique `id`, a `type` (`original`, `publication`,
`oral_recording`, or `website`), `title`, `creator`, `rights`, and `note`.
`created_year` is optional when known; an external source should also include
its citation or URL and access date when available.

## Usage

List riddle text and answer:

```sh
jq -r '.[] | "\(.text) — \(.answer)"' utils/riddles/riddles.json
```

Select nature riddles:

```sh
jq '.[] | select(.category == "tebigat")' utils/riddles/riddles.json
```

## Sources, rights, and limitations

The initial records were composed for `tm-data` with AI assistance in 2026.
They were not extracted from a book, website, or oral-history collection. Their
source is recorded in `sources.json`; the repository [LICENSE](../../LICENSE)
describes the terms for original project material. These riddles should not be
attributed to an unnamed traditional source. Their wording, cultural fit, and
whether another answer could also fit remain unreviewed.

When contributing collected riddles, add bibliographic details, a URL or
publication reference, collection date if applicable, and redistribution
rights to `sources.json`. Link each new riddle to its actual source and secure
permission where needed. Preserve UTF-8 Turkmen characters and original wording.

## Validation

```sh
go run ./tools/validate/main.go utils/riddles
go run ./tools/integrity
go run ./tools/catalog --check
```
