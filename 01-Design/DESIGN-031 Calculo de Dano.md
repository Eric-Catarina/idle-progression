---
id: DESIGN-031
aliases:
  - DESIGN-031
title: "Cálculo de Dano (Multiplicativo)"
type: system-design
subtype: mechanic
status: Draft
moscow: Must
moscow_note: Combate básico é Must; sem a fórmula o combate não resolve. Os blocos avançados (IED/Boss) são profundidade Should.
dependencies:
  - "[[DESIGN-028 Equipamentos|DESIGN-028]]"
  - "[[DESIGN-029 Potential|DESIGN-029]]"
data_spec: "[[DATA-009 Dano|DATA-009]]"
---

# [DESIGN-031] Cálculo de Dano (Multiplicativo)

> Inspiração: fórmula do **MapleStory** (blocos multiplicativos). Referência bruta em `99-Inbox/reference/MAPLESTORY_GEAR_REFERENCE.md`.

## 0. Prioridade MoSCoW
- **Categoria:** Must
- **Justificativa:** sem a fórmula **não há combate**. Os **blocos avançados** (IED, Boss Damage) são profundidade de endgame (Should), mas a **estrutura** é Must. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
O dano é **multiplicativo entre blocos** e **aditivo dentro de cada bloco**. Isso é o que faz o **balanceamento** importar: empilhar um só tipo de bônus rende cada vez menos, então o jogador **equilibra** as fontes (gear, Potential, estrelas, skills).

## 2. Fórmula (blocos)

```text
DanoFinal ≈ DanoSkill × (Main×4 + Sec) × (ATT_arma / 100) × (1 + ATT%) × (1 + Damage% + BossDmg%) × Fator_IED × Fator_Crit × (1 + FinalDmg%)
```

| Bloco | Fórmula | Origem típica |
| :--- | :--- | :--- |
| **DanoSkill** | multiplicador da skill | skills |
| **Stat** | `Main×4 + Sec` | stats base (STR/DEX/INT/LUK) |
| **Weapon ATT** | `ATT_arma / 100` | arma (+ ★16★+) |
| **Attack%** | `1 + ATT%` | **WSE** ([[DESIGN-028 Equipamentos\|DESIGN-028]] §5) |
| **Dano Total** | `1 + Damage% + BossDmg%` | gear/potential/skills |
| **IED** | `1 − PDR_alvo × (1 − IED_total)` | **WSE** |
| **Crítico** | `1 + CritChance × CritDmg%` (esperado) | gear/potential |
| **Final Damage%** | `1 + FinalDmg%` | raro/endgame |

> **Main/Sec** por classe (MapleStory-like): Guerreiro → **STR** (sec: DEX); Arqueiro → **DEX** (sec: STR); Mago → **INT** (sec: LUK). Arqueiro usa **ATT**, Mago usa **MATT**.

## 3. Regra de Ouro
- **Aditivo DENTRO do bloco:** `Damage%` **soma** com `BossDmg%` → retorno **decrescente**.
- **Multiplicativo ENTRE blocos:** cada bloco **multiplica** os outros → equilíbrio > concentração.
- Consequência prática: no endgame, **ATT%** costuma valer mais que **BossDmg%** (porque Boss já acumulou).

## 4. IED (Ignore Enemy Defense)
- **Combinação multiplicativa** de várias fontes: `IED_total = 1 − Π(1 − ied_i)`.
- Aplicado à defesa do alvo (**PDR**): dano efetivo **×** `(1 − PDR × (1 − IED_total))`.
- **Retorno decrescente:** se o alvo tem PDR alto e você tem **pouco** IED, subir IED é o **maior** ganho de dano; se já tem muito, o ganho cai.

## 5. Crítico e nossos stats extras
- **Crítico:** `CritChance` (%) × `CritDmg%`. Valor **esperado** = `1 + (CritChance × CritDmg%)`.
- **`Damage%`** e **`Critical Damage%`** são stats **desta game** (não existem como bloco separado no MapleStory; aqui `Damage%` entra em **Dano Total** e `CritDmg%` entra em **Crítico**).

## 6. Contrato Funcional (I/O)
- **Entrada:** stats agregados do personagem + stats da skill + **PDR** do alvo.
- **Saída:** `dano` por hit (BigNumber).

## 7. Casos de Borda
- **PDR = 0** → IED é irrelevante (fator 1).
- **IED = 100%** → ignora toda a defesa (cap: definir se 100% é atingível).
- **Sem crit** → bloco crítico = 1.
- Overflow/exponenciais → BigNumber ([[CONTEXT-004 Notacao Numerica|CONTEXT-004]]).

## 8. UI/UX e Feedback
- Tooltip de stats **separado por bloco** (ajuda o jogador a ver o que está "curto").
- Preview do **Δ de dano** ao trocar gear/Potential.

## 9. Relacionados
- Equipamentos: [[DESIGN-028 Equipamentos|DESIGN-028]] · Potential: [[DESIGN-029 Potential|DESIGN-029]] · Estrelas: [[DESIGN-030 Star Force|DESIGN-030]].
- Valores: [[DATA-009 Dano|DATA-009]]. Referência: `99-Inbox/reference/MAPLESTORY_GEAR_REFERENCE.md`.
