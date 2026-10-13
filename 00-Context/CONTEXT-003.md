---
id: CONTEXT-003
aliases:
  - CONTEXT-003
title: Idea Lifecycle & Intake Pipeline
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-12
dependencies:
  - "[[CONTEXT-000]]"
  - "[[CONTEXT-001]]"
tags:
  - context
  - convention
  - process
  - lifecycle
  - inbox
---

# 🔄 [CONTEXT-003] Idea Lifecycle & Intake Pipeline

## 1. Propósito

Definir o **caminho controlado de uma ideia**: da captura bruta até virar spec priorizada e implementada. Sem isso, ideias ficam soltas ou entram direto em design sem triagem, quebrando o controle de escopo.

## 2. Estados (`status`)

| Status | Onde vive | Exigência mínima | Próximo estado |
| :--- | :--- | :--- | :--- |
| `raw` | `99-Inbox/BRAINSTORM_STREAM.md` | Uma frase de ideia (checkbox `- [ ]`). | `triaged` |
| `triaged` | Inbox ou `DESIGN` em Draft | Classificada em pilar + MoSCoW preliminar. | `specified` |
| `specified` | `01-Design/` | `DESIGN` com I/O, passo a passo e edge cases. | `prioritized` |
| `prioritized` | `01-Design/` + board | `moscow` + `moscow_note`; listada no [[DESIGN-000]]. | `implemented` / `Backlog` |
| `Backlog` | `01-Design/backlog/` | `moscow: Could` + `promote_when`. | `specified` (promoção) |
| `implemented` | `01-Design/` | `SYSTEM` `Done` + `DATA` `Balanced`. | — |
| `dropped` | Inbox `_archive/` | Motivo registrado. | — |

## 3. Fluxo

```text
        captura                 triagem                 especificação
  raw ───────────► triaged ───────────────► specified ───────────────┐
                                                                     │
                                          priorização (MoSCoW)       ▼
                                          prioritized ────────► implemented
                                               │
                                               └── Could ──► Backlog (backlog/) ──promote_when──► specified
```

## 4. Captura (99-Inbox)

- Toda ideia bruta entra como checkbox em `99-Inbox/BRAINSTORM_STREAM.md`.
- A consolidação é feita pelo **Modo C** do manifesto (`CONTEXT-000`).
- Itens processados viram `- [x] Título -> [[DESIGN-XXX]]`.

## 5. Critérios de Transição

1. **raw → triaged:** classificada num pilar (DESIGN/SYSTEM/DATA) e com MoSCoW preliminar.
2. **triaged → specified:** existe `DESIGN` (com `subtype` quando aplicável) com Contrato Funcional, Lógica Passo a Passo e Casos de Borda. `SYSTEM`/`DATA` são criados quando aplicável.
3. **specified → prioritized:** `moscow` e `moscow_note` preenchidos e o item aparece no board.
4. **prioritized → implemented:** `SYSTEM` em `Done` e `DATA` em `Balanced`.
5. **Could:** nunca implementa; vai para `01-Design/backlog/` com `promote_when`.

## 6. Definition of Ready / Done

- **DoR (pronto para especificar):** ideia triada, sem duplicata (buscada por nome/ID).
- **DoD (pronto para implementar):** `DESIGN` completo + `SYSTEM` aprovado + `DATA` com schema. Validação do vault passando (`npm run validate`).

## 7. Relacionado

- [[CONTEXT-000]] — Manifesto mestre (Modo C – Inbox Processor).
- [[CONTEXT-001]] — Priorização MoSCoW.
- [[DESIGN-000]] — Board de prioridades.
