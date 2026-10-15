---
id: DATA-013
aliases:
  - DATA-013
title: "XP & Nível: Curvas"
type: data-spec
status: Draft
moscow: Must
system: "[[DESIGN-031 Calculo de Dano|DESIGN-031]]"
dependencies:
  - "[[DESIGN-005 Classes|DESIGN-005]]"
  - "[[DESIGN-031 Calculo de Dano|DESIGN-031]]"
---

# [DATA-013] XP & Nível: Curvas

> Curvas de **progressão de nível** do jogador. Validadas no protótipo (`tools/balance-sim.mjs`). `Draft` — calibrar.

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `lvl` | nível do jogador |
| `xp` | XP acumulado dentro do nível |

## 2. Formulação
- **XP para subir** (`lvl → lvl+1`): `xpNeeded(lvl) = floor(20 · lvl^2.2)`
- **Stat base:** `stat(lvl) = 10 + (lvl − 1)` — aplica-se a **STR/DEX/INT/LUK**.
- **Damage flat do jogador:** `damageFlat(lvl) = 8 + 3·(lvl − 1)` (+ o que vem do **gear**).
- **Gates de classe:** **10** (Base) e **50** (Especialização) → [[DESIGN-005 Classes|DESIGN-005]].

## 3. Tabela de Simulação
| Nível | XP p/ subir | Damage flat | Stat (cada) |
| :--- | :--- | :--- | :--- |
| 1 | 20 | 8 | 10 |
| 5 | 690 | 20 | 14 |
| 10 | 3.17 K | 35 | 19 |
| 25 | 23.8 K | 80 | 34 |
| 50 | 109 K | 155 | 59 |
| 70 | 229 K | 215 | 79 |

## 4. Armadilha & Notas
- ⚠️ Com essas curvas o **dano cresce ~nível²** (stat × damage flat). Se a **curva de XP** ficar "plana", o **leveling dispara** e o jogador vira um deus — no 1º teste o jogador chegou a **nível 300+**. A XP (`lvl^2.2`) existe para acompanhar.
- **Progressão validada** (protótipo): `1→10` em ~2 min · `10→22` em 5 · `22→36` em 7 · `36→51` em 9 · `52→70` em 12 — ver [[DATA-014 Populacao Mundo 1|DATA-014]].
- **Não é o XP por classe** ([[DESIGN-005 Classes|DESIGN-005]]): esta é a curva **global** de nível do personagem.

## 5. Schema de Configuração (JSON)
```json
{
  "id": "xp_curve",
  "xp": { "base": 20, "exp": 2.2 },
  "stat": { "base": 10, "perLevel": 1 },
  "damageFlat": { "base": 8, "perLevel": 3 },
  "classGates": [10, 50]
}
```

## 6. Relacionados
- Classes: [[DESIGN-005 Classes|DESIGN-005]] · Dano: [[DESIGN-031 Calculo de Dano|DESIGN-031]] / [[DATA-009 Dano|DATA-009]] · População: [[DATA-014 Populacao Mundo 1|DATA-014]].
