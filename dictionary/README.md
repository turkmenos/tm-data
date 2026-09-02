# Turkmen Dictionary

[← Main page](../README.md)

This directory contains a machine-readable JSON edition of **“Türkmen diliniň sözlügi I (A–Ž)”**. It was created to make the printed/PDF dictionary easier to search, process, and reuse in software.

## Why was it created?

Structured, machine-readable resources for the Turkmen language are limited. This dataset was created to support:

- fast dictionary searches,
- web and mobile dictionary applications,
- linguistic research on the Turkmen language,
- natural language processing, text analysis, and educational projects, and
- programmatic access to the PDF content without reading it page by page.

## Source

The data was extracted from a PDF copy of the following work:

- **Title:** *Türkmen diliniň sözlügi I (A–Ž)*
- **Year:** 2010
- **Publisher:** Türkmen döwlet neşirýat gullugy
- **Source file:** `Türkmen diliniň sözlügi I (A–Ž)-2010 Türkmen döwlet neşirýat gullugy.pdf`

The source PDF is not included in this repository. The download URL and access date were not recorded in the current data. They should be added to this section if they are identified.

## File

| File | Format | Description |
| --- | --- | --- |
| [`dictionary.json`](dictionary-1.json) | JSON, UTF-8 | Dictionary metadata and structured word entries |

Approximate file statistics:

- **18,674** search keys
- **19,102** dictionary entries
- **24,677** meaning/definition sections

The number of dictionary entries is higher than the number of search keys because one search key can contain multiple entries.

## JSON structure

The top level of the file contains the `meta` and `words` fields:

```json
{
  "meta": {
    "title": "Türkmen diliniň sözlügi I (A–Ž)",
    "source": "Source PDF file",
    "generatedAt": "2026-08-29T18:23:32+05:00",
    "wordCount": 18674
  },
  "words": {
    "abadan": [
      {
        "word": "ABADAN",
        "pronunciation": "avada:n",
        "partOfSpeech": "syp",
        "meanings": [
          {
            "number": 1,
            "text": "Hemme zat ýerbe-ýer, tertipli, gurnalan..."
          }
        ],
        "raw": "[avada:n], syp. 1. Hemme zat..."
      }
    ]
  }
}
```

### Fields

| Field | Description |
| --- | --- |
| `meta.title` | Title of the source dictionary |
| `meta.source` | Name of the PDF file from which the data was extracted |
| `meta.generatedAt` | Time when the JSON file was generated |
| `meta.wordCount` | Number of normalized search keys |
| `words` | Object containing words grouped by search key |
| `word` | Original headword as it appears in the dictionary |
| `pronunciation` | Pronunciation information, when available |
| `partOfSpeech` | Part of speech or grammatical information parsed from the entry |
| `meanings` | List of numbered meanings and examples |
| `meanings[].number` | Meaning number |
| `meanings[].text` | Definition, explanation, and any usage examples |
| `raw` | Unprocessed entry text extracted from the source |

`pronunciation` and some other fields may not be present in every entry. Keys in `words` are stored in lowercase to make lookup easier. Each value is always an array because multiple entries may share the same spelling.

## Usage

### Search for a word with `jq`

```sh
jq '.words["abadan"]' dictionary/dictionary.json
```

To print only the meaning text for a word:

```sh
jq -r '.words["abadan"][] | .meanings[] | .text' dictionary/dictionary.json
```

### JavaScript

```js
import dictionary from "./dictionary/dictionary.json" with { type: "json" };

const query = "Abadan".toLocaleLowerCase("tk");
const entries = dictionary.words[query] ?? [];

for (const entry of entries) {
  console.log(entry.word, entry.pronunciation ?? "");
  console.log(entry.meanings);
}
```

### Python

```python
import json

with open("dictionary/dictionary.json", encoding="utf-8") as file:
    dictionary = json.load(file)

entries = dictionary["words"].get("abadan", [])

for entry in entries:
    for meaning in entry.get("meanings", []):
        print(meaning["number"], meaning["text"])
```

Applications should preserve the Turkmen letters `ä`, `ç`, `ň`, `ö`, `ş`, `ü`, `ý`, and `ž`, and read the file as UTF-8. Converting user input to lowercase is sufficient for most searches. More advanced search implementations may also apply Unicode normalization and Turkmen-aware case conversion.

## Data quality and limitations

This file was created by automatically parsing text extracted from a PDF. It is not a manually verified digital edition of the source work.

- PDF extraction may have produced joined or incorrectly separated words.
- Part-of-speech abbreviations may not have been parsed correctly in every entry.
- Definitions and example sentences may appear together in the same `text` field.
- Punctuation, spacing, line-break, and character-recognition errors may remain.
- The `raw` field is preserved for review and possible future reprocessing.
- Compare relevant entries with the source work before using the data for academic, commercial, or production purposes.

When correcting an entry, preserve the original `raw` text where possible and record the source page on which the correction is based.

## Copyright and usage rights

The MIT License covering this repository does not automatically apply to the text of the source dictionary. Its definitions, examples, publication, and digital copy may be subject to separate copyright or usage terms. Before publishing or redistributing the data, using it in a commercial product, or including it in model training, verify the rights status of the source work and obtain any necessary permission.

## Contributing

Contributions are welcome for incorrectly parsed entries, missing pronunciations, incorrect meaning numbers, and source information. When submitting a correction, include the word, current value, proposed value, and source page number whenever possible.
