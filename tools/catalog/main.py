#!/usr/bin/env python3
"""Generate and verify the repository dataset catalog (Python standard library)."""
import argparse
import csv
import io
import sqlite3
import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
FORMATS = {'.json': 'json', '.sql': 'sql', '.db': 'sqlite', '.txt': 'text',
           '.csv': 'csv', '.jsonl': 'jsonl', '.parquet': 'parquet', '.geojson': 'geojson'}


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f'duplicate JSON key: {key}')
        result[key] = value
    return result


def parse_json(data):
    return json.loads(data.decode('utf-8'), object_pairs_hook=unique_object,
                      parse_constant=lambda value: fail(f'invalid JSON constant: {value}'))


def fail(message):
    raise ValueError(message)


def count_records(value, path):
    """Count actual collections, never trust embedded count metadata."""
    if isinstance(value, list):
        return len(value), 'records'
    if not isinstance(value, dict):
        return None, None
    if path == 'utils/transliteration/rules.json':
        return sum(len(collection) for direction in ('latin_to_cyrillic', 'cyrillic_to_latin')
                   for collection in value[direction].values()), 'mappings_and_rules'
    for key, unit in [('pages', 'pages'), ('poems', 'poems'),
                      ('proverbs', 'proverbs'), ('test_cases', 'test_cases')]:
        if isinstance(value.get(key), list):
            return len(value[key]), unit
    if isinstance(value.get('words'), list):
        return len(value['words']), 'words'
    if isinstance(value.get('words'), dict):
        return len(value['words']), 'search_keys'
    if path.startswith('dictionary/') and all(isinstance(v, list) for v in value.values()):
        return len(value), 'search_keys'
    return None, None


def count_file(path, data, relative):
    if path.suffix in ('.json', '.geojson'):
        value = parse_json(data)
        if path.suffix == '.geojson' and isinstance(value, dict) and isinstance(value.get('features'), list):
            return len(value['features']), 'features'
        return count_records(value, relative)
    if path.suffix == '.jsonl':
        records = [parse_json(line) for line in data.splitlines() if line.strip()]
        return len(records), 'records'
    if path.suffix == '.csv':
        rows = list(csv.reader(io.StringIO(data.decode('utf-8')), strict=True))
        if not rows or len(set(rows[0])) != len(rows[0]):
            fail(f'{relative}: missing or duplicate CSV header')
        if any(len(row) != len(rows[0]) for row in rows[1:]):
            fail(f'{relative}: inconsistent CSV row width')
        return len(rows) - 1, 'records'
    if path.suffix == '.db':
        # Read only; count stored rows, excluding SQLite internal tables and views.
        connection = sqlite3.connect(path.resolve().as_uri() + '?mode=ro', uri=True)
        try:
            tables = connection.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'").fetchall()
            total = sum(connection.execute('SELECT COUNT(*) FROM "' + name.replace('"', '""') + '"').fetchone()[0]
                        for (name,) in tables)
            return total, 'table_rows'
        finally:
            connection.close()
    return None, None


def build(root):
    datasets = []
    folders = [root / name for name in ('dictionary', 'geo', 'poetry', 'stories')]
    folders += sorted(p for p in (root / 'utils').iterdir() if p.is_dir())
    for folder in folders:
        location = folder.relative_to(root).as_posix()
        resources = []
        for path in sorted(folder.rglob('*')):
            if not path.is_file() or path.suffix not in FORMATS:
                continue
            relative = path.relative_to(root).as_posix()
            data = path.read_bytes()
            count, unit = None, None
            if path.suffix not in ('.db', '.parquet'):
                data.decode('utf-8')
            count, unit = count_file(path, data, relative)
            resource = dict(path=relative, format=FORMATS[path.suffix],
                            version='sha256:' + hashlib.sha256(data).hexdigest(),
                            record_count=count, record_unit=unit)
            if count is None:
                resource['count_note'] = 'No supported record counter; count is unknown, not zero.'
            resources.append(resource)
        if not resources:
            continue
        docs = [p.relative_to(root).as_posix() for p in sorted(folder.rglob('*.md'))]
        # Hash the ordered path/content manifest so renames also change the version.
        manifest = json.dumps([(r['path'], r['version']) for r in resources], ensure_ascii=False)
        datasets.append(dict(
            id=location.replace('/', '-'), title=folder.name.replace('-', ' ').title(),
            location=location,
            version='sha256:' + hashlib.sha256(manifest.encode('utf-8')).hexdigest(),
            formats=sorted({r['format'] for r in resources}),
            documentation=docs,
            provenance=dict(references=docs or ['SOURCES.md'],
                            note='Repository documentation and embedded source metadata; '
                                 'coverage and redistribution rights may be incomplete.'),
            resources=resources))
    ids = [dataset['id'] for dataset in datasets]
    if len(ids) != len(set(ids)):
        fail('duplicate dataset identifiers')
    return dict(schema_version='1.0.0', datasets=datasets)


def render(catalog):
    return (json.dumps(catalog, ensure_ascii=False, indent=2) + '\n').encode('utf-8')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='fail if catalog.json is stale or invalid')
    args = parser.parse_args()
    try:
        expected = render(build(ROOT))
        path = ROOT / 'catalog.json'
        if args.check:
            actual = path.read_bytes()
            parse_json(actual)
            if actual != expected:
                fail('catalog.json is stale or invalid; run python3 tools/catalog/main.py')
            print('Passed: catalog matches dataset files, counts, versions, and documentation.')
        else:
            path.write_bytes(expected)
            print('Generated catalog.json')
    except (OSError, ValueError, TypeError, AttributeError, sqlite3.Error, csv.Error) as error:
        print(f'ERROR: {error}', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
