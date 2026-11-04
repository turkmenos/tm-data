# Parallel corpus sources and rights

[← Parallel corpus guide](README.md)

Every sentence record names a `source` entry in [`sources.json`](sources.json).
That entry documents where the text came from and the permission to
redistribute it. Records without documented provenance and redistribution
permission are not accepted.

## Current sources

| Source ID | Type | Records | License | Status |
| --- | --- | --- | --- | --- |
| `tm-data-original-2026` | Original, AI-assisted | 20 (`sentence-000001`–`sentence-000020`) | ODbL 1.0 (repository [LICENSE](../../LICENSE)) | All `unverified` |

### `tm-data-original-2026`

The Turkmen sentences and their Turkish and English translations were written
for `tm-data` in 2026 with AI assistance. They are examples of everyday phrases
and are meant to exercise the schema and validation tooling. They were not taken
from a book, phrasebook, website, subtitle file, or existing parallel corpus.
`sentence-000001` reuses the example record from issue #44.

No licensed, source-backed Turkmen–Turkish–English sentence collection was
added in this first version. These sentences are therefore not presented as
collected or attested language data. No human translator has reviewed them, so
every record stays `unverified`.

## Adding sources

1. Use only text you may redistribute under the repository's ODbL 1.0 terms:
   - your own original sentences,
   - public-domain text,
   - text under a compatible open license, or
   - text whose rights holder has given written permission.

   Do not copy sentences from copyrighted textbooks, phrasebooks, news sites,
   subtitles, or translation services without that permission.
2. Add an entry to `sources.json` with these fields:
   - `id`, `type` (`original`, `publication`, `website`, or `corpus`), `title`,
     and `creator`;
   - `license` and `rights`, which state the redistribution permission;
   - `machine_assisted` and a `note`;
   - for external material, `url` and `access_date`.
3. Link each new record to its source. Keep the original Turkmen spelling and
   characters.
4. Set `verification_status` to `human_reviewed` only after a fluent human
   reviewer has checked every translation in the record. Machine-generated
   translations stay `unverified`.
5. Run `go run ./tools/parallelcorpus`, then `go run ./tools/catalog`, and
   commit the regenerated files.
