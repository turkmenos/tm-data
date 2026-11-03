# Turkmen–Turkish–English Parallel Corpus

[← Main page](../../README.md)

This directory defines an aligned sentence corpus for Turkmen (`tk`), Turkish
(`tr`), and English (`en`). It currently holds **20 original example sentences**
written for `tm-data` with AI assistance. They demonstrate the schema and
tooling. They are **not** a source-backed or human-reviewed corpus, and every
record is marked `unverified`. See [SOURCES.md](SOURCES.md).

## Files

| File | Format | Description |
| --- | --- | --- |
| [`sentences.json`](sentences.json) | UTF-8 JSON | Canonical array of aligned sentence records |
| [`sentences.csv`](sentences.csv) | UTF-8 CSV | Flat export generated from `sentences.json` |
| [`schema.json`](schema.json) | JSON Schema 2020-12 | Record structure, identifiers, and allowed values |
| [`sources.json`](sources.json) | UTF-8 JSON | Machine-readable provenance and redistribution rights |
| [`SOURCES.md`](SOURCES.md) | Markdown | Provenance, licensing, and contribution rules |
| [`examples/load_corpus.py`](examples/load_corpus.py) | Python 3 | Standard-library loader that prints sentence pairs |

## Record structure

```json
{
  "id": "sentence-000001",
  "translations": {
    "tk": "Salam, nähili?",
    "tr": "Merhaba, nasılsın?",
    "en": "Hello, how are you?"
  },
  "category": "greetings",
  "verification_status": "unverified",
  "source": "tm-data-original-2026"
}
```

| Field | Meaning |
| --- | --- |
| `id` | Stable identifier `sentence-NNNNNN`; records are in ascending order; never renumber or reuse an identifier |
| `translations` | Aligned sentences keyed by ISO 639-1 code. `tk` is required, together with `tr`, `en`, or both. A missing key means that translation is not available. No other keys are allowed |
| `category` | `greetings`, `daily_life`, `food`, `travel`, `weather`, `education`, or `numbers_time` |
| `verification_status` | `unverified` or `human_reviewed` (see below) |
| `source` | Identifier of an entry in `sources.json`. Required and never `null` |

The record shape follows issue #44. One change from the example there: `source`
references a provenance entry and may not be `null`, so every sentence has
documented provenance.

The record may hold all three languages (three-way alignment). It may also hold
a Turkmen–Turkish or Turkmen–English pair. In `sentences.csv`, an absent
translation is an empty cell. The CSV columns are `id`, `tk`, `tr`, `en`,
`category`, `verification_status`, and `source`. The CSV uses comma delimiters,
one header row, LF line endings, RFC 4180 quoting, and no byte-order mark.

### Verification status

- `unverified`: no fluent human reviewer has checked the translations against
  the Turkmen sentence. Machine-translated and AI-assisted text always starts
  here and is never promoted automatically.
- `human_reviewed`: a fluent human reviewer has checked every translation in
  the record against the Turkmen sentence. Name the reviewer, or describe the
  review, in the pull request that changes the status.

## Validation and exports

```sh
go run ./tools/parallelcorpus          # validate and rewrite sentences.json and sentences.csv
go run ./tools/parallelcorpus --check  # validate only; fail if either export is stale
go test ./tools/parallelcorpus
```

The tool checks:

- **Encoding:** UTF-8, no byte-order mark, Unicode NFC, and no control
  characters. Turkmen text may use only letters of the Turkmen Latin alphabet,
  so Turkish `ı`/`ğ` or Cyrillic lookalikes are rejected.
- **Schema:** no unknown fields or language codes, a valid `id` pattern,
  ascending order, and allowed categories and statuses.
- **Duplicates:** unique identifiers and unique Turkmen sentences. Comparison
  ignores case, punctuation, and spacing.
- **Alignment heuristics:** each translation must end with the same
  sentence-final mark (`.`, `?`, `!`, or none) as the Turkmen sentence, and
  must contain the same numerals. These checks catch shifted or mismatched rows.
  They cannot confirm that a translation is correct.
- **Provenance:** every `source` resolves to `sources.json`. Every source names
  a license and rights statement, external sources give a URL, and unused
  sources are rejected.

Both exports are written with fixed key order, two-space indentation, and a
trailing newline, so identical input always produces identical bytes. The CI
workflow runs both commands.

## Usage

Print Turkmen–English pairs:

```sh
python3 language/parallel-corpus/examples/load_corpus.py tk en
```

Only human-reviewed Turkmen–Turkish pairs (none yet):

```sh
python3 language/parallel-corpus/examples/load_corpus.py tk tr --reviewed-only
```

With `jq`:

```sh
jq -r '.[] | select(.translations.tr) | [.translations.tk, .translations.tr] | @tsv' language/parallel-corpus/sentences.json
```

## Limitations

- The 20 sentences are short and simple. They were written as examples and are
  too small for training or benchmarking machine translation.
- None of the sentences has been reviewed by a native or fluent speaker of
  Turkmen, Turkish, or English. Treat their wording and translations as drafts.
- The alignment checks are heuristics. They do not measure translation quality.
