# Changelog

Dataset changes in `tm-data`, newest first. Entries are generated from Git
history by [`tools/changelog`](tools/changelog/README.md); each one compares two
commits on `main` and uses the content-based dataset versions from
[`catalog.json`](catalog.json). Matching machine-readable reports are stored in
[`changes/`](changes/README.md). See the [versioning rules](changes/README.md#versioning-rules)
for what counts as a breaking change.

Do not edit generated entries by hand; regenerate them instead:

```sh
go run ./tools/changelog --from <previous-commit> --to <commit> --changelog
```

<!-- changelog:entries -->

<!-- changelog:range 33f2a3e99ba1bcb963e01887734b4ab3c398c4d9..0d12c9d4cd541e888dd885f2ca7f6002e3e36834 -->
## 2026-10-18 · `33f2a3e99ba1`…`0d12c9d4cd54`

1 dataset changed: 0 added, 0 modified, 0 deleted record(s).

### Geo (`geo`)

Version `sha256:040770fd65ed` → `sha256:7e55c797ca99`.

#### Added

- File `geo/search/index.json`
- File `geo/search/schema.json`

#### Changed

- Metadata: documentation added: geo/search/README.md
- Metadata: provenance references or note changed

<!-- changelog:end -->

<!-- changelog:range a52aba537e1794a84a4e5637bcecf89e28ab8a90..33f2a3e99ba1bcb963e01887734b4ab3c398c4d9 -->
## 2026-10-17 · `a52aba537e17`…`33f2a3e99ba1`

3 datasets changed: 100 added, 0 modified, 0 deleted record(s).

### Geo (`geo`)

Version `sha256:026387806c57` → `sha256:040770fd65ed`.

#### Added

- Format json

#### Changed

- Metadata: documentation added: geo/json/README.md
- Metadata: provenance references or note changed
- Metadata: geo/json/region_aliases.json: already present but missing from the previous catalog
- Metadata: geo/json/region_types.json: already present but missing from the previous catalog
- Metadata: geo/json/regions.json: already present but missing from the previous catalog
- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Morphology (`language-morphology`)

New dataset, version `sha256:81329c594dfe`.

#### Added

- 50 records in `language/morphology/examples.json`
- 4 records in `language/morphology/exceptions.json`
- 8 records in `language/morphology/rules.json`
- 2 records in `language/morphology/sources.json`
- 25 records in `language/morphology/suffixes.json`
- File `language/morphology/examples.json`
- File `language/morphology/exceptions.json`
- File `language/morphology/rules.json`
- File `language/morphology/sources.json`
- File `language/morphology/suffixes.json`
- Format json

### Riddles (`utils-riddles`)

New dataset, version `sha256:2c595f498c99`.

#### Added

- 10 records in `utils/riddles/riddles.json`
- 1 record in `utils/riddles/sources.json`
- File `utils/riddles/riddles.json`
- File `utils/riddles/sources.json`
- Format json

<!-- changelog:end -->

<!-- changelog:range e68e252613e2629a64ee5ef7b9fb98bcbdc42bd1..ce48836ee743d41baca6eac4b18bd207e2c27e02 -->
## 2026-09-28 · `e68e252613e2`…`ce48836ee743`

1 dataset changed: 447 added, 0 modified, 0 deleted record(s).

### Names (`utils-names`)

Version `sha256:981fe18839d9` → `sha256:5daa4747e9a6`.

#### Added

- 447 records in `utils/names/given-names.json`
- File `utils/names/given-names.json`

<!-- changelog:end -->

<!-- changelog:range eb5a5aba67b091456cd6ac1a410bb518e99952ff..e68e252613e2629a64ee5ef7b9fb98bcbdc42bd1 -->
## 2026-09-27 · `eb5a5aba67b0`…`e68e252613e2`

1 dataset changed: 16 added, 0 modified, 0 deleted record(s).

### Normalization (`utils-normalization`)

New dataset, version `sha256:459682ba3dcd`.

#### Added

- 16 records in `utils/normalization/test_cases.json`
- File `utils/normalization/rules.json`
- File `utils/normalization/test_cases.json`
- Format json

<!-- changelog:end -->

<!-- changelog:range 1a9a7c12fb5c8abaad263746f193466a426620e3..eb5a5aba67b091456cd6ac1a410bb518e99952ff -->
## 2026-09-27 · `1a9a7c12fb5c`…`eb5a5aba67b0`

1 dataset changed: 0 added, 0 modified, 0 deleted record(s).

### Geo (`geo`)

Version `sha256:2fbd81dd12d2` → `sha256:026387806c57`.

#### Added

- File `geo/geojson/regions.geojson`
- Format geojson

<!-- changelog:end -->

<!-- changelog:range 6a83d68e41fe6ed8ab2dc0aa241e1bf23e4127a3..1a9a7c12fb5c8abaad263746f193466a426620e3 -->
## 2026-09-27 · `6a83d68e41fe`…`1a9a7c12fb5c`

7 datasets changed: 0 added, 0 modified, 0 deleted record(s).

### Calendar (`utils-calendar`)

Version `sha256:1b39dfa59d94` → `sha256:1c566b398b9f`.

#### Added

- File `utils/calendar/day-periods.csv`
- File `utils/calendar/months.csv`
- File `utils/calendar/seasons.csv`
- File `utils/calendar/time-units.csv`
- File `utils/calendar/weekdays.csv`
- Format csv

### Colors (`utils-colors`)

Version `sha256:36689439b1cf` → `sha256:88a565117f68`.

#### Added

- File `utils/colors/colors.csv`
- Format csv

### Country Names (`utils-country-names`)

Version `sha256:2ef1e0551189` → `sha256:53e998ae614f`.

#### Added

- File `utils/country-names/countries.csv`
- Format csv

### Holidays (`utils-holidays`)

Version `sha256:833bebf8697c` → `sha256:258650502f2a`.

#### Added

- File `utils/holidays/holidays.csv`
- Format csv

### Postal Codes (`utils-postal-codes`)

Version `sha256:17ed69e44728` → `sha256:a86b592d7f29`.

#### Added

- File `utils/postal-codes/places.csv`
- File `utils/postal-codes/regions.csv`
- Format csv

### Proverbs (`utils-proverbs`)

Version `sha256:6766df4c1569` → `sha256:d3409e6acc4d`.

#### Added

- File `utils/proverbs/nakyllar.csv`
- Format csv

### Stopword (`utils-stopword`)

Version `sha256:81e98d6bfd7e` → `sha256:939b833432ca`.

#### Added

- File `utils/stopword/stopwords.csv`
- Format csv

<!-- changelog:end -->

<!-- changelog:range 70405fd51471abe42581a1da9aa476ccec1ecd76..6a83d68e41fe6ed8ab2dc0aa241e1bf23e4127a3 -->
## 2026-09-26 · `70405fd51471`…`6a83d68e41fe`

13 datasets changed: 0 added, 0 modified, 0 deleted record(s).

### Dictionary (`dictionary`)

Version `sha256:5f036780ab98` → `sha256:5eb353bfdb9d`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Geo (`geo`)

Version `sha256:4a30d0993f75` → `sha256:2fbd81dd12d2`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Poetry (`poetry`)

Version `sha256:98737587fd3c` → `sha256:475c5c039edc`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Stories (`stories`)

Version `sha256:6424b9cd2622` → `sha256:b016f4f665f9`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Calendar (`utils-calendar`)

Version `sha256:5af82e61a4fe` → `sha256:1b39dfa59d94`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Colors (`utils-colors`)

Version `sha256:d571ef33e716` → `sha256:36689439b1cf`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Country Names (`utils-country-names`)

Version `sha256:9ea2ef5dcc10` → `sha256:2ef1e0551189`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Holidays (`utils-holidays`)

Version `sha256:8f5c6c3a9ef7` → `sha256:833bebf8697c`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Names (`utils-names`)

Version `sha256:ff7c07c9e8af` → `sha256:981fe18839d9`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Postal Codes (`utils-postal-codes`)

Version `sha256:901eeea3e8ec` → `sha256:17ed69e44728`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Proverbs (`utils-proverbs`)

Version `sha256:2cac0525ee2c` → `sha256:6766df4c1569`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Stopword (`utils-stopword`)

Version `sha256:509516b89b36` → `sha256:81e98d6bfd7e`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

### Transliteration (`utils-transliteration`)

Version `sha256:5a1cfebb5662` → `sha256:0330db546ade`.

#### Changed

- Metadata: version identifier changed without any file content change (catalog listing or fingerprint method changed)

<!-- changelog:end -->
