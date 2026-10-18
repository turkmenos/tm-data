# Geographic search index

[Geography](../README.md) · [JSON sources](../json/README.md)

`index.json` is a deterministic UTF-8 array with one entry per existing region
(2,711 in the current export). Its contract is [schema.json](schema.json).
Generation reads `geo/json/regions.json` and `geo/json/region_aliases.json`;
it never changes those files or invents names, coordinates, or parent links.
Run all commands from the repository root:

```sh
go run ./tools/geosearch
go run ./tools/geosearch --check
go test ./tools/geosearch
go run ./tools/catalog
go run ./tools/catalog --check
```

Each entry retains `slug`, `parent_slug`, canonical Turkmen `name`, `type`,
`verification_status`, `source_url`, and `source_date`. Coordinates are omitted.
Aliases retain their text, language, and alias type and add `key` and
`ascii_key`. Existing canonical, English, and Russian name fields also provide
search names when absent from the alias file. Exact duplicate alias text within
a region is stored once; the canonical name takes priority, followed by the
existing alias record. Identical names across different regions remain separate.

## Search

```sh
go run ./tools/geosearch --request '{"query":"Ashgabat","limit":10}'
go run ./tools/geosearch --query 'AŞGABAT' --verified-only
go run ./tools/geosearch --query 'Ашхабад'
go run ./tools/geosearch --query 'das' --prefix --type welayat
go run ./tools/geosearch --query 'asgabat' --parent turkmenistan-lebap
go run ./tools/geosearch --query 'Ashgabatx' --fuzzy
```

The first command returns both the independent city and a village with that
English name. The first result includes these fields (additional metadata and
aliases are returned too):

```json
{
  "slug": "turkmenistan-asgabat",
  "name": "Aşgabat",
  "type": "independent_city",
  "matched_alias": "Ashgabat",
  "match": "exact",
  "distance": 0
}
```

Output is `{"results":[...]}`; no matches gives an empty array. One result is
returned per slug, using its best matching alias. Ties use alias text order,
then results use stable slug order. Matching priority is exact Unicode key,
normalized key, prefix, then fuzzy distance. Original names are preserved.

JSON request fields are `query` (required, nonblank, at most 256 Unicode code
points), `limit` (default 10, maximum 1000), `type`, `parent_slug`, `prefix`,
`fuzzy`, and `verified_only`. Boolean options default to false. The corresponding
CLI flags are shown above; `--request` supplies the complete request and takes
precedence over other search flags. Invalid types, unknown parent slugs, and
invalid limits fail. `parent_slug` includes all descendants of the supplied
region and excludes the region itself. Cycles are guarded against. Filters use
actual parent links, never slug prefixes. Status filtering is optional so
unverified settlements remain discoverable without being presented as verified.

## Unicode and approximate matching

`key` trims surrounding whitespace, applies Unicode case folding and NFC.
`ascii_key` additionally uses NFD to remove combining marks (including Turkmen
Latin diacritics), then NFC; dotless i and barred l map to i and l. Despite its
name, this key preserves non-Latin scripts: it does not transliterate Cyrillic.
Existing source `normalized_alias` values are not used because some already
remove diacritics. Consumers can reproduce the Go normalization functions to
search the JSON directly. Prefix matching applies to both derived keys.

Fuzzy matching is opt-in Levenshtein distance of at most one Unicode code point,
using the smaller distance between the Unicode and normalized key pairs.
It compares full aliases, does not implement transpositions or phonetics, and
can produce misleading results for short names. It never establishes identity
or verification. Prefix matching is separately enabled. The reference tool
scans the index in memory; it is intended for this dataset size, not as a
large-scale search service.

## Provenance and limits

All existing aliases are included as source assertions. Alias records have no
individual verification status or source URL: the index does **not** certify
aliases independently. The retained verification and provenance fields belong
to the region. `verified_only` filters region status, not alias quality.
Russian names (`ru`) are not relabeled as Turkmen Cyrillic; no Turkmen Cyrillic
names or spelling variants are generated. Such searches work only where an
existing name or alias supports them. ASCII normalization supplies search keys,
not new geographic names.

Source errors, historical names, and the hierarchy caveats in the
[geography guide](../README.md#known-data-notes) apply unchanged, including to
parent filtering. See the [English](../source/en/SOURCES.md) and
[Turkmen](../source/tm/SOURCES.md) provenance guides for dates and rights.
`--check` verifies byte-for-byte freshness; tests verify source coverage,
metadata preservation, normalization, ranking, filters, and duplicate names.
