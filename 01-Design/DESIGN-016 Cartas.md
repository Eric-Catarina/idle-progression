---
id: DESIGN-016
aliases:
  - DESIGN-016
title: "Cartas & Pacotinhos"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Mecânica transversal #3 do Mundo 1; coleção progressiva (cartas sobem de tier por acúmulo), mas o core loop valida sem ela.
dependencies:
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
  - "[[DESIGN-013 Selos|DESIGN-013]]"
  - "[[CONTEXT-007 Raridades|CONTEXT-007]]"
data_spec: "[[DATA-005 Cartas Odds|DATA-005]]"
---

# [DESIGN-016] Cartas & Pacotinhos

> **Mecânica Transversal #3 do [[DESIGN-003 Mundo 1|DESIGN-003]] (Mundo 1).**
> Inspiração: **IdleOn** (cartas que **sobem de tier** acumulando cópias) + **raridade compartilhada** ([[CONTEXT-007 Raridades|CONTEXT-007]]).
> Referência bruta: `99-Inbox/reference/IDLEON_CARDS_REFERENCE.md` (**não** carrega por padrão).

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Eixo de coleção/dopamina que dá motivo para farmar mapas, mas o core loop valida sem ela (F2).
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Uma **coleção de cartas** que **cresce sozinha**: cada carta **sobe de tier** conforme você junta cópias, ficando mais forte e mais bonita. Diferente de um gacha de raridade fixa, aqui a **raridade é uma conquista** — o fim é ter a carta **Divina**. É o eixo "farmar por coleção" que **conversa com mapas, mobs e drops**.

## 2. Como Funcionam
- **Carta:** ligada a um **mob** (logo, a um nível/mundo). Ex.: `Level1_1` → *Carta do Mob 1-1*.
- **Obtenção:** drop do mob (cada roll dá **1 cópia**) **ou** abertura de **pacotinhos**.
- **Coleção account-wide:** `cards[id] = nº de cópias` (compartilhada por todos os personagens).
- **Equipar por personagem:** a carta só dá bônus a quem **equipou** (N slots por personagem).
- **Subir de tier:** ao atingir o **requisito de cópias** (§3), a carta sobe de tier e o bônus cresce.

## 3. Tiers das Cartas (escala de raridade)
O **tier da carta usa a escala compartilhada** ([[CONTEXT-007 Raridades|CONTEXT-007]]) — **Comum → Raro → Épico → Lendário → Extraordinário → Divino** (mesmas cores/bordas, glow crescente).

- **Requisito de cópias** e **bônus** por tier → [[DATA-005 Cartas Odds|DATA-005]].
- **Bônus por tier:** `Bônus(tier) = Base × tier` — é o padrão `+{X per tier}` (ex: `+{12 per tier}` Base HP).
- Ao subir de tier → a **borda da carta muda** (juice imediato) e o bônus é recalculado.

## 4. Contrato Funcional (I/O)
- **Gatilho:** morte de mob (roll de drop) / abrir pacote.
- **Pré-requisitos:** —
- **Saída:** `cards[id] += 1`; recalcula **tier** e **soma dos bônus equipados**; persiste.

## 5. Cartas do Mundo 1
| Nível | Carta | Bônus (por tier) |
| :--- | :--- | :--- |
| **Level1_1** | Carta do Mob 1-1 | `+{12 per tier}` **Base HP** |
| **Level1_2** | Carta do Mob 1-2 | `+{7 per tier}` **Base Damage** |
| **Level1_3** | Carta do Mob 1-3 | `+{1 per tier}%` **Critical Chance** |
| **Level1_4** | Carta do Mob 1-4 | `+{5 per tier}%` **Money from Monsters** |
| **Level1_5** | Carta do Mob 1-5 | `+{5 per tier}%` **Card Drop Chance** |

> O **nome final** de cada carta = nome do **mob** daquele nível (população em [[DESIGN-003 Mundo 1|DESIGN-003]] §4).

## 6. Cartas Novas (drop reforçado)
Uma carta com **0 cópias** tem chance de drop **muito maior** — para acelerar a coleção. Após ter **≥ 1** cópia, cai para a chance normal. Fator exato → [[DATA-005 Cartas Odds|DATA-005]].

## 7. Pacotinhos
- **Tipos:** seguem a **escala de raridade** — `Pacote Comum … Pacote Divino` (os tipos exatos ainda **a decidir**).
- Cada pacote concede **N cópias** de cartas sorteadas por peso do tier (pacotes altos enviesam para tiers altos).
- **Diário:** 1 pacote grátis/dia. **Pity:** a definir.
- **Fonte:** moedas, recompensas de nível/mundo e dailies.

## 8. Sets (Should — a definir)
Montar **conjuntos** (por mundo/mob) concede bônus extra; a "força" do set pondera o **tier** de cada carta que o compõe (cartas mais altas contam mais). Efeitos: +% drop no Mundo 1, +% dano em área (mobbing), +% dano vs bosses, etc.

## 9. Casos de Borda
- Pacote sem cartas novas → vira **poeira** de carta.
- Duplicata de tier alto → poeira proporcional.
- Overflow de bônus (BigNumber / [[CONTEXT-004 Notacao Numerica|CONTEXT-004]]).
- Equipar carta não coletada (bloqueado).
- **Multikill não afeta cartas** ([[DESIGN-033 Multikill|DESIGN-033]] §4).

## 10. UI/UX e Feedback
- **Álbum** com a **borda por tier** ([[CONTEXT-007 Raridades|CONTEXT-007]]); brilho/animação crescem com o tier.
- Barra de progresso de cópias até o **próximo tier**.
- Abertura de pacote animada (dopamina).

## 11. Ganchos para o Futuro (inspirados no IdleOn)
- **Presets** de cartas por personagem (troca rápida).
- **Filtro de loot** (ignorar itens específicos do droptable).
- **Cartas passivas** (bônus sempre ativo, sem equipar).
- **Upgrade direto** de tier via item raro (ex.: "Cardifier").
- 7º tier+ se a curva exigir ([[DATA-005 Cartas Odds|DATA-005]] cita o valor seguinte).

## 12. Relacionados
- Mundo: [[DESIGN-003 Mundo 1|DESIGN-003]] · Raridade: [[CONTEXT-007 Raridades|CONTEXT-007]] · Curvas: [[DATA-005 Cartas Odds|DATA-005]].
- Outros eixos do Mundo 1: [[DESIGN-013 Selos|DESIGN-013]] · [[DESIGN-014 Osiris|DESIGN-014]].
- Descoberta do sistema (NPC `cartas`): [[DESIGN-017 Interactables & Hub|DESIGN-017]].
