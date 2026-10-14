---
id: DESIGN-019
aliases:
  - DESIGN-019
title: "Nível 1-2"
type: system-design
subtype: level
status: Draft
moscow: Should
moscow_note: 2º nível de combate; introduz o 1º NPC (Selos) e o fluxo de primeiro encontro.
parent: "[[DESIGN-003 Mundo 1|DESIGN-003]]"
path: "Campanha / Mundo 1 / Nível 1-2"
data_spec: "[[DATA-006 Level Layout|DATA-006]]"
dependencies:
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
  - "[[DESIGN-017 Interactables & Hub|DESIGN-017]]"
---

# [DESIGN-019] Nível 1-2

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Introduz o **primeiro NPC** e o loop de **descoberta** dos sistemas ([[DESIGN-017 Interactables & Hub|DESIGN-017]]). Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Objetivo
2º nível de **combate** do Mundo 1. Apresenta o **primeiro NPC** — o altar dos **[[DESIGN-013 Selos|Selos]]** — e ensina o fluxo **aproximar → primeiro encontro → desbloquear no Hub + Menu Rápido**.

## 2. Layout
- 55×21 (ver `levels/level-1-2.json` / [[DATA-006 Level Layout|DATA-006]]).
- **Spawn** `(2,19)` · **Portal Entrada** `(1,19)` · **Portal Saída** `(53,19)`.

## 3. Interactables
- **`selos`** em `(27,14)` — **primeiro encontro**: ao alcançar, dispara o evento e **desbloqueia** os Selos no **Hub (1-0)** e no **Menu Rápido** ([[DESIGN-018 Menu de Acesso Rapido|DESIGN-018]]).

## 4. Gating & Desbloqueio
- **Entrada:** vir do Nível 1-1.
- **Saída:** completar libera o **Nível 1-3**.

## 5. Casos de Borda
- Interagir 2× (não re-dispara o primeiro encontro).
- Chegar ao NPC morrendo no caminho (re-tenta).

## 6. Relacionados
- [[DESIGN-003 Mundo 1|DESIGN-003]] · [[DESIGN-017 Interactables & Hub|DESIGN-017]] · [[DESIGN-013 Selos|DESIGN-013]] · [[DATA-006 Level Layout|DATA-006]].
