---
id: DATA-023
aliases:
  - DATA-023
title: "Quests do Mundo 1"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-048 Quests|DESIGN-048]]"
dependencies:
  - "[[DESIGN-048 Quests|DESIGN-048]]"
  - "[[DATA-019 Itens|DATA-019]]"
  - "[[DATA-014 Populacao Mundo 1|DATA-014]]"
---

# [DATA-023] Quests do Mundo 1

> A **cadeia tutorial** (estilo Scripticus) + **1 quest por mapa**. Todas dadas pelo **mesmo NPC** no Hub.
> `Draft` — calibrar.

## 1. O NPC
| id | Nome | Onde | Papel |
| :--- | :--- | :--- | :--- |
| `npc_chip` | **Chip** (pica-pau) | Hub `Level1_0` | **dá TODAS as quests** (cadeia única) |

> 💡 *Nome/espécie = proposta* (um pica-pau numa Árvore Gigante). Trocar é só o `name` no JSON.

## 2. A cadeia (9 quests)
| # | id | Título | Objetivo | Recompensa | Pré-requisito |
| --: | :--- | :--- | :--- | :--- | :--- |
| 1 | `q_wake` | **Wake Up, Hero** | `level` → **nível 3** | **150** ouro | — |
| 2 | `q_first_blood` | **First Blood** | `kill` **10 Lesmas** (1-1) | **200** ouro + `gear_sword_common` | 1 |
| 3 | `q_look_sharp` | **Look Sharp** | `equip` **1 arma** | **250** ouro | 2 |
| 4 | `q_clear_roots` | **Clear the Roots** | `kill` **60** (1-1, a cota) | **500** ouro | 3 |
| 5 | `q_spores` | **Spore Trouble** | `collect` **10 `spore_cap`** (1-2) | **1.500** ouro + `gear_ring_rare` | 4 |
| 6 | `q_sting` | **Sting Operation** | `collect` **10 `wasp_wing`** (1-3) | **4.000** ouro + `gear_pendant_rare` | 5 |
| 7 | `q_up_trunk` | **Up the Trunk** | `level` → **nível 36** | **10.000** ouro + `gear_armor_rare` | 6 |
| 8 | `q_wise_owl` | **The Wise Owl** | `kill` **220** (1-5, a cota) | **30.000** ouro + `upgrade_stone` ×5 | 7 |
| 9 | `q_face_vorax` | **Face Vorax** | `boss` **derrotar Vorax** | 🎉 **destrava o 2º personagem** + **100.000** ouro | 8 |

> 🎯 **A quest 9 é o marco do Mundo 1:** matar o chefe **abre o segundo slot** ([[DESIGN-046 Personagens|DESIGN-046]] §2). O fim do mundo **é** o início do próximo eixo (conta).

## 3. Itens novos (entram no catálogo — [[DATA-019 Itens|DATA-019]])
| id | Nome | kind | scope | Origem | Uso |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `spore_cap` | Spore Cap | `material` | **account** | drop do **Cogumelo** (1-2), **~40%** | quest 5 (e venda) |
| `wasp_wing` | Wasp Wing | `material` | **account** | drop do **Vespão** (1-3), **~35%** | quest 6 (e venda) |

## 4. Regras de avanço
- **Cadeia única e linear**: nenhuma quest abre antes da anterior ✓ (simples de propósito).
- **Máx. 3 ativas** simultâneas ✓ ([[DESIGN-048 Quests|DESIGN-048]] §4).
- **Sem prazo / sem falha** — quest não expira, não se perde.
- **Progresso por CONTA** ✓ — trocar de personagem **não** reinicia a quest (é a jornada).

## 5. Schema de Configuração (JSON)
```json
{
  "id": "quests_world1",
  "giver": "npc_chip",
  "scope": "account",
  "maxActive": 3,
  "quests": [
    { "id": "q_wake", "title": "Wake Up, Hero", "objective": { "type": "level", "target": 3 }, "reward": { "gold": 150 } },
    { "id": "q_first_blood", "title": "First Blood", "objective": { "type": "kill", "mob": "snail", "count": 10 }, "reward": { "gold": 200, "items": ["gear_sword_common"] }, "after": "q_wake" },
    { "id": "q_look_sharp", "title": "Look Sharp", "objective": { "type": "equip", "kind": "weapon", "count": 1 }, "reward": { "gold": 250 }, "after": "q_first_blood" },
    { "id": "q_clear_roots", "title": "Clear the Roots", "objective": { "type": "kill", "level": "Level1_1", "count": 60 }, "reward": { "gold": 500 }, "after": "q_look_sharp" },
    { "id": "q_spores", "title": "Spore Trouble", "objective": { "type": "collect", "item": "spore_cap", "count": 10 }, "reward": { "gold": 1500, "items": ["gear_ring_rare"] }, "after": "q_clear_roots" },
    { "id": "q_sting", "title": "Sting Operation", "objective": { "type": "collect", "item": "wasp_wing", "count": 10 }, "reward": { "gold": 4000, "items": ["gear_pendant_rare"] }, "after": "q_spores" },
    { "id": "q_up_trunk", "title": "Up the Trunk", "objective": { "type": "level", "target": 36 }, "reward": { "gold": 10000, "items": ["gear_armor_rare"] }, "after": "q_sting" },
    { "id": "q_wise_owl", "title": "The Wise Owl", "objective": { "type": "kill", "level": "Level1_5", "count": 220 }, "reward": { "gold": 30000, "items": ["upgrade_stone"], "itemCounts": [5] }, "after": "q_up_trunk" },
    { "id": "q_face_vorax", "title": "Face Vorax", "objective": { "type": "boss", "boss": "vorax" }, "reward": { "gold": 100000, "unlock": "character_slot_2" }, "after": "q_wise_owl" }
  ],
  "items": [
    { "id": "spore_cap", "name": "Spore Cap", "kind": "material", "scope": "account", "stackable": true, "dropChance": 0.40 },
    { "id": "wasp_wing", "name": "Wasp Wing", "kind": "material", "scope": "account", "stackable": true, "dropChance": 0.35 }
  ]
}
```

## 6. Tabela de Simulação — ritmo da cadeia (jogador mediano)
| Quest | Quando termina | Acumula |
| :--- | :--- | :--- |
| 1–3 (tutorial) | ~1 min no Hub | ~600 ouro + 1ª arma |
| 4 (1-1) | ao bater a cota (2 min) | 1.100 ouro |
| 5 (1-2) | ~5 min | 2.600 ouro + anel |
| 6 (1-3) | ~7 min | 6.600 ouro + colar |
| 7 (1-4) | ~9 min | 16,6 K ouro + armadura |
| 8 (1-5) | ~12 min | 46,6 K ouro + 5 pedras |
| 9 (**Vorax**) | ~2–3 min de luta | **146,6 K ouro** + **2º personagem** |

> **Total ≈ 37 min de Mundo 1** — casa com as metas de tempo (2+5+7+9+12) ✅

## 7. Relacionados
- Sistema: [[DESIGN-048 Quests|DESIGN-048]] · Itens: [[DATA-019 Itens|DATA-019]] · Roster: [[DESIGN-046 Personagens|DESIGN-046]].
- Chefe: [[DESIGN-041 Level1_Boss1|DESIGN-041]] · População: [[DATA-014 Populacao Mundo 1|DATA-014]].
