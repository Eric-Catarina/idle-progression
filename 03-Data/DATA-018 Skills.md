---
id: DATA-018
aliases:
  - DATA-018
title: "Skills: Números & Ritmo (Warrior)"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-036 Skills & Fila de Skills|DESIGN-036]]"
dependencies:
  - "[[DESIGN-036 Skills & Fila de Skills|DESIGN-036]]"
  - "[[DATA-009 Dano|DATA-009]]"
  - "[[DESIGN-008 Machado|DESIGN-008]]"
  - "[[CONTEXT-015 Tags de Skill|CONTEXT-015]]"
---

# [DATA-018] Skills: Números & Ritmo (Warrior)

> Os números que faltavam para implementar o combate. **Base: talents do Warrior do IdleOn** (`99-Inbox/reference/IDLEON_COMBAT_REFERENCE.md` §1).
> Herdado de [[DESIGN-036 Skills & Fila de Skills|DESIGN-036]]: `lines` **base 3**, crítico **por linha** ([[DESIGN-037 Linhas de Dano|DESIGN-037]]).

## 1. Ritmo global
| Var | Valor | Origem |
| :--- | --: | :--- |
| `combatTick` | **100 ms** | decisão (janela do auto-cast) |
| `basicAttackCooldown` | **0,7 s** | **o solver já assume `1/0,7`** ([[DATA-014 Populacao Mundo 1\|DATA-014]]) — não mudar sem recalibrar |
| `basicAttackActionTime` | 0,2 s | estimativa (visível) |
| `lines` (base) | **3** | [[DESIGN-037 Linhas de Dano\|DESIGN-037]] |
| `aoeFactor` (solver) | **1,8** | já no solver → é o `Whirl` |

## 2. Skills do protótipo (5)
| id | Skill | Tags ([[CONTEXT-015 Tags de Skill\|CONTEXT-015]]) | Mana | Action | Cooldown | Dano (`×` do golpe base) |
| :--- | :--- | :--- | --: | --: | --: | :--- |
| `basic` | **Ataque Básico** | `melee` · `single` · `damage` | 0 | 0,2 s | **0,7 s** | `100%` |
| `power_strike` | **Power Strike** | `melee` · `multi`(2) · `damage` | 3 | **0,45 s** | **3 s** | `130 + 3/nível %` |
| `whirl` | **Whirl** | `melee` · `aoe` · `damage` | 5 | **0,45 s** | **5 s** | `60 + 1,5/nível %` |
| `axe_throw` | **Arremesso de Machado** | `projectile` · `arc` · `boomerang` · `line` · `damage` | 5 | — | **4 s** *(est.)* | `90 + 2/nível %` |
| `str_buff` | **Firmly Grasp It** | `instant` · `self` · `buff` | 5 | **1,5 s** | **30 s** | `+15 + 1/nível` STR por **2 min** |

- **Power Strike** = alvo **+1** (2 no total) → testa `target:multi`.
- **Whirl** = **AoE em volta** → é o fator `1,8` do solver ✅ → testa `target:aoe`.
- **Machado** = **ida-e-volta, perfurante** ([[DESIGN-008 Machado|DESIGN-008]]) → testa `delivery:projectile` + `trajectory:boomerang`.
- **Firmly Grasp It** = **buff de duração** → testa a fila com uma skill que não dá dano.

> Cobre **melee, multi, aoe, projétil e buff** — dá para validar a taxonomia inteira com 5 skills.

## 3. Fila & ritmo ([[DESIGN-036 Skills & Fila de Skills|DESIGN-036]])
```
a cada combatTick (100 ms):
  1. procura a 1ª skill da fila cujo COOLDOWN está pronto
  2. se ninguém está pronto → nada (o próximo tick tenta de novo)
  3. executa: paga mana (DESIGN-031 §) → aplica o efeito → consome cooldown
```
- **Sem mobs à frente:** skills de dano **não são gastas** (a fila **pula** para a próxima, inclusive o básico) — resolve o *"(a definir)"* do [[DESIGN-036 Skills & Fila de Skills|DESIGN-036]] §5.
- **Alvo morto no meio:** o efeito resolve no **frame em que foi aplicado**; não re-mira.

## 4. Escalonamento
- **Dano por nível da skill:** `dano% = base + perLevel × (nível − 1)` (a fórmula por skill está na tabela §2).
- **Custo de mana:** fixo por skill (IdleOn).
- **Mana regen:** **1%/s** do máximo (`IDLEON_COMBAT_REFERENCE` §5) — [[DESIGN-028 Equipamentos|DESIGN-028]] dá o MP flat.

## 5. Schema de Configuração (JSON)
```json
{
  "id": "skills_warrior",
  "combatTickMs": 100,
  "basicCooldown": 0.7,
  "linesBase": 3,
  "aoeFactor": 1.8,
  "skills": [
    { "id": "basic", "tags": ["delivery:melee","target:single","role:damage"], "mana": 0, "action": 0.2, "cooldown": 0.7, "lines": 3, "dmg": { "base": 100, "perLevel": 0 } },
    { "id": "power_strike", "tags": ["delivery:melee","target:multi","role:damage"], "mana": 3, "action": 0.45, "cooldown": 3.0, "lines": 3, "targets": 2, "dmg": { "base": 130, "perLevel": 3 } },
    { "id": "whirl", "tags": ["delivery:melee","target:aoe","role:damage"], "mana": 5, "action": 0.45, "cooldown": 5.0, "lines": 3, "dmg": { "base": 60, "perLevel": 1.5 } },
    { "id": "axe_throw", "tags": ["delivery:projectile","trajectory:arc","trajectory:boomerang","target:line","role:damage"], "mana": 5, "cooldown": 4.0, "lines": 3, "dmg": { "base": 90, "perLevel": 2 } },
    { "id": "str_buff", "tags": ["delivery:instant","target:self","role:buff"], "mana": 5, "action": 1.5, "cooldown": 30.0, "buff": { "stat": "str", "base": 15, "perLevel": 1, "durationSec": 120 } }
  ]
}
```

## 6. Tabela de Simulação — golpes para matar (referência)
| Nível | Golpe base | Mob HP ([[DATA-014 Populacao Mundo 1\|DATA-014]]) | Golpes |
| :--- | --: | --: | --: |
| 1-1 (Lv 1) | ~20 | 124 | ~6 (no início, com 3 linhas: bem menos) |
| 1-5 (Lv 70) | ~1.044 | 6.783 | ~7 |

> ✅ **Bate com o solver** (`DATA-014`: 25→3 golpes no 1-1 … 6,5 no 1-5). **Não recalibrar sem rodar `node tools/balance-sim.mjs`.**

## 7. Relacionados
- Fila/tags: [[DESIGN-036 Skills & Fila de Skills|DESIGN-036]] · [[CONTEXT-015 Tags de Skill|CONTEXT-015]].
- Dano: [[DATA-009 Dano|DATA-009]] · [[DESIGN-031 Calculo de Dano|DESIGN-031]] · Linhas: [[DESIGN-037 Linhas de Dano|DESIGN-037]].
- Referência (IdleOn): `99-Inbox/reference/IDLEON_COMBAT_REFERENCE.md`.
