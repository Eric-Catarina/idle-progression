---
id: DESIGN-020
aliases:
  - DESIGN-020
title: "Level1_1"
type: system-design
subtype: level
status: Draft
moscow: Should
moscow_note: 1º nível de combate do Mundo 1.
parent: "[[DESIGN-003 Mundo 1|DESIGN-003]]"
path: "Campanha / Mundo 1 / Level1_1"
data_spec: "[[DATA-006 Level Layout|DATA-006]]"
dependencies:
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
---

# [DESIGN-020] Level1_1

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Primeiro nível de **combate**; valida o loop de matar mobs. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Objetivo
1º nível de **combate** do Mundo 1. Ensina o loop de **derrotar mobs** para progredir. Vem logo após o Hub ([[DESIGN-004 Level1_0|DESIGN-004]]).

## 2. Layout
- 55×21 (ver `levels/Level1_1.json` / [[DATA-006 Level Layout|DATA-006]]).
- **Spawn** `(2,19)` · **Portal Entrada** `(1,19)` · **Portal Saída** `(53,19)`.

## 3. População
- _(a definir)_ tipos/quantidade de monstros.

## 4. Gating & Desbloqueio
- **Entrada:** vir do Hub (Level1_0).
- **Saída:** completar libera o **Level1_2**.

## 5. Casos de Borda
- Morte total, monstros presos em plataforma, limites da tela.

## 6. Relacionados
- [[DESIGN-003 Mundo 1|DESIGN-003]] · [[DESIGN-004 Level1_0|DESIGN-004]] · [[DATA-006 Level Layout|DATA-006]].

## 7. Ver no Obsidian (Visual + JSON)

> Requer o plugin **Dataview** com **Enable JavaScript Queries** ligado (Configurações → Dataview).

```dataviewjs
const path = "03-Data/levels/Level1_1.json";
const raw = await app.vault.adapter.read(path);
const lvl = JSON.parse(raw);
const COLORS = { 0:"#0b0d10", 1:"#9e9e9e", 2:"#fcc419", 3:"#5c636a", 4:"#51cf66", 5:"#f783ac", 6:"#ffd43b" };
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
