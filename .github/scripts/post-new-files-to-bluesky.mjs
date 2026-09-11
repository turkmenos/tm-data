import { execFileSync } from "node:child_process";
import { readFileSync, statSync } from "node:fs";
import { basename, extname } from "node:path";

const {
  BLUESKY_HANDLE,
  BLUESKY_APP_PASSWORD,
  BEFORE_SHA,
  AFTER_SHA,
<<<<<<< HEAD
  EVENT_NAME,
=======
>>>>>>> origin/main
  REPOSITORY,
  SERVER_URL = "https://github.com",
} = process.env;

if (!BLUESKY_HANDLE || !BLUESKY_APP_PASSWORD) {
  throw new Error("BLUESKY_HANDLE and BLUESKY_APP_PASSWORD secrets are required.");
}

<<<<<<< HEAD
const isWeekly = EVENT_NAME === "schedule" || EVENT_NAME === "workflow_dispatch";
const dataExtensions = new Set([
  ".csv", ".db", ".json", ".jsonl", ".sqlite", ".sql", ".tsv", ".txt", ".xml", ".yaml", ".yml",
]);
let output;
if (isWeekly) {
  output = execFileSync("git", ["ls-files", "-z"], { encoding: "utf8" });
} else {
  const zeroSha = /^0+$/.test(BEFORE_SHA ?? "");
  const base = zeroSha ? `${AFTER_SHA}^` : BEFORE_SHA;
  output = execFileSync(
    "git",
    ["diff", "--name-only", "--diff-filter=A", "-z", base, AFTER_SHA],
    { encoding: "utf8" },
  );
}
=======
const zeroSha = /^0+$/.test(BEFORE_SHA ?? "");
const base = zeroSha ? `${AFTER_SHA}^` : BEFORE_SHA;
const output = execFileSync(
  "git",
  ["diff", "--name-only", "--diff-filter=A", "-z", base, AFTER_SHA],
  { encoding: "utf8" },
);
>>>>>>> origin/main

// Workflow implementation files are not dataset additions.
const files = output
  .split("\0")
  .filter(Boolean)
<<<<<<< HEAD
  .filter((file) => !file.startsWith(".github/"))
  .filter((file) => dataExtensions.has(extname(file).toLowerCase()));

if (!isWeekly && files.length === 0) {
=======
  .filter((file) => !file.startsWith(".github/"));

if (files.length === 0) {
>>>>>>> origin/main
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

<<<<<<< HEAD
function groupNewFiles(newFiles) {
  const groups = new Map();
  for (const file of newFiles) {
    const key = file.slice(0, file.length - extname(file).length);
    const group = groups.get(key) ?? [];
    group.push(file);
    groups.set(key, group);
  }
  return [...groups.values()];
}

function preferredFile(group) {
  const priority = [".json", ".txt", ".csv", ".sql", ".db"];
  const rank = (file) => {
    const index = priority.indexOf(extname(file).toLowerCase());
    return index === -1 ? priority.length : index;
  };
  return [...group].sort(
    (a, b) => rank(a) - rank(b),
  )[0];
}

function weeklyPost(allFiles) {
  let totalBytes = 0;
  let works = 0;
  let pages = 0;
  let poems = 0;
  let words = 0;

  for (const file of allFiles) {
    totalBytes += statSync(file).size;
    if (extname(file).toLowerCase() !== ".json") continue;
    try {
      const data = JSON.parse(readFileSync(file, "utf8").replace(/^\uFEFF/, ""));
      if (Array.isArray(data?.pages)) {
        works += 1;
        pages += data.pages.length;
      }
      if (Array.isArray(data?.poems)) {
        works += 1;
        poems += data.poems.length;
      }
      words += Number(data?.meta?.wordCount) || 0;
    } catch {
      // Only valid JSON datasets contribute to the detailed totals.
    }
  }

  const lines = [
    "📊 Hepdelik maglumat hasabaty",
    `📚 ${works.toLocaleString("en-US")} eser`,
    `📄 ${allFiles.length.toLocaleString("en-US")} maglumat faýly · ${formatBytes(totalBytes)}`,
  ];
  if (pages) lines.push(`📖 ${pages.toLocaleString("en-US")} sahypa`);
  if (poems) lines.push(`✍️ ${poems.toLocaleString("en-US")} goşgy`);
  if (words) lines.push(`🔤 ${words.toLocaleString("en-US")} söz`);
  lines.push("", `🔗 ${SERVER_URL}/${REPOSITORY}`);
  return lines.join("\n");
}

const posts = [];
if (isWeekly) {
  posts.push({ label: "weekly report", text: weeklyPost(files) });
} else {
  for (const group of groupNewFiles(files)) {
    const file = preferredFile(group);
    const details = fileDetails(file);
    const totalSize = formatBytes(group.reduce((total, item) => total + statSync(item).size, 0));
    const formats = group.length > 1 ? ` · ${group.length} görnüş · jemi ${totalSize}` : "";
    const prefix = `🆕 Täze maglumat goşuldy\n📚 Eser: ${truncate(details.title, 100)}\n📊 ${details.amount}${formats}\n\n`;
    const suffix = `\n\n🔗 ${SERVER_URL}/${REPOSITORY}`;
    const available = 300 - [...segmenter.segment(prefix + suffix)].length;
    posts.push({
      label: details.title,
      text: `${prefix}${truncate(details.preview, Math.max(0, available))}${suffix}`,
    });
  }
}

for (const post of posts) {
=======
for (const file of files) {
  const details = fileDetails(file);
  const prefix = `🆕 Täze maglumat goşuldy\n📚 Eser: ${truncate(details.title, 100)}\n📊 ${details.amount}\n\n`;
  const suffix = `\n\n🔗 ${SERVER_URL}/${REPOSITORY}`;
  const available = 300 - [...segmenter.segment(prefix + suffix)].length;
  const text = `${prefix}${truncate(details.preview, Math.max(0, available))}${suffix}`;

>>>>>>> origin/main
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
<<<<<<< HEAD
        text: post.text,
=======
        text,
>>>>>>> origin/main
        createdAt: new Date().toISOString(),
      },
    }),
  });

  if (!response.ok) {
<<<<<<< HEAD
    throw new Error(`Posting ${post.label} failed (${response.status}): ${await response.text()}`);
  }

  console.log(`Posted ${post.label}`);
=======
    throw new Error(`Posting ${file} failed (${response.status}): ${await response.text()}`);
  }

  console.log(`Posted ${file}`);
>>>>>>> origin/main
  await new Promise((resolve) => setTimeout(resolve, 1000));
}
