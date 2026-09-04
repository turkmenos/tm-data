#!/usr/bin/env python3
"""Update the stories README contents table from local exports."""

from __future__ import annotations

import json
from pathlib import Path
from urllib.parse import quote


ROOT = Path(__file__).resolve().parent
README = ROOT / "README.md"
START = "<!-- stories-contents:start -->"
END = "<!-- stories-contents:end -->"


def display_title(path: Path) -> str:
    title = path.parent.name
    title = title.replace("_", " ").replace("-", " ")
    return " ".join(word[:1].upper() + word[1:] for word in title.split())


def comma(value: int) -> str:
    return f"{value:,}"


def link_path(path: Path) -> str:
    return quote(path.as_posix(), safe="/._-")


def html_link(label: str, path: Path) -> str:
    return f'<a href="{link_path(path)}">{label}</a>'


def row_for(json_path: Path) -> tuple[str, int, int]:
    data = json.loads(json_path.read_text(encoding="utf-8"))
    pages = data.get("pages") or []
    page_count = int(data.get("page_count") or len(pages))
    chars = sum(int(page.get("character_count") or len(page.get("text", ""))) for page in pages)

    rel_json = json_path.relative_to(ROOT)
    base = json_path.with_suffix("")
    title = display_title(json_path)
    links = [html_link("JSON", rel_json)]
    for suffix, label in ((".db", "SQLite"), ((".sql"), "MySQL")):
        candidate = base.with_suffix(suffix)
        if not candidate.exists():
            matches = sorted(json_path.parent.glob(f"*{suffix}"))
            if len(matches) == 1:
                candidate = matches[0]
        if candidate.exists():
            rel = candidate.relative_to(ROOT)
            links.append(html_link(label, rel))

    return f"{title}<br>{' · '.join(links)}", page_count, chars


def build_table() -> str:
    rows = [row_for(path) for path in sorted(ROOT.glob("*/*.json"))]
    total_pages = sum(row[1] for row in rows)
    total_chars = sum(row[2] for row in rows)

    lines = [
        "| Work | Source pages | Extracted characters |",
        "| --- | ---: | ---: |",
    ]
    for title, pages, chars in rows:
        lines.append(f"| {title} | {pages} | {comma(chars)} |")
    lines.append(f"| **Total** | **{total_pages}** | **{comma(total_chars)}** |")
    return "\n".join(lines)


def main() -> None:
    readme = README.read_text(encoding="utf-8")
    table = build_table()

    if START not in readme or END not in readme:
        raise SystemExit(f"Missing {START} / {END} markers in {README}")

    before, rest = readme.split(START, 1)
    _, after = rest.split(END, 1)
    README.write_text(f"{before}{START}\n{table}\n{END}{after}", encoding="utf-8")


if __name__ == "__main__":
    main()
