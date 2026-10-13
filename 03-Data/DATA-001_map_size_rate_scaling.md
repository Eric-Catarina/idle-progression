---
id: DATA-001
aliases:
  - DATA-001
title: "Map Shape → Mob/Drop Rate Scaling"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-006]]"
dependencies:
  - "[[DESIGN-006]]"
---

# [DATA-001] Map Shape → Mob/Drop Rate Scaling

> Regula o **mobrate/droprate** conforme a forma do mapa (evita que mapas apertados/quadrados sejam farm genérico trivial). Ver [[DESIGN-006]].

## 1. Variáveis Base & Constantes
| Var | Descrição | Faixa |
| :--- | :--- | :--- |
| `shape` | Formato do mapa | vertical \| horizontal \| square \| compact |
| `area` | Área jogável (px²) | > 0 |
| `openness` | Fração de área livre (sem paredes/blocos) | 0–1 |
| `reachableMobs` | Inimigos alcançáveis simultaneamente | ≥ 0 |

## 2. Formulação Matemática
- `farmability F = reachableMobs / (area / 1e6)` — quantos mobs por "tela-padrão".
- `rateMultiplier = clamp(0.40, 1.00, 1 / (1 + 0.05 * F))`
- `opennessFactor = 0.5 + 0.5 * openness`
- **Final:** `spawnRate = baseSpawn * rateMultiplier * opennessFactor` (idem para `dropRate`).

## 3. Schema de Configuração (JSON)
```json
{
  "id": "map_rate_scaling",
  "clampMin": 0.40,
  "clampMax": 1.00,
  "farmabilityK": 0.05,
  "shapeDefaults": {
    "vertical":   { "openness": 0.7 },
    "horizontal": { "openness": 0.7 },
    "square":     { "openness": 0.5 },
    "compact":    { "openness": 0.25 }
  }
}
```

## 4. Tabela de Simulação
| Formato | `reachableMobs` | `area (px²)` | `F` | `rateMultiplier` | `openness` | `opennessFactor` | `rate` final |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Vertical | 12 | 1.0e6 | 12 | 0.625 | 0.70 | 0.85 | 0.53× |
| Horizontal | 10 | 1.0e6 | 10 | 0.667 | 0.70 | 0.85 | 0.57× |
| Quadrado | 20 | 4.0e6 | 5 | 0.800 | 0.50 | 0.75 | 0.60× |
| Compacto | 15 | 1.5e6 | 10 | 0.667 | 0.25 | 0.625 | 0.42× |

> Valores são **placeholder de balanceamento** (status `Draft`) — a refinar com simulação. Formatação de exibição segue [[CONTEXT-004]].
