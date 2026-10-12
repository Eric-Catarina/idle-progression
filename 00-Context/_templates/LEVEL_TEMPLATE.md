---
id: DESIGN-XXX
aliases:
  - DESIGN-XXX
title: "Nível X-Y: Nome"
type: system-design
subtype: level
status: Draft | Spec Ready | Implemented
moscow: Must | Should | Could | Wont
moscow_note: Herda do Mundo salvo override.
parent: "[[DESIGN-mundo]]"
path: "Campanha / Mundo X / Nível X-Y"
dependencies: []
---

# [DESIGN-XXX] Nível X-Y: Nome

## 0. Prioridade MoSCoW
- **Categoria:** Must | Should | Could | Wont
- **Justificativa:**
- Ver [[CONTEXT-001]].

## 1. Visão & Objetivo
- Fantasia do nível e que progressão ele entrega.

## 2. Layout de Plataformas
- Nós do grafo (coordenadas), uso de **one-way platforms**, dimensões.
- Dados de layout → [[DATA-XXX]].

## 3. População
- Inimigos (tipo, spawn, patrulha), densidade, respawn.

## 4. Gating & Desbloqueio
- **Entrada:** condição para acessar (ex: completar o nível anterior).
- **Saída (regra padrão):** matar **X** monstros deste nível libera o próximo.
- **X** → parâmetro em [[DATA-XXX]].

## 5. Curva de Dificuldade
- HP/DPS esperado; referência de fórmula → [[DATA-XXX]].

## 6. Recompensas
- Loot, XP, desbloqueios.

## 7. Casos de Borda
- Jogador sem pré-requisito, morte total, limites da tela, transição de cena.

## 8. UI/UX
- Nome do nível, indicador de progresso (X/N monstros), transições.
