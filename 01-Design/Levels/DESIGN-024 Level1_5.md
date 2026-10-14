---
id: DESIGN-024
aliases:
  - DESIGN-024
title: "Level1_5"
type: system-design
subtype: level
status: Draft
moscow: Should
moscow_note: Fecha o Mundo 1; introduz o Portal Intrafase em mapa de 3 andares.
parent: "[[DESIGN-003 Mundo 1|DESIGN-003]]"
path: "Campanha / Mundo 1 / Level1_5"
data_spec: "[[DATA-006 Level Layout|DATA-006]]"
dependencies:
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
---

# [DESIGN-024] Level1_5

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** **Nível final do Mundo 1** — fecha a curva de combate e libera o Mundo 2. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].
- Ver [[CONTEXT-005 Roadmap|CONTEXT-005]].

## 1. Visão & Objetivo
- **Fechamento do Mundo 1:** o jogador atravessa um mapa de **3 andares** e termina no **Portal Saída**.
- **Ensina o Portal Intrafase** ([[DESIGN-023 Plataformas & Portais|DESIGN-023]]): um par `(1,3)` ↔ `(44,19)` permite subir/voltar rápido entre o topo-esquerda e o piso-direita.
- Prepara a transição para o **Mundo 2**.

## 2. Layout
- **50×21** (ver `03-Data/levels/Level1_5.json` / [[DATA-006 Level Layout|DATA-006]]).
- **Formato:** horizontal, 3 andares (ver [[DESIGN-006 Meta Espacial|DESIGN-006]]).
- **Spawn** `(2,19)` · **Portal Entrada** `(1,19)` · **Portal Saída** `(48,19)`.
- **Portal Intrafase:** `(1,3)` ↔ `(44,19)` (par em ordem de leitura).
- **Piso:** linha 20 inteira (sólida). Andar do meio: linha 9 inteira. Ledge superior-esquerda: linha 4 (com vão no centro).
- **Interactables:** —.

## 3. População
- _(a definir)_ herda o repertório de mobs do Mundo 1 ([[DESIGN-003 Mundo 1|DESIGN-003]] §4); densidade maior por ser nível final.

## 4. Gating & Desbloqueio
- **Entrada:** vir do **Portal Saída** do nível anterior (`Level1_4`).
- **Saída:** completar o `Level1_5` **libera o Mundo 2** ([[DESIGN-003 Mundo 1|DESIGN-003]] §3).

## 5. Casos de Borda
- **Nº ímpar de portais intrafase** → o último fica inativo (aqui são 2, ok).
- Portal Intrafase cair fora da grade / sobre o piso.
- **Morte total**, mobs presos em plataforma, limites laterais.

## 6. Relacionados
- [[DESIGN-003 Mundo 1|DESIGN-003]] · [[DATA-006 Level Layout|DATA-006]].

## 7. Ver no Obsidian (Visual + JSON)

> Requer o plugin **Dataview** com **Enable JavaScript Queries** ligado (Configurações → Dataview).

```dataviewjs
const path = "03-Data/levels/Level1_5.json";
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
const bar = document.createElement("div");
bar.style = "display:flex;gap:8px;align-items:center;margin:8px 0";
const btn = document.createElement("button");
btn.textContent = "📋 Copiar JSON";
btn.style = "cursor:pointer;padding:4px 10px;border-radius:6px;border:1px solid #2c313a;background:#1b1f27;color:inherit";
const fb = document.createElement("span");
fb.style = "font-size:0.85em;opacity:.85";
btn.onclick = async () => {
  try { await navigator.clipboard.writeText(raw); }
  catch (e) {
    const ta = document.createElement("textarea");
    ta.value = raw; ta.style = "position:fixed;opacity:0";
    document.body.appendChild(ta); ta.select();
    try { document.execCommand("copy"); } catch (e2) {}
    document.body.removeChild(ta);
  }
  fb.textContent = "Copiado! ✓";
  setTimeout(() => { fb.textContent = ""; }, 1500);
};
bar.appendChild(btn); bar.appendChild(fb);
this.container.appendChild(bar);
const det = document.createElement("details");
det.innerHTML = "<summary style='cursor:pointer'>📋 JSON do nível (clique para expandir)</summary><pre style='max-height:320px;overflow:auto;background:#0f1115;padding:8px;border-radius:8px'>" + raw.replace(/&/g,"&amp;").replace(/</g,"&lt;") + "</pre>";
this.container.appendChild(det);
```
