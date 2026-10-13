---
id: CONTEXT-005
aliases:
  - CONTEXT-005
  - ROADMAP
title: Roadmap & Fases de Entrega
type: roadmap
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-12
dependencies:
  - "[[CONTEXT-001]]"
  - "[[DESIGN-000]]"
tags:
  - context
  - roadmap
  - governance
  - phases
---

# 🗺️ [CONTEXT-005] Roadmap & Fases de Entrega

## 1. Propósito

Ancorar o MoSCoW ([[CONTEXT-001]]) a **fases de entrega concretas**. Sem fases, "Must/Should" vira opinião. Cada fase tem um objetivo de validação claro.

## 2. Fases

| Fase | Objetivo | MoSCoW | Saída |
| :--- | :--- | :--- | :--- |
| **F0 — Fundação** | Documentação, convenções e ferramentas. | — | Vault estruturado + validador. |
| **F1 — MVP (Core Loop)** | Provar o loop: mover → lutar → acumular → prestar. | `Must` | Protótipo jogável de 1 personagem. |
| **F2 — Vertical Slice** | Profundidade de conteúdo e feedback. | `Should` | Uma zona completa polida. |
| **F3 — Profundidade/Escala** | Promover `Could` e escalar sistemas. | `Could` promovidos | Party, mais skills, mais zonas. |

## 3. Mapeamento

- **`Must`** → pertencem a **F1**. Sem eles, o core loop não valida.
- **`Should`** → pertencem a **F2**. Deixar pronto o *ponto de extensão*, implementar se couber.
- **`Could`** → pertencem a **F3** (ou além). Ficam no backlog até promoção.
- **`Wont`** → fora de todas as fases desta versão.

## 4. Critério de Saída de Fase

Uma fase só é considerada concluída quando **todos os itens `Must`/`Should` dela** estão `implemented` e o `npm run validate` passa. O board [[DESIGN-000]] é a fonte de verdade do progresso.

## 5. Relacionado

- [[CONTEXT-001]] — Priorização MoSCoW (dona das categorias).
- [[CONTEXT-003]] — Ciclo de vida das ideias.
- [[DESIGN-000]] — Board de prioridades.
