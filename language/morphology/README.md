# Turkmen morphological analysis

[← Main page](../../README.md)

A curated, machine-readable starting point for modern written Turkmen (`tk`):
25 suffix families, 50 segmented examples, 8 rules, and 4 exception records.
Version **1.0.0** uses UTF-8 NFC JSON arrays with stable string identifiers.
The canonical files are maintained by hand; no external corpus is bundled.

This is a reference dataset for segmentation, search, spell-checking research,
and language learning. It does not analyze arbitrary input, enumerate every
valid word, resolve ambiguous analyses, or provide a complete grammar.

## Files and schema

All fields below are required except `variants[].rounded`. Unknown fields are
rejected by the morphology checker. Arrays must be present, including empty
`requires_previous`, `excludes`, `exception_ids`, and `suffix_ids` arrays.
IDs are unique within each file; example words are unique in this initial
single-analysis collection. Consumers must not assume that a word has only one
linguistically possible analysis.

Every suffix, rule, exception, and example has `references`, a non-empty array
of `{ "source_id": "pc-grammar", "locator": "p. 21" }` objects. Source IDs
resolve to `sources.json`; locators refer to **printed** pages, not PDF indices.

### `suffixes.json`

| Field | Type and meaning |
| --- | --- |
| `id` | Stable suffix-family string ID |
| `pos` | `noun` or `verb`; category of the input stem |
| `slot` | Integer ordering position within that category |
| `features` | Non-empty object of grammatical string labels contributed by this suffix |
| `harmony` | `none`, `backness`, or `second_syllable_high` |
| `variants` | Non-empty array of written allomorph objects described below |
| `requires_previous` | Allowed immediately preceding suffix IDs, or `[]` for no extra constraint |
| `excludes` | Suffix IDs that cannot co-occur in this supported subset; checked in both directions |
| `verification_status` | `source_checked` |
| `references` | Source/locator objects |

Each variant has a non-empty `value` without a leading hyphen, `backness`
(`front`, `back`, `any`), and `after` (`vowel`, `consonant`, `any`). An optional
boolean `rounded` selects the written rounded/unrounded high-vowel variant;
absence means no rounding constraint. Values are unique within a family.
`any` is used for invariant suffixes such as possessive `-m`.

Feature keys are `number`, `possessor_person`, `possessor_number`, `case`,
`polarity`, `verb_form`, `tense`, `mood`, and `person`. Values used here are
`singular`/`plural`, person strings `1`/`2`/`3`, the five named non-nominative
cases, `negative`, `infinitive`, `past`/`present`/`future`, and
`intentional`/`conditional`. `possessor_number: "unspecified"` means that the
third-person suffix alone does not establish the possessor's number. Labels
are local descriptive features, not a claim of Universal Dependencies compliance.

### `rules.json`

Each record has `id`, `kind`, `description`, `parameters`,
`verification_status: "source_checked"`, and `references`.

| Rule ID | `kind` | Machine-readable `parameters` |
| --- | --- | --- |
| `vowel-backness` | `harmony` | `front`, `back`: arrays of vowel strings |
| `written-rounding` | `harmony` | `rounded`: vowel array; `max_stem_vowels`: integer; `suffix_harmony`: target harmony type |
| `noun-order` | `ordering` | `pos`, ordered integer `slots` |
| `verb-order` | `ordering` | `pos`, ordered integer `slots`, `required_slot` |
| `possessive-case-buffer` | `compatibility` | `blocked_predecessor`: suffix ID; `blocked_slot`: integer |
| `lexical-stem-voicing` | `alternation` | `exception_kind`, `trigger`: strings |
| `mixed-vowel-roots` | `exception` | `examples`: root strings |
| `orthography-not-speech` | `scope` | `representation`: string |

Only the parameters listed for a rule belong to that rule. Descriptive scope
rules are documentation; the checker enforces the covered harmony, ordering,
compatibility, and explicit exception records. It does not infer new exceptions.

### `examples.json`

| Field | Type and meaning |
| --- | --- |
| `id` | Stable analysis ID |
| `word` | Complete written surface form |
| `root` | Dictionary/root spelling, before any recorded alternation |
| `stem` | Surface spelling of that root in this word |
| `pos` | `noun` or `verb` |
| `segments` | Ordered non-empty array of `{ "suffix_id": string, "value": string }` |
| `meaning_en` | Short editorial English gloss; context may change translation |
| `exception_ids` | IDs authorizing a stem change, or `[]` |
| `verification_status` | `attested` or `rule_checked`, defined below |
| `references` | Source/locator objects |

The root itself is **not** repeated in `segments`:
`stem + ''.join(segment.value) == word`. A stem change requires a matching
exception and its trigger. No silent character insertion/deletion is allowed.
A bare finite tense can omit an agreement segment; absent person information
must not be inferred from an English gloss. Infinitives are nonfinite.

The proposed example is retained as an explicitly constructed analysis:

```json
{
  "word": "kitaplarymyzdan",
  "root": "kitap",
  "stem": "kitap",
  "segments": [
    { "suffix_id": "noun-plural", "value": "lar" },
    { "suffix_id": "noun-poss-1pl", "value": "ymyz" },
    { "suffix_id": "noun-ablative", "value": "dan" }
  ],
  "verification_status": "rule_checked"
}
```

This fragment omits other required record fields for readability; the complete
record is `books-our-from` in `examples.json`. Its gloss is “from our books”.
The first suffix starts with a consonant, so the root remains `kitap` here.
The separately attested `kitabym` uses surface stem `kitab` and an explicit
voicing exception.

### `exceptions.json`

Every record has `id`, `kind`, `root`, `stem`, `pos`, `trigger`, `suffix_ids`,
`example_word`, `note`, `verification_status: "source_checked"`, and
`references`. All scalar fields are non-empty strings; `suffix_ids` is an array.

- `stem_alternation` permits a specific root-to-stem rewrite. Trigger
  `vowel_initial_suffix` tests the first suffix; trigger `suffix_ids` requires
  that suffix to appear in the record's non-empty allowed list.
- `mixed_vowel_root` documents an exception to root-internal vowel harmony,
  with unchanged root/stem and trigger `last_vowel`. It does not authorize
  rewriting. The `kitap` record's example is constructed, as its note states.

These records distinguish `kitap → kitab`, `pişik → pişig`, the present-tense
stem `git → gid`, and the mixed-vowel root `kitap`. They are a selected list,
not a rule to voice every final `p`, `k`, `t`, or `ç`.

### `sources.json`

Each source has string fields `id`, `title`, `creator`, `url` (HTTPS),
`accessed_on` (`YYYY-MM-DD`), `rights`, and `note`, plus `publication_year`
(integer, or `null` when unknown). See [SOURCES.md](SOURCES.md) for the source
review, editorial method, and redistribution limits.

## Ordering, harmony, and compatibility

For nouns, slots are plural **10**, possessive **20**, case **30**, each optional
and used at most once. Nominative and unmarked singular have no segment.
For verbs: negation **10**, tense/mood/infinitive **20**, agreement **30**.
Slot 20 is required in verb examples; short agreement follows past/conditional,
while present agreement follows the present suffix. Definite future `-jak/-jek`
is represented without a person ending and cannot combine with the negative
suffix here; the separate-word negative construction is out of scope.

Suffix backness follows the last written vowel of the accumulated surface stem,
including on mixed-vowel roots. Written high-vowel rounding is limited to marked
variants after a monosyllabic stem with `o`, `ö`, `u`, or `ü`. Other variants do
not acquire rounded vowels automatically. Phonetic rounding and assimilation
are distinct from written segmentation.

The dative inventory currently covers consonant-final stems. Vowel-final dative
contraction, vowel loss, pronoun paradigms, third-person possessive plus case
(linking `n` and special dative forms), derivational morphology, voice, compound
tenses, and third-person plural verb agreement need further records. The
checker rejects third-person possessive/case combinations rather than accepting
an incomplete analysis. The affix inventories and slots describe the curated
subset, not unrestricted productive compatibility.

## Verification and rights

- `source_checked`: a suffix, rule, or exception was checked against the cited
  instructional reference; descriptions and machine representation are editorial.
- `attested`: the example's complete word occurs on the cited source page;
  segmentation, IDs, and English gloss are editorial annotations.
- `rule_checked`: the complete word is constructed from cited patterns, and is
  not claimed to occur verbatim in the source.

No record currently claims independent native-speaker or specialist review.
Automated success verifies structural consistency, not linguistic correctness.
Database use follows the repository [ODbL](../../LICENSE); no third-party source
PDF, extended passage, or table is redistributed. Source rights remain separate.

## Usage

Run from the repository root (Python 3, standard library only):

```python
import json
from pathlib import Path

base = Path("language/morphology")
suffixes = {s["id"]: s for s in json.loads((base / "suffixes.json").read_text(encoding="utf-8"))}
examples = json.loads((base / "examples.json").read_text(encoding="utf-8"))
example = next(e for e in examples if e["id"] == "books-our-from")
print(example["root"], [s["value"] for s in example["segments"]])
for segment in example["segments"]:
    print(segment["value"], suffixes[segment["suffix_id"]]["features"])
assert example["stem"] + "".join(s["value"] for s in example["segments"]) == example["word"]
```

Validate and regenerate the repository catalog after editing:

```sh
go run ./tools/validate/main.go language/morphology
go run ./tools/integrity
go test ./tools/morphology ./tools/catalog
go run ./tools/morphology
go run ./tools/catalog
go run ./tools/catalog --check
```

The dedicated checker validates allomorph attachment, backness, marked rounding,
ordering, agreement compatibility, lexical alternations, references, coverage
of suffix families, and exact reconstruction. It also checks NFC UTF-8 and
rejects unknown fields. General validation additionally catches duplicate JSON
keys. Both checks run in CI; use them together. The checker reports errors and
never modifies the data or downloads references.
