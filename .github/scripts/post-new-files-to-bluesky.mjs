import { execFileSync } from "node:child_process";
import { readFileSync, statSync } from "node:fs";
import { extname } from "node:path";

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

function preview(file) {
  if (!textExtensions.has(extname(file).toLowerCase())) {
    return `Binary file · ${statSync(file).size.toLocaleString("en-US")} bytes`;
  }

  const content = readFileSync(file, "utf8")
    .replace(/^\uFEFF/, "")
    .replace(/\s+/g, " ")
    .trim();
  return content || "Empty text file";
}

for (const file of files) {
  const url = `${SERVER_URL}/${REPOSITORY}/commit/${AFTER_SHA}`;
  const prefix = `🆕 Yeni veri eklendi\n📄 ${truncate(file, 100)}\n\n`;
  const suffix = `\n\n🔗 ${url}`;
  const available = 300 - [...segmenter.segment(prefix + suffix)].length;
  const text = `${prefix}${truncate(preview(file), Math.max(0, available))}${suffix}`;

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
