## JSON

A JSON export, generated from the SQL seed data, is also available for applications that don't use a database:

| File | Contents |
| --- | --- |
| [`json/regions.json`](json/regions.json) | 2,711 administrative regions and settlements |
| [`json/region_aliases.json`](json/region_aliases.json) | 7,494 aliases (canonical names, transliterations, ASCII forms, historical names) |
| [`json/region_types.json`](json/region_types.json) | The 8 region types and their descriptions |

See [`json/README.md`](json/README.md) for the schema, and [Known data notes](#known-data-notes) below for data-quality findings surfaced while generating this export.

## GeoJSON

`regions.geojson` is a UTF-8 `FeatureCollection` generated from the canonical
SQLite import. It contains one feature per region or settlement. Feature IDs
are stable slugs; properties include the parent slug, names, type, verification
status, and record-level source metadata. Records with coordinates use WGS 84
`Point` geometry in `[longitude, latitude]` order. Records without documented
coordinates use `geometry: null`; coordinates and administrative boundary
polygons are never inferred.

Regenerate and check the export from the repository root:

```sh
go run ./tools/geojson
go run ./tools/geojson --check
go test ./tools/geojson
```

The source coverage, dates, licensing, and verification limitations documented
in the [English](source/en/SOURCES.md) and [Turkmen](source/tm/SOURCES.md)
source guides apply unchanged to this derived export.

## Geographic search

[The derived search index](search/README.md) supports canonical names, existing
aliases, Unicode and ASCII-normalized matching, optional prefix and fuzzy
matching, and administrative filters while preserving stable slugs and provenance.

```sh
go run ./tools/geosearch
go run ./tools/geosearch --query Ashgabat
go run ./tools/geosearch --check
```
