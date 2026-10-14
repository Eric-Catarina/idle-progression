---
id: DESIGN-XXX
aliases:
  - DESIGN-XXX
title: "LevelX_Y"
type: system-design
subtype: level
status: Draft
moscow: Should
moscow_note: Descreva a prioridade deste nível.
parent: "[[DESIGN-003 Mundo 1|DESIGN-003]]"
path: "Campanha / Mundo W / LevelX_Y"
data_spec: "[[DATA-006 Level Layout|DATA-006]]"
dependencies:
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
---

# [DESIGN-XXX] LevelX_Y

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** ...
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Objetivo
- O que este nível ensina/entrega.

## 2. Layout
- **{{SIZE}}** (ver `03-Data/levels/LevelX_Y.json` / [[DATA-006 Level Layout|DATA-006]]).
- **Formato:** {{ORIENTATION}} (ver [[DESIGN-006 Meta Espacial|DESIGN-006]]).
- **Spawn** `{{SPAWN}}` · **Portal Entrada** `{{ENTRADA}}` · **Portal Saída** `{{SAIDA}}`.
- **Interactables:** {{INTERACTABLES}}.

## 3. População
- _(a definir)_ tipos/quantidade de monstros.

## 4. Gating & Desbloqueio
- **Entrada:** vir do nível anterior.
- **Saída:** completar libera o próximo.

## 5. Casos de Borda
- Morte total, monstros presos em plataforma, limites da tela.

## 6. Relacionados
- [[DESIGN-003 Mundo 1|DESIGN-003]] · [[DATA-006 Level Layout|DATA-006]].

## 7. Ver no Obsidian (Visual + JSON)

> Requer o plugin **Dataview** com **Enable JavaScript Queries** ligado (Configurações → Dataview).

```dataviewjs
const path = "03-Data/levels/LevelX_Y.json";
const raw = await app.vault.adapter.read(path);
const lvl = JSON.parse(raw);
const COLORS = { 0:"#0b0d10", 1:"#9e9e9e", 2:"#4dabf7", 3:"#5c636a", 4:"#51cf66", 5:"#f783ac", 6:"#ffd43b" };
const s = 14;
const cv = document.createElement("canvas");
cv.width = lvl.cols * s; cv.height = lvl.rows * s;
cv.style = "border:1px solid #2c313a;border-radius:8px";
const g = cv.getContext("2d");
for (let y = 0; y < lvl.rows; y++) for (let x = 0; x < lvl.cols; x++) { g.fillStyle = COLORS[lvl.grid[y][x]] || "#000"; g.fillRect(x*s, y*s, s, s); }
for (let x = 0; x <= lvl.cols; x++) { g.strokeStyle = x % 5 ? "rgba(255,255,255,.16)" : "rgba(255,255,255,.34)"; g.beginPath(); g.moveTo(x*s+.5, 0); g.lineTo(x*s+.5, cv.height); g.stroke(); }
for (let y = 0; y <= lvl.rows; y++) { g.strokeStyle = y % 5 ? "rgba(255,255,255,.16)" : "rgba(255,255,255,.34)"; g.beginPath(); g.moveTo(0, y*s+.5); g.lineTo(cv.width, y*s+.5); g.stroke(); }
(lvl.interactables || []).forEach((e, i) => { const cx = e.x*s + s/2, cy = e.y*s + s/2; g.beginPath(); g.arc(cx, cy, s*0.34, 0, 7); g.fillStyle = ["#38d9a9","#b197fc","#ffa94d"][i % 3]; g.fill(); g.strokeStyle = "#101010"; g.lineWidth = 2; g.stroke(); });
this.container.appendChild(cv);
const det = document.createElement("details");
det.innerHTML = "<summary style='cursor:pointer'>📋 JSON do nível (clique para expandir/copiar)</summary><pre style='max-height:320px;overflow:auto;background:#0f1115;padding:8px;border-radius:8px'>" + raw.replace(/&/g,"&amp;").replace(/</g,"&lt;") + "</pre>";
this.container.appendChild(det);
```
