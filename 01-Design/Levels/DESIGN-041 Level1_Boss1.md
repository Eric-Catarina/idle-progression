---
id: DESIGN-041
aliases:
  - DESIGN-041
title: "Level1_Boss1 (Chefe Vorax)"
type: system-design
subtype: level
status: Draft
moscow: Should
moscow_note: Arena de chefe (finale do Mundo 1); conteúdo de topo, o core loop valida sem ela.
parent: "[[DESIGN-003 Mundo 1|DESIGN-003]]"
path: "Campanha / Mundo 1 / Level1_Boss1"
data_spec: "[[DATA-006 Level Layout|DATA-006]]"
dependencies:
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
  - "[[DESIGN-024 Level1_5|DESIGN-024]]"
  - "[[DATA-014 Populacao Mundo 1|DATA-014]]"
---

# [DESIGN-041] Level1_Boss1 (Chefe Vorax)

> **Fase de chefe separada.** As fases de chefe são **níveis próprios** (`Level<W>_Boss<N>`) — chefes **secundários** virão depois (`Level1_Boss2`, …).
> **Referência de layout:** a arena do **Zakum** (*MapleStory*) — chefe **parado no centro**, arena **simétrica**, com **6 plataformas (3 de cada lado)**.

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** é o **finale do Mundo 1** (o confronto com o chefe). Agrega muito valor, mas o core loop valida sem ela. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Objetivo
- **O que entrega:** um **confronto de chefe** — o exame do que o jogador construiu (build, gear, dano de chefe) nos 5 níveis do Mundo 1.
- **A ideia central (Zakum):** o chefe **não se move** e fica **no centro**; a arena é **simétrica**. O jogador escolhe onde lutar:
  - **chão** → corpo a corpo e mobilidade;
  - **plataformas (degraus)** → posicionamento, alcance e descanso de knockback.
- **Por que simétrica:** o Zakum é legível — o jogador **aprende a arena em 3 segundos** e a luta inteira é sobre **execução** (dano, posicionamento, sobrevivência), não sobre explorar o mapa.

## 2. Layout
- **35×15** — **compacta de propósito** (vs. 55×21 dos níveis normais). Ver `03-Data/levels/Level1_Boss1.json` / [[DATA-006 Level Layout|DATA-006]].
- **Formato:** horizontal (ver [[DESIGN-006 Meta Espacial|DESIGN-006]]).
- **Spawn** `(2,13)` · **Portal Entrada** `(1,13)` · **Portal Saída** `(33,13)`.
- **Portal Intrafase:** — · **Interactables:** —.

### 2.1 A arena
| Elemento | Células | Papel |
| :--- | :--- | :--- |
| **Piso principal** | `r14` · cols `0–34` | chão da luta (sólido, largura total) |
| **Degrau 1** (base) | `r11` · `2–10` e `24–32` | sobe direto do chão |
| **Degrau 2** | `r8` · `3–11` e `23–31` | **+1 tile** rumo ao centro |
| **Degrau 3** (alto) | `r5` · `4–12` e `22–30` | **+1 tile** rumo ao centro |
| **Corredor do chefe** | cols `15–19` | **livre** (nenhuma plataforma) — área do chefe |
| **Spawn do Chefe** | `(17,13)` | **tile `7`** — centro exato |

- **Empilhadas, não espalhadas:** cada plataforma fica **1 tile à frente** da de baixo e **3 linhas acima** — um **degrau vertical** enxuto, não uma escada larga.
- **Simetria:** plataformas e piso **espelhados** sobre a coluna **17**.
- **Subir é andar:** a sobreposição entre degraus é de **8 células** (`2–10` ▸ `3–11` ▸ `4–12`) → sem salto de precisão.
- **Borda do chefe:** o topo termina em `col 12` (esq.) e recomeça em `col 22` (dir.) → **9 células livres** para o chefe, que é **largo**.

## 3. População
- **Só o chefe:** **Vorax** (o chefe do Mundo 1) — **parado** no centro, **não cai** e **não patrulha**.
  - Stats em [[DATA-014 Populacao Mundo 1|DATA-014]] (HP/ATK/Essência); é o alvo **Boss** → `Boss Damage%` pega ([[DESIGN-031 Calculo de Dano|DESIGN-031]]).
- **Sem mobs comuns** — a arena é limpa de propósito: o confronto é 1v1.

## 4. Gating & Desbloqueio
- **Entrada:** vir da **copa** ([[DESIGN-024 Level1_5|DESIGN-024]]) — a fase do chefe é o **passo seguinte** ao nível 1-5.
- **Saída:** o **Portal Saída** só abre ao **derrotar o chefe** (é a "cota" desta fase: `1` chefe).
  - **Destino:** o **hub do Mundo 2** — [[DESIGN-043 Level2_1|Level2_1]] ([[DESIGN-042 Mundo 2|DESIGN-042]]).
## 5. Casos de Borda
- **O chefe nunca se move nem cai** — a posição é o tile `7`, e a tag do chefe ([[CONTEXT-015 Tags de Skill|CONTEXT-015]]) não tem movimento.
- **Jogador preso no degrau:** toda plataforma tem **rota de descida** pelo **down-jump** ([[DESIGN-023 Plataformas & Portais|DESIGN-023]] §2) — a arena tem o chão embaixo de tudo.
- **Knockback:** no chão o player pode ser empurrado; nos degraus, não (posicionamento recompensado).
- **Morte do jogador:** *(a definir)* — revive na entrada ou reinicia a fase; **não** perde o progresso do Mundo 1.
- **Chefe morto e portal aberto** → o nível fica "limpo"; reentrar não deve re-spawnar o chefe enquanto a fase não resetar.

## 6. ✅ Reconciliação (o chefe saiu do `Level1_5`)
A fase separada **moveu o chefe** para cá. Estes docs foram atualizados **no mesmo passo**:
| Documento | O que ficou |
| :--- | :--- |
| [[DESIGN-003 Mundo 1\|DESIGN-003]] | a jornada termina aqui; `Level1_5` = copa (**véspera**); a Relíquia vem do chefe |
| [[DESIGN-024 Level1_5\|DESIGN-024]] | a copa — **sem** o chefe; o Portal Saída leva **para cá** |
| [[DESIGN-034 Livro dos Contratos\|DESIGN-034]] | gatilho = **derrotar Vorax** (aqui) |
| [[DESIGN-032 Gear Sets\|DESIGN-032]] | "Relíquia de Vorax — Chefe do Mundo 1" (já estava por papel, não por nível) |
| [[DATA-014 Populacao Mundo 1\|DATA-014]] | "Chefe — Vorax (**Level1_Boss1**)" |
| [[DATA-006 Level Layout\|DATA-006]] | tabela de níveis com `Level1_Boss1` + tile `7` = Spawn Chefe |

## 7. Relacionados
- Mundo/nível anterior: [[DESIGN-003 Mundo 1|DESIGN-003]] · [[DESIGN-024 Level1_5|DESIGN-024]].
- Layout/tiles: [[DATA-006 Level Layout|DATA-006]] · População: [[DATA-014 Populacao Mundo 1|DATA-014]].
- Plataformas/down-jump: [[DESIGN-023 Plataformas & Portais|DESIGN-023]] · Dano de chefe: [[DESIGN-031 Calculo de Dano|DESIGN-031]].

## 8. Ver no Obsidian (Visual + JSON)

> Requer o plugin **Dataview** com **Enable JavaScript Queries** ligado (Configurações → Dataview).

```dataviewjs
const path = "03-Data/levels/Level1_Boss1.json";
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
