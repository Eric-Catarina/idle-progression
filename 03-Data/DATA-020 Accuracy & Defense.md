---
id: DATA-020
aliases:
  - DATA-020
title: "Accuracy & Defense (Curvas do Gate)"
type: data-spec
status: Draft
moscow: Must
system: "[[DESIGN-045 Gate de Avanco (Accuracy & Defense)|DESIGN-045]]"
dependencies:
  - "[[DESIGN-045 Gate de Avanco (Accuracy & Defense)|DESIGN-045]]"
  - "[[DATA-013 XP e Nivel|DATA-013]]"
  - "[[DATA-014 Populacao Mundo 1|DATA-014]]"
---

# [DATA-020] Accuracy & Defense (Curvas do Gate)

> As duas únicas paredes do avanço ([[DESIGN-045 Gate de Avanco (Accuracy & Defense)|DESIGN-045]]). Fórmulas **exatas do IdleOn** (`99-Inbox/reference/IDLEON_COMBAT_REFERENCE.md` §3 e §7).

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `acc` | `sec_stat(nível) + gear_accuracy` — **stat secundário**: Warrior=WIS · Archer=STR · Mage=AGI (IdleOn) |
| `sec_stat(nível)` | `10 + (nível − 1)` ([[DATA-013 XP e Nivel\|DATA-013]]) |
| `accReq` | exigência de acerto do **mob** |
| `def` | **armadura** (flat) + nível — **base do personagem sem gear = 0** |
| `attack` | ATK do mob ([[DATA-014 Populacao Mundo 1\|DATA-014]]) |

## 2. Chance de acerto (IdleOn, exata)
```
HitChance(%) = 142,5 × acc ÷ accReq − 42,5
```
- `acc == accReq` → **100%** · **mínimo 5%**; **abaixo de 5% conta como 0**.
- Rola **por alvo** e **por golpe** (um `MISS` gasta o cooldown — [[DESIGN-045 Gate de Avanco (Accuracy & Defense)|DESIGN-045]] §3).

## 3. Dano recebido (IdleOn, exata)
```
DamageTaken = floor( 0,6 + (attack − 2,5 × def^0,8) ÷ (1 + def^2,5 ÷ attack ÷ 100) )
```
- **`def > attack` → dano ZERO** (imune) ✅
- O contato respeita o **i-frame de 1 s** ([[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]] §1.3).

## 4. Tabela — a parede do Mundo 1
`accReq(level) = sec_stat(nível INICIAL do level)` → **quem chega no nível certo acerta 100%**.

| Level | Mob | ATK | `accReq` | Hit **no nível certo** | Hit **entrando 1 tier antes** | `def` p/ **imunidade** |
| :--- | :--- | --: | --: | --: | --: | --: |
| **1-1** | Lesma | 2 | **10** | 100% | — | **3** |
| **1-2** | Cogumelo | 5 | **19** | 100% | **32,5%** (nível 1) | **6** |
| **1-3** | Vespão | 12 | **31** | 100% | **44,8%** (nível 10) | **15** |
| **1-4** | Esquilo Coletor | 28 | **45** | 100% | **55,7%** (nível 22) | **34** |
| **1-5** | Coruja Sábia | 60 | **60** | 100% | **64,4%** (nível 36) | **72** |
| **Boss** | Vorax | 150 | **79** | 100% | **65,7%** (nível 51) | **180** |

> 🔒 **Leitura:** a parede **morde no começo** (1-2 a 32% e 1-3 a 45% de acerto = cota **eterna**) e **afrouxa** depois. Se o jogador **entrar adiantado, ele volta** — é o softlock.
> 🛡️ **Defense** é o outro lado: com `def = 0` (sem armadura) ele **toma dano cheio**; a coluna da direita é o valor que **zera** o dano.

## 5. Schema de Configuração (JSON)
```json
{
  "id": "accuracy_defense",
  "hitChance": { "mult": 142.5, "offset": -42.5, "minPct": 5, "floorToZeroBelow": 5 },
  "damageTaken": { "base": 0.6, "defScale": 2.5, "defExp": 0.8, "defDenomExp": 2.5, "immuneIfDefAboveAttack": true },
  "perLevel": [
    { "level": "Level1_1", "attack": 2,   "accReq": 10, "defImmune": 3 },
    { "level": "Level1_2", "attack": 5,   "accReq": 19, "defImmune": 6 },
    { "level": "Level1_3", "attack": 12,  "accReq": 31, "defImmune": 15 },
    { "level": "Level1_4", "attack": 28,  "accReq": 45, "defImmune": 34 },
    { "level": "Level1_5", "attack": 60,  "accReq": 60, "defImmune": 72 },
    { "level": "Level1_Boss1", "attack": 150, "accReq": 79, "defImmune": 180 }
  ]
}
```

## 6. Tabela de Simulação — hit% por (nível do jogador × level)
| Level \ Nível do player | 1 | 10 | 22 | 36 | 51 | 70 |
| :--- | --: | --: | --: | --: | --: | --: |
| **1-1** (accReq 10) | 100% | 100% | 100% | 100% | 100% | 100% |
| **1-2** (19) | 32% | 100% | 100% | 100% | 100% | 100% |
| **1-3** (31) | **0%** | 45% | 100% | 100% | 100% | 100% |
| **1-4** (45) | 0% | **0%** | 56% | 100% | 100% | 100% |
| **1-5** (60) | 0% | 0% | **0%** | 64% | 100% | 100% |
| **Boss** (79) | 0% | 0% | 0% | **0%** | 66% | 100% |

## 7. Relacionados
- Design: [[DESIGN-045 Gate de Avanco (Accuracy & Defense)|DESIGN-045]] · Dano: [[DESIGN-031 Calculo de Dano|DESIGN-031]] · Gear: [[DESIGN-028 Equipamentos|DESIGN-028]].
- Referência (IdleOn): `99-Inbox/reference/IDLEON_COMBAT_REFERENCE.md` §3/§7.
