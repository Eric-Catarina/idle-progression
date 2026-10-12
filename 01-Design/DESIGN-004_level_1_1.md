---
id: DESIGN-004
aliases:
  - DESIGN-004
title: "Nível 1-1: Rascunho"
type: system-design
subtype: level
status: Draft
moscow: Should
moscow_note: Conteúdo da F2; primeiro nível que valida a estrutura de nível + desbloqueio.
parent: "[[DESIGN-003]]"
path: "Campanha / Mundo 1 / Nível 1-1"
dependencies:
  - "[[CONTEXT-006]]"
---

# [DESIGN-004] Nível 1-1: Rascunho

> Nó-semente de exemplo ([[CONTEXT-006]]).

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Primeiro nível da F2. Ver [[CONTEXT-005]].
- Ver [[CONTEXT-001]].

## 1. Visão & Objetivo
- Introduzir o jogador ao loop de plataformas + combate.

## 2. Layout de Plataformas
- Layout 2D único; nós do grafo e one-way platforms → [[DATA-XXX]].

## 3. População
- _(a definir)_ tipos/quantidade de monstros.

## 4. Gating & Desbloqueio
- **Entrada:** início da campanha.
- **Saída:** matar **X** monstros libera o Nível 1-2. `X` → [[DATA-XXX]].

## 5. Casos de Borda
- Morte total, monstros presos em plataforma, limites da tela.

## 6. UI/UX
- Indicador de progresso `X/N`.
