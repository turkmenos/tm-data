# Turkmen Names Dataset

[← Main page](../../README.md)

This directory contains Turkmen given names with short descriptions, origins, and variants when available.

## Files

| File | Format | Records | Description |
| --- | --- | ---: | --- |
| [`man-names.json`](man-names.json) | JSON, UTF-8 | 282 | Male given names |
| [`woman-names.json`](woman-names.json) | JSON, UTF-8 | 135 | Female given names |
| [`unisex-names.json`](unisex-names.json) | JSON, UTF-8 | 30 | Names used for more than one gender |

## JSON structure

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

Only `name` and `description` are present in every record. Applications should treat `origin` and `variants` as optional.

## Usage

Search for a name with `jq`:

```sh
jq '.[] | select(.name == "Abdylla")' utils/names/man-names.json
```

Load all names in JavaScript:

```js
import men from "./utils/names/man-names.json" with { type: "json" };
import women from "./utils/names/woman-names.json" with { type: "json" };
import unisex from "./utils/names/unisex-names.json" with { type: "json" };

const allNames = [
  ...men.map((item) => ({ ...item, category: "male" })),
  ...women.map((item) => ({ ...item, category: "female" })),
  ...unisex.map((item) => ({ ...item, category: "unisex" })),
];
```

Preserve UTF-8 encoding and Turkmen letters such as `ä`, `ç`, `ň`, `ö`, `ş`, `ü`, `ý`, and `ž`.

## Data quality and limitations

Descriptions are short explanatory notes rather than full etymological entries. Origins, variants, spelling, and gender assignment may need review against reliable name dictionaries or primary sources before production, academic, or official use.

## Sources and contributions

This directory does not currently include a dedicated source list. Contributions should include the source used for each new or corrected name, especially when adding origin, variant, or meaning information.
