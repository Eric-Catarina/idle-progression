---
id: DESIGN-043
aliases:
  - DESIGN-043
title: "Level2_1"
type: system-design
subtype: level
status: Draft
moscow: Should
moscow_note: Descreva a prioridade deste nível.
parent: "[[DESIGN-042 Mundo 2|DESIGN-042]]"
path: "Campanha / Mundo 2 / Level2_1"
data_spec: "[[DATA-006 Level Layout|DATA-006]]"
dependencies:
  - "[[DESIGN-042 Mundo 2|DESIGN-042]]"
---

# [DESIGN-043] Level2_1

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** é o **primeiro lugar do Mundo 2** (a chegada depois do chefe). Estrutura simples, mas é o nó que **dá destino** ao finale do Mundo 1. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Objetivo
- **Hub do Mundo 2:** zona **segura** (sem mobs) onde o jogador **chega, respira e se orienta** antes do primeiro combate do mundo.
- **O que entrega:** o ponto de encontro das **estações/sistemas** do Mundo 2 e o **Portal Saída** para a primeira fase de combate.
- **Tom:** contraste com o finale do Mundo 1 — o Mundo 1 termina em **confronto**; o Mundo 2 abre em **calmaria**. O `TBD` do tema fica para o [[DESIGN-042 Mundo 2|DESIGN-042]].

## 2. Layout
- **55×21** (ver `03-Data/levels/Level2_1.json` / [[DATA-006 Level Layout|DATA-006]]).
- **Formato:** horizontal (ver [[DESIGN-006 Meta Espacial|DESIGN-006]]).
- **Spawn** `(2,19)` · **Portal Entrada** `(1,19)` · **Portal Saída** `(53,19)`.
- **Portal Intrafase:** —.
- **Interactables:** `contratos` `(27,19)`.

### 2.1 O hub
| Elemento | Células | Papel |
| :--- | :--- | :--- |
| **Piso** | `r20` · `0–54` | chão único (hub é plano e legível) |
| **Balcões laterais** | `r14` · `4–15` e `39–50` | onde as **estações** ficam |
| **Mezaninos** | `r9` · `12–20` e `34–42` | verticalidade leve (não bloqueia a passagem) |
| **Estação do Livro** | `(27,19)` | **Livro do Mundo 2** ([[DESIGN-034 Livro dos Contratos\|DESIGN-034]] §2) |

- **Simetria** sobre a coluna **27** — o hub da **base da Árvore** ([[DESIGN-004 Level1_0|Level1_0]]) também é simétrico; a linguagem se repete.
- **Passagem livre:** o centro do piso é **desimpedido** — o jogador cruza o hub inteiro **andando**, sem pular nada.

## 3. População
- **Nenhuma** — hub é **zona segura** (igual ao [[DESIGN-004 Level1_0|Hub do Mundo 1]]).

## 4. Gating & Desbloqueio
- **Entrada:** o **Portal Saída** da fase de chefe do Mundo 1 ([[DESIGN-041 Level1_Boss1|DESIGN-041]]) → o player nasce no Portal Entrada `(1,19)`.
- **Saída:** o **Portal Saída** `(53,19)` leva ao **primeiro combate do Mundo 2** (`Level2_2`, `TBD`).
  - *Até `Level2_2` existir:* a saída volta ao hub do Mundo 1 ([[DESIGN-004 Level1_0|DESIGN-004]]).

## 5. Casos de Borda
- **Recém-chegado do chefe** (HP baixo, sem cura): o hub é seguro de propósito — é onde o jogador **se recupera** sem morrer.
- **Portal Entrada no canto:** evita spawnar em cima da estação.
- Nenhum mob preso/plataforma: sem população, o único risco é travar em geometria — o piso é contínuo.

## 6. Relacionados
- Mundo: [[DESIGN-042 Mundo 2|DESIGN-042]] · Mundo anterior: [[DESIGN-003 Mundo 1|DESIGN-003]] · Chefe que libera: [[DESIGN-041 Level1_Boss1|DESIGN-041]].
- Layout/tiles: [[DATA-006 Level Layout|DATA-006]] · Livro dos Contratos: [[DESIGN-034 Livro dos Contratos|DESIGN-034]].

## 7. Ver no Obsidian (Visual + JSON)

> Requer o plugin **Dataview** com **Enable JavaScript Queries** ligado (Configurações → Dataview).

```dataviewjs
const path = "03-Data/levels/Level2_1.json";
const raw = await app.vault.adapter.read(path);
const lvl = JSON.parse(raw);
const COLORS = { 0:"#0b0d10", 1:"#9e9e9e", 2:"#fcc419", 3:"#5c636a", 4:"#51cf66", 5:"#f783ac", 6:"#ffd43b", 7:"#ff6b6b" };
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
