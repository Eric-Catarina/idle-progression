---
id: DESIGN-031
aliases:
  - DESIGN-031
title: "Cálculo de Dano (Multiplicativo)"
type: system-design
subtype: mechanic
status: Draft
moscow: Must
moscow_note: Combate básico é Must; sem a fórmula o combate não resolve.
dependencies:
  - "[[DESIGN-028 Equipamentos|DESIGN-028]]"
  - "[[DESIGN-029 Potential|DESIGN-029]]"
data_spec: "[[DATA-009 Dano|DATA-009]]"
---

# [DESIGN-031] Cálculo de Dano (Multiplicativo)

> Inspiração: fórmula do **MapleStory** (blocos multiplicativos), **com duas mudanças nossas**: (1) o **ATT foi removido** e virou **Damage**; (2) **não há bloco aditivo** — `Damage%` e `Boss Damage%` são **blocos próprios**.
> Referência bruta em `99-Inbox/reference/MAPLESTORY_GEAR_REFERENCE.md`.

## 0. Prioridade MoSCoW
- **Categoria:** Must
- **Justificativa:** sem a fórmula **não há combate**. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
O dano é **multiplicativo entre todos os blocos**. Cada fonte de aumento (gear, Potential, estrelas, skills, sets) é **um multiplicador próprio**. Empilhar o mesmo multiplicador não sofre "desgaste" — então o balanceamento é controlado pelo **número** de blocos e pelos **caps**, não por retorno decrescente.

## 2. Fórmula (blocos)

```text
DanoFinal ≈ DanoSkill × (Main×4 + Sec + Tert) × (Damage_arma / 100) × (1 + Damage%) × (1 + BossDamage%) × Fator_IED × Fator_Crit × (1 + FinalDamage%)
```

| Bloco | Fórmula | Origem |
| :--- | :--- | :--- |
| **DanoSkill** | multiplicador da skill | skills |
| **Stat** | `Main×4 + Sec + Tert` | stats base (STR/DEX/INT/LUK) |
| **Damage (flat)** | `Damage_arma / 100` | **arma** (+ bônus de ★16★+) |
| **Damage%** | `1 + Damage%` | **WSE** (arma/badge) |
| **Boss Damage%** | `1 + BossDamage%` | **WSE** |
| **IED** | `1 − PDR × (1 − IED_total)` | **WSE** |
| **Crítico** | `1 + CritChance × CritDamage%` | gear |
| **Final Damage%** | `1 + FinalDamage%` | endgame |

### Stats por classe (Main / Sec / Tert)
| Classe | Main ×4 | Sec ×1 | Tert ×1 |
| :--- | :--- | :--- | :--- |
| **Guerreiro** | STR | DEX | LUK |
| **Arqueiro** | DEX | STR | LUK |
| **Mago** | INT | LUK | DEX |

> Assim **todos os 4 stats têm utilidade** (cada um é Main de uma classe e Sec/Tert de outras). Pesos (`4/1/1`) são configuráveis.

## 3. Regra Geral
- **Multiplicativo** entre **todos** os blocos → sem retorno decrescente por empilhamento.
- `Damage vs Monsters%` (normal) e `Boss Damage%` (chefe) são **blocos condicionais** ao tipo de alvo.
- **Implicação de balanceamento:** o poder cresce com o **produto** dos blocos; como não há "desgaste", é preciso **limitar** quantos blocos existem e seus **caps** (ex.: IED ≤ 100%, Crit Chance ≤ 100% — [[DATA-009 Dano|DATA-009]] §5).

## 4. IED (Ignore Enemy Defense)
- **Combinação multiplicativa** de várias fontes: `IED_total = 1 − Π(1 − ied_i)`.
- Aplicado à defesa do alvo (**PDR**): dano efetivo **×** `(1 − PDR × (1 − IED_total))`.
- Mesmo com tudo multiplicativo, o IED tem **retorno decrescente** *por natureza* (progresso assintótico a 100%).

## 5. Crítico e nossos stats extras
- **Crítico:** `CritChance` (%) × `CritDamage%`. Valor **esperado** = `1 + (CritChance × CritDamage%)`.
- **`Critical Damage%`** é stat desta game (não existe como bloco no MapleStory); entra no bloco **Crítico**.
- **`Damage%` substitui o `ATT%`** (o ATT foi removido) — mesma função, nome único.

## 6. Contrato Funcional (I/O)
- **Entrada:** stats agregados do personagem + stats da skill + **PDR** do alvo.
- **Saída:** `dano` por hit (BigNumber).

## 7. Casos de Borda
- **PDR = 0** → IED é irrelevante (fator 1).
- **IED = 100%** → ignora toda a defesa (cap em 100%; ver [[DATA-009 Dano|DATA-009]] §5).
- **Crit Chance = 100%** → sempre crita (cap).
- Valores **acima do cap** → truncados no agregado.
- **Sem crit** → bloco crítico = 1.
- Overflow/exponenciais → BigNumber ([[CONTEXT-004 Notacao Numerica|CONTEXT-004]]).

## 8. UI/UX e Feedback
- Tooltip de stats **separado por bloco** (mostra o que está "curto").
- Preview do **Δ de dano** ao trocar gear/Potential.

## 9. Linhas de Dano (multi-hit)
- A fórmula é **por linha**: uma skill com `lines = N` aplica a fórmula **N vezes**.
- **Dano total** = `Σ linhas`; o alvo pode ter **teto por linha** (`capLinha`) → **mais linhas vencem** contra esses alvos.
- Detalhes → [[DESIGN-037 Linhas de Dano|DESIGN-037]].

## 10. Escalonamento por Nível (validado no protótipo)
- **Stats base:** `10 + (nível − 1)` por stat.
- **Damage (flat) do jogador:** `8 + 3·(nível − 1)` (+ gear).
- ⚠️ **Armadilha:** com isso o dano cresce **~nível²** — a **curva de XP tem que acompanhar**, senão o leveling **dispara** (no 1º teste o jogador chegou a **nível 300+**). Ver [[DATA-013 XP e Nivel|DATA-013]].
- **Caps** de stats → [[DATA-009 Dano|DATA-009]] §5.

## 10. Relacionados
- Equipamentos: [[DESIGN-028 Equipamentos|DESIGN-028]] · Potential: [[DESIGN-029 Potential|DESIGN-029]] · Estrelas: [[DESIGN-030 Star Force|DESIGN-030]] · Sets: [[DESIGN-032 Gear Sets|DESIGN-032]].
- Valores: [[DATA-009 Dano|DATA-009]]. Referência: `99-Inbox/reference/MAPLESTORY_GEAR_REFERENCE.md`.
