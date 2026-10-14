---
id: DATA-011
aliases:
  - DATA-011
title: "Multikill & Contratos: Tiers, Pontos e Recurso Base"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-034 Livro dos Contratos|DESIGN-034]]"
dependencies:
  - "[[DESIGN-033 Multikill|DESIGN-033]]"
  - "[[DESIGN-034 Livro dos Contratos|DESIGN-034]]"
---

# [DATA-011] Multikill & Contratos: Tiers, Pontos e Recurso Base

> Curvas do **Multikill** e do **Livro dos Contratos** ([[DESIGN-033 Multikill|DESIGN-033]] · [[DESIGN-034 Livro dos Contratos|DESIGN-034]]). `Draft` — calibrar.

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `tier` | Tier de Abate: `max(1, floor(dano_golpe / HP_mob))` |
| `MK%` | bônus de Multikill do mundo (= `pontos × 1%` + gear) |
| `pontos` | pontos do livro do mundo |
| `recursoBase` | 1º item da drop table do mob (único afetado) |

## 2. Tiers de Abate
| Tier | Dano necessário | Bônus no recurso base |
| :--- | :--- | :--- |
| 1 | 100% do HP | base (sem bônus) |
| 2 | 200% do HP | `+1 × MK%` |
| 3 | 300% do HP | `+2 × MK%` |
| 4 | 400% do HP | `+3 × MK%` |
| 5 | 500% do HP | `+4 × MK%` |
| … | `tier × HP` | `+ (tier−1) × MK%` |

> **Cap de tier:** 10 (a definir) — evita explosão em overkill absurdo.

## 3. Formulação
- **Tier:** `tier = max(1, floor(dano_golpe / HP_mob))`.
- **Recurso base:** `recursoBaseFinal = base × (1 + (tier − 1) × MK%)`.
- **Multikill do mundo:** `MK% = pontos × 1%`.
- **CAP:** `MK%` **sem cap** (é multiplicador); **não** afeta Cartas/XP/moedas.

## 4. Pontos por Mundo
| Mundo | Livro desbloqueado em | `MK%` base |
| :--- | :--- | :--- |
| **Mundo 1** | portal do **Level1_5** (chefe) | `pontos × 1%` |
| Mundo 2+ | (a definir) | idem |

## 5. Recurso Base por Mob (Mundo 1)
| Mob | Recurso base |
| :--- | :--- |
| Mob 1-1 | (1º drop do mob — a definir com a população) |
| Mob 1-2 | (idem) |
| Mob 1-3 | (idem) |
| Mob 1-4 | (idem) |
| Mob 1-5 | (idem) |

> Depende da **população de mobs** ([[DESIGN-003 Mundo 1|DESIGN-003]] §4, *a definir*). O `recursoBase` é sempre o **1º item** da drop table.

## 6. Schema de Configuração (JSON)
```json
{
  "id": "multikill_contracts",
  "tierCap": 10,
  "multikillPerPoint": 0.01,
  "worldPointsPerTier": 1,
  "affected": ["baseResource"],
  "unaffected": ["cards", "xp", "coins", "secondaryDrops"],
  "worlds": {
    "w1": { "unlockedBy": "Level1_5_portal", "points": 0, "multikillPct": 0.0 }
  }
}
```

## 7. Notas & Limites (óbvios)
- **Tier mínimo 1** (golpe de 100%); dano abaixo do HP **não** conta tier.
- **`MK%` sem cap** (multiplicador puro); **Cartas/XP/moedas nunca** são multiplicados ([[DESIGN-033 Multikill|DESIGN-033]] §4).
- **Pontos sem cap** — cada mob contribui até o `tierCap` (10).
- **Stats agregados** respeitam os caps de [[DATA-009 Dano|DATA-009]] §5.

> Formatação segue [[CONTEXT-004 Notacao Numerica|CONTEXT-004]]. `Draft` — calibrar.
