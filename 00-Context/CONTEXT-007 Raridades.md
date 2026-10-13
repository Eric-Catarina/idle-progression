---
id: CONTEXT-007
aliases:
  - CONTEXT-007
title: Raridades (Escala Compartilhada)
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-13
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
tags:
  - context
  - convention
  - rarity
---

# 💎 [CONTEXT-007] Raridades (Escala Compartilhada)

## 1. Propósito

Definir uma **escala única de raridade** reutilizável por **todos** os sistemas do jogo (cartas, itens, potencial de itens, monstros, mundos). **Nomes e cores são fixos**; **pesos/odds são por sistema** (cada um no seu `DATA`).

## 2. Os 6 Tiers

| # | Raridade | Cor | Sensação |
| :--- | :--- | :--- | :--- |
| 1 | **Comum** | Cinza | básico |
| 2 | **Raro** | Azul fraco | "achei algo bom" |
| 3 | **Épico** | Roxo | forte |
| 4 | **Lendário** | Laranja dourado | cobiçado |
| 5 | **Extraordinário** | Arco-íris | celebrado |
| 6 | **Divino** | Preto-branco brilhoso | máximo / único |

## 3. Uso Compartilhado

- **Mesma escala, sistemas diferentes:** Cartas ([[DESIGN-016 Cartas|DESIGN-016]]), Itens, **Potencial de Itens**, Monstros, Mundos.
- Cada sistema declara **seus próprios pesos** no respectivo `DATA`; **nomes e cores são idênticos** em todos.
- Raridade é **ortogonal ao tipo de conteúdo**: uma carta Divina e um item Divino compartilham a mesma identidade visual.
- Cada sistema pode dar um **significado mecânico** ao tier (ex: no sistema de cartas, tiers altos concedem keywords/efeitos únicos).

## 4. Apresentação (juice)
- Cor padrão por tier (§2); **glow/animação proporcionais** ao tier.
- Raridade alta na abertura → flash + som (dopamina imediata).

## 5. Relacionado
- [[CONTEXT-000 Manifesto|CONTEXT-000]] — Manifesto mestre.
- [[DESIGN-016 Cartas|DESIGN-016]] — Cartas (primeiro consumidor).
