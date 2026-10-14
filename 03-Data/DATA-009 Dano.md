---
id: DATA-009
aliases:
  - DATA-009
title: "Dano: Stats e Blocos Multiplicativos"
type: data-spec
status: Draft
moscow: Must
system: "[[DESIGN-031 Calculo de Dano|DESIGN-031]]"
dependencies:
  - "[[DESIGN-031 Calculo de Dano|DESIGN-031]]"
  - "[[DESIGN-005 Classes|DESIGN-005]]"
---

# [DATA-009] Dano: Stats e Blocos Multiplicativos

> Stats base e blocos da fórmula de dano ([[DESIGN-031 Calculo de Dano|DESIGN-031]]). **ATT removido → Damage.** `Draft` — calibrar.

## 1. Stats Base por Classe (Main / Sec / Tert)
Peso: `Main×4 + Sec×1 + Tert×1`.

| Base | Main ×4 | Sec ×1 | Tert ×1 | Recurso |
| :--- | :--- | :--- | :--- | :--- |
| **Guerreiro** | STR | DEX | LUK | HP |
| **Arqueiro** | DEX | STR | LUK | MP |
| **Mago** | INT | LUK | DEX | MP |
| **Genérica** (0–9) | — (menor entre os 4) | — | — | HP |

- Um stat pode ser **Main** de uma classe e **Sec/Tert** de outras → **todos os 4 têm utilidade**.
- Pesos `4/1/1` são configuráveis (alternativa: `4/2/1`).

## 2. Fórmula (blocos)
```text
DanoFinal = DanoSkill × (Main×4 + Sec + Tert) × (Damage_arma / 100) × (1 + Damage%) × (1 + BossDamage%) × Fator_IED × Fator_Crit × (1 + FinalDamage%)
```

| Bloco | Fórmula | Tipo |
| :--- | :--- | :--- |
| Stat | `Main×4 + Sec + Tert` | multiplicativo |
| Damage (flat) | `Damage_arma / 100` | multiplicativo |
| Damage% | `1 + Damage%` | multiplicativo |
| Boss Damage% | `1 + BossDamage%` | multiplicativo (condicional: chefes) |
| Damage vs Monsters% | `1 + DamageVsMobs%` | multiplicativo (condicional: mobs) |
| IED | `1 − PDR × (1 − IED_total)` | multiplicativo |
| Crítico | `1 + CritChance × CritDamage%` | multiplicativo (esperado) |
| Final Damage% | `1 + FinalDamage%` | multiplicativo |

> **Não há mais bloco aditivo** (`Damage% + Boss%` do MapleStory foi desfeito). Todos os blocos **multiplicam**.

## 3. IED (combinação multiplicativa)
```text
IED_total = 1 − Π(1 − ied_i)
```
- Fontes separadas **não somam**: 30% + 30% → `1 − (0.7×0.7) = 51%`.
- Efeito na defesa do alvo: `dano × (1 − PDR × (1 − IED_total))`.

| IED_total | PDR 300% → multiplicador |
| :--- | :--- |
| 0% | ×0.00 |
| 50% | ×0.50 |
| 90% | ×0.90 |
| 96% | ×0.96 |

## 4. Crítico
- `Fator_Crit = 1 + (CritChance × CritDamage%)`.
- Ex.: 50% chance × 20% dano = `1 + 0.10 = ×1.10` (esperado).

## 5. Caps & Limites

| Stat | Faixa | Motivo |
| :--- | :--- | :--- |
| `CritChance%` | **0 – 100%** | não se pode critar mais que sempre |
| `IED%` | **0 – 100%** | não se pode ignorar mais que toda a defesa (assíntota) |
| `PDR` (alvo) | **0% – sem teto** | chefes podem ter PDR > 100% |
| `CritDamage%` | **sem cap** | adendo dentro do bloco Crítico |
| `Damage%` · `BossDamage%` · `DamageVsMobs%` · `FinalDamage%` | **sem cap** | escalam com o progresso |
| `Damage Reduction` (futuro) | 0 – 100% | análogo ao IED |
| `Hit Rate` / acerto (futuro) | 0 – 100% | idem |

> **Regra:** valores **acima do cap são truncados** no agregado — a UI pode mostrar o excedente, mas o cálculo usa o **valor limitado**.

## 6. Schema de Configuração (JSON)
```json
{
  "id": "damage",
  "classes": {
    "guerreiro": { "main": "STR", "sec": "DEX", "tert": "LUK" },
    "arqueiro":  { "main": "DEX", "sec": "STR", "tert": "LUK" },
    "mago":      { "main": "INT", "sec": "LUK", "tert": "DEX" }
  },
  "weights": { "main": 4, "sec": 1, "tert": 1 },
  "blocks": ["skill", "stat", "weaponDamage", "damagePct", "bossDamage", "ied", "crit", "finalDamage"],
  "iedFormula": "1 - (1 - PDR)*(1 - IED_total)",
  "critFormula": "1 + CritChance*CritDamage",
  "caps": { "critChance": 100, "ied": 100, "critDamage": null, "damagePct": null, "bossDamage": null, "finalDamage": null, "pdr": null }
}
```

## 7. Tabela de Simulação — ganho por bloco (base 100)
| Cenário | Damage% | BossDmg% | IED% | Crit | DanoFinal |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Base | 0 | 0 | 0 | 0 | **100** |
| +50% Damage | 50 | 0 | 0 | 0 | **150** |
| +50% Boss (bloco próprio) | 0 | 50 | 0 | 0 | **150** |
| Ambos | 50 | 50 | 0 | 0 | **225** |
| +10% Crit dmg a 50% chance | — | — | — | ×1.05 | **×1.05** |
| IED 30% vs PDR 300% | — | — | 30 | — | ×0.30 no efetivo |

> Confirma que os blocos agora **multiplicam** (não somam): `1.5 × 1.5 = 2.25`.

> Formatação segue [[CONTEXT-004 Notacao Numerica|CONTEXT-004]]. `Draft` — calibrar em simulação.
