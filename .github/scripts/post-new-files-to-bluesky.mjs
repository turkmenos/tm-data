import { execFileSync } from "node:child_process";
import { readFileSync, statSync } from "node:fs";
import { basename, extname } from "node:path";

const {
  BLUESKY_HANDLE,
  BLUESKY_APP_PASSWORD,
  BEFORE_SHA,
  AFTER_SHA,
  REPOSITORY,
  SERVER_URL = "https://github.com",
} = process.env;

if (!BLUESKY_HANDLE || !BLUESKY_APP_PASSWORD) {
  throw new Error("BLUESKY_HANDLE and BLUESKY_APP_PASSWORD secrets are required.");
}

const zeroSha = /^0+$/.test(BEFORE_SHA ?? "");
const base = zeroSha ? `${AFTER_SHA}^` : BEFORE_SHA;
const output = execFileSync(
  "git",
  ["diff", "--name-only", "--diff-filter=A", "-z", base, AFTER_SHA],
  { encoding: "utf8" },
);

// Workflow implementation files are not dataset additions.
const files = output
  .split("\0")
  .filter(Boolean)
  .filter((file) => !file.startsWith(".github/"));

if (files.length === 0) {
  console.log("No new data files to post.");
  process.exit(0);
}

const service = "https://bsky.social";
const sessionResponse = await fetch(`${service}/xrpc/com.atproto.server.createSession`, {
  method: "POST",
  headers: { "content-type": "application/json" },
  body: JSON.stringify({
    identifier: BLUESKY_HANDLE,
    password: BLUESKY_APP_PASSWORD,
  }),
});

if (!sessionResponse.ok) {
  throw new Error(`Bluesky login failed (${sessionResponse.status}): ${await sessionResponse.text()}`);
}

const session = await sessionResponse.json();
const textExtensions = new Set([
  ".csv", ".json", ".jsonl", ".md", ".sql", ".txt", ".tsv", ".xml", ".yaml", ".yml",
]);
const segmenter = new Intl.Segmenter("tk", { granularity: "grapheme" });

function truncate(value, maxLength) {
  const graphemes = [...segmenter.segment(value)].map(({ segment }) => segment);
  return graphemes.length <= maxLength
    ? value
    : `${graphemes.slice(0, Math.max(0, maxLength - 1)).join("")}…`;
}

function formatBytes(bytes) {
  if (bytes < 1024) return `${bytes} baýt`;
  if (bytes < 1024 ** 2) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / 1024 ** 2).toFixed(1)} MB`;
}

function readableFileName(file) {
  return basename(file, extname(file))
    .replace(/_+-+_/g, " — ")
    .replace(/[_-]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function workTitle(data, file) {
  const title = data?.title
    ?? data?.work_title
    ?? data?.book_title
    ?? data?.name
    ?? data?.meta?.title;
  if (typeof title === "string" && title.trim()) return title.trim();

  if (typeof data?.source_file === "string" && data.source_file.trim()) {
    return readableFileName(data.source_file.trim());
  }

  if (typeof data?.poet === "string" && data.poet.trim()) {
    return `${data.poet.trim()} goşgulary`;
  }

  return readableFileName(file);
}

function fileDetails(file) {
  const size = formatBytes(statSync(file).size);
  if (!textExtensions.has(extname(file).toLowerCase())) {
    return { title: readableFileName(file), amount: size, preview: "Ikilik maglumat faýly" };
  }

  const rawContent = readFileSync(file, "utf8").replace(/^\uFEFF/, "");
  const content = rawContent
    .replace(/\s+/g, " ")
    .trim();

  if (extname(file).toLowerCase() === ".json") {
    try {
      const data = JSON.parse(rawContent);
      if (Array.isArray(data)) {
        return {
          title: readableFileName(file),
          amount: `${data.length.toLocaleString("en-US")} ýazgy · ${size}`,
          preview: content,
        };
      }
      if (Array.isArray(data.pages)) {
        const characters = data.pages.reduce(
          (total, page) => total + (Number(page.character_count) || String(page.text ?? "").length),
          0,
        );
        return {
          title: workTitle(data, file),
          amount: `${data.pages.length.toLocaleString("en-US")} sahypa · ${characters.toLocaleString("en-US")} nyşan · ${size}`,
          preview: data.pages.map((page) => page.text).find(Boolean) ?? content,
        };
      }
      if (Array.isArray(data.poems)) {
        return {
          title: workTitle(data, file),
          amount: `${data.poems.length.toLocaleString("en-US")} goşgy · ${size}`,
          preview: content,
        };
      }
      const wordCount = Number(data?.meta?.wordCount)
        || (data?.words && typeof data.words === "object" ? Object.keys(data.words).length : 0);
      if (wordCount) {
        return {
          title: workTitle(data, file),
          amount: `${wordCount.toLocaleString("en-US")} söz · ${size}`,
          preview: content,
        };
      }
      return { title: workTitle(data, file), amount: size, preview: content };
    } catch {
      // Invalid JSON is still described as a regular text file.
    }
  }

  const lines = rawContent.split(/\r?\n/).filter((line) => line.trim()).length;
  return {
    title: readableFileName(file),
    amount: `${lines.toLocaleString("en-US")} setir · ${size}`,
    preview: content || "Boş tekst faýly",
  };
}

for (const file of files) {
  const details = fileDetails(file);
  const prefix = `🆕 Täze maglumat goşuldy\n📚 Eser: ${truncate(details.title, 100)}\n📊 ${details.amount}\n\n`;
  const suffix = `\n\n🔗 ${SERVER_URL}/${REPOSITORY}`;
  const available = 300 - [...segmenter.segment(prefix + suffix)].length;
  const text = `${prefix}${truncate(details.preview, Math.max(0, available))}${suffix}`;

  const response = await fetch(`${service}/xrpc/com.atproto.repo.createRecord`, {
    method: "POST",
    headers: {
      authorization: `Bearer ${session.accessJwt}`,
      "content-type": "application/json",
    },
    body: JSON.stringify({
      repo: session.did,
      collection: "app.bsky.feed.post",
      record: {
        $type: "app.bsky.feed.post",
        text,
        createdAt: new Date().toISOString(),
      },
    }),
  });

  if (!response.ok) {
    throw new Error(`Posting ${file} failed (${response.status}): ${await response.text()}`);
  }

  console.log(`Posted ${file}`);
  await new Promise((resolve) => setTimeout(resolve, 1000));
}
