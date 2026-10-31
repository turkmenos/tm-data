# Units Dataset

[← Main page](../../README.md)

SI base units, SI derived units with special names, non-SI units listed by the
BIPM for use with the SI, and SI prefixes, with symbols, values in SI units,
and drafted Turkmen names for commonly used units.

## Files

| File | Format | Records | Description |
| --- | --- | ---: | --- |
| [`units.json`](units.json) | JSON, UTF-8 | 52 | 7 base, 22 derived, and 23 non-SI units |
| [`prefixes.json`](prefixes.json) | JSON, UTF-8 | 24 | SI prefixes from quecto (10⁻³⁰) to quetta (10³⁰) |
| [`sources.json`](sources.json) | JSON, UTF-8 | 2 | Source and rights records |
| [`units.csv`](units.csv), [`prefixes.csv`](prefixes.csv) | CSV, UTF-8 | | Flat exports generated with `go run ./tools/csvexports` |

## `units.json`

```json
{
  "id": "newton",
  "category": "si_derived",
  "quantity_en": "force",
  "name_en": "newton",
  "symbol": "N",
  "alternative_symbol": null,
  "name_tk": "nýuton",
  "name_tk_status": "unreviewed",
  "name_tk_source_id": "tm-data-turkmen-drafts-2026",
  "si_expression": "kg m s⁻²",
  "source_id": "si-brochure-9-v4.01"
}
```

| Field | Type | Description |
| --- | --- | --- |
| `id` | string | Unique, stable identifier (English, hyphenated) |
| `category` | string | `si_base`, `si_derived` (special names, Table 2 of the concise summary), or `non_si` (Table 8 of the SI Brochure) |
| `quantity_en` | string | Quantity as named by the BIPM |
| `name_en` | string | Unit name as in the brochure; the angle units `arcminute` and `arcsecond` are named `minute` and `second` there |
| `symbol` | string or `null` | Unit symbol in Unicode; `null` for the nautical mile and knot, which have none |
| `alternative_symbol` | string or `null` | Second accepted symbol (`l` for litre, `as` for arcsecond) |
| `name_tk`, `name_tk_status`, `name_tk_source_id` | string or `null` | Drafted Turkmen name, `unreviewed` status, and its source; all `null` when no Turkmen name has been added |
| `si_expression` | string or `null` | For derived units, the expression in other SI units and base units; for non-SI units, the value in SI units; `null` for base units and for neper, bel, and decibel, whose values depend on the quantity |
| `source_id` | string | Source in `sources.json` |

## `prefixes.json`

| Field | Type | Description |
| --- | --- | --- |
| `name_en` | string | Prefix name |
| `symbol` | string | Prefix symbol; micro uses `µ` (U+00B5) as in the brochure |
| `exponent` | integer | Power of ten |
| `name_tk`, `name_tk_status`, `name_tk_source_id` | string or `null` | As in `units.json` |
| `source_id` | string | Source in `sources.json` |

## Usage

```sh
jq -r '.[] | select(.category == "si_base") | "\(.symbol)\t\(.name_en)\t\(.name_tk)"' utils/units/units.json
jq '.[] | select(.exponent == 3)' utils/units/prefixes.json
```

## Sources, rights, and limitations

- Names, symbols, quantities, values, and prefixes come from *The International
  System of Units (SI)*, 9th edition (2019), V4.01 (June 2026), and its concise
  summary V4.01, published by the BIPM (accessed 2026-10-31). Only table
  entries are reproduced, with attribution; base unit definitions are not included.
- Non-SI units are those in Table 8 of the brochure; the list is not exhaustive.
- Turkmen names exist for common units and prefixes only. They were drafted
  for this repository, are **not** from an official Turkmen terminology source,
  and stay `unreviewed` until a Turkmen-language reviewer checks them. Turkmen
  unit abbreviations are not included; use the international `symbol`.
