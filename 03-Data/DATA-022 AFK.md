---
id: DATA-022
aliases:
  - DATA-022
title: "AFK (Ganhos Offline)"
type: data-spec
status: Draft
moscow: Must
system: "[[DESIGN-047 AFK & Ganhos Offline|DESIGN-047]]"
dependencies:
  - "[[DESIGN-047 AFK & Ganhos Offline|DESIGN-047]]"
  - "[[DATA-013 XP e Nivel|DATA-013]]"
  - "[[DATA-014 Populacao Mundo 1|DATA-014]]"
  - "[[DATA-020 Accuracy & Defense|DATA-020]]"
---

# [DATA-022] AFK (Ganhos Offline)

> Números dos ganhos offline ([[DESIGN-047 AFK & Ganhos Offline|DESIGN-047]]). **Sem cap de tempo. Por personagem.**
> Simulação **analítica** (nunca tick a tick).

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `dt` | segundos offline do **personagem** (`agora − lastSeen[char]`) |
| `dps` | DPS **efetivo** do personagem no mapa (dano/s × `hitChance` × `aoe`) |
| `hitRate` | `HitChance/100` no mob do mapa ([[DATA-020 Accuracy & Defense\|DATA-020]] §2) |
| `hp`, `xp`, `gold`, `ess` | do mob do mapa ([[DATA-014 Populacao Mundo 1\|DATA-014]]; `gold = xp × 0,25`) |
| `killsRate` | `dps × hitRate ÷ hp` (mortes/s) |
| `cap` | **∅ (nenhum)** — decisão do usuário |

## 2. Formulação
```
kills   = floor( killsRate × dt )
xp      = kills × mobXp          → aplica xpNeed(lvl) = 20 × lvl^2,2   (DATA-013)
gold    = kills × mobGold
essence = kills × mobEssence
drops   = para cada item do mob: rola `kills` vezes com as MESMAS odds do online
```
- **Escala linear no tempo** (kills), e o **nível cresce sublinearmente** porque `xpNeed ~ lvl^2,2`:
  `nível ≈ (kills × mobXp × 3,2 ÷ 20)^(1/3,2)` — **cresce, mas cada vez mais devagar** ✅ (é o que torna o "sem cap" aceitável).

## 3. As duas checagens (o gate morde offline também)
1. **Accuracy** → multiplica `killsRate` (`hitRate`) ✅
2. **Defense** → se `danoRecebido(mob) ≥ 1`, o personagem **morre** no primeiro contato:
   `tempoAtéMorrer = hpPlayer ÷ (danoRecebido × mobsEmContato)` → **o offline para ali** ✅

> 🔒 **Consequência:** um personagem **sem armadura não farma offline** (morre em segundos). O AFK **premia** quem passou pelo gate de [[DESIGN-045 Gate de Avanco (Accuracy & Defense)|DESIGN-045]].

## 4. ⚠️ Alerta de balanceamento (ler antes de implementar)
| Offline em **1-1** (killRate 0,85/s) | kills | XP | **Nível** | Ouro |
| :--- | --: | --: | --: | --: |
| 1 h | 3.060 | 428 K | ~26 | 107 K |
| 6 h | 18,4 K | 2,57 M | ~52 | 643 K |
| **24 h** | 73,4 K | 10,3 M | **~87** | 2,57 M |
| 1 semana | 514 K | 72 M | ~157 | 18 M |
| 1 mês | 2,2 M | 308 M | ~262 | 77 M |

- **A curva segura** o nível (cresce `~(kills)^(1/3,2)`), mas **1 dia no mapa 1-1 chega a ~nível 87** — isso **fura a jornada** (o mapa é de nível 1–10).
- 💡 **Mitigação sugerida (1 linha, se você quiser):** o **XP offline respeita o *range* do mapa** — acima do nível-alvo do nível, o mob vira trivial e **não dá mais XP** (o **loot continua infinito** ✅).
  > Assim: **tempo infinito ✓, loot infinito ✓, mas o XP para no range do mapa** — a jornada sobrevive.
- Decisão do usuário: **sem cap** → implementar como está e **medir**; a mitigação é barata de ligar depois.

## 5. Schema de Configuração (JSON)
```json
{
  "id": "afk",
  "perCharacter": true,
  "timeCapSeconds": -1,
  "formula": "analytic",
  "killsRate": "dps * hitRate / mobHp",
  "goldPerXp": 0.25,
  "dropsUseOnlineOdds": true,
  "deathStopsGains": true,
  "xpRespectsMapRange": false,
  "clockSkewGuard": true
}
```

## 6. Tabela de Simulação — 1-5 (Coruja: HP 6.783 · XP 13.738 · ATK 60)
| Offline | kills (killRate 0,9/s) | Nível | Ouro |
| :--- | --: | --: | --: |
| 1 h | 3.240 | ~72 | 11,1 M |
| 6 h | 19,4 K | ~90 | 66,8 M |
| 24 h | 77,8 K | ~113 | 267 M |

> Note que **1-5 dá ~25× mais ouro/h** que o 1-1 — **farmar no mapa certo é a decisão** do idle ✅

## 7. Relacionados
- Design: [[DESIGN-047 AFK & Ganhos Offline|DESIGN-047]] · Gate: [[DESIGN-045 Gate de Avanco (Accuracy & Defense)|DESIGN-045]].
- Curvas: [[DATA-013 XP e Nivel|DATA-013]] · População: [[DATA-014 Populacao Mundo 1|DATA-014]] · Dano: [[DESIGN-031 Calculo de Dano|DESIGN-031]].
