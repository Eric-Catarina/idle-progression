#!/usr/bin/env node
/**
 * Ponte de integridade vault -> jogo (ver CONTEXT-012, secao 6).
 *
 * O vault e a FONTE DE VERDADE; o jogo CONSOME. Este script gera `game/data/`
 * (que e gitignored) a partir de:
 *   1. `03-Data/levels/*.json`      -> `game/data/levels/*.json`  (copia fiel)
 *   2. bloco ```json dos `03-Data/DATA-*.md` -> `game/data/tables/<id>.json`
 *
 * Ele tambem VALIDA: se um bloco JSON de um doc DATA nao fizer parse, o script
 * falha alto (integridade dos dados). Nada aqui e especifico de engine.
 *
 * Uso: node tools/export-data.mjs
 */
import { readFileSync, writeFileSync, mkdirSync, readdirSync, rmSync, existsSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const vaultData = join(root, "03-Data");
const outDir = join(root, "game", "data");

let copied = 0;
let tables = 0;
const errors = [];

// zera o destino (dado gerado — nunca editar a mao)
rmSync(outDir, { recursive: true, force: true });
mkdirSync(join(outDir, "levels"), { recursive: true });
mkdirSync(join(outDir, "tables"), { recursive: true });

// 1) Niveis: copia fiel + valida JSON
const levelsDir = join(vaultData, "levels");
if (existsSync(levelsDir)) {
  for (const name of readdirSync(levelsDir).filter((f) => f.endsWith(".json"))) {
    const raw = readFileSync(join(levelsDir, name), "utf8");
    try {
      JSON.parse(raw);
    } catch (e) {
      errors.push(`levels/${name}: JSON invalido -> ${e.message}`);
      continue;
    }
    writeFileSync(join(outDir, "levels", name), raw, "utf8");
    copied++;
  }
}

// 2) Tabelas: ultimo bloco ```json de cada DATA-*.md
for (const name of readdirSync(vaultData).filter((f) => /^DATA-\d+.*\.md$/.test(f))) {
  const raw = readFileSync(join(vaultData, name), "utf8");
  const idMatch = raw.match(/^id:\s*(DATA-\d+)/m);
  const id = (idMatch ? idMatch[1] : name.replace(/\.md$/, "")).toLowerCase();
  const blocks = [...raw.matchAll(/```json\s*\r?\n([\s\S]*?)```/g)];
  if (blocks.length === 0) continue;
  const last = blocks[blocks.length - 1][1].trim();
  try {
    const parsed = JSON.parse(last);
    writeFileSync(join(outDir, "tables", `${id}.json`), JSON.stringify(parsed, null, 2) + "\n", "utf8");
    tables++;
  } catch (e) {
    errors.push(`${name}: bloco JSON invalido -> ${e.message}`);
  }
}

console.log(`export-data: ${copied} nivel(is) + ${tables} tabela(s) -> game/data/`);
if (errors.length) {
  console.error("\nERROS DE INTEGRIDADE:");
  for (const e of errors) console.error(" - " + e);
  process.exit(1);
}
