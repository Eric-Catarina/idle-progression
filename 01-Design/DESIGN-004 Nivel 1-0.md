---
id: DESIGN-004
aliases:
  - DESIGN-004
title: "Nível 1-0 (Hub)"
type: system-design
subtype: level
status: Draft
moscow: Should
moscow_note: Hub do Mundo 1 (NPCs/estações) + primeiro nível.
parent: "[[DESIGN-003 Mundo 1|DESIGN-003]]"
path: "Campanha / Mundo 1 / Nível 1-0"
data_spec: "[[DATA-006 Level Layout|DATA-006]]"
dependencies:
  - "[[CONTEXT-006 Hierarquia|CONTEXT-006]]"
  - "[[DESIGN-017 Interactables & Hub|DESIGN-017]]"
---

# [DESIGN-004] Nível 1-0 (Hub)

> Nó-semente de exemplo ([[CONTEXT-006 Hierarquia|CONTEXT-006]]).

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Primeiro nível da F2. Ver [[CONTEXT-005 Roadmap|CONTEXT-005]].
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Objetivo
- **Hub do Mundo 1:** ponto inicial, onde ficam os **NPCs/estações** dos sistemas ([[DESIGN-017 Interactables & Hub|DESIGN-017]]).
- Introduz o jogador ao loop de plataformas + combate.

## 2. Layout de Plataformas
- Layout 2D **55×21** (ver [[DATA-006 Level Layout|DATA-006]]): plataformas, portals e interactables.

## 3. População
- _(a definir)_ tipos/quantidade de monstros.

## 4. Gating & Desbloqueio
- **Entrada:** início da campanha.
- **Saída:** matar **X** monstros libera o Nível 1-2. `X` → [[DATA-XXX]].

## 5. Casos de Borda
- Morte total, monstros presos em plataforma, limites da tela.

## 6. UI/UX
- Indicador de progresso `X/N`.
