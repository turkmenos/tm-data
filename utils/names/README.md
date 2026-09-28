# Turkmen Names Dataset

[← Main page](../../README.md)

This directory contains Turkmen given names with explicit gender categories,
short meanings, origins, variants, and provenance status when available.

## Files

| File | Format | Records | Description |
| --- | --- | ---: | --- |
| [`given-names.json`](given-names.json) | JSON, UTF-8 | 447 | Unified, normalized dataset with explicit gender and provenance fields |
| [`man-names.json`](man-names.json) | JSON, UTF-8 | 282 | Male given names |
| [`woman-names.json`](woman-names.json) | JSON, UTF-8 | 135 | Female given names |
| [`unisex-names.json`](unisex-names.json) | JSON, UTF-8 | 30 | Names used for more than one gender |

`given-names.json` is the recommended interface. The three category files are
retained as legacy source files and for backward compatibility. Regenerate the
unified file with `go run ./tools/names` rather than editing it directly.

## Unified JSON structure

The top-level object contains schema and provenance metadata, a `sources`
registry, and a `names` array. A record has this shape:

```json
{
  "name": "Abdylla",
  "gender": "male",
  "meaning": "allanyň guly.",
  "origins": ["Arabic"],
  "variants": [],
  "related_names": [],
  "original_form": null,
  "note": null,
  "origin_note": null,
  "source_ids": [],
  "verification_status": "unverified"
}
```

| Field | Type | Description |
| --- | --- | --- |
| `name` | string | Unique name written with Turkmen characters |
| `gender` | string | `male`, `female`, or `unisex`, derived from the legacy source file |
| `meaning` | string or null | Short Turkmen explanation; null for the one record without a supplied meaning |
| `origins` | array of strings | Reported linguistic or cultural origins; empty when unknown |
| `variants` | array of strings | Alternative or related forms recorded as variants |
| `related_names` | array of strings | Separately recorded related names |
| `original_form` | string or null | Source-language or earlier form, when recorded |
| `note`, `origin_note` | string or null | Legacy explanatory metadata |
| `source_ids` | array of strings | References into the top-level `sources` registry; currently empty |
| `verification_status` | string | Currently `unverified` for every record |

The arrays and nullable fields are always present, giving consumers a stable
schema. `record_count` must equal the number of entries in `names`.

## Legacy JSON structure

Each file contains an array of name records:

```json
{
  "name": "Abdylla",
  "origin": "Arabic",
  "variants": ["..."],
  "description": "allanyň guly."
}
```

| Field | Type | Description |
| --- | --- | --- |
| `name` | string | Name written with Turkmen characters |
| `origin` | string | Name origin, when available |
| `variants` | array of strings | Alternative spellings or related forms, when available |
| `description` | string | Short Turkmen explanation, meaning, or usage note |

Only `name` is non-empty in every legacy record. Applications should treat
`description`, `origin`, `variants`, and the other legacy metadata as optional.

## Usage

Search the unified dataset with `jq`:

```sh
jq '.names[] | select(.name == "Abdylla")' utils/names/given-names.json
```

Load all names in JavaScript:

```js
import dataset from "./utils/names/given-names.json" with { type: "json" };

const femaleNames = dataset.names.filter((item) => item.gender === "female");
```

Preserve UTF-8 encoding and Turkmen letters such as `ä`, `ç`, `ň`, `ö`, `ş`, `ü`, `ý`, and `ž`.

## Data quality and limitations

Descriptions are short explanatory notes rather than full etymological entries.
The generator rejects duplicate names across gender categories and unexpected
legacy fields. Origins, variants, spelling, meanings, and gender assignments
still need review against reliable name dictionaries or primary sources before
production, academic, or official use.

## Sources and contributions

The legacy files do not identify an author, publication, URL, retrieval date,
or redistribution terms. Consequently, the top-level `sources` registry is
empty, every `source_ids` array is empty, and every record is explicitly marked
`unverified`; these fields must not be interpreted as evidence of verification
or unrestricted redistribution rights.

Contributions should add a stable entry to `sources`, reference its ID from
affected records, and include the title, author or organization, URL or
bibliographic citation, access date, and rights information where known.
