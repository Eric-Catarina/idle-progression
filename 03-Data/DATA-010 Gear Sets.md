---
id: DATA-010
aliases:
  - DATA-010
title: "Gear Sets: Faixas e Bônus"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-032 Gear Sets|DESIGN-032]]"
dependencies:
  - "[[DESIGN-032 Gear Sets|DESIGN-032]]"
---

# [DATA-010] Gear Sets: Faixas e Bônus

> Bônus por faixa de cada **set** do Mundo 1 ([[DESIGN-032 Gear Sets|DESIGN-032]]). Valores `Draft` — calibrar.

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `setId` | id do conjunto |
| `pecas` | nº de peças do set equipadas |
| `faixa` | faixa destravada (1..3) conforme `pecas` |
| `cond` | condição opcional (ex.: `map:vertical`) |

## 2. Tabela de Bônus por Set × Faixa
Bônus **acumulativos** (a faixa 3 soma as anteriores).

| Set | Peças | Faixa 1 (2 peças) | Faixa 2 (3 peças) | Faixa 3 (4 peças) |
| :--- | :--- | :--- | :--- | :--- |
| **Relíquia de Vorax** | 7 (3/5/7) | +10% Boss Damage · +5% IED | +15% Damage · +5% Crit Damage | +15% IED · +10% Final Damage |
| **Recruta** | 4 | +10% HP | +10% EXP (mobs) | +15% DEF · +10% HP |
| **Selador** | 4 | +10% Drop Rate | +15% Stamp Drop | +10% EXP · +10% Drop Rate |
| **Minerador** | 4 | +10% Money | +10% Crystal gain | +15% Drop Rate · +10% Money |
| **Colecionador** | 4 | +10% Card Drop | +10% Drop Rate | +15% Card Drop · +5% Crit Chance |
| **Caçador** | 4 | +10% Damage vs Mobs | +10% Crit Chance | +15% Damage vs Mobs · +10% Crit Damage |
| **Alpinista** | 4 | +10% Damage (mapa vertical) | +10% Damage vs Mobs | +15% Damage (vertical) · +5% Crit Chance |
| **Corredor** | 4 | +10% Damage (mapa horizontal) | +10% EXP | +15% Damage (horizontal) · +5% Crit Chance |

> **Relíquia de Vorax** usa faixas **3 / 5 / 7** (é o set do chefe, maior).

## 3. Fonte & Peças
| Set | Fonte | Peças disponíveis |
| :--- | :--- | :--- |
| Relíquia de Vorax | Chefe do Mundo 1 | 7 (todos os slots) |
| Recruta | Level1_1 / Level1_2 | 4 (armadura) |
| Selador | Level1_2 | 4 (armadura) |
| Minerador | Level1_3 | 4 (armadura) |
| Colecionador | Level1_4 | 4 (armadura) |
| Caçador | mobs gerais | 4 (armadura) |
| Alpinista | Level1_4 | 4 (armadura) |
| Corredor | Level1_5 | 4 (armadura) |

## 4. Schema de Configuração (JSON)
```json
{
  "id": "gear_sets",
  "sets": [
    {
      "id": "vorax_relic",
      "name": "Relíquia de Vorax",
      "pieces": 7,
      "tiers": [
        { "need": 3, "mods": { "bossDamage%": 10, "ied%": 5 } },
        { "need": 5, "mods": { "damage%": 15, "critDamage%": 5 } },
        { "need": 7, "mods": { "ied%": 15, "finalDamage%": 10 } }
      ]
    },
    {
      "id": "recruit",
      "name": "Recruta",
      "pieces": 4,
      "tiers": [
        { "need": 2, "mods": { "hp%": 10 } },
        { "need": 3, "mods": { "expFromMobs%": 10 } },
        { "need": 4, "mods": { "def%": 15, "hp%": 10 } }
      ]
    },
    {
      "id": "alpinist",
      "name": "Alpinista",
      "pieces": 4,
      "tiers": [
        { "need": 2, "mods": { "damage%": 10 }, "cond": "map:vertical" },
        { "need": 3, "mods": { "damageVsMobs%": 10 } },
        { "need": 4, "mods": { "damage%": 15, "critChance%": 5 }, "cond": "map:vertical" }
      ]
    }
  ]
}
```

## 5. Notas
- `cond` = bônus **condicional** (só vale no contexto). Sets Alpinista/Corredor usam `map:vertical` / `map:horizontal` ([[DESIGN-006 Meta Espacial|DESIGN-006]]).
- Bônus de set entram no **agregado de stats** junto com Potential/estrelas (pipeline de [[DESIGN-031 Calculo de Dano|DESIGN-031]]).
- `Draft` — calibrar; valores crescem com a profundidade do mundo.

> Formatação segue [[CONTEXT-004 Notacao Numerica|CONTEXT-004]].
