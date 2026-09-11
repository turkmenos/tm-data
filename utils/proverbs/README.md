# Turkmen Proverbs Dataset

[← Main page](../../README.md)

This directory contains Turkmen proverbs and sayings in JSON and plain-text formats.

## Files

| File | Format | Records | Description |
| --- | --- | ---: | --- |
| [`nakyllar.json`](nakyllar.json) | JSON, UTF-8 | 5,168 | Count metadata and proverb list |
| [`nakyllar.txt`](nakyllar.txt) | Plain text, UTF-8 | 5,168 | One proverb per paragraph |

## JSON structure

```json
{
  "count": 5168,
  "proverbs": [
    "Abadan kent tüssesinden belli.",
    "Abat öýüň bilbili, bibat öýüň baýguşy."
  ]
}
```

| Field | Type | Description |
| --- | --- | --- |
| `count` | number | Number of proverbs in the dataset |
| `proverbs` | array of strings | Proverbs written in Turkmen |

## Usage

Print the number of proverbs:

```sh
jq '.count' utils/proverbs/nakyllar.json
```

Search for proverbs containing a word:

```sh
jq -r '.proverbs[] | select(test("Abraý"))' utils/proverbs/nakyllar.json
```

Read the plain-text file line by line:

```sh
awk 'NF' utils/proverbs/nakyllar.txt
```

## Data quality and limitations

The dataset currently stores proverb text only. It does not include translations, topic labels, explanations, dialect notes, source references per proverb, or duplicate/variant grouping. Punctuation, capitalization, and spelling may need additional review before linguistic or publication use.

## Sources and contributions

This directory does not currently include a dedicated source list. Contributions are welcome for source documentation, corrected spellings, duplicate detection, topic labels, English translations, and explanatory notes.
