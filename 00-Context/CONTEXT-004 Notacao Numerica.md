---
id: CONTEXT-004
aliases:
  - CONTEXT-004
title: Number Formatting & Value Display
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-12
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
  - "[[CONTEXT-002 Multiplicadores|CONTEXT-002]]"
tags:
  - context
  - convention
  - numbers
  - formatting
  - balance
---

# 🔢 [CONTEXT-004] Number Formatting & Value Display

## 1. Propósito

Padronizar **como valores exponenciais são armazenados e exibidos**. O jogo escala por muitas ordens de grandeza; sem uma notação única, os `DATA` e a UI divergem. Regra: **armazenar cru (BigNumber), formatar só na borda de exibição**.

## 2. Armazenamento vs Exibição

- **Armazenamento:** sempre o número exato (BigNumber). Nunca guardar string formatada.
- **Exibição:** aplicar a escada de sufixos (abaixo) na UI e nas tabelas de simulação dos `DATA`.
- A formatação de multiplicadores é regida por [[CONTEXT-002 Multiplicadores|CONTEXT-002]] (`x1.05`).

## 3. Escada de Sufixos

| Faixa | Sufixo | Exemplo |
| :--- | :--- | :--- |
| < 1.000 | — | `982` |
| 1e3 | K | `12.50K` |
| 1e6 | M | `3.40M` |
| 1e9 | B | `1.05B` |
| 1e12 | T | `7.20T` |
| 1e15 | Qa | `9.99Qa` |
| 1e18 | Qi | `1.00Qi` |
| 1e21 | Sx | `2.31Sx` |
| 1e24 | Sp | `4.00Sp` |
| ≥ 1e27 | _aa, ab, ac…_ | `5.00aa` |

- Após `Sp`, usar pares de letras (`aa`, `ab`, …, `az`, `ba`…) para evitar colisão.
- **Precisão:** sempre **2 casas decimais** na parte significativa (`12.50K`).
- **Sem parte inteira:** nunca exibir `.00` isolado como `K` — arredondar para o nível correto.

## 4. Casos de Borda

- **Números muito grandes (`> 1e33`):** migrar para notação científica `1.23e45` (definir o corte no `DATA`).
- **Negativos / penalidades:** seguir [[CONTEXT-002 Multiplicadores|CONTEXT-002]] (`x0.80`).
- **Tempo:** formatar separadamente (`1d 4h 32m`), não usar a escada de sufixos.
- **Localização:** separador decimal sempre `.` (ponto), por consistência técnica.

## 5. Relacionado

- [[CONTEXT-002 Multiplicadores|CONTEXT-002]] — Notação de multiplicadores.
- [[CONTEXT-000 Manifesto|CONTEXT-000]] — Manifesto mestre.
