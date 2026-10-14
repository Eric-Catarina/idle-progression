---
id: DATA-008
aliases:
  - DATA-008
title: "Star Force: Custos, Chances e Bônus"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-030 Star Force|DESIGN-030]]"
dependencies:
  - "[[DESIGN-030 Star Force|DESIGN-030]]"
---

# [DATA-008] Star Force: Custos, Chances e Bônus

> Curvas do **Star Force** ([[DESIGN-030 Star Force|DESIGN-030]]). `L` = **nível do item**. Valores `Draft` — calibrar.

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `s` | estrela atual (`0..25`) |
| `L` | nível do item |
| `custoMult(s)` | multiplicador de custo (× `L`) |
| `statPerStar` | stat flat por estrela |
| `attPerStar` | ATT/MA por estrela (só `s ≥ 16`) |

- `custo(s) = custoMult(s) × L` (em **Ouro**).
- `statPerStar = max(1, floor(L / 20))`.
- `attPerStar = max(1, floor(L / 20))` (idêntico ao stat; escalar separado se preciso).

## 2. Tabela por Estrela
`P(Sucesso)` = chance de `s → s+1`. As demais colunas são **probabilidades absolutas por tentativa** (somam 100%).

| ★ | custoMult | Sucesso | Mantém | −1★ | Destrói | stat flat | ATT/★ |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 0 | 0.10 | 95% | 5% | — | — | +1 | — |
| 1 | 0.15 | 95% | 5% | — | — | +1 | — |
| 2 | 0.20 | 95% | 5% | — | — | +1 | — |
| 3 | 0.25 | 95% | 5% | — | — | +1 | — |
| 4 | 0.30 | 95% | 5% | — | — | +1 | — |
| 5 | 0.40 | 95% | 5% | — | — | +1 | — |
| 6 | 0.50 | 95% | 5% | — | — | +1 | — |
| 7 | 0.65 | 95% | 5% | — | — | +1 | — |
| 8 | 0.80 | 95% | 5% | — | — | +1 | — |
| 9 | 1.00 | 95% | 5% | — | — | +1 | — |
| 10 | 1.30 | 95% | 5% | — | — | +1 | — |
| 11 | 1.60 | 90% | 9% | — | **1%** | +1 | — |
| 12 | 2.00 | 90% | 9% | — | **1%** | +1 | — |
| 13 | 2.50 | 90% | 9% | — | **1%** | +1 | — |
| 14 | 3.00 | 90% | 9% | — | **1%** | +1 | — |
| **15** | 4.00 | **30%** | — | 65% | 5% | +1 | — |
| 16 | 5.00 | 95% | — | 2% | 3% | +1 | **+1** |
| 17 | 6.00 | 90% | — | 7% | 3% | +1 | +1 |
| 18 | 7.00 | 90% | — | 7% | 3% | +1 | +1 |
| 19 | 8.00 | 90% | — | 7% | 3% | +1 | +1 |
| 20 | 10.0 | 70% | — | 25% | 5% | +1 | +1 |
| **21** | 14.0 | 40% | — | 52% | 8% | +1 | **+2** (marco) |
| 22 | 22.0 | 30% | — | 60% | 10% | +1 | +1 |
| 23 | 35.0 | 20% | — | 65% | 15% | +1 | +1 |
| 24 | 60.0 | 15% | — | 65% | 20% | +1 | +1 |
| 25 | 100 | 10% | — | 65% | 25% | +1 | +1 |

**Níveis de proteção:** ★12 e ★15 (destruição desabilitada nessas tentativas, se "proteção" ativa).

## 3. Fórmulas de Bônus
- **Stat flat acumulado** (`s ≤ 15`): `flat(s) = statPerStar × s`.
- **ATT acumulado** (`s ≥ 16`): `att(s) = attPerStar × (s − 15)` — **escala com `L`**.
- **Marco 21★:** o incremento de ATT dobra nesse passo (`+2×attPerStar` em vez de `+1×`) — é o "salto".
- Exemplo (`L = 100` → `statPerStar = attPerStar = 5`):

| ★ | flat stat | ATT |
| :--- | :--- | :--- |
| 10 | +50 | +0 |
| 15 | +75 | +0 |
| 16 | +75 | +5 |
| 20 | +75 | +25 |
| **21** | +75 | **+35** |
| 25 | +75 | +55 |

## 4. Chance Time & Proteção
- **Chance Time:** após **2 falhas seguidas** numa tentativa, a **próxima** tem `P(Sucesso) = 100%` (consumido com sucesso). *(MapleStory-like; a definir se vale em ★21+.)*
- **Spares:** manter cópias do item para recuperar após **destruição**.
- **Eventos:** multiplicador temporário de sucesso (ex.: *Shining Star Force*).

## 5. Schema de Configuração (JSON)
```json
{
  "id": "starforce",
  "maxStar": 25,
  "costMult": [0.10, 0.15, 0.20, 0.25, 0.30, 0.40, 0.50, 0.65, 0.80, 1.00, 1.30, 1.60, 2.00, 2.50, 3.00, 4.00, 5.00, 6.00, 7.00, 8.00, 10.0, 14.0, 22.0, 35.0, 60.0],
  "success": [0.95, 0.95, 0.95, 0.95, 0.95, 0.95, 0.95, 0.95, 0.95, 0.95, 0.95, 0.90, 0.90, 0.90, 0.90, 0.30, 0.95, 0.90, 0.90, 0.90, 0.70, 0.40, 0.30, 0.20, 0.15, 0.10],
  "destroy": [0,0,0,0,0,0,0,0,0,0,0, 0.01,0.01,0.01,0.01, 0.05, 0.03,0.03,0.03,0.03, 0.05, 0.08, 0.10, 0.15, 0.20, 0.25],
  "statPerStarDivisor": 20,
  "attPerStarDivisor": 20,
  "milestoneStar": 21,
  "protectedStars": [12, 15],
  "chanceTimeFails": 2
}
```

## 6. Tabela de Simulação — custo acumulado até `s` (`L = 100`)
| Alvo | Custo acumulado (aprox.) |
| :--- | :--- |
| 10★ | ~600 Ouro |
| 15★ | ~2.4 K |
| 17★ | ~9 K |
| 20★ | ~25 K |
| 21★ | ~42 K |
| 22★ | ~100 K |

> Valores `Draft` — calibrar em simulação ([[CONTEXT-004 Notacao Numerica|CONTEXT-004]]).
