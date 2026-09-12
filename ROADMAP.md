# Roadmap

Planned improvements for `tm-data`. Items are proposals without fixed release dates; priorities may change based on available sources and contributions.

## Data structure and quality

- [x] Document shared conventions for field names, identifiers, dates, and UTF-8 encoding in [DATA_FORMAT.md](DATA_FORMAT.md).
- [ ] Add automated schema, duplicate, encoding, and integrity checks.
- [ ] Document source URLs, retrieval dates, redistribution rights, and verification status for each dataset.
- [ ] Update the main dataset catalog to include all datasets under `utils/`.

## Access and usage

- [ ] Add `USAGE.md` with examples for reading JSON and importing SQL data.
- [ ] Provide JSON and CSV exports where practical.
- [ ] Add GeoJSON exports for geography where suitable coordinate or boundary data is available.
- [ ] Track dataset additions and corrections in `CHANGELOG.md`.

## New and expanded datasets

- [ ] Add thematic vocabulary for animals, plants, food, occupations, and family relationships.
- [ ] Add Turkmen interface translations for common buttons, labels, and error messages.
- [ ] Document the Turkmen alphabet, sorting conventions, and Latin–Cyrillic transliteration mappings.
- [ ] Add stop words, suffixes, and text-normalization resources.
- [ ] Expand proverbs with topic labels and add sayings and riddles with explanations or answers.
- [ ] Expand given names with verified meanings and origins where sources are available.
- [ ] Add historical dates and cultural heritage records with sources.
- [ ] Add parallel Turkmen–Turkish–English sentences for language learning and translation.

## Longer-term ideas

- [ ] Build a searchable dataset catalog with record previews and downloads.
- [ ] Create a pronunciation dataset using recordings with contributor consent and redistribution permission.
- [ ] Create source-linked reading comprehension questions from suitable texts.

## Contributing

To work on an item, open an issue describing its scope, proposed sources, and output format. Follow [CONTRIBUTING.md](CONTRIBUTING.md) and [SOURCES.md](SOURCES.md) when adding data.
