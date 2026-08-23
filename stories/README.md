# Turkmen Stories Dataset

[← Main page](../README.md) · [Sources](SOURCES.md)

A structured home for Turkmen folk tales, short stories, legends, fables, and children's stories. The dataset is designed for reading applications, search, text-to-speech, linguistic research, RAG, and—where the license explicitly permits it—machine-learning training.

## Status

The schema and contribution rules are ready, but no story text has been imported yet. A work must not be added merely because it can be read or downloaded online. Include full text only when it is:

- in the public domain and that status has been verified;
- published under a license that permits redistribution; or
- covered by written permission from the relevant rights holder.

## Files

| File | Purpose |
| --- | --- |
| [`schema/story.schema.json`](schema/story.schema.json) | JSON Schema for validating each story record |
| `data/*.jsonl` | Future UTF-8 story records, one JSON object per line |
| [`SOURCES.md`](SOURCES.md) | Provenance, permission, and source notes |

## Record format

```json
{
  "id": "folk-tale-example",
  "language": "tk",
  "title": "Example title",
  "slug": "example-title",
  "genre": "folk_tale",
  "text_original": "Original Turkmen text...",
  "text_normalized": "Normalized Turkmen text...",
  "author": null,
  "is_anonymous": true,
  "source_title": "Source publication",
  "source_url": "https://example.org/source",
  "source_date": "1900",
  "retrieved_at": "2026-08-23",
  "copyright_status": "public_domain",
  "license": "Public domain",
  "permission_reference": null,
  "verification_status": "verified"
}
```

## Important fields

- `text_original` preserves the source spelling and layout as closely as practical.
- `text_normalized` contains a corrected, search- and TTS-friendly version without silently replacing the original.
- `copyright_status` records whether reuse is actually permitted; `unknown` records must not contain full text.
- `permission_reference` identifies written permission when redistribution depends on it.
- `verification_status` describes editorial verification, not copyright status.

## Recommended genres

- `folk_tale`
- `short_story`
- `legend`
- `fable`
- `children_story`
- `anecdote`
- `myth`
- `other`

## Adding material from Kitaphana

[Kitaphana](https://www.kitaphana.net/) is a useful discovery catalog, but availability on the website does not by itself grant redistribution or model-training rights. Before importing a book:

1. Identify the author, translator, editor, publisher, and publication year.
2. Determine the copyright status of the underlying work and the specific edition.
3. Obtain written permission if no explicit reusable license is provided.
4. Save evidence of the license or permission in the source record.
5. Extract and normalize the text, then manually review OCR errors and story boundaries.
6. Keep train, validation, and test splits separated by work—not by random paragraphs—to prevent leakage.

Do not import account details, annotations, website interface text, or unrelated books. Do not bypass access controls or overload the website.

## Validation

Each line in a future JSONL file should validate against `schema/story.schema.json`. IDs and slugs must be unique across the dataset. UTF-8 Turkmen characters must be preserved.
