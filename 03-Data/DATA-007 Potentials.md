---
id: DATA-007
aliases:
  - DATA-007
title: "Potentials: Linhas, Valores e Reset"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-028 Equipamentos|DESIGN-028]]"
dependencies:
  - "[[DESIGN-029 Potential|DESIGN-029]]"
  - "[[CONTEXT-007 Raridades|CONTEXT-007]]"
---

# [DATA-007] Potentials: Linhas, Valores e Reset

> Valores das **linhas de Potential** por raridade. Ver [[DESIGN-029 Potential|DESIGN-029]]. Escala de raridade: [[CONTEXT-007 Raridades|CONTEXT-007]]. Valores `Draft` — calibrar.

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `rarItem` | raridade do item (1..6) → nº de linhas |
| `rarLinha` | raridade da linha (1..6), com `rarLinha ≤ rarItem` |
| `valor` | bônus da linha naquela raridade |
| `pesoLinha` | peso de sorteio da raridade da linha |
| `custoReset` | custo em **Ouro** para re-sortear |

## 2. Linhas por Raridade do Item
| Raridade do item | Linhas de Potential |
| :--- | :--- |
| Comum | 1 |
| Raro | 2 |
| Épico | 3 |
| Lendário | 4 |
| Extraordinário | 5 |
| Divino | 6 |

## 3. Valor por Stat × Raridade da Linha
Valores em **flat** (a menos que marcado `%`).

| Stat | Comum | Raro | Épico | Lendário | Extraordinário | Divino |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **ATT% / MATT%** | 3% | 6% | 9% | 12% | **15%** | **25%** |
| **Boss Damage%** | 10% | 20% | 30% | 35% | 40% | 60% |
| **IED%** | 5% | 10% | 15% | 20% | 25% | 35% |
| **Damage%** | 3% | 6% | 9% | 12% | 15% | 20% |
| **Critical Damage%** | 3% | 5% | 8% | 10% | 15% | 20% |
| **Critical Chance%** | 2% | 3% | 5% | 8% | 10% | 15% |
| **STR/DEX/INT/LUK%** | 3% | 6% | 9% | 12% | 15% | **21%** |
| **All Stat%** | 1% | 2% | 3% | 4% | 5% | 7% |
| **HP% / MP% / DEF%** | 3% | 6% | 9% | 12% | 15% | 21% |
| **Drop Rate% / Money%** | 5% | 10% | 15% | 20% | 25% | 35% |

> **Exemplo canônico:** `ATT%` = **3 / 6 / 9 / 12 / 15 / 25** (os valores que você definiu: Raro 6, Épico 9, Extraordinário 15, Divino 25).

## 4. Pesos de Sorteio (raridade da linha)
| Raridade da linha | Peso |
| :--- | :--- |
| Comum | 100 |
| Raro | 45 |
| Épico | 15 |
| Lendário | 5 |
| Extraordinário | 1.5 |
| Divino | 0.4 |

> O sorteio é **clampado** à raridade do item: um item Épico sortearia apenas Comum/Raro/Épico (pesos renorm.).

## 5. Custo de Reset (Ouro)
| Raridade do item | Custo base |
| :--- | :--- |
| Comum | 1.0 K |
| Raro | 10 K |
| Épico | 100 K |
| Lendário | 1.0 M |
| Extraordinário | 10 M |
| Divino | 100 M |

- Escala também com o **nível do item**: `custoReset = custoBase × (nível/100)`.

## 6. Pool de Stats por Tipo de Equipamento
| Tipo | Stats possíveis |
| :--- | :--- |
| Armadura | HP%, STR/DEX/INT/LUK%, All Stat%, DEF%, MP% |
| Weapon | ATT%/MATT%, Boss Damage%, IED%, Damage%, Critical Damage%, Critical Chance%, STR/DEX/INT/LUK% |
| Accessory | All Stat%, STR/DEX/INT/LUK%, HP%, Critical Chance%, Critical Damage%, Drop Rate%, Money% |
| Badge | ATT%/MATT%, Boss Damage%, IED%, Damage%, Critical Damage% |

## 7. Schema de Configuração (JSON)
```json
{
  "id": "potentials",
  "linesByRarity": { "Comum": 1, "Raro": 2, "Epico": 3, "Lendario": 4, "Extraordinario": 5, "Divino": 6 },
  "lineRarityWeights": { "Comum": 100, "Raro": 45, "Epico": 15, "Lendario": 5, "Extraordinario": 1.5, "Divino": 0.4 },
  "values": {
    "ATTpct": [3, 6, 9, 12, 15, 25],
    "BossDmg": [10, 20, 30, 35, 40, 60],
    "IED": [5, 10, 15, 20, 25, 35],
    "Damage": [3, 6, 9, 12, 15, 20],
    "CritDmg": [3, 5, 8, 10, 15, 20],
    "CritChance": [2, 3, 5, 8, 10, 15],
    "StatPct": [3, 6, 9, 12, 15, 21]
  },
  "resetCost": [1000, 10000, 100000, 1000000, 10000000, 100000000],
  "resetScalesWithItemLevel": true
}
```

## 8. Tabela de Simulação — item **Divino** (6 linhas, raridade Divina)
| # | Stat | Valor (Divino) |
| :--- | :--- | :--- |
| 1 | ATT% | 25% |
| 2 | Boss Damage% | 60% |
| 3 | IED% | 35% |
| 4 | Critical Damage% | 20% |
| 5 | Damage% | 20% |
| 6 | STR% | 21% |

## 9. Gráfico — ATT% por Raridade da Linha (Charts View)
```chartsview
#-----------------#
#- chart type    -#
#-----------------#
type: Bar

#-----------------#
#- chart data    -#
#-----------------#
data: |
  dataviewjs:
  return [
    { raridade: 'Comum', att: 3 },
    { raridade: 'Raro', att: 6 },
    { raridade: 'Epico', att: 9 },
    { raridade: 'Lendario', att: 12 },
    { raridade: 'Extraord.', att: 15 },
    { raridade: 'Divino', att: 25 }
  ];

#-----------------#
#- chart options -#
#-----------------#
options:
  xField: 'att'
  yField: 'raridade'
  color: ['#9775fa']
```

> Formatação segue [[CONTEXT-004 Notacao Numerica|CONTEXT-004]]; gráficos usam **Charts View** (ver [[DATA-002 Selos Curvas|DATA-002]]). `Draft` — calibrar.
