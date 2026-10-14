---
id: DATA-005
aliases:
  - DATA-005
title: "Cartas: Tiers, Drops e Pacotes"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-016 Cartas|DESIGN-016]]"
dependencies:
  - "[[DESIGN-016 Cartas|DESIGN-016]]"
  - "[[CONTEXT-007 Raridades|CONTEXT-007]]"
---

# [DATA-005] Cartas: Tiers, Drops e Pacotes

> Curvas e odds das **cartas** ([[DESIGN-016 Cartas|DESIGN-016]]). O **tier da carta** usa a escala de [[CONTEXT-007 Raridades|CONTEXT-007]]. Valores `Draft` — calibrar.

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `tier` | tier da carta (1..6) = raridade ([[CONTEXT-007 Raridades|CONTEXT-007]]) |
| `copias` | cópias acumuladas da carta (account-wide) |
| `base` | incremento de bônus por tier (`+{base per tier}`) |
| `cartasPorPacote` | nº de cópias por pacote |
| `chance` | chance de drop da carta por morte de mob |

## 2. Tiers de Carta — requisitos e bônus

**Bônus por tier:** `Bonus(tier) = base × tier`.

**Requisito de cópias (acumulado para atingir o tier):**

| tier | Raridade | Cópias acumuladas |
| :--- | :--- | :--- |
| 1 | Comum | 1 |
| 2 | Raro | 7 |
| 3 | Épico | 21 |
| 4 | Lendário | 35 |
| 5 | Extraordinário | 112 |
| 6 | Divino | 3.22 K |
| _(7)_ | _hook_ | _103 K_ |

- Valores **exponenciais** (archetype do IdleOn: `7/21/35/112/3.22K/103K`); o último (`103K`) fica como hook de um eventual **7º tier**.
- **Subir de tier** usa o **acumulado**: ex. sair do Épico (21) pro Lendário (35) exige **14 cópias** a mais.

## 3. Cartas do Mundo 1 (bônus base)
Base (`base`) = incremento por tier. `Bônus(tier) = base × tier`.

| id | Nível | Carta | Stat | base | Tipo |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `card_1_1` | Level1_1 | Carta do Mob 1-1 | Base HP | **12** | flat |
| `card_1_2` | Level1_2 | Carta do Mob 1-2 | Base Damage | **7** | flat |
| `card_1_3` | Level1_3 | Carta do Mob 1-3 | Critical Chance | **1** | % |
| `card_1_4` | Level1_4 | Carta do Mob 1-4 | Money from Monsters | **5** | % |
| `card_1_5` | Level1_5 | Carta do Mob 1-5 | Card Drop Chance | **5** | % |

Exemplo (`card_1_1`, `base=12`): tier 1 → **+12** HP · tier 3 → **+36** HP · tier 6 → **+72** HP.

## 4. Drop de Cartas
- **Chance base:** `chance = 1/N` por morte de mob (roll independente do drop de item).
- **Carta nova (0 cópias):** multiplicador `newCardMultiplier` (drop muito mais provável).

| Parâmetro | Valor (Draft) |
| :--- | :--- |
| `N` (base) | 500 (1 em 500 = 0.2%) |
| `newCardMultiplier` | ×10 (1 em 50 enquanto não possui nenhuma) |

> A carta `card_1_5` (`+{5 per tier}%` Card Drop Chance) **aumenta** `1/chance` de todas as cartas.

## 5. Pacotinhos (por raridade)
Cartas por pacote: **3** (Comum…Lendário) · **5** (Extraordinário/Divino). Odds em % (somam 100 por linha).

| Pacote \ Tier | 1 Comum | 2 Raro | 3 Épico | 4 Lendário | 5 Extraord. | 6 Divino |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Comum** | 60 | 25 | 10 | 4 | 0.9 | 0.1 |
| **Raro** | 35 | 34 | 20 | 8 | 2.5 | 0.5 |
| **Épico** | 15 | 30 | 30 | 18 | 6 | 1 |
| **Lendário** | 5 | 20 | 32 | 28 | 12 | 3 |
| **Extraordinário** | 0 | 10 | 27 | 35 | 22 | 6 |
| **Divino** | 0 | 0 | 12 | 30 | 38 | 20 |

- Cada pacote dá **cópias** de cartas sorteadas pela linha do seu tier.
- **Diário:** 1 pacote grátis/dia (odds do **Comum**). **Pity:** a definir.

## 6. Poeira (duplicatas)
Duplicata de uma carta já no **tier máximo** vira **poeira** (`dustByTier`, proporcional ao tier).

| tier | Poeira por duplicata |
| :--- | :--- |
| 1 | 1 |
| 2 | 4 |
| 3 | 12 |
| 4 | 40 |
| 5 | 150 |
| 6 | 600 |

## 7. Schema de Configuração (JSON)
```json
{
  "id": "cards",
  "equipSlots": 4,
  "tierReq": [1, 7, 21, 35, 112, 3220],
  "newCardMultiplier": 10,
  "dropChance": "1/500",
  "dustByTier": { "1": 1, "2": 4, "3": 12, "4": 40, "5": 150, "6": 600 },
  "packCards": { "comum": 3, "raro": 3, "epico": 3, "lendario": 3, "extraordinario": 5, "divino": 5 },
  "cards": [
    { "id": "card_1_1", "name": "Carta do Mob 1-1", "mob": "Level1_1", "stat": "BaseHP", "base": 12, "unit": "flat" },
    { "id": "card_1_2", "name": "Carta do Mob 1-2", "mob": "Level1_2", "stat": "BaseDamage", "base": 7, "unit": "flat" },
    { "id": "card_1_3", "name": "Carta do Mob 1-3", "mob": "Level1_3", "stat": "CritChance", "base": 1, "unit": "pct" },
    { "id": "card_1_4", "name": "Carta do Mob 1-4", "mob": "Level1_4", "stat": "MoneyFromMonsters", "base": 5, "unit": "pct" },
    { "id": "card_1_5", "name": "Carta do Mob 1-5", "mob": "Level1_5", "stat": "CardDropChance", "base": 5, "unit": "pct" }
  ]
}
```

## 8. Tabela de Simulação — bônus por tier (Mundo 1)
| Carta | T1 | T2 | T3 | T4 | T5 | T6 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Carta 1-1 (+12 HP) | +12 | +24 | +36 | +48 | +60 | +72 |
| Carta 1-2 (+7 Dmg) | +7 | +14 | +21 | +28 | +35 | +42 |
| Carta 1-3 (+1% Crit) | +1% | +2% | +3% | +4% | +5% | +6% |
| Carta 1-4 (+5% Money) | +5% | +10% | +15% | +20% | +25% | +30% |
| Carta 1-5 (+5% CardDrop) | +5% | +10% | +15% | +20% | +25% | +30% |

## 9. Gráfico — Requisito de Cópias por Tier (Charts View)
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
    { tier: 'Comum (1)', copias: 1 },
    { tier: 'Raro (2)', copias: 7 },
    { tier: 'Epico (3)', copias: 21 },
    { tier: 'Lendario (4)', copias: 35 },
    { tier: 'Extraord. (5)', copias: 112 },
    { tier: 'Divino (6)', copias: 3220 }
  ];

#-----------------#
#- chart options -#
#-----------------#
options:
  xField: 'copias'
  yField: 'tier'
  color: ['#9775fa']
```

> Formatação segue [[CONTEXT-004 Notacao Numerica|CONTEXT-004]]; gráficos usam **Charts View** (ver [[DATA-002 Selos Curvas|DATA-002]]). Valores `Draft` — calibrar.
