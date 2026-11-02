"use strict";

// Data files sit next to the site when deployed. When the repository root is
// served locally, the site lives under /site/ and the data one level up.
const BASE = location.pathname.includes("/site/") ? "../" : "./";
const REPO = "https://github.com/turkmenos/tm-data";
const PREVIEWABLE = new Set(["json", "geojson"]);
const PREVIEW_ROWS = 100;

const app = document.getElementById("app");
const cache = new Map();
const state = { catalog: null, quality: null };

const fmt = new Intl.NumberFormat("en-US");

function esc(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function fetchCached(path, type) {
  const key = `${type}:${path}`;
  if (!cache.has(key)) {
    cache.set(key, fetch(BASE + path).then((res) => {
      if (!res.ok) throw new Error(`${path}: HTTP ${res.status}`);
      return type === "json" ? res.json() : res.text();
    }));
  }
  return cache.get(key);
}

function qualityFor(id) {
  return state.quality?.datasets.find((d) => d.dataset === id) ?? null;
}

// The quality report counts each dataset once, from its configured primary
// files; summing catalog resources would count the same records per format.
function datasetCount(id) {
  const quality = qualityFor(id);
  if (quality?.record_count == null) return null;
  const unit = quality.record_unit === "mixed" ? "entries (mixed units)" : quality.record_unit.replaceAll("_", " ");
  return { count: quality.record_count, unit };
}

function statusBadge(status) {
  return status ? `<span class="status ${esc(status)}">${esc(status)}</span>` : "";
}

function shortVersion(version) {
  return version ? version.replace(/^sha256:/, "").slice(0, 12) : "";
}

function githubLink(path, label = path) {
  return `<a href="${REPO}/blob/main/${esc(path)}">${esc(label)}</a>`;
}

// ---------- Home ----------

function renderHome() {
  const { catalog, quality } = state;
  const datasets = catalog.datasets;
  const resources = datasets.flatMap((d) => d.resources);
  const formats = [...new Set(resources.map((r) => r.format))].sort();

  app.innerHTML = `
    <section class="hero">
      <h1>tm-data</h1>
      <p>Open, machine-readable datasets related to Turkmenistan: geography,
      dictionaries, literature, and everyday reference data.</p>
      <div class="stats">
        <div class="stat"><b>${fmt.format(datasets.length)}</b><span>datasets</span></div>
        <div class="stat"><b>${fmt.format(resources.length)}</b><span>files</span></div>
        <div class="stat"><b>${fmt.format(formats.length)}</b><span>file formats</span></div>
        ${quality ? `<div class="stat"><b>${fmt.format(quality.totals.passed)}/${fmt.format(quality.totals.datasets)}</b><span>pass quality checks</span></div>` : ""}
      </div>
    </section>
    <div class="toolbar">
      <input type="search" id="q" placeholder="Search datasets" aria-label="Search datasets">
      <select id="format" aria-label="Filter by format">
        <option value="">All formats</option>
        ${formats.map((f) => `<option>${esc(f)}</option>`).join("")}
      </select>
    </div>
    <div class="grid" id="list"></div>
    <p class="muted" id="empty" hidden>No dataset matches.</p>
  `;

  const q = document.getElementById("q");
  const format = document.getElementById("format");
  const list = document.getElementById("list");
  const empty = document.getElementById("empty");

  function update() {
    const term = q.value.trim().toLowerCase();
    const shown = datasets.filter((d) =>
      (!term || `${d.title} ${d.id} ${d.location}`.toLowerCase().includes(term)) &&
      (!format.value || d.formats.includes(format.value)));
    list.innerHTML = shown.map(card).join("");
    empty.hidden = shown.length > 0;
  }
  q.addEventListener("input", update);
  format.addEventListener("change", update);
  update();
}

function card(dataset) {
  const count = datasetCount(dataset.id);
  const quality = qualityFor(dataset.id);
  return `
    <a class="card" href="#/d/${encodeURIComponent(dataset.id)}">
      <div class="row" style="justify-content:space-between">
        <h3>${esc(dataset.title)}</h3>
        ${statusBadge(quality?.status)}
      </div>
      <div class="count">${count ? `${fmt.format(count.count)} <span class="muted" style="font-size:.8rem;font-weight:400">${esc(count.unit)}</span>` : "—"}</div>
      <div class="muted mono">${esc(dataset.location)}/</div>
      <div class="row">${dataset.formats.map((f) => `<span class="chip">${esc(f)}</span>`).join("")}</div>
    </a>`;
}

// ---------- Dataset ----------

async function renderDataset(id) {
  const dataset = state.catalog.datasets.find((d) => d.id === id);
  if (!dataset) {
    app.innerHTML = `<p class="crumb"><a href="#/">← All datasets</a></p><h1>Not found</h1><p>No dataset with id <code>${esc(id)}</code>.</p>`;
    return;
  }
  const quality = qualityFor(id);
  const docs = dataset.documentation ?? [];

  app.innerHTML = `
    <p class="crumb"><a href="#/">← All datasets</a></p>
    <div class="row" style="gap:12px">
      <h1 style="margin:0">${esc(dataset.title)}</h1>
      ${statusBadge(quality?.status)}
    </div>
    <p class="muted mono">${esc(dataset.id)} · version ${esc(shortVersion(dataset.version))}</p>
    <p id="intro" class="muted"></p>

    <section class="panel">
      <h2>Files</h2>
      <div class="table-wrap">
        <table>
          <thead><tr><th>Path</th><th>Format</th><th>Records</th><th></th></tr></thead>
          <tbody>${dataset.resources.map(resourceRow).join("")}</tbody>
        </table>
      </div>
      <div id="preview" class="preview"></div>
    </section>

    ${quality ? qualityPanel(quality) : ""}

    <section class="panel">
      <h2>Documentation and provenance</h2>
      <ul>
        ${docs.map((p) => `<li>${githubLink(p)}</li>`).join("")}
        ${(dataset.provenance?.references ?? []).filter((p) => !docs.includes(p)).map((p) => `<li>${githubLink(p)}</li>`).join("")}
      </ul>
      ${dataset.provenance?.note ? `<p class="muted">${esc(dataset.provenance.note)}</p>` : ""}
    </section>
  `;

  app.querySelectorAll("button[data-preview]").forEach((button) => {
    button.addEventListener("click", () => preview(button.dataset.preview, button.dataset.format));
  });

  if (docs[0]) {
    fetchCached(docs[0], "text")
      .then((text) => { document.getElementById("intro").textContent = readmeIntro(text); })
      .catch(() => {});
  }
}

function resourceRow(resource) {
  const count = resource.record_count == null
    ? `<span class="null" title="${esc(resource.count_note ?? "")}">unknown</span>`
    : `${fmt.format(resource.record_count)}${resource.record_unit && resource.record_unit !== "records" ? ` <span class="muted">${esc(resource.record_unit)}</span>` : ""}`;
  const actions = [
    PREVIEWABLE.has(resource.format)
      ? `<button type="button" data-preview="${esc(resource.path)}" data-format="${esc(resource.format)}">Preview</button>`
      : "",
    `<a href="${BASE}${esc(resource.path)}" download>Download</a>`,
  ].join(" ");
  return `<tr>
    <td class="mono">${githubLink(resource.path)}</td>
    <td><span class="chip">${esc(resource.format)}</span></td>
    <td class="num">${count}</td>
    <td class="row" style="flex-wrap:nowrap">${actions}</td>
  </tr>`;
}

function qualityPanel(quality) {
  const problems = [
    ...quality.errors.map((m) => `<li class="breaking">${esc(m)}</li>`),
    ...quality.warnings.map((m) => `<li>${esc(m)}</li>`),
  ];
  const checks = Object.entries(quality.checks)
    .map(([name, result]) => `<span class="chip">${esc(name)}: ${esc(result.replaceAll("_", " "))}</span>`)
    .join("");
  return `<section class="panel">
    <h2>Quality</h2>
    <div class="row">${checks}</div>
    ${problems.length ? `<ul style="margin-top:12px">${problems.join("")}</ul>` : `<p class="muted">No warnings.</p>`}
    <p class="muted" style="margin-bottom:0">From ${githubLink("reports/quality/summary.json")}.</p>
  </section>`;
}

// Picks the first prose paragraph of a README's lead, before its first section.
function readmeIntro(markdown) {
  const blocks = markdown.split(/\n\s*\n/).map((b) => b.trim());
  const sectionStart = blocks.findIndex((b) => b.startsWith("##"));
  const lead = sectionStart === -1 ? blocks : blocks.slice(0, sectionStart);
  const prose = lead.find((b) =>
    b && !/^(#|\[←|\||```|!\[|<|-|\*|\d+\.)/.test(b));
  if (!prose) return "";
  return prose
    .replace(/!\[[^\]]*\]\([^)]*\)/g, "")
    .replace(/\[([^\]]+)\]\([^)]*\)/g, "$1")
    .replace(/[*_`]/g, "")
    .replace(/\s+/g, " ");
}

// ---------- Record preview ----------

const isRecord = (v) => v !== null && typeof v === "object" && !Array.isArray(v);

// Flattens a map keyed by headword (or similar) into records, keeping the key.
// Values may be one record or a list of records per key.
function fromMap(object) {
  const entries = Object.entries(object);
  const ok = entries.length > 0 && entries.every(([, v]) =>
    isRecord(v) || (Array.isArray(v) && v.every(isRecord)));
  if (!ok) return null;
  return entries.flatMap(([key, v]) => (Array.isArray(v) ? v : [v]).map((item) => ({ key, ...item })));
}

function extractRecords(data, format) {
  if (format === "geojson" && Array.isArray(data?.features)) {
    return data.features.map((f) => f.properties ?? {});
  }
  if (Array.isArray(data)) return data;
  if (!isRecord(data)) return [{ value: data }];
  const values = Object.values(data);
  if (values.length > 1 && values.every((v) => Array.isArray(v) && v.every(isRecord))) {
    return fromMap(data);
  }
  for (const value of values) {
    if (Array.isArray(value) && value.some(isRecord)) return value;
  }
  for (const value of values) {
    const records = isRecord(value) && Object.keys(value).length > 1 ? fromMap(value) : null;
    if (records) return records;
  }
  return fromMap(data) ?? [data];
}

async function preview(path, format) {
  const box = document.getElementById("preview");
  box.innerHTML = `<p class="muted">Loading ${esc(path)}…</p>`;
  let records;
  try {
    records = extractRecords(await fetchCached(path, "json"), format);
  } catch (err) {
    box.innerHTML = `<p class="breaking">Could not load ${esc(path)}: ${esc(err.message)}</p>`;
    return;
  }

  const columns = [];
  for (const record of records.slice(0, 200)) {
    const keys = record && typeof record === "object" && !Array.isArray(record) ? Object.keys(record) : ["value"];
    for (const key of keys) if (!columns.includes(key)) columns.push(key);
  }
  const rows = records.map((r) => (r && typeof r === "object" && !Array.isArray(r) ? r : { value: r }));
  const haystack = rows.map((r) => JSON.stringify(r).toLowerCase());

  box.innerHTML = `
    <div class="preview-head">
      <strong class="mono">${esc(path)}</strong>
      <input type="search" id="pq" placeholder="Filter records" aria-label="Filter records" style="flex:0 1 280px">
    </div>
    <p class="muted" id="pinfo"></p>
    <div class="table-wrap preview-body">
      <table><thead><tr>${columns.map((c) => `<th>${esc(c)}</th>`).join("")}</tr></thead><tbody id="pbody"></tbody></table>
    </div>`;

  const input = document.getElementById("pq");
  const body = document.getElementById("pbody");
  const info = document.getElementById("pinfo");

  function update() {
    const term = input.value.trim().toLowerCase();
    const matches = [];
    for (let i = 0; i < rows.length; i++) {
      if (!term || haystack[i].includes(term)) matches.push(rows[i]);
    }
    body.innerHTML = matches.slice(0, PREVIEW_ROWS).map((row) =>
      `<tr>${columns.map((c) => `<td>${cell(row[c])}</td>`).join("")}</tr>`).join("");
    const total = term ? `${fmt.format(matches.length)} of ${fmt.format(rows.length)}` : fmt.format(rows.length);
    info.textContent = `${total} records${matches.length > PREVIEW_ROWS ? `, showing the first ${PREVIEW_ROWS}` : ""}.`;
  }
  input.addEventListener("input", update);
  update();
  box.scrollIntoView({ behavior: "smooth", block: "start" });
}

function cell(value) {
  if (value === undefined) return "";
  if (value === null) return `<span class="null">null</span>`;
  const text = typeof value === "object" ? JSON.stringify(value) : String(value);
  return `<div class="cell" title="${esc(text.slice(0, 2000))}">${esc(text)}</div>`;
}

// ---------- Changes ----------

async function renderChanges() {
  app.innerHTML = `<p class="crumb"><a href="#/">← All datasets</a></p>
    <h1>Dataset changes</h1>
    <p class="muted">Generated from Git history by <code>tools/changelog</code>. Full text in ${githubLink("CHANGELOG.md")}.</p>
    <div id="changes"><p class="muted">Loading…</p></div>`;
  const box = document.getElementById("changes");

  let ranges;
  try {
    const changelog = await fetchCached("CHANGELOG.md", "text");
    ranges = [...changelog.matchAll(/<!-- changelog:range ([0-9a-f]+)\.\.([0-9a-f]+) -->/g)]
      .map(([, from, to]) => `changes/${from.slice(0, 12)}..${to.slice(0, 12)}.json`);
  } catch (err) {
    box.innerHTML = `<p class="breaking">Could not load the changelog: ${esc(err.message)}</p>`;
    return;
  }

  const reports = await Promise.all(ranges.map((path) =>
    fetchCached(path, "json").then((report) => ({ path, report }), () => ({ path, report: null }))));
  box.innerHTML = reports.map(changeEntry).join("") || `<p class="muted">No entries yet.</p>`;
}

function changeEntry({ path, report }) {
  if (!report) return `<div class="change"><p class="muted">Missing report ${esc(path)}.</p></div>`;
  const { added, modified, deleted } = report.summary.changes;
  const date = report.to.date ?? "";
  const datasets = report.datasets.map((d) => {
    const c = d.changes;
    const link = state.catalog.datasets.some((x) => x.id === d.dataset)
      ? `<a href="#/d/${encodeURIComponent(d.dataset)}">${esc(d.title)}</a>`
      : esc(d.title);
    return `<li>${link} <span class="chip">${esc(d.status)}</span> <span class="muted">+${fmt.format(c.added)} ~${fmt.format(c.modified)} −${fmt.format(c.deleted)}</span></li>`;
  }).join("");
  return `<div class="change">
    <h3>${esc(date)} · <span class="mono">${esc(report.from.commit.slice(0, 12))}…${esc(report.to.commit.slice(0, 12))}</span></h3>
    <p class="muted" style="margin:0 0 6px">
      ${fmt.format(report.summary.datasets_changed)} dataset(s): ${fmt.format(added)} added, ${fmt.format(modified)} modified, ${fmt.format(deleted)} deleted record(s).
      ${report.summary.breaking ? `<span class="breaking">Breaking.</span>` : ""}
      <a href="${BASE}${esc(path)}">JSON</a>
    </p>
    <ul>${datasets}</ul>
  </div>`;
}

// ---------- Router ----------

async function route() {
  const hash = location.hash.replace(/^#/, "") || "/";
  window.scrollTo(0, 0);
  if (hash.startsWith("/d/")) {
    const id = decodeURIComponent(hash.slice(3));
    document.title = `${state.catalog.datasets.find((d) => d.id === id)?.title ?? id} · tm-data`;
    await renderDataset(id);
  } else if (hash === "/changes") {
    document.title = "Changes · tm-data";
    await renderChanges();
  } else {
    document.title = "tm-data";
    renderHome();
  }
}

async function start() {
  try {
    state.catalog = await fetchCached("catalog.json", "json");
  } catch (err) {
    app.innerHTML = `<p class="breaking">Could not load catalog.json: ${esc(err.message)}</p>`;
    return;
  }
  state.quality = await fetchCached("reports/quality/summary.json", "json").catch(() => null);
  window.addEventListener("hashchange", route);
  route();
}

start();
