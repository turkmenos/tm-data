import json
import sqlite3
from unittest.mock import patch
import main as catalog
from pathlib import Path
import tempfile
import unittest

from main import build, count_file, count_records, parse_json, render


class CatalogTests(unittest.TestCase):
    def test_counts_use_records_not_metadata(self):
        self.assertEqual(count_records({'page_count': 999, 'pages': [{}, {}]}, 'stories/a.json'), (2, 'pages'))
        self.assertEqual(count_records({'words': {'ä': [{}, {}]}}, 'dictionary/a.json'), (1, 'search_keys'))
        self.assertEqual(count_records({'words': ['we']}, 'utils/stopword/a.json'), (1, 'words'))
        self.assertEqual(count_records({'unknown': []}, 'a.json'), (None, None))

    def test_rejects_invalid_json_and_encoding(self):
        for data in (b'{"a":1,"a":2}', b'NaN', b'"\xff"'):
            with self.assertRaises(ValueError):
                parse_json(data)

    def test_additional_formats(self):
        self.assertEqual(count_records(None, 'a.json'), (None, None))
        self.assertEqual(count_file(Path('a.csv'), b'name\n"A,B"\n', 'a.csv'), (1, 'records'))
        self.assertEqual(count_file(Path('a.jsonl'), b'{}\n\n{}\n', 'a.jsonl'), (2, 'records'))
        with self.assertRaises(ValueError):
            count_file(Path('a.csv'), b'a,b\n1\n', 'a.csv')
        rules = {'latin_to_cyrillic': {'mappings': {'a': 'b'}, 'rules': []},
                 'cyrillic_to_latin': {'mappings': {'b': 'a'}}}
        self.assertEqual(count_records(rules, 'utils/transliteration/rules.json'), (2, 'mappings_and_rules'))
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'data.db'
            with sqlite3.connect(path) as connection:
                connection.executescript('CREATE TABLE pages(id INTEGER PRIMARY KEY AUTOINCREMENT); INSERT INTO pages DEFAULT VALUES; CREATE VIEW copy AS SELECT * FROM pages;')
            before = path.read_bytes()
            self.assertEqual(count_file(path, before, 'data.db'), (1, 'table_rows'))
            self.assertEqual(path.read_bytes(), before)

    def test_check_rejects_tampering_without_rewriting(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'utils/example').mkdir(parents=True)
            (root / 'utils/example/data.json').write_text('[1, 2]', encoding='utf-8')
            path = root / 'catalog.json'
            expected = build(root)
            path.write_bytes(render(expected))
            with patch.object(catalog, 'ROOT', root), patch('sys.argv', ['catalog', '--check']):
                self.assertEqual(catalog.main(), 0)
                expected['datasets'][0]['resources'][0]['record_count'] = 99
                tampered = render(expected)
                path.write_bytes(tampered)
                self.assertEqual(catalog.main(), 1)
                self.assertEqual(path.read_bytes(), tampered)

    def test_inventory_and_content_versions(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in ('dictionary', 'geo', 'poetry', 'stories', 'utils/colors'):
                (root / name).mkdir(parents=True)
            data = root / 'utils/colors/colors.json'
            data.write_text('[{"name":"Ýaşyl"}]', encoding='utf-8')
            (root / 'utils/colors/README.md').write_text('Sources', encoding='utf-8')
            first = build(root)
            self.assertEqual(first, build(root))
            dataset = first['datasets'][0]
            self.assertEqual(dataset['resources'][0]['record_count'], 1)
            self.assertIn('Ýaşyl', data.read_text(encoding='utf-8'))
            self.assertEqual(json.loads(render(first)), first)
            data.write_text('[{"name":"Gök"}]', encoding='utf-8')
            second = build(root)
            self.assertNotEqual(dataset['version'], second['datasets'][0]['version'])
            data.rename(data.with_name('renamed.json'))
            self.assertNotEqual(second, build(root))
            data.with_name('renamed.json').unlink()
            self.assertEqual(build(root)['datasets'], [])


if __name__ == '__main__':
    unittest.main()
