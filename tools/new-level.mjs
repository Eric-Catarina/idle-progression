#!/usr/bin/env node
// Cria a pagina Obsidian de um nivel a partir do JSON (+ template).
// Uso: node tools/new-level.mjs Level1_3
import { readdirSync, readFileSync, writeFileSync, existsSync, statSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");
const name = (process.argv[2] || "").replace(/\.json$/i, "");
if (!/^Level\d+_(\d+|Boss\d+)$/.test(name)) {
  console.error("Uso: node tools/new-level.mjs Level1_3  |  node tools/new-level.mjs Level1_Boss1");
  console.error("     padrao: LevelX_Y (fase normal) ou LevelX_BossN (fase de chefe)");
  process.exit(1);
}
const world = name.match(/^Level(\d+)_/)[1];
const jsonRel = `03-Data/levels/${name}.json`;
if (!existsSync(join(ROOT, jsonRel))) {
  console.error("JSON nao encontrado: " + jsonRel + " (exporte do editor primeiro)");
  process.exit(1);
}

function walk(dir, out = []) {
  for (const e of readdirSync(dir)) {
    const full = join(dir, e);
    const st = statSync(full);
    if (st.isDirectory()) { if (e !== "_archive" && e !== "_templates") walk(full, out); }
    else if (e.endsWith(".md")) out.push(full);
  }
  return out;
}
let max = 0;
for (const f of walk(join(ROOT, "01-Design"))) {
  const m = readFileSync(f, "utf8").match(/^id:\s*DESIGN-(\d+)/m);
  if (m) max = Math.max(max, Number(m[1]));
}
const id = "DESIGN-" + String(max + 1).padStart(3, "0");

const lvl = JSON.parse(readFileSync(join(ROOT, jsonRel), "utf8"));
const find = (v) => { for (let y = 0; y < lvl.grid.length; y++) for (let x = 0; x < lvl.grid[y].length; x++) if (lvl.grid[y][x] === v) return `(${x},${y})`; return "—"; };
const inter = (lvl.interactables || []).map((e) => `${e.slot} (${e.x},${e.y})`).join(" · ") || "—";
const scan = (v) => { const out = []; for (let y = 0; y < lvl.grid.length; y++) for (let x = 0; x < lvl.grid[y].length; x++) if (lvl.grid[y][x] === v) out.push(`(${x},${y})`); return out; };
const p2 = scan(2);
const pairs = [];
for (let i = 0; i < p2.length; i += 2) pairs.push(p2[i + 1] ? `${p2[i]} ↔ ${p2[i + 1]}` : `${p2[i]} (sem par)`);
const intrafase = pairs.join(" · ") || "—";
const ratio = lvl.rows / lvl.cols;
const orientation = ratio > 1.3 ? "vertical" : ratio < 0.77 ? "horizontal" : "neutro";

// Pai do mundo: resolve no vault procurando um DESIGN cujo title seja "Mundo <W>"
let parentId = world === "1" ? "DESIGN-003" : null;
for (const f of walk(join(ROOT, "01-Design"))) {
  const t = readFileSync(f, "utf8");
  if (new RegExp(`^title:\\s*"?Mundo ${world}"?\\s*$`, "m").test(t)) {
    const m = t.match(/^id:\s*(DESIGN-\d+)/m);
    if (m) { parentId = m[1]; break; }
  }
}
if (!parentId) {
  console.error(`Nao encontrei o doc do "Mundo ${world}" (title: "Mundo ${world}"). Crie o mundo antes do nivel.`);
  process.exit(1);
}

const tpl = readFileSync(join(ROOT, "00-Context/_templates/LEVEL_PAGE_TEMPLATE.md"), "utf8");
const page = tpl
  .replaceAll("LevelX_Y", name)
  .replaceAll("DESIGN-XXX", id)
  .replaceAll("Mundo W", "Mundo " + world)
  .replaceAll("DESIGN-003 Mundo 1|DESIGN-003", `${parentId} Mundo ${world}|${parentId}`)
  .replaceAll("{{SIZE}}", `${lvl.cols}×${lvl.rows}`)
  .replaceAll("{{ORIENTATION}}", orientation)
  .replaceAll("{{SPAWN}}", find(6))
  .replaceAll("{{ENTRADA}}", find(4))
  .replaceAll("{{SAIDA}}", find(5))
  .replaceAll("{{INTRAFASE}}", intrafase)
  .replaceAll("{{INTERACTABLES}}", inter);

const levelsDir = join(ROOT, "01-Design/Levels");
const already = existsSync(levelsDir) && readdirSync(levelsDir).some((f) => f.endsWith(`${name}.md`));
if (already) {
  console.error(`Ja existe uma pagina para ${name} em 01-Design/Levels/.`);
  process.exit(1);
}
const outRel = `01-Design/Levels/${id} ${name}.md`;
if (existsSync(join(ROOT, outRel))) {
  console.error("Ja existe: " + outRel);
  process.exit(1);
}
writeFileSync(join(ROOT, outRel), page);
console.log(`Criado: ${outRel}`);
console.log(`JSON:   ${jsonRel}`);
console.log(`\nLembre de preencher: Prioridade, Visao, Populacao e Gating.`);
