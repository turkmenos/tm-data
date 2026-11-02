# Site

[← Main page](../README.md)

A static website for browsing the datasets. It has no build step and no
dependencies: `index.html`, `style.css`, and `app.js` read the repository's own
files at runtime.

| Page | Reads |
| --- | --- |
| Dataset list | [`catalog.json`](../catalog.json), [`reports/quality/summary.json`](../reports/quality/summary.json) |
| Dataset page | The dataset's files, first README paragraph, and quality report entry; JSON and GeoJSON files can be previewed and filtered in the browser |
| Changes | Range markers in [`CHANGELOG.md`](../CHANGELOG.md) and the matching [`changes/*.json`](../changes/README.md) reports |

Nothing here duplicates dataset content, so the site stays current as long as
`catalog.json`, the quality report, and the changelog are regenerated with the
data.

## Preview locally

Serve the repository root and open `/site/`:

```sh
python3 -m http.server 8000
# open http://localhost:8000/site/
```

When served under `/site/`, the site reads data from the parent directory.

## Publishing

[`.github/workflows/pages.yml`](../.github/workflows/pages.yml) copies the site,
the catalog, the reports, and the dataset directories into one directory and
deploys it to GitHub Pages on every push to `main`. GitHub Pages must be enabled
for the repository with **Source: GitHub Actions**.
