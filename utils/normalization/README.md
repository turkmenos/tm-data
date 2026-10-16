# Turkmen text normalization

This directory defines a conservative, machine-readable normalization profile
for storing modern Turkmen text. It standardizes encoding-level differences
without correcting spelling, transliterating scripts, or changing content.

## Files

| File | Purpose |
| --- | --- |
| [`rules.json`](rules.json) | Ordered normalization policy, alphabet metadata, exclusions, and sources |
| [`test_cases.json`](test_cases.json) | Input/output fixtures for conforming implementations |

## Storage profile

Apply the operations in this order:

1. Reject invalid UTF-8.
2. Remove one UTF-8 BOM only when it occurs at the beginning.
3. Replace CRLF and bare CR line endings with LF.
4. Normalize the result to Unicode NFC.

NFC composes canonically equivalent sequences, so decomposed `A` + diaeresis
becomes `Ä` while meaning and spelling are retained. NFKC and NFKD are excluded
because compatibility normalization may erase distinctions. Implementations
must not silently transliterate Cyrillic, replace lookalike characters, change
case, remove Turkmen diacritics, standardize punctuation, or trim/collapse
whitespace.

The alphabet section is descriptive metadata for modern Turkmen Latin text.
It does not mean arbitrary input should have non-alphabet characters removed.
Use [`tools/validation`](../../tools/validation/README.md) separately when a
field is explicitly restricted to the Turkmen Latin alphabet.

## Reference implementation

Normalize command-line text or a file:

```sh
go run ./tools/normalization -text $'A\u0308new\r\n'
go run ./tools/normalization -file input.txt
```

Verify that the implementation conforms to every fixture and that rule
metadata is valid:

```sh
go run ./tools/normalization --check
go test ./tools/normalization
```

Output is UTF-8 and may contain any script because the storage profile is not
an alphabet validator. File output is written to standard output; input files
are not modified.

## Sources and provenance

Unicode NFC is defined by [Unicode Standard Annex #15](https://www.unicode.org/reports/tr15/).
The Turkmen-specific alphabet metadata follows the BGN/PCGN 2000 correspondence
table already used by the adjacent [transliteration dataset](../transliteration/README.md).
The pipeline, exclusions, schema, and fixtures are original repository work.
No external text corpus is included, and these rules make no spelling or
linguistic-correction claim.
