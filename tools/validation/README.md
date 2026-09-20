# Turkmen text validation

This command validates UTF-8 encoding and checks text against the modern
Turkmen Latin alphabet.

Allowed letters are:

```text
A B Ç D E Ä F G H I J Ž K L M N Ň O Ö P R S Ş T U Ü W Y Ý Z
a b ç d e ä f g h i j ž k l m n ň o ö p r s ş t u ü w y ý z
```

Whitespace, decimal digits, and common punctuation are also accepted. Letters
outside this alphabet—including visually similar Cyrillic characters—produce
an error.

## Usage

Validate a value:

```sh
go run ./tools/validation -text "Türkmenistanyň paýtagty Aşgabat."
```

Validate a plain-text file:

```sh
go run ./tools/validation -file path/to/turkmen.txt
```

The command exits with status `0` for valid text, `1` for invalid encoding or
characters, and `2` for incorrect command usage.

Run the automated tests with:

```sh
go test ./tools/validation
```

## Scope and provenance

Use this strict alphabet check only for fields or files documented as modern
Turkmen Latin text. Do not apply it to Cyrillic transliterations, foreign-language
fields, source quotations, or phonetic notation. The implementation is original
repository tooling, uses only the Go standard library, and does not download or
embed external datasets.
