---
id: DATA-014
aliases:
  - DATA-014
title: "População do Mundo 1 (Mobs, XP, Essência & Cota)"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-003 Mundo 1|DESIGN-003]]"
dependencies:
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
  - "[[DATA-013 XP e Nivel|DATA-013]]"
---

# [DATA-014] População do Mundo 1

> Stats dos mobs, XP, Essência e **cota de abate** por nível. Resolvido pelo **solver** do protótipo (`tools/balance-sim.mjs`) para bater os **tempos-alvo**. `Draft` — calibrar.

## 1. Alvo de Tempo (design)
| Nível | Tempo p/ "passar" |
| :--- | :--- |
| 1-1 | **2 min** |
| 1-2 | **5 min** |
| 1-3 | **7 min** |
| 1-4 | **9 min** |
| 1-5 | **12 min** |

## 2. Tabela (resolvida)
| Nível | Mob | HP | ATK | XP | Essência | **Cota de abate** | **Cap/linha** | Lv entra→sai | Golpes/mob (início→fim) |
| :--- | :--- | --: | --: | --: | --: | --: | --: | :--- | :--- |
| 1-1 | **Lesma** | 124 | 2 | 140 | 1 | **60** | — | 1 → 10 | 25 → 3 |
| 1-2 | **Cogumelo** | 588 | 5 | 966 | 4 | **110** | — | 10 → 22 | 14 → 5 |
| 1-3 | **Vespão** | 1550 | 12 | 3041 | 16 | **150** | — | 22 → 36 | 11 → 5 |
| 1-4 | **Esquilo Coletor** | 3433 | 28 | 7260 | 64 | **180** | — | 36 → 51 | 11 → 6 |
| 1-5 | **Coruja Sábia** | 6783 | 60 | 13738 | 256 | **220** | — | 52 → 70 | 11 → 7 |

- **Chefe — Vorax ([[DESIGN-041 Level1_Boss1|Level1_Boss1]]):** HP **60 000** · ATK **150** · Essência **5 000** · `capLinha` **(a definir)**.

> **`capLinha` (teto de dano por linha):** *a definir* por inimigo. **Regra:** mobs **comuns = sem teto** (`—`); **elites/bosses** têm teto → **favorecem builds multi-hit** ([[DESIGN-037 Linhas de Dano|DESIGN-037]]).

## 3. Regras de Balanceamento
- **Nada de one-shot nos mobs fortes:** no começo de cada nível o mob exige **11–25 golpes**; cai para **3–7 no fim**, conforme o jogador **upa**. ✅ (requisito de design)
- **Cota de abate (gate):** o **Portal Saída** só abre ao matar a **cota** do nível — ver [[DESIGN-003 Mundo 1|DESIGN-003]] §4 e [[DESIGN-034 Livro dos Contratos|DESIGN-034]] §3.
- **Essência cresce ~4× por nível** → os custos dos sinks ([[DATA-012 Essencia Custos|DATA-012]]) precisam escalar junto.
- **Curvas que produziram isto:** [[DATA-013 XP e Nivel|DATA-013]] + [[DATA-009 Dano|DATA-009]] (ritmo efetivo ≈ `1.43 golpes/s × fator de área ~1.8`).

## 4. Schema de Configuração (JSON)
```json
{
  "id": "world1_population",
  "levels": [
    { "level": "1-1", "mob": "lesma",     "hp": 124,  "atk": 2,  "xp": 140,   "essence": 1,   "quota": 60,  "capLine": null },
    { "level": "1-2", "mob": "cogumelo",  "hp": 588,  "atk": 5,  "xp": 966,   "essence": 4,   "quota": 110, "capLine": null },
    { "level": "1-3", "mob": "vespao",    "hp": 1550, "atk": 12, "xp": 3041,  "essence": 16,  "quota": 150, "capLine": null },
    { "level": "1-4", "mob": "esquilo",   "hp": 3433, "atk": 28, "xp": 7260,  "essence": 64,  "quota": 180, "capLine": null },
    { "level": "1-5", "mob": "coruja",    "hp": 6783, "atk": 60, "xp": 13738, "essence": 256, "quota": 220, "capLine": null }
  ],
  "boss": { "id": "vorax", "hp": 60000, "atk": 150, "essence": 5000, "capLine": null }
}
```

## 5. Relacionados
- Mundo: [[DESIGN-003 Mundo 1|DESIGN-003]] · XP: [[DATA-013 XP e Nivel|DATA-013]] · Dano: [[DATA-009 Dano|DATA-009]].
- Essência: [[DESIGN-035 Essencia|DESIGN-035]] / [[DATA-012 Essencia Custos|DATA-012]] · Livro: [[DESIGN-034 Livro dos Contratos|DESIGN-034]].
