#!/usr/bin/env python3
"""Load the tm-data parallel corpus and print aligned sentence pairs.

Uses only the Python standard library. Run from the repository root:

    python3 language/parallel-corpus/examples/load_corpus.py tk en
    python3 language/parallel-corpus/examples/load_corpus.py tk tr --reviewed-only
"""

import argparse
import csv
import json
from pathlib import Path

CORPUS = Path(__file__).resolve().parent.parent
LANGUAGES = ("tk", "tr", "en")


def load_json():
    with open(CORPUS / "sentences.json", encoding="utf-8") as handle:
        return json.load(handle)


def load_csv():
    """Read the CSV export; empty cells mean the translation is absent."""
    with open(CORPUS / "sentences.csv", encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def pairs(records, source_lang, target_lang, reviewed_only=False):
    """Yield (id, source text, target text) for records that contain both languages."""
    for record in records:
        if reviewed_only and record["verification_status"] != "human_reviewed":
            continue
        texts = record["translations"]
        if texts.get(source_lang) and texts.get(target_lang):
            yield record["id"], texts[source_lang], texts[target_lang]


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("source", choices=LANGUAGES)
    parser.add_argument("target", choices=LANGUAGES)
    parser.add_argument("--reviewed-only", action="store_true", help="skip unverified records")
    args = parser.parse_args()

    records = load_json()
    assert len(records) == len(load_csv()), "JSON and CSV exports differ; run go run ./tools/parallelcorpus"
    selected = list(pairs(records, args.source, args.target, args.reviewed_only))
    for record_id, source_text, target_text in selected:
        print(f"{record_id}\t{source_text}\t{target_text}")
    print(f"# {len(selected)} {args.source}-{args.target} pairs")


if __name__ == "__main__":
    main()
