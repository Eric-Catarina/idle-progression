---
id: DATA-012
aliases:
  - DATA-012
title: "Essência: Custos dos Sinks"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-035 Essencia|DESIGN-035]]"
dependencies:
  - "[[DESIGN-035 Essencia|DESIGN-035]]"
  - "[[DATA-002 Selos Curvas|DATA-002]]"
  - "[[DATA-003 Osiris Curvas|DATA-003]]"
  - "[[DATA-005 Cartas Odds|DATA-005]]"
---

# [DATA-012] Essência: Custos dos Sinks

> Curvas de **custo em Essência** dos 4 sinks do Mundo 1 ([[DESIGN-035 Essencia|DESIGN-035]]). `Draft` — calibrar.

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `E` | Essência (recurso, BigNumber) |
| `L` | nível do selo |
| `tier` | tier atual da carta (1..6) |
| `mult` | multiplicador do Impulso do Osíris |
| `extras` | nº de expansões de contrato já feitas |
| `reneg` | nível de renegociação de contrato |

## 2. Custos por Sink

### 2.1 Selos — subir nível
`costStamp(L) = 50 × 1.15^L`
| Nível | Custo (E) |
| :--- | :--- |
| 1 | 57 |
| 10 | 202 |
| 25 | 1.6 K |
| 50 | 54.4 K |
| 100 | 59.4 M |

### 2.2 Cartas — forjar uma carta específica
`costForge(tier) = 500 × 3^(tier−1)` **essência** **+** `poeira(ver §6 do DATA-005)`
| Tier alvo | Essência | Poeira |
| :--- | :--- | :--- |
| 1 | 500 | 1 |
| 2 | 1.5 K | 4 |
| 3 | 4.5 K | 12 |
| 4 | 13.5 K | 40 |
| 5 | 40.5 K | 150 |
| 6 | 121.5 K | 600 |

### 2.3 Osíris — Impulso (acelerar produção)
`costBoost(mult) = 1 K × mult^2` → ativa `gen × mult` por `T = 30 min` (duração empilhável).
| Mult | Custo (E) |
| :--- | :--- |
| ×2 | 4 K |
| ×5 | 25 K |
| ×10 | 100 K |
| ×20 | 400 K |

### 2.4 Livro dos Contratos — Expandir / Renegociar
- **Expandir** (por contrato): `costExpand(extras) = 2 K × 2^extras` → **+5** no `tierCap` daquele mob.
- **Renegociar** (por mundo): `costReneg(reneg) = 5 K × 3^reneg` → **+0.1%** no `MK%` por ponto.

## 3. Schema de Configuração (JSON)
```json
{
  "id": "essence_sinks",
  "stamp":  { "base": 50, "growth": 1.15 },
  "forge":  { "base": 500, "growth": 3 },
  "boost":  { "base": 1000, "exp": 2, "durationMin": 30 },
  "expand": { "base": 2000, "growth": 2, "tierCapStep": 5 },
  "reneg":  { "base": 5000, "growth": 3, "mkPerPointStep": 0.001 }
}
```

## 4. Notas & Limites (óbvios)
- **Saldo insuficiente** → bloqueia a compra.
- Custo **exponencial** em todos os sinks (a Essência escala com o Multikill).
- Essência é **world-local**; **sem cap** (BigNumber).
- Custos enormes → **catch-up offline** analítico (sem tick a tick).

> Formatação segue [[CONTEXT-004 Notacao Numerica|CONTEXT-004]]. `Draft` — calibrar.
