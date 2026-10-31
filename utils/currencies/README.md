# Currencies Dataset

[← Main page](../../README.md)

Current ISO 4217 currency and fund codes with numeric codes, minor units,
English names, the entities that use each currency, and drafted Turkmen names
for commonly used currencies.

## Files

| File | Format | Records | Description |
| --- | --- | ---: | --- |
| [`currencies.json`](currencies.json) | JSON, UTF-8 | 178 | One record per ISO 4217 alphabetic code, sorted by `code` |
| [`entities.json`](entities.json) | JSON, UTF-8 | 277 | Countries, territories, and organizations using each currency |
| [`sources.json`](sources.json) | JSON, UTF-8 | 2 | Source and rights records |
| [`currencies.csv`](currencies.csv), [`entities.csv`](entities.csv) | CSV, UTF-8 | | Flat exports generated with `go run ./tools/csvexports` |

## `currencies.json`

```json
{
  "code": "TMT",
  "numeric": "934",
  "minor_units": 2,
  "name_en": "Turkmenistan New Manat",
  "name_tk": "Türkmen manady",
  "name_tk_status": "unreviewed",
  "name_tk_source_id": "tm-data-turkmen-drafts-2026",
  "is_fund": false,
  "source_id": "iso-4217-list-one-2026-09-17"
}
```

| Field | Type | Description |
| --- | --- | --- |
| `code` | string | Unique ISO 4217 alphabetic code |
| `numeric` | string | Unique ISO 4217 numeric code; a string so leading zeros are kept (`"051"`) |
| `minor_units` | integer or `null` | Decimal places of the minor unit (0–4); `null` where ISO lists "N.A." (precious metals, testing, and other non-currency codes) |
| `name_en` | string | Currency name exactly as in the ISO list |
| `name_tk` | string or `null` | Drafted Turkmen name; `null` when no Turkmen name has been added |
| `name_tk_status` | string or `null` | `unreviewed` while `name_tk` awaits review; `null` when `name_tk` is `null` |
| `name_tk_source_id` | string or `null` | Source of `name_tk` in `sources.json` |
| `is_fund` | boolean | `true` for ISO fund codes (for example `CLF`, `USN`) |
| `source_id` | string | Source of all other fields in `sources.json` |

## `entities.json`

| Field | Type | Description |
| --- | --- | --- |
| `currency_code` | string | `code` in `currencies.json` |
| `entity` | string | Entity name exactly as in the ISO list (uppercase, ISO wording) |
| `source_id` | string | Source in `sources.json` |

A currency can have several entities (the euro has many) and an entity can
have several currencies (for example Bolivia: `BOB` and the fund `BOV`).
Entity names are not ISO 3166 codes and are not linked to
[`country-names`](../country-names/README.md); match them only with care.

## Usage

```sh
jq '.[] | select(.code == "TMT")' utils/currencies/currencies.json
jq -r '.[] | select(.currency_code == "EUR") | .entity' utils/currencies/entities.json
```

```python
import json
from pathlib import Path

currencies = json.loads(Path("utils/currencies/currencies.json").read_text(encoding="utf-8"))
by_code = {item["code"]: item for item in currencies}
print(by_code["TMT"]["minor_units"])  # 2
```

## Sources, rights, and limitations

- Codes, numeric codes, minor units, English names, fund flags, and entity
  names come from the ISO 4217 List One published by SIX Financial Information
  AG, the ISO 4217 maintenance agency, on 2026-09-17 (accessed 2026-10-31).
  They are reproduced as factual identifiers; no text of the ISO standard is included.
- Three ISO rows without a currency (Antarctica; Palestine, State of; South
  Georgia and the South Sandwich Islands) are omitted.
- Turkmen names exist for 25 commonly used currencies only. They were drafted
  for this repository, are **not** from an official Turkmen terminology source,
  and stay `unreviewed` until a Turkmen-language reviewer checks them.
  Contributions of reviewed names with sources are welcome.
- ISO 4217 changes over time. To update, compare against the latest List One,
  keep codes stable, and record the new publication date in `sources.json`.
