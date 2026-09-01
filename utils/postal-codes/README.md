# Turkmenistan Postal Codes Dataset

[← Main page](../../README.md)

This directory contains Turkmenistan postal-code and place data, split into region records and locality records.

## Files

| File | Format | Records | Description |
| --- | --- | ---: | --- |
| [`regions.json`](regions.json) | JSON, UTF-8 | 30 | Country, capital, region, and district-level records |
| [`places.json`](places.json) | JSON, UTF-8 | 101 | Localities with postal codes, coordinates, and administrative fields |

## Regions structure

`regions.json` contains an array of administrative records:

```json
{
  "iso": "TM",
  "country": "Turkmenistan",
  "language": "EN",
  "level": "1",
  "type": "Welayatlar",
  "name": "Ahal",
  "region1": "Ahal",
  "region2": "",
  "region3": "",
  "region4": "",
  "iso2": "TM-A",
  "fips": "TX01",
  "nuts": "",
  "hasc": "TM.AL",
  "stat": ""
}
```

| Field | Type | Description |
| --- | --- | --- |
| `iso` | string | ISO country code |
| `country` | string | Country name |
| `language` | string | Language code for the record |
| `level` | string | Administrative level as provided by the source |
| `type` | string | Region type, such as `Country`, `Capital city`, or `Welayatlar` |
| `name` | string | Region or administrative-unit name |
| `region1` | string | First-level region |
| `region2` | string | Second-level region or district |
| `region3` | string | Third-level region, when available |
| `region4` | string | Fourth-level region, when available |
| `iso2` | string | ISO 3166-2 code, when available |
| `fips` | string | FIPS code, when available |
| `nuts` | string | NUTS code, when available |
| `hasc` | string | HASC code, when available |
| `stat` | string | Statistical code, when available |

## Places structure

`places.json` contains an array of locality records:

```json
{
  "iso": "TM",
  "country": "Turkmenistan",
  "language": "EN",
  "id": "1006203395",
  "region1": "Ahal",
  "region2": "Akbugdaý",
  "region3": "",
  "region4": "",
  "locality": "Änew",
  "postcode": "745205",
  "suburb": "",
  "latitude": "37.903920",
  "longitude": "58.504875",
  "elevation": "231",
  "iso2": "TM-A",
  "fips": "TX01",
  "nuts": "",
  "hasc": "TM.AL",
  "stat": "",
  "timezone": "Asia/Ashgabat",
  "utc": "+05:00",
  "dst": "+05:00",
  "locality_type": "town",
  "is_postal": "1",
  "is_business": "0",
  "is_po_box": "0",
  "post_town": ""
}
```

| Field | Type | Description |
| --- | --- | --- |
| `id` | string | Source locality identifier |
| `region1` | string | First-level region |
| `region2` | string | Second-level region or district |
| `region3` | string | Third-level region, when available |
| `region4` | string | Fourth-level region, when available |
| `locality` | string | Locality or settlement name |
| `postcode` | string | Postal code, when available |
| `suburb` | string | Suburb or smaller delivery area, when available |
| `latitude` | string | Latitude in decimal degrees |
| `longitude` | string | Longitude in decimal degrees |
| `elevation` | string | Elevation value from the source |
| `timezone` | string | IANA time zone |
| `utc` | string | UTC offset |
| `dst` | string | Daylight-saving offset value from the source |
| `locality_type` | string | Locality type, such as `town` |
| `is_postal` | string | Postal locality flag, usually `1` or `0` |
| `is_business` | string | Business-address flag, usually `1` or `0` |
| `is_po_box` | string | PO-box flag, usually `1` or `0` |
| `post_town` | string | Post town, when available |

Common geographic/code fields such as `iso`, `country`, `language`, `iso2`, `fips`, `nuts`, `hasc`, and `stat` follow the same meaning as in `regions.json`.

Numeric-looking values are stored as strings in the current files. Applications may parse coordinates or flags when needed, but should keep `postcode` as a string so formatting is not lost.

## Usage

Find places with a known postcode:

```sh
jq '.[] | select(.postcode == "745205")' utils/postal-codes/places.json
```

List localities in Ahal:

```sh
jq -r '.[] | select(.region1 == "Ahal") | [.region2, .locality, .postcode] | @tsv' utils/postal-codes/places.json
```

List region names and codes:

```sh
jq -r '.[] | [.level, .type, .name, .iso2, .hasc] | @tsv' utils/postal-codes/regions.json
```

## Data quality and limitations

Some locality records have an empty `postcode` value even when `is_postal` is `1`. Coordinates, administrative hierarchy, flags, and postal-code coverage should be verified before use in shipping, address validation, logistics, legal compliance, or official services.

Postal-code systems and delivery areas can change. Treat this dataset as a reusable structured reference, not as an authoritative current postal directory.

## Sources and contributions

This directory does not currently include a dedicated source list. Contributions should document the source URL, access date, redistribution rights, and whether changes affect postal codes, coordinates, administrative hierarchy, or naming.
