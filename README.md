# tm-data

Open, machine-readable datasets related to Turkmenistan.

`tm-data` collects, organizes, and shares Turkmen data for use in software, research, data analysis, education, and machine learning.

## Datasets

| Dataset | Contents | Format | Documentation |
| --- | --- | --- | --- |
| Geography | Administrative divisions, settlements, alternative names, and search helpers | PostgreSQL, MySQL, SQLite, SQL Server | [Guide](geo/README.md) |
| Poetry | 605 works by seven Turkmen poets | MySQL 8+ SQL | [Guide](poetry/README.md) |
| Stories | Page-level text extracted from Turkmen stories and prose | JSON, SQLite, MySQL SQL | [Guide](stories/README.md) |
| Colors | Turkmen color names, English translations, HEX values, and categories | MySQL 8+ SQL | [Guide](colors/README.md) |
| Dictionary | 18,674 searchable Turkmen headwords with pronunciations, definitions, and examples | JSON | [Guide](dictionary/README.md) |

Each dataset documents its structure, import process, limitations, and available sources in its own directory.

## Usage

Clone the repository:

```sh
git clone https://github.com/turkmenos/tm-data.git
cd tm-data
```

Follow the import instructions for the dataset you want to use. SQL files use UTF-8; choose a connection encoding and collation that preserve Turkmen characters such as `ä`, `ç`, `ň`, `ö`, `ş`, `ü`, `ý`, and `ž`.

## Contributing

Contributions may include new datasets, corrections, sources, translations, or additional export formats.

1. Place data in an appropriately named directory and use a clear, machine-readable structure.
2. Document the source URL, retrieval date, and redistribution rights.
3. Describe the schema, format, import steps, and known limitations in the dataset README.
4. Preserve the Turkmen alphabet in UTF-8 and check for duplicates where possible.
5. Do not include private, sensitive, or non-redistributable data.

<<<<<<< HEAD
<<<<<<< Updated upstream
=======
=======
>>>>>>> origin/main
## Bluesky bot

When a new data file is pushed to `main`, the GitHub Action publishes a Turkmen
post containing the work's title, data size, a short content preview, and only the
repository's main link. JSON datasets also include a record count or, where
applicable, page, poem, word, and character counts.
Binary files are posted with their name and size instead of a content preview.
<<<<<<< HEAD
Multiple formats of the same work (such as JSON, SQL, and SQLite) produce one
post rather than one post per file. Every Monday at 09:00 Ashgabat time, the bot
also publishes a Turkmen summary of the repository's total works and data.
=======
>>>>>>> origin/main

Configure these repository secrets under **Settings → Secrets and variables →
Actions**:

- `BLUESKY_HANDLE` — the bot account handle, for example `bot.bsky.social`
- `BLUESKY_APP_PASSWORD` — an app password created in the Bluesky account settings

Use an app password rather than the account's main password.

<<<<<<< HEAD
>>>>>>> Stashed changes
=======
>>>>>>> origin/main
## Ideas for future datasets

- Proverbs, sayings, and riddles with topic labels
- Turkmen given names with gender, meaning, and origin
- District codes, postal codes, and telephone codes
- Holidays, historical dates, and cultural heritage sites
- Thematic vocabulary for animals, plants, food, occupations, and family relationships
- Turkmen stop words, suffixes, transliteration rules, and text-normalization data
- GeoJSON and CSV exports for geography, plus JSON and CSV exports for other datasets
- Automated schema, encoding, duplicate, and integrity checks

For any new dataset, reliable provenance, redistribution rights, and verification status are more important than record count alone.

## Sources and license

General provenance guidelines are available in [SOURCES.md](SOURCES.md). Detailed sources are documented within each dataset when available.

The repository's original code and independently created material are provided under the [MIT License](LICENSE). External data, source material, and literary works may have separate licenses or copyright restrictions. Review each dataset's documentation before use or redistribution.
