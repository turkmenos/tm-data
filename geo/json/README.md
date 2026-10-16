# Geography — JSON export

[← Geography dataset](../README.md) · [← Main page](../../README.md)

JSON export of the administrative geography and settlements of Turkmenistan, generated from [`../sql/sqlite/import.sql`](../sql/sqlite/import.sql) (all four SQL dialects in `../sql/` encode the same data; SQLite's single-statement-per-row format made it the most direct to parse). Edit the SQL and regenerate these files rather than editing them by hand.

## Files

| File | Records | Contents |
| --- | ---: | --- |
| [`regions.json`](regions.json) | 2,711 | Administrative regions and settlements, as a tree |
| [`region_aliases.json`](region_aliases.json) | 7,494 | Alternative names, transliterations, and historical names for each region |
| [`region_types.json`](region_types.json) | 8 | The region type vocabulary used by `regions.json`'s `type` field |

## `regions.json`

A flat JSON array. Each object:

```json
{
  "slug": "turkmenistan-ahal-ak-bugday-anew",
  "parent_slug": "turkmenistan-ahal-ak-bugday",
  "name_tm": "Änew",
  "name_en": "Anew",
  "name_ru": "Анев",
  "type": "city",
  "latitude": null,
  "longitude": null,
  "country_code": "TM",
  "verification_status": "verified",
  "source_url": "https://en.wikipedia.org/wiki/Cities_of_Turkmenistan",
  "source_date": "2022-12-20"
}
```

| Field | Type | Description |
| --- | --- | --- |
| `slug` | string | Stable, human-readable identifier. Unique across the file; used instead of a synthetic numeric ID since the SQL's own `id` is an auto-increment value assigned at import time and not present in the SQL text. |
| `parent_slug` | string \| null | The `slug` of this region's parent. `null` only for the root (`turkmenistan`). |
| `name_tm`, `name_en`, `name_ru` | string / string / string \| null | Name in Turkmen, English, and Russian |
| `type` | string | One of the values in `region_types.json`: `country`, `independent_city`, `welayat`, `etrap`, `city`, `town`, `village`, `rural_council` |
| `latitude`, `longitude` | number \| null | Decimal degrees. `null` where the source has no coordinate, which is true for most records — see [Known data notes](../README.md#known-data-notes) |
| `country_code` | string | Always `"TM"` in the current data |
| `verification_status` | string | `"verified"` or `"verification_required"` — the large majority of records (mostly villages and rural councils) are `verification_required`; see [Sources](../source/en/SOURCES.md) |
| `source_url`, `source_date` | string | Provenance for this specific record |

## `region_aliases.json`

A flat JSON array. Each object:

```json
{
  "region_slug": "turkmenistan",
  "alias": "Туркменистан",
  "language": "ru",
  "alias_type": "transliteration",
  "normalized_alias": "туркменистан"
}
```

| Field | Type | Description |
| --- | --- | --- |
| `region_slug` | string | The `slug` of the region this alias belongs to, from `regions.json` |
| `alias` | string | The alias text |
| `language` | string | `tm`, `en`, `ru`, or `und` (undetermined — mostly ASCII-only search forms) |
| `alias_type` | string | `canonical`, `transliteration`, `ascii`, or `historical` |
| `normalized_alias` | string | Lowercased form of `alias`, used for search matching |

Every region has exactly one `canonical` alias. A `(region_slug, alias)` pair is unique — see [Known data notes](../README.md#known-data-notes) for cases where two different regions legitimately share the same alias text.

## `region_types.json`

A flat JSON array of all 8 values used by `regions.json`'s `type` field, each with a one-line description:

```json
{ "type": "rural_council", "description": "Geňeşlik" }
```

## Validating

`regions.json`, `region_aliases.json`, and `region_types.json` are flat top-level arrays, so — unlike the Poetry dataset's nested per-poet JSON — they're covered by both repo-wide validators:

```sh
go run ./tools/validate/main.go geo/json
go run ./tools/integrity
```

`tools/integrity/rules.json` also cross-checks referential integrity: every `region_aliases.region_slug` and every `regions.parent_slug` resolves to a real `regions.slug`. See the [Geography dataset README](../README.md#known-data-notes) for a data-quality finding about the hierarchy that these checks cannot catch (they confirm every parent link points to *some* real region, not that it points to the *correct* one).
