---
id: CONTEXT-002
aliases:
  - CONTEXT-002
title: Padrão de Notação de Multiplicadores na UI
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-12
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
tags:
  - context
  - convention
  - ui
  - math
---

# ✖️ [CONTEXT-002] Padrão de Notação de Multiplicadores na UI

## 1. Propósito

Padronizar a forma como bônus percentuais e multiplicadores são **exibidos ao jogador** na interface. O jogador deste gênero lê números exponenciais constantemente; exibir "x1.05" em vez de "+5%" reduz ambiguidade e deixa claro que o efeito é **multiplicativo** e não aditivo.

## 2. Regra

Todo multiplicador exibido na UI é renderizado no formato:

```text
x<input>.<2 casas decimais>
```

- O valor interno é armazenado como fator (ex: `1.05`), nunca como percentual.
- A conversão de percentual para fator é: `fator = 1 + (percentual / 100)`.
- Sempre exatamente **2 casas decimais**, mesmo quando o valor for inteiro (`x2.00`, não `x2`).

## 3. Tabela de Conversão

| Efeito Interno | Cálculo | Exibição na UI |
| :--- | :--- | :--- |
| Sem bônus | `1.0` | `x1.00` |
| +5% | `1 + 0.05` | `x1.05` |
| +25% | `1 + 0.25` | `x1.25` |
| +100% | `1 + 1.00` | `x2.00` |
| +250% | `1 + 2.50` | `x3.50` |
| -20% (penalidade) | `1 - 0.20` | `x0.80` |

## 4. Casos de Borda

- **Multiplicadores empilhados:** múltiplos bônus são multiplicados entre si no cálculo, mas cada um é exibido com seu próprio fator (a UI pode mostrar o produto final com o mesmo formato).
- **Valores muito grandes:** quando o fator ultrapassa `1e6`, usar a mesma notação com sufixos (ex: `x1.25M`) conforme a formatação numérica de `DATA`.
- **Penalidades:** nunca usar sinal negativo solto (`-20%`); usar `x0.80`.

## 5. Relacionado

- [[CONTEXT-000 Manifesto|CONTEXT-000]] — Manifesto mestre que define esta convenção.
