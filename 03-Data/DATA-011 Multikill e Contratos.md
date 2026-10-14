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
| `essencia` | **Essência do mundo** (verde no Mundo 1) — único drop de mob, único afetado pelo Multikill |

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
- **Essência:** `essenciaFinal = essencia × (1 + (tier − 1) × MK%)`.
- **Multikill do mundo:** `MK% = pontos × 1%`.
- **CAP:** `MK%` **sem cap** (é multiplicador); **não** afeta Cartas/XP/moedas.

## 4. Pontos por Mundo
| Mundo | Livro desbloqueado em | `MK%` base |
| :--- | :--- | :--- |
| **Mundo 1** | portal do **Level1_5** (chefe) | `pontos × 1%` |
| Mundo 2+ | (a definir) | idem |

## 5. Essência (Recurso do Mundo 1)
- O **único recurso** de mob no Mundo 1 é a **Essência Verde** (sem recursos por mob — o cogumelo não dropa "chapéu de cogumelo").
- Os mobs têm **drop table** com **coleções** (cartas/selos/gear) em rolls separados, mas essas **não** são multiplicadas pelo Multikill.
- É a **Essência** que o **Multikill** multiplica.

## 6. Schema de Configuração (JSON)
```json
{
  "id": "multikill_contracts",
  "tierCap": 10,
  "multikillPerPoint": 0.01,
  "worldPointsPerTier": 1,
  "affected": ["worldEssence"],
  "unaffected": ["cards", "xp", "coins", "secondaryDrops"],
  "worlds": {
    "w1": { "unlockedBy": "Level1_5_portal", "points": 0, "multikillPct": 0.0, "retroactive": true }
  }
}
```

## 7. Notas & Limites (óbvios)
- **Tier mínimo 1** (golpe de 100%); dano abaixo do HP **não** conta tier.
- **`MK%` sem cap** (multiplicador puro); **Cartas/XP/moedas nunca** são multiplicados ([[DESIGN-033 Multikill|DESIGN-033]] §4).
- **Pontos sem cap** — cada mob contribui até o `tierCap` (10).
- **Retroativo:** `tierRecorde` conta mesmo antes do desbloqueio (`retroactive: true`).
- **Stats agregados** respeitam os caps de [[DATA-009 Dano|DATA-009]] §5.

> Formatação segue [[CONTEXT-004 Notacao Numerica|CONTEXT-004]]. `Draft` — calibrar.
