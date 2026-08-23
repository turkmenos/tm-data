# Turkmen Stories and Prose Dataset

[← Main page](../README.md) · [Sources and rights](SOURCES.md)

Page-level Turkmen text extracted from PDF books. The collection is intended for search, reading applications, text-to-speech experiments, linguistic research, and the preparation of future RAG or machine-learning datasets.

> The current files are extraction outputs, not a finished story-level training dataset. Text still needs source verification, OCR cleanup, metadata enrichment, and—in multi-work books—division into individual works.

## Contents

| Work | Source pages | Extracted characters | Files |
| --- | ---: | ---: | --- |
| Gökdepe galasy | 84 | 116,667 | [JSON](gokdepe-galasy/gokdepe_galasy.json) · [SQLite](gokdepe-galasy/gokdepe_galasy.db) · [MySQL](gokdepe-galasy/gokdepe_galasy.sql) |
| Goňubek | 38 | 56,583 | [JSON](gonubek/gonubek.json) · [SQLite](gonubek/gonubek.db) · [MySQL](gonubek/gonubek.sql) |
| Göreş | 235 | 375,230 | [JSON](goresh/chary_ashyr_-_goresh.json) · [SQLite](goresh/chary_ashyr_-_goresh.db) · [MySQL](goresh/chary_ashyr_-_goresh.sql) |
| Şükür bagşy | 58 | 93,514 | [JSON](shukur-bagshy/nurmyrat_saryhanow_-_shukur_bagshy.json) · [SQLite](shukur-bagshy/nurmyrat_saryhanow_-_shukur_bagshy.db) · [MySQL](shukur-bagshy/nurmyrat_saryhanow_-_shukur_bagshy.sql) |
| **Total** | **415** | **641,994** | |

Counts come from the extraction metadata and include front matter, page numbers, running headers, and other text that may later be removed.

## Available formats

Each work is distributed in three equivalent formats:

- **JSON** — one document object containing metadata, a `pages` array, and—when generated—a `page_columns` object.
- **SQLite** — a ready-to-query database containing `documents` and `pages`; some files also contain `page_columns`.
- **MySQL SQL** — a UTF-8 import script containing the schema and extracted text.

These files use page-level records. They are regular JSON documents, not JSONL files.

## JSON structure

```json
{
  "source_file": "example.pdf",
  "source_path": "/local/path/example.pdf",
  "created_at": "2026-08-23T19:44:17Z",
  "page_count": 2,
  "pages": [
    {
      "page_number": 1,
      "text": "Extracted Turkmen text...",
      "character_count": 27
    }
  ],
  "page_columns": {
    "page_1": "Extracted Turkmen text..."
  }
}
```

`pages` is the preferred representation. The wide `page_columns` object is a compatibility export and should not be used as the canonical structure for new tools.

## Querying SQLite

SQLite files can be opened without an import step:

```sh
sqlite3 stories/shukur-bagshy/nurmyrat_saryhanow_-_shukur_bagshy.db
```

Example queries:

```sql
SELECT source_file, page_count FROM documents;

SELECT page_number, text
FROM pages
WHERE text LIKE '%bagşy%'
ORDER BY page_number;
```

## Importing into MySQL

The SQL exports target MySQL and use `utf8mb4`:

```sh
mysql --default-character-set=utf8mb4 -u USER -p DATABASE_NAME \
  < stories/shukur-bagshy/nurmyrat_saryhanow_-_shukur_bagshy.sql
```

Import each work into a separate database. The files use the same table names, and some exports drop existing `documents`, `pages`, and `page_columns` tables. Importing multiple files into one database can overwrite or conflict with previously imported data.

## Database schema

### `documents`

| Column | Description |
| --- | --- |
| `id` | Document identifier |
| `source_file` | Original PDF filename |
| `source_path` | PDF path recorded during extraction |
| `created_at` | Extraction timestamp |
| `page_count` | Number of extracted pages |

### `pages`

| Column | Description |
| --- | --- |
| `id` | Page record identifier |
| `document_id` | Reference to `documents.id` |
| `page_number` | One-based source page number |
| `text` | Extracted UTF-8 text |
| `character_count` | Character count for the extracted page |

## Data quality and limitations

- Text is organized by PDF page rather than by chapter or story.
- OCR and PDF extraction artifacts remain, including broken words, control characters, page numbers, and repeated website headers or footers.
- `character_count` measures extracted text and is not a linguistic word or token count.
- Empty pages may be present.
- `source_path` may reveal an extraction-time local filesystem path and should be removed or replaced with a relative path before publishing derived exports.
- The same content is repeated across JSON, SQLite, and SQL formats; do not treat each format as a separate work.
- No train, validation, or test split has been prepared.

## Preparing JSONL for language-model use

Do not rename the current JSON files to `.jsonl`. Create a separate derived file after cleanup and story/chapter segmentation, with one complete record per line:

```jsonl
{"id":"shukur-bagshy","language":"tk","title":"Şükür bagşy","text":"Cleaned text...","source_title":"Şükür bagşy","verification_status":"needs_review"}
```

A recommended pipeline is:

```text
PDF extraction → page review → OCR cleanup → work/chapter segmentation
→ source and rights verification → JSONL export → validation
```

Keep the original page-level export so every cleaned passage can be traced back to its source page.

## Sources, copyright, and redistribution

Online availability does not by itself grant permission to redistribute a work or use it for model training. Before publishing full text or derived training data, verify the rights for the underlying work, translation, edition, and digital transcription.

Record the author, publisher, publication date, source URL, retrieval date, copyright status, license, and any written permission in [SOURCES.md](SOURCES.md). Material with unknown rights should not be presented as openly licensed data.

## Adding another work

1. Keep the original PDF outside the repository unless redistribution is explicitly permitted.
2. Extract every page in UTF-8 and preserve Turkmen characters such as `ä`, `ç`, `ň`, `ö`, `ş`, `ü`, `ý`, and `ž`.
3. Store the work in its own lowercase, hyphenated directory.
4. Generate matching JSON, SQLite, and MySQL files only when those formats are needed.
5. Check page counts, ordering, empty pages, encoding, and duplicate text.
6. Document provenance, extraction method, data quality, and rights.
7. Update the contents table in this README.
