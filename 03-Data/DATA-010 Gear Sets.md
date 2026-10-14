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
| `dropWeight` | peso relativo de drop das peças do set (maior = cai mais) |

## 2. Tabela de Bônus por Set × Faixa
Bônus **acumulativos** (a faixa 3 soma as anteriores).

| Set | Peças | Faixa 1 (2 peças) | Faixa 2 (3 peças) | Faixa 3 (4 peças) |
| :--- | :--- | :--- | :--- | :--- |
| **Relíquia de Vorax** | 7 (3/5/7) | +10% Boss Damage · +5% IED | +15% Damage · +5% Crit Damage | +15% IED · +10% Final Damage |
| **Recruta** | 4 | +10% DEF · +10% Max HP · +5% HP Regen · +10% XP (online) | +10% DEF · +10% Max HP · +10% XP (online) | **+1 Multikill** |
| **Ganância** | 4 | +10% Money · +10% Drop Rate | +15% Stamp Drop · +15% Card Drop | +15% Money · +15% Drop Rate |
| **Legado do Mundo 1** | 4 | +10% efeito dos Selos | +10% produção do Osíris | +10% efeito das Cartas |

## 3. Peso de Drop por Set (o Recruta cai mais)
| Set | `dropWeight` | Observação |
| :--- | :--- | :--- |
| **Recruta** | **100** | 1º a dropar; mais comum |
| **Ganância** | 40 | comum nos níveis médios |
| **Legado do Mundo 1** | 30 | comum nos níveis altos |
| **Relíquia de Vorax** | 5 | raro (chefe) |

## 4. Fonte & Peças
| Set | Fonte | Peças disponíveis |
| :--- | :--- | :--- |
| Relíquia de Vorax | Chefe do Mundo 1 | 7 (todos os slots) |
| Recruta | Level1_1 / Level1_2 | 4 (armadura) |
| Ganância | Level1_3 / Level1_4 | 4 (armadura) |
| Legado do Mundo 1 | Level1_4 / Level1_5 | 4 (armadura) |

## 5. Schema de Configuração (JSON)
```json
{
  "id": "gear_sets",
  "sets": [
    {
      "id": "vorax_relic",
      "name": "Relíquia de Vorax",
      "pieces": 7,
      "dropWeight": 5,
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
      "dropWeight": 100,
      "tiers": [
        { "need": 2, "mods": { "def%": 10, "maxHp%": 10, "hpRegen%": 5, "xpOnline%": 10 } },
        { "need": 3, "mods": { "def%": 10, "maxHp%": 10, "xpOnline%": 10 } },
        { "need": 4, "mods": { "multikill": 1 } }
      ]
    },
    {
      "id": "greed",
      "name": "Ganância",
      "pieces": 4,
      "dropWeight": 40,
      "tiers": [
        { "need": 2, "mods": { "moneyFromMobs%": 10, "dropRate%": 10 } },
        { "need": 3, "mods": { "stampDrop%": 15, "cardDrop%": 15 } },
        { "need": 4, "mods": { "moneyFromMobs%": 15, "dropRate%": 15 } }
      ]
    },
    {
      "id": "w1_legacy",
      "name": "Legado do Mundo 1",
      "pieces": 4,
      "dropWeight": 30,
      "tiers": [
        { "need": 2, "mods": { "stampEffect%": 10 } },
        { "need": 3, "mods": { "osirisOutput%": 10 } },
        { "need": 4, "mods": { "cardEffect%": 10 } }
      ]
    }
  ]
}
```

## 6. Stats Novos Referenciados
| Stat | Significado |
| :--- | :--- |
| `xpOnline%` | ganho de XP **enquanto online** |
| `multikill` | tier de abate → +recurso base ([[DESIGN-033 Multikill\|DESIGN-033]]) |
| `stampDrop%` / `stampEffect%` | drop / efeito dos **Selos** |
| `osirisOutput%` | produção do **Osíris** |
| `cardDrop%` / `cardEffect%` | drop / efeito das **Cartas** |

## 7. Notas
- `dropWeight` é **relativo** (comparado com outros sets/itens), não uma chance absoluta.
- Bônus de set entram no **agregado de stats** (pipeline de [[DESIGN-031 Calculo de Dano|DESIGN-031]]); os **caps** de [[DATA-009 Dano|DATA-009]] §5 se aplicam.
- `Draft` — calibrar.

> Formatação segue [[CONTEXT-004 Notacao Numerica|CONTEXT-004]].
