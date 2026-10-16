---
id: DESIGN-028
aliases:
  - DESIGN-028
title: "Equipamentos (Slots, Tipos & Raridade)"
type: system-design
subtype: system
status: Draft
moscow: Should
moscow_note: Eixo de progressão de combate; o core loop valida com stats base, mas gear é o que dá longevidade ao farm.
dependencies:
  - "[[CONTEXT-007 Raridades|CONTEXT-007]]"
  - "[[DESIGN-005 Classes|DESIGN-005]]"
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
tech_spec: "[[SYSTEM-XXX]]"
data_spec: "[[DATA-007 Potentials|DATA-007]]"
---

# [DESIGN-028] Equipamentos (Slots, Tipos & Raridade)

> Inspiração: **MapleStory** (WSE, Potential, Star Force) — o sistema de stats deve ser **praticamente idêntico**.
> Referência bruta: `99-Inbox/reference/MAPLESTORY_GEAR_REFERENCE.md` (**não** carrega por padrão).

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Combate básico é `Must`, mas roda com stats base; **gear** é o eixo que dá **longevidade** ao farm (F2). Promover a `Must` se o MVP exigir builds.
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Cada personagem veste **8 peças**. Cada peça tem uma **raridade** (6 tiers, [[CONTEXT-007 Raridades|CONTEXT-007]]) que define **quantas linhas de Potential** ela tem. Evoluir gear = **mais linhas**, **linhas melhores** e **mais estrelas** ([[DESIGN-030 Star Force|Star Force]]) — é onde mora a maior parte do poder de combate.

## 2. Slots (8 por personagem)
| # | Slot | Tipo |
| :--- | :--- | :--- |
| 1 | **Capacete** | Armadura |
| 2 | **Peitoral** | Armadura |
| 3 | **Calça** | Armadura |
| 4 | **Bota** | Armadura |
| 5 | **Arma** | Weapon |
| 6 | **Acessório A** | Accessory |
| 7 | **Acessório B** | Accessory |
| 8 | **Badge** | Badge |

> Sem upgrade de slots (8 é fixo). Sem troca/mercado entre personagens (item é **equipável por quem o vestir**).

## 3. Tipos de Equipamento & Restrições
| Tipo | Restrição de classe | Observação |
| :--- | :--- | :--- |
| **Armadura** | Nenhuma (todos) | capacete/peitoral/calça/bota |
| **Arma** | **Por tipo de arma** (ver tabela) | une a build à classe |
| **Acessório** | Nenhuma (todos) | 2 slots |
| **Badge** | Nenhuma (todos) | carrega linhas estilo **WSE** |

### Armas por classe
| Arma | Classe |
| :--- | :--- |
| Machado · Espada · Lança | **Guerreiro** |
| Arco · Besta | **Arqueiro** |
| Cajado · Varinha | **Mago** |

- A arma só pode ser **equipada** por personagens da classe (base) correspondente — ex.: **arco só Arqueiro**, **machado só Guerreiro** ([[DESIGN-005 Classes|DESIGN-005]]).
- Toda arma dá **Damage** (dano flat) — não há ATT/MATT separados ([[DESIGN-031 Calculo de Dano|DESIGN-031]]).

## 4. Raridade do Equipamento (6 tiers)
Mesma escala compartilhada ([[CONTEXT-007 Raridades|CONTEXT-007]]). Define o **nº de linhas de Potential**:

| Raridade | Linhas de Potential |
| :--- | :--- |
| Comum | **1** |
| Raro | **2** |
| Épico | **3** |
| Lendário | **4** |
| Extraordinário | **5** |
| Divino | **6** |

> Cada linha tem a **sua própria raridade** (ver [[DESIGN-029 Potential|DESIGN-029]]), limitada pela **raridade do item**.

## 5. Stats por Tipo (pool de linhas)
| Tipo | Stats base (flat) | Linhas de Potential (pool) |
| :--- | :--- | :--- |
| **Armadura** | DEF, HP, MP | `HP%`, `STR/DEX/INT/LUK%`, `All Stat%`, `DEF%`, `MP%` |
| **Weapon** | Damage (flat) | `Damage%`, `Boss Damage%`, `IED%`, `Crit Damage%`, `Crit Chance%`, `STR/DEX/INT/LUK%` |
| **Accessory** | HP, MP | `All Stat%`, `STR/DEX/INT/LUK%`, `HP%`, `Crit Chance%`, `Crit Damage%`, `Drop Rate%`, `Money%` |
| **Badge** | — | `Damage%`, `Boss Damage%`, `IED%`, `Crit Damage%` (linhas **WSE**) |

- **WSE** = **W**eapon + **B**adge + (Secondary; aqui o **Badge** faz esse papel) → é onde `Damage%`, `Boss Damage%` e `IED%` "pegam".
- Valores por raridade de linha → [[DATA-007 Potentials|DATA-007]].
- **Removemos o ATT:** `Damage%` (potencial) substitui o `ATT%`; **Critical Damage%** é stat novo ([[DESIGN-031 Calculo de Dano|DESIGN-031]]).
- **Stat novo (proposto):** `Ability Range%` ([[DESIGN-040 Range de Habilidade|DESIGN-040]]) — **ainda não atribuído** a nenhum slot; candidato natural é o **Accessory** (pool de utilidade). A definir.

## 6. Contrato Funcional (I/O)
- **Gatilho:** equipar/desequipar; dropar item; aplicar Potential/estrela.
- **Pré-requisitos:** slot compatível; classe compatível (armas); item coletado.
- **Saída:** stats agregados do personagem recalculados (**pipeline multiplicativo**, [[DESIGN-031 Calculo de Dano|DESIGN-031]]); persistido.

## 7. Casos de Borda
- Arma de outra classe (bloquear equipar, não dropar).
- Dois itens com o mesmo `id` (identidade por **instância**, não por tipo).
- Overflow de stats (BigNumber / [[CONTEXT-004 Notacao Numerica|CONTEXT-004]]).
- Desequipar item com Star Force/ Potential (mantém os rolls, não destrói).

## 8. UI/UX e Feedback
- **Paper-doll** com os 8 slots; **borda por raridade** ([[CONTEXT-007 Raridades|CONTEXT-007]]).
- Tooltip com as linhas de Potential (cor por **raridade da linha**) e o nível de **★**.

## 9. Ganchos para o Futuro
- **Em escopo agora:** **Sets de gear** → [[DESIGN-032 Gear Sets|DESIGN-032]].
- **Fora de escopo por enquanto** (não priorizado): Secondary weapon, **Flames**, linhas travadas/Cubes, subir raridade do item, transferência de ★, safeguarding, transmog.

## 10. Relacionados
- Potential: [[DESIGN-029 Potential|DESIGN-029]] · Estrelas: [[DESIGN-030 Star Force|DESIGN-030]] · Dano: [[DESIGN-031 Calculo de Dano|DESIGN-031]].
- Raridade: [[CONTEXT-007 Raridades|CONTEXT-007]] · Classes: [[DESIGN-005 Classes|DESIGN-005]] · Valores: [[DATA-007 Potentials|DATA-007]].
