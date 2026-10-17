---
id: DATA-019
aliases:
  - DATA-019
title: "Itens & Inventário (Catálogo)"
type: data-spec
status: Draft
moscow: Must
system: "[[DESIGN-044 Inventario|DESIGN-044]]"
dependencies:
  - "[[DESIGN-044 Inventario|DESIGN-044]]"
  - "[[CONTEXT-019 Conta & Personagem|CONTEXT-019]]"
  - "[[CONTEXT-007 Raridades|CONTEXT-007]]"
---

# [DATA-019] Itens & Inventário (Catálogo)

> Catálogo e **schema** dos itens + as regras de **stack** e **escopo**. Decisão do usuário: **inventário infinito**, **stacks infinitos**.
> Ids em **inglês** ([[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]] §1.16).

## 1. Variáveis Base & Constantes
| Var | Valor | Nota |
| :--- | :--- | :--- |
| `slots` | **∞** | sem teto de slots (decisão do usuário) |
| `maxStack` | **-1 (∞)** | **tudo** que é `stackable` empilha sem limite |
| `count` | **BigNumber** | contagem pode estourar `int` |
| `scope` | `account` \| `character` | [[CONTEXT-019 Conta & Personagem\|CONTEXT-019]] |

## 2. Schema do Item
| Campo | Tipo | Descrição |
| :--- | :--- | :--- |
| `id` | string | chave única (`snake_case`) |
| `name` | string | nome exibido (**EN**) |
| `kind` | enum | `currency` · `material` · `consumable` · `card` · `stamp` · `gear` · `shard` · `pet_token` · `quest` |
| `scope` | enum | **`account`** (inventário compartilhado) · **`character`** (só gear) |
| `stackable` | bool | `true` → `maxStack = ∞` |
| `rarity` | int (1..6) | [[CONTEXT-007 Raridades\|CONTEXT-007]] (0 = N/A) |
| `desc` | string | texto do tooltip |
| `use` | obj? | efeito de consumível (`{ heal_pct: 40, cooldown: 30 }`) |

## 3. Catálogo inicial
| id | Nome (EN) | kind | scope | stack | Origem |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `gold` | Gold | `currency` | **account** | ∞ | mobs/chefe |
| `essence` | Essence | `currency` | **account** | ∞ | mobs/chefe ([[DESIGN-035 Essencia\|DESIGN-035]]) |
| `gems` | Gems | `currency` | **account** | ∞ | IAP ([[CONTEXT-013 Moeda Premium\|CONTEXT-013]]) |
| `relic_shard` | Relic Shard | `shard` | **account** | ∞ | **chefe** → craft do set |
| `vorax_crystal` | Vorax Crystal | `material` | **account** | ∞ | **chefe** → **vendável 1×/dia** |
| `potion_hp` | HP Potion | `consumable` | **account** | ∞ | drop/vendor (`heal 40%`, cd 30 s) |
| `upgrade_stone` | Upgrade Stone | `material` | **account** | ∞ | chefe (raro) · [[DESIGN-030 Star Force\|DESIGN-030]] |
| `card_*` | Card: … | `card` | **account** (coleção) | ∞ | mobs ([[DESIGN-016 Cartas\|DESIGN-016]]) |
| `stamp_*` | Stamp: … | `stamp` | **account** | ∞ | mobs ([[DESIGN-013 Selos\|DESIGN-013]]) |
| `gear_*` | (arma/armadura/acessório) | `gear` | 🔴 **character** | 1 | mobs/chefe (**vai pra mochila do personagem**) |
| `pet_token_*` | Pet Shot Token | `pet_token` | **account** | ∞ | daily/weekly ([[DESIGN-038 Pets\|DESIGN-038]]) |

> **Gear nunca entra no inventário da conta** — o drop vai direto para o `equipmentBag` do **personagem ativo** ([[DESIGN-044 Inventario|DESIGN-044]] §2).

## 4. Formulacao — o que stacka e o que não
- **Stacka (∞):** `currency`, `material`, `consumable`, `shard`, `card`, `stamp`, `pet_token`, `quest`.
- **NÃO stacka:** **`gear`** (cada peça tem stats próprios: Potential/Star Force/enchants → [[DESIGN-028 Equipamentos|DESIGN-028]], [[DESIGN-029 Potential|DESIGN-029]], [[DESIGN-030 Star Force|DESIGN-030]]).
- **Chave de stack:** o `id` **+ o estado** do item. Gear com estado diferente = entradas diferentes.

## 5. Schema de Configuração (JSON)
```json
{
  "id": "inventory",
  "slots": -1,
  "defaultMaxStack": -1,
  "countType": "BigNumber",
  "kindsStackable": ["currency", "material", "consumable", "shard", "card", "stamp", "pet_token", "quest"],
  "kindsUnique": ["gear"],
  "items": [
    { "id": "gold", "name": "Gold", "kind": "currency", "scope": "account", "stackable": true, "rarity": 0 },
    { "id": "essence", "name": "Essence", "kind": "currency", "scope": "account", "stackable": true, "rarity": 0 },
    { "id": "gems", "name": "Gems", "kind": "currency", "scope": "account", "stackable": true, "rarity": 0 },
    { "id": "relic_shard", "name": "Relic Shard", "kind": "shard", "scope": "account", "stackable": true, "rarity": 0 },
    { "id": "vorax_crystal", "name": "Vorax Crystal", "kind": "material", "scope": "account", "stackable": true, "rarity": 0 },
    { "id": "potion_hp", "name": "HP Potion", "kind": "consumable", "scope": "account", "stackable": true, "rarity": 1, "use": { "heal_pct": 40, "cooldown": 30 } },
    { "id": "upgrade_stone", "name": "Upgrade Stone", "kind": "material", "scope": "account", "stackable": true, "rarity": 2 },
    { "id": "pet_token_common", "name": "Common Shot Token", "kind": "pet_token", "scope": "account", "stackable": true, "rarity": 1 }
  ]
}
```

## 6. Tabela de Simulação — onde cada item entra
| Origem | Vai para |
| :--- | :--- |
| Morte de mob | `gold` + `essence` + (carta/selo/gear por roll) → **conta** (gear → **personagem**) |
| Morte de chefe | `gold` (100×) · `essence` (20×) · `vorax_crystal` · `relic_shard` (8–15) · gear genérico · (raro) `upgrade_stone` |
| Vendor | compra poção/consumível → gasta `gold` da **conta** |
| Vendor de chefe | vende `vorax_crystal` → `gold` (**1×/dia**) |
| Craft do set | gasta `relic_shard` (100/peça) |

## 7. Relacionados
- Design: [[DESIGN-044 Inventario|DESIGN-044]] · Escopo: [[CONTEXT-019 Conta & Personagem|CONTEXT-019]].
- Gear: [[DESIGN-028 Equipamentos|DESIGN-028]] · Raridade: [[CONTEXT-007 Raridades|CONTEXT-007]] · Moeda premium: [[CONTEXT-013 Moeda Premium|CONTEXT-013]].
