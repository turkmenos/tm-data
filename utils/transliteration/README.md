# Turkmen Transliteration

Machine-readable transliteration rules for converting text between the Turkmen Latin and Cyrillic alphabets.

## Overview

This dataset provides character mappings and transliteration rules for:

- Turkmen Latin → Cyrillic
- Turkmen Cyrillic → Latin

The rules are intended for use in search systems, NLP pipelines, text normalization, data migration, and other applications that work with Turkmen text written in different scripts.

## Files

```text
transliteration/
├── README.md
├── rules.json
└── test_cases.json
```

- `rules.json` — character mappings and transliteration rules.
- `test_cases.json` — example words and expected transliteration results.

## Example

```text
Latin:     Türkmenistan
Cyrillic:  Түркменистан

Latin:     Aşgabat
Cyrillic:  Ашгабат
```

## Encoding

All files use UTF-8 encoding.

Turkmen-specific Latin characters are preserved:

```text
Ä ä
Ç ç
Ň ň
Ö ö
Ş ş
Ü ü
Ý ý
Ž ž
```

Cyrillic characters used in Turkmen text are also stored directly as UTF-8.

## Notes

Transliteration is not always a simple one-to-one character replacement. Some Cyrillic characters or character combinations may require contextual rules when converting between scripts.

Implementations using this dataset should process multi-character and contextual rules before applying simple character mappings.

## Validation

The dataset should be validated to ensure that:

- all records are valid UTF-8;
- duplicate mappings are not introduced;
- required fields are present;
- test cases produce the expected output;
- Latin and Cyrillic mappings remain consistent.

## Sources

The transliteration rules should be based on documented Turkmen alphabet and orthographic sources.

Source references and any deviations or implementation-specific decisions should be documented alongside the dataset.

## Contributing

Contributions, corrections, and additional test cases are welcome.

When modifying the transliteration rules, please include a source or explanation for the change and update the relevant test cases.