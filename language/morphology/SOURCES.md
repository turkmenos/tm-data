# Sources and editorial method

Source access date: **2026-10-17**. Machine-readable source identifiers and
bibliographic fields are in [sources.json](sources.json).

## `pc-grammar`

**U.S. Peace Corps Turkmenistan, _Turkmen Language Grammar Guide_**.
The consulted PDF does not establish a publication year; it is recorded as
`null`, rather than inferred from the mirror's upload path.

- [Consulted PDF mirror](https://parsistrans.com/wp-content/uploads/2019/02/TurkmenLanguageLearningGuide_001.pdf)
- Printed pp. 10–13: vowels, harmony, and spelling/phonetic transformations.
- Printed pp. 14–18: cases, pronouns, and possession.
- Printed pp. 21–25: plural, infinitive, present, and past forms.
- Printed p. 28: definite future; pp. 46–47: simple conditionals and negation.

This is an institutional instructional source hosted by a third party, not a
modern normative spelling dictionary. The PDF was consulted as text and the
possession table was visually inspected. Locators use the numbers printed in
the document: printed p. 18 is the seventeenth PDF page (zero-based index 16).

The guide has editorial inconsistencies. It calls the `Çykyş düşüm` “instrumental”;
this dataset labels the `-dan/-den` function **ablative**. The possession table
also contains inconsistent `öý` spelling and possessive forms; disputed cells
are not treated as authoritative examples. Its broad consonant-voicing statement
is not implemented as a universal rewrite. Only the listed lexical alternations
are allowed by the checker. Spoken variants are not substituted for spelling.

## `pc-manual-1993`

**David Tyson and Larry Clark, _Turkmen Language Manual_, U.S. Peace Corps,
June 1993**, ERIC ED362052.

- [ERIC bibliographic record](https://eric.ed.gov/?id=ED362052)
- [ERIC full text](https://files.eric.ed.gov/fulltext/ED362052.pdf)
- Introduction, printed pp. 7–10 (PDF pages 14–17): vowel harmony, suffixation,
  and grammatical suffixes.

This primary institutional manual provides a background cross-check for the
agglutinative model and noun suffix ordering. It uses Cyrillic; no automatic
transliteration or bulk extraction from it is included. Individual modern Latin
records cite `pc-grammar`, where their surface spelling can be inspected.

## Annotation and verification

The JSON organization, stable IDs, grammatical labels, segment boundaries,
English glosses, and explanations were authored for this repository. This is a
small editorial selection of linguistic facts and isolated word forms, not a
reproduction of source tables or prose. All example forms except
`kitaplarymyzdan` occur in the cited guide locations; the complete proposed
word is marked `rule_checked`, since its analysis combines independently
cited suffix patterns. `attested` does not imply that the source supplies the
same segmentation or that an expert reviewed the annotation.

Before extending coverage, consult a normative Turkmen grammar or spelling
reference and seek a qualified speaker's review where the teaching source is
ambiguous. Record a distinct status if independent review is added; do not
silently reinterpret `source_checked` as expert verification.

## Redistribution rights

No explicit blanket reuse license was identified for the consulted guide copy.
Public access and U.S. institutional attribution alone are not treated as proof
that every contributor's material is public domain. The same caution applies
to third-party material in the ERIC manual. Neither PDF, its tables, nor extended
passages are bundled or relicensed here.

The repository's original database arrangement and annotations are offered
under its [ODbL 1.0 license](../../LICENSE). Attribution should identify
`turkmenos/tm-data`, link this source guide, and retain record-level references.
That database license grants no additional rights in the source publications;
consult their rights holders before redistributing their material.
