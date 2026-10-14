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

> Stats base e blocos da fórmula de dano ([[DESIGN-031 Calculo de Dano|DESIGN-031]]). `Draft` — calibrar.

## 1. Stats Base por Classe (Main / Sec)
| Base | Main | Sec | Ataque | Recurso |
| :--- | :--- | :--- | :--- | :--- |
| **Guerreiro** | STR | DEX | **ATT** (físico) | HP |
| **Arqueiro** | DEX | STR | **ATT** (físico) | MP |
| **Mago** | INT | LUK | **MATT** (mágico) | MP |
| **Genérica** (0–9) | — (usa a menor) | — | ATT | HP |

- `Main` e `Sec` são os stats primários; `Main×4 + Sec` alimenta o bloco **Stat**.

## 2. Fórmula (blocos)
```text
DanoFinal = DanoSkill × (Main×4 + Sec) × (ATT_arma / 100) × (1 + ATT%) × (1 + Damage% + BossDmg%) × Fator_IED × Fator_Crit × (1 + FinalDmg%)
```

| Bloco | Fórmula | Tipo |
| :--- | :--- | :--- |
| Stat | `Main×4 + Sec` | multiplicativo |
| Weapon ATT | `ATT_arma / 100` | multiplicativo |
| Attack% | `1 + ATT%` | multiplicativo |
| Dano Total | `1 + Damage% + BossDmg%` | **aditivo dentro** |
| IED | `1 − PDR × (1 − IED_total)` | multiplicativo |
| Crítico | `1 + CritChance × CritDmg%` | multiplicativo (esperado) |
| Final Damage | `1 + FinalDmg%` | multiplicativo |

## 3. IED (combinação multiplicativa)
```text
IED_total = 1 − Π(1 − ied_i)
```
- Fontes separadas **não somam**: 30% + 30% → `1 − (0.7×0.7) = 51%`.
- Efeito na defesa do alvo: `dano × (1 − PDR × (1 − IED_total))`.

| IED_total | PDR 300% → dano efetivo |
| :--- | :--- |
| 0% | ×0.00 (bloqueado) |
| 50% | ×0.50 → -50% |
| 90% | ×0.90 |
| 96% | ×0.96 |

## 4. Crítico
- `Fator_Crit = 1 + (CritChance × CritDmg%)`.
- Ex.: 50% chance × 20% dano = `1 + 0.10 = ×1.10` (esperado).

## 5. Schema de Configuração (JSON)
```json
{
  "id": "damage",
  "classes": {
    "guerreiro": { "main": "STR", "sec": "DEX", "attack": "ATT" },
    "arqueiro":  { "main": "DEX", "sec": "STR", "attack": "ATT" },
    "mago":      { "main": "INT", "sec": "LUK", "attack": "MATT" }
  },
  "blocks": ["skill", "stat", "weaponAtt", "attackPct", "totalDamage", "ied", "crit", "finalDamage"],
  "totalDamageFormula": "1 + Damage% + BossDmg%",
  "iedFormula": "1 - (1 - PDR)*(1 - IED_total)",
  "critFormula": "1 + CritChance*CritDmg"
}
```

## 6. Tabela de Simulação — ganho por bloco (base 100)
| Cenário | ATT% | Damage% | BossDmg% | IED% | Crit | DanoFinal |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Base | 0 | 0 | 0 | 0 | 0 | **100** |
| +50% ATT | 50 | 0 | 0 | 0 | 0 | **150** |
| +50% Damage | 0 | 50 | 0 | 0 | 0 | **150** |
| +50% Boss (soma c/ Damage) | 0 | 50 | 50 | 0 | 0 | **200** |
| Sharp: +25% ATT **vs** +50% Boss | 25 | 0 | 50 | 0 | 0 | ATT: 125 · Boss: 150 |
| IED: +30% IED vs PDR 300% | 0 | 0 | 0 | 30 | 0 | ×0.30 no dano efetivo |

> Demonstra a **regra de ouro**: blocos **aditivos** (Damage+Boss) sofrem retorno decrescente; blocos **novos** multiplicam.

> Formatação segue [[CONTEXT-004 Notacao Numerica|CONTEXT-004]]. `Draft` — calibrar em simulação.
