# Country Names Dataset

[← Main page](../../README.md)

Country and territory names in Turkmen and English, paired with two-letter codes. Use this dataset for country selectors, localized labels, and code-to-name lookups.

## Files

| File | Format | Records | Description |
| --- | --- | ---: | --- |
| [`countries.json`](countries.json) | JSON, UTF-8 | 249 | Country and territory codes with Turkmen and English names |

## JSON structure

The file contains an array of objects, sorted by `code`:

```json
{
  "code": "TM",
  "tm": "Türkmenistan",
  "en": "Turkmenistan"
}
```

| Field | Type | Description |
| --- | --- | --- |
| `code` | string | Unique uppercase two-letter country or territory code |
| `tm` | string | Turkmen display name |
| `en` | string | English display name |

All three fields are present in every record. The `tm` field identifies the Turkmen name within this dataset.

## Usage

Run these examples from the repository root.

Look up a country with `jq`:

```sh
jq '.[] | select(.code == "TM")' utils/country-names/countries.json
```

Load the dataset and create a Turkmen name lookup in Python:

```python
import json
from pathlib import Path

path = Path("utils/country-names/countries.json")
countries = json.loads(path.read_text(encoding="utf-8"))
names_tm = {country["code"]: country["tm"] for country in countries}

print(names_tm["TM"])  # Türkmenistan
```

Preserve UTF-8 encoding when reading or exporting the data so that Turkmen characters remain intact.

## Scope and sources

The dataset includes territories as well as countries. Names are display labels and may use shortened forms; they are not necessarily official full names.

This directory does not currently include source references or a retrieval date. Contributions should document sources for new entries and corrections, especially changes to codes or translated names. See the repository's [source guidelines](../../SOURCES.md) and [license](../../LICENSE) for more information.
