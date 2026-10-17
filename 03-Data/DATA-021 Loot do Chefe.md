---
id: DATA-021
aliases:
  - DATA-021
title: "Loot do Chefe (Vorax)"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-041 Level1_Boss1|DESIGN-041]]"
dependencies:
  - "[[DESIGN-041 Level1_Boss1|DESIGN-041]]"
  - "[[DATA-019 Itens|DATA-019]]"
  - "[[DESIGN-032 Gear Sets|DESIGN-032]]"
  - "[[DATA-014 Populacao Mundo 1|DATA-014]]"
---

# [DATA-021] Loot do Chefe (Vorax)

> Drops do **Vorax** ([[DESIGN-041 Level1_Boss1|DESIGN-041]]), no modelo **MapleStory**: muito ouro, recurso, **gear genérico**, e **fragmentos** para o set — mais um **cristal gacha**.
> Valores `Draft` — calibrar com o solver.

## 1. Variáveis Base & Constantes
| Var | Valor | Nota |
| :--- | --: | :--- |
| `mobGold(1-5)` | `xp × 0,25` = **3.434** | mob = Coruja ([DATA-014 Populacao Mundo 1\|DATA-014]) |
| `goldBoss` | **343.400** | = **100×** um mob do 1-5 |
| `essenceBoss` | **5.120** | ≈ **20×** a essência do mob |
| `shardPerKill` | **8–15** | roll uniforme |
| `shardPerPiece` | **100** | craft do set (5 peças = **500**) |
| `crystalUsePerDay` | **1** | o gacha do cristal é **diário** |

## 2. Drops por morte (garantido × roll)
| Drop | Qtd | Chance | Nota |
| :--- | :--- | :--- | :--- |
| `gold` | **343,4 K** | **100%** | o "burst" de dinheiro |
| `essence` | **5.120** | **100%** | alimenta os sinks |
| `vorax_crystal` | 1 | **100%** | **gacha** (§4) · uso **1×/dia** |
| `relic_shard` | **8–15** | **100%** | craft do set |
| **gear genérico** | 1–2 peças | **100%** | raridade **4–5** ([CONTEXT-007 Raridades\|CONTEXT-007]) — chão de upgrade |
| `upgrade_stone` | 1–2 | **15%** | Star Force ([DESIGN-030 Star Force\|DESIGN-030]) |
| **peça do SET inteira** | 1 | **🟡 1%** | **mínuscula** — o "jackpot" (decisão do usuário) |
| **Pet de Vorax** | 1 | **2%** | liga com [[DESIGN-038 Pets\|DESIGN-038]] |
| Carta de Vorax | 1 | **1ª kill: 100%** · depois 5% | coleção |
| Selo de Vorax | 1 | **1ª kill: 100%** | [[DESIGN-013 Selos\|DESIGN-013]] |

> 🎯 **Os dois caminhos para o set:** **fragmentos** (garantido, ~35–60 kills p/ o set de 5 peças) **ou** o **jackpot de 1%** (uma peça inteira, sorte). MapleStory puro (CRA/Absolab).

## 3. First clear (uma vez por conta)
| Recompensa | Qtd |
| :--- | --: |
| Carta de Vorax | 1 |
| Selo de Vorax | 1 |
| `relic_shard` | **50** (meia peça de graça) |

> O primeiro kill tem que **ensinar o loop**: você levou **metade** de uma peça. O resto é grind.

## 4. 🔮 Cristal de Vorax — **o gacha** (uso diário)
Consumir o cristal (segurando o dedo — [[DESIGN-044 Inventario|DESIGN-044]] §5) rola **uma** tabela. **1 uso por dia.**

| Prêmio | Chance |
| :--- | --: |
| `gold` **171,7 K** (metade de um kill do chefe) | **60%** |
| `essence` **2.560** | **25%** |
| `upgrade_stone` ×3 | **10%** |
| `relic_shard` ×20 | **4%** |
| gear raridade **6 (Divino)** | **0.9%** |
| **peça do SET inteira** | **0.1%** |
| | **100%** |

> 💰 **Por que o cristal é gacha e não "venda direta":** vira o **gancho diário** — em vez de um botão de dinheiro, é um **momento** ("o que vai sair hoje?"). E o valor esperado (~**120 K**/dia) fica **abaixo** de um kill do chefe → **farmar o chefe vale mais** que só abrir o cristal ✅.

## 5. Schema de Configuração (JSON)
```json
{
  "id": "boss_loot_vorax",
  "guaranteed": [
    { "item": "gold", "amount": 343400 },
    { "item": "essence", "amount": 5120 },
    { "item": "vorax_crystal", "amount": 1 },
    { "item": "relic_shard", "amount": [8, 15] },
    { "item": "gear_generic", "amount": [1, 2], "rarity": [4, 5] }
  ],
  "rolls": [
    { "item": "upgrade_stone", "amount": [1, 2], "chance": 0.15 },
    { "item": "gear_set_piece", "amount": 1, "chance": 0.01 },
    { "item": "pet_vorax", "amount": 1, "chance": 0.02 }
  ],
  "firstClear": { "card": "card_vorax", "stamp": "stamp_vorax", "relic_shard": 50 },
  "crystalGacha": {
    "usesPerDay": 1,
    "table": [
      { "item": "gold", "amount": 171700, "chance": 0.60 },
      { "item": "essence", "amount": 2560, "chance": 0.25 },
      { "item": "upgrade_stone", "amount": 3, "chance": 0.10 },
      { "item": "relic_shard", "amount": 20, "chance": 0.04 },
      { "item": "gear_generic", "amount": 1, "rarity": [6, 6], "chance": 0.009 },
      { "item": "gear_set_piece", "amount": 1, "chance": 0.001 }
    ]
  },
  "setCraft": { "set": "relic_of_vorax", "pieces": 5, "shardPerPiece": 100 }
}
```

## 6. Tabela de Simulação — caminho do set
| Kills do chefe | Fragmentos | Peças (100 cada) | Chance ≥1 jackpot (1%) |
| --: | --: | --: | --: |
| 1 (first clear) | 50 + 8–15 | 0 (meia peça) | 1% |
| 10 | ~165 | 1 | 9,6% |
| 25 | ~337 | **3** | 22,2% |
| 50 | ~625 | **6** (set completo!) | 39,5% |
| 100 | ~1.200 | 12 | 63,4% |

> **Meta:** o **set completo por fragmentos** em **~45–50 kills**; o **jackpot** só **acelera**.

## 7. Relacionados
- Chefe/arena: [[DESIGN-041 Level1_Boss1|DESIGN-041]] · Itens: [[DATA-019 Itens|DATA-019]] · Set: [[DESIGN-032 Gear Sets|DESIGN-032]].
- Consumo (segurar o dedo): [[DESIGN-044 Inventario|DESIGN-044]] §5 · População: [[DATA-014 Populacao Mundo 1|DATA-014]].
