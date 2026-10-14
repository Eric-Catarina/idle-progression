#!/usr/bin/env node
// Cria a pagina Obsidian de um nivel a partir do JSON (+ template).
// Uso: node tools/new-level.mjs Level1_3
import { readdirSync, readFileSync, writeFileSync, existsSync, statSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = join(dirname(fileURLToPath(import.meta.url)), "..");
const name = (process.argv[2] || "").replace(/\.json$/i, "");
if (!/^Level\d+_\d+$/.test(name)) {
  console.error("Uso: node tools/new-level.mjs Level1_3   (padrao LevelX_Y)");
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

const tpl = readFileSync(join(ROOT, "00-Context/_templates/LEVEL_PAGE_TEMPLATE.md"), "utf8");
const page = tpl
  .replaceAll("LevelX_Y", name)
  .replaceAll("DESIGN-XXX", id)
  .replaceAll("Mundo W", "Mundo " + world);

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
