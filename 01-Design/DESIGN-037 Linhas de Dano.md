---
id: DESIGN-037
aliases:
  - DESIGN-037
title: "Linhas de Dano (Damage Lines)"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Camada de leitura/estratégia do dano; o core loop valida com 1 linha.
dependencies:
  - "[[DESIGN-031 Calculo de Dano|DESIGN-031]]"
  - "[[DESIGN-036 Skills & Fila de Skills|DESIGN-036]]"
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
data_spec: "[[DATA-009 Dano|DATA-009]]"
---

# [DESIGN-037] Linhas de Dano (Damage Lines)

> Inspiração: **MapleStory** — números de dano **empilhados em camadas**, um por *linha*.

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** é *juice* + uma **mecânica de build** (multi-hit vs alvo com teto por linha). O core loop valida com 1 linha. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Um acerto produz **N linhas de dano** — **N números separados**, empilhados na tela (estilo MapleStory). Além da leitura, a **quantidade de linhas é mecânica**: alguns inimigos têm **teto de dano POR LINHA**, então builds/skills com **mais linhas** são **mais eficientes** contra eles.

## 2. Definição Formal
- Cada **skill** declara `lines` (nº de linhas por cast).
- **Cada linha** aplica a **fórmula de dano** ([[DESIGN-031 Calculo de Dano|DESIGN-031]]) **separadamente** (variância/crítico por linha).
- **Dano total** = `Σ linhas`.
- **Teto por linha (`capLinha`)** do alvo: `linha_i = min(dano_i, capLinha)`.
  - **Consequência:** com teto, `total = lines × min(dano, capLinha)` → **mais linhas = mais dano total**.

## 3. Exemplo (por que é mecânica)
Alvo com `capLinha = 1.000`:

| Build | Dano/linha | Linhas | Conta | **Total** |
| :--- | --: | --: | :--- | --: |
| **A** (single-hit) | 10.000 | 1 | `min(10k, 1k) × 1` | **1.000** |
| **B** (multi-hit) | 900 | 10 | `900 × 10` | **9.000** |

→ Contra um alvo com teto por linha, a build **B** faz **9×** o dano da **A**.

## 4. Onde Entra
- **Skills** têm `lines` ([[DESIGN-036 Skills & Fila de Skills|DESIGN-036]] §2).
- **Classes / gear / potential** podem **aumentar linhas** (`+1 linha`) — **gancho** (ex.: arqueiro = arquétipo multi-hit).
- **Mobs** podem ter `capLinha` ([[DATA-014 Populacao Mundo 1|DATA-014]]).

## 5. UI/UX — Números em Camadas
- Cada linha = **um número empilhado** acima do alvo (offset crescente), com **stagger** (~40–60 ms) e *fade/rise*.
- **Crítico** destacado (cor/maior); opcionalmente o **total** no topo.
- **Limite de números simultâneos** na tela (performance) → agrupar/limitar.

## 6. Contrato Funcional (I/O)
- **Entrada:** `skill.lines`, `danoPorLinha`, `alvo.capLinha`.
- **Saída:** `N` eventos de dano + `N` números flutuantes.

## 7. Casos de Borda
- `lines` alto + teto → **muitos números** (perf): agrupar ou limitar por frame.
- `capLinha` **ausente/0** → **sem teto**.
- **Crítico por linha** (independente) vs **um** crítico por cast *(a definir)*.
- **Catch-up offline:** resolve por **DPS** agregado, sem spawnar números.

## 8. Relacionados
- Dano: [[DESIGN-031 Calculo de Dano|DESIGN-031]] / [[DATA-009 Dano|DATA-009]] · Skills: [[DESIGN-036 Skills & Fila de Skills|DESIGN-036]].
- População: [[DATA-014 Populacao Mundo 1|DATA-014]] · UI: [[CONTEXT-010 UI de Jogo|CONTEXT-010]].
