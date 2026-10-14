#!/usr/bin/env node
// Validador do vault Progression Idle.
// Uso: node tools/validate-vault.mjs
// Sai com codigo != 0 se houver erros. Warnings nao quebram o build.
import { readdirSync, readFileSync, statSync } from "node:fs";
import { join, relative, sep, basename, extname, dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(HERE, "..");

const IGNORED_DIRS = new Set([".git", ".obsidian", ".obsidian-mcp", "node_modules", ".githooks"]);
const TEMPLATES_DIR = join("00-Context", "_templates");
const IGNORED_FILES = new Set(["README.md", "AGENTS.md", "BRAINSTORM_STREAM.md"]);
const PILLARS = new Set(["00-Context", "01-Design", "02-Architecture", "03-Data"]);

// Exige frontmatter/id apenas para documentos dos 4 pilares e arquivos .md na raiz.
function requiresId(rel) {
  const parts = rel.split(sep);
  if (parts.length === 1) return true;
  return PILLARS.has(parts[0]);
}

const REQUIRED = {
  "context-manifest": ["id", "title", "type", "status"],
  "context-convention": ["id", "title", "type", "status"],
  "roadmap": ["id", "title", "type", "status"],
  "system-design": ["id", "title", "type", "status", "moscow"],
  "tech-spec": ["id", "title", "type", "status", "moscow", "implements"],
  "data-spec": ["id", "title", "type", "system"],
};
const MOSCOW = new Set(["Must", "Should", "Could", "Wont"]);
const CROSS_REFS = ["tech_spec", "data_spec", "implements", "system", "parent"];

const errors = [];
const warnings = [];
const err = (f, m) => errors.push(`${f}: ${m}`);
const warn = (f, m) => warnings.push(`${f}: ${m}`);

function walk(dir, out = []) {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    const st = statSync(full);
    if (st.isDirectory()) {
      if (IGNORED_DIRS.has(entry)) continue;
      walk(full, out);
    } else if (extname(entry) === ".md") {
      out.push(full);
    }
  }
  return out;
}

function parseFrontmatter(text) {
  if (!text.startsWith("---")) return null;
  const end = text.indexOf("\n---", 3);
  if (end === -1) return null;
  const block = text.slice(3, end).trim();
  const data = {};
  let list = null;
  for (const raw of block.split(/\r?\n/)) {
    const line = raw.replace(/\t/g, "  ");
    const item = line.match(/^\s*-\s+(.*)$/);
    if (item) {
      if (list) list.push(item[1].trim().replace(/^["']|["']$/g, ""));
      continue;
    }
    const kv = line.match(/^([A-Za-z0-9_]+):\s*(.*)$/);
    if (!kv) { list = null; continue; }
    const key = kv[1];
    const val = kv[2].trim();
    if (val === "") { data[key] = []; list = data[key]; continue; }
    if (val.startsWith("[") && val.endsWith("]")) {
      const inner = val.slice(1, -1).trim();
      data[key] = inner ? inner.split(",").map((s) => s.trim().replace(/^["']|["']$/g, "")) : [];
    } else {
      data[key] = val.replace(/^["']|["']$/g, "");
    }
    list = null;
  }
  return data;
}

// Remove blocos e trechos de codigo (fences e inline) para nao sinalizar
// wikilinks usados apenas como exemplo em documentacao.
function stripCode(text) {
  return text.replace(/```[\s\S]*?```/g, "").replace(/`[^`\n]*`/g, "");
}

function linkTarget(value) {
  const mm = String(value).match(/\[\[([^\]]+)\]\]/);
  const raw = mm ? mm[1] : String(value);
  return raw.replace(/\\/g, "").split("|")[0].split("#")[0].trim();
}

const files = walk(ROOT);
const targets = new Set();
const docs = [];

for (const f of files) {
  const rel = relative(ROOT, f);
  const text = readFileSync(f, "utf8");
  const name = basename(f, ".md");
  targets.add(name);
  const fm = parseFrontmatter(text);
  const al = fm ? (Array.isArray(fm.aliases) ? fm.aliases : fm.aliases ? [fm.aliases] : []) : [];
  al.forEach((a) => targets.add(String(a)));
  const inTemplates = rel.startsWith(TEMPLATES_DIR + sep);
  const inInbox = rel.startsWith("99-Inbox" + sep);
  if (inTemplates || inInbox || IGNORED_FILES.has(basename(f))) continue;
  if (!fm || !fm.id) {
    if (requiresId(rel)) err(rel, "documento sem frontmatter/id (placeholder orfao?)");
    continue;
  }
  docs.push({ rel, text, fm, name });
}

const nameToId = new Map();
for (const d of docs) {
  nameToId.set(d.fm.id, d.fm.id);
  nameToId.set(d.name, d.fm.id);
  const al = Array.isArray(d.fm.aliases) ? d.fm.aliases : d.fm.aliases ? [d.fm.aliases] : [];
  al.forEach((a) => nameToId.set(String(a), d.fm.id));
}

const ids = new Map();
const aliases = new Map();

for (const { rel, text, fm } of docs) {
  const required = REQUIRED[fm.type] ?? [];
  for (const field of required) {
    const v = fm[field];
    if (v === undefined || v === "" || (Array.isArray(v) && v.length === 0)) {
      err(rel, `campo obrigatorio ausente: "${field}" (type: ${fm.type})`);
    }
  }
  if (ids.has(fm.id)) err(rel, `ID duplicado "${fm.id}" (ja em ${ids.get(fm.id)})`);
  else ids.set(fm.id, rel);

  const al = Array.isArray(fm.aliases) ? fm.aliases : fm.aliases ? [fm.aliases] : [];
  for (const a of al) {
    if (aliases.has(a)) err(rel, `alias duplicado "${a}" (ja em ${aliases.get(a)})`);
    else aliases.set(a, rel);
  }

  if ((fm.type === "system-design" || fm.type === "tech-spec") && fm.moscow && !MOSCOW.has(fm.moscow)) {
    err(rel, `moscow invalido: "${fm.moscow}"`);
  }
  if (fm.moscow === "Could" && !rel.includes(`01-Design${sep}backlog${sep}`)) {
    err(rel, "moscow: Could deve ficar em 01-Design/backlog/");
  }

  const prose = stripCode(text);
  for (const m of prose.matchAll(/\[\[([^\]]+)\]\]/g)) {
    const target = m[1].replace(/\\/g, "").split("|")[0].split("#")[0].trim();
    if (!target || /xxx/i.test(target) || target.includes("...")) continue;
    if (!targets.has(target)) err(rel, `wikilink orfao: [[${target}]]`);
  }

  for (const field of CROSS_REFS) {
    const v = fm[field];
    if (!v) continue;
    const target = linkTarget(v);
    if (/xxx/i.test(target)) continue;
    if (!targets.has(target)) err(rel, `referencia cruzada "${field}" nao resolve: ${v}`);
  }
}

// Deteccao de ciclos na hierarquia (parent).
const parentOf = new Map();
for (const d of docs) {
  if (!d.fm.parent) continue;
  const t = linkTarget(d.fm.parent);
  if (/xxx/i.test(t)) continue;
  const pid = nameToId.get(t);
  if (pid) parentOf.set(d.fm.id, pid);
}
for (const [id] of parentOf) {
  const seen = new Set();
  let cur = id;
  while (cur) {
    if (seen.has(cur)) {
      err(ids.get(id) ?? id, `ciclo de parent detectado a partir de "${id}"`);
      break;
    }
    seen.add(cur);
    cur = parentOf.get(cur);
  }
}

console.log(`Vault: ${docs.length} documentos indexados, ${targets.size} alvos de link.`);
if (warnings.length) {
  console.log(`\n⚠  ${warnings.length} aviso(s):`);
  warnings.forEach((w) => console.log("  - " + w));
}
if (errors.length) {
  console.error(`\n✗ ${errors.length} erro(s):`);
  errors.forEach((e) => console.error("  - " + e));
  process.exit(1);
}
console.log("\n✓ Vault valido.");
