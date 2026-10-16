---
id: DESIGN-042
aliases:
  - DESIGN-042
title: "Mundo 2"
type: system-design
subtype: world
status: Draft
moscow: Should
moscow_note: Próximo mundo da campanha; entra depois de fechar o Mundo 1 (o hub já existe).
parent: "[[DESIGN-002 Campanha|DESIGN-002]]"
path: "Campanha / Mundo 2"
dependencies:
  - "[[DESIGN-002 Campanha|DESIGN-002]]"
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
---

# [DESIGN-042] Mundo 2

> **Esqueleto.** O mundo foi criado para **fechar a campanha do Mundo 1** (a fase de chefe leva pra cá). **Conteúdo, tema, mobs e sistemas estão `TBD`** — não inventar aqui.

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** é o **destino** depois do chefe do Mundo 1 — a promessa que dá sentido ao finale. O conteúdo só se especifica **depois** do Mundo 1 jogável. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Tema & Visão
- **Tema:** `TBD`.
- **Bioma:** `TBD` (o Mundo 1 é floresta; o espaço está aberto).
- **A jornada:** `TBD`.

## 2. Níveis — a Jornada
| Nível | Papel | No mapa |
| :--- | :--- | :--- |
| **Level2_1** | **Hub** | [[DESIGN-043 Level2_1\|DESIGN-043]] |
| `Level2_2`+ | combate | `TBD` |

- `parent` de cada nível aponta para este mundo.

## 3. Desbloqueio
- **Entrada:** derrotar **Vorax** ([[DESIGN-041 Level1_Boss1|Level1_Boss1]]) — o **Portal Saída** da fase de chefe leva ao hub `Level2_1`.
- **Saída:** `TBD`.

## 4. População & Inimigos
- `TBD` (roleta, mobs, cartas, essência do mundo).

## 5. Mecânicas Transversais
- `TBD` — cada mundo tem o **seu próprio** Livro dos Contratos ([[DESIGN-034 Livro dos Contratos|DESIGN-034]] §2); os demais sistemas do Mundo 2 estão em aberto.

## 6. Relacionados
- Campanha: [[DESIGN-002 Campanha|DESIGN-002]] · Mundo anterior: [[DESIGN-003 Mundo 1|DESIGN-003]] · Chefe que libera: [[DESIGN-041 Level1_Boss1|DESIGN-041]].
- Hub: [[DESIGN-043 Level2_1|DESIGN-043]] · Layout/tiles: [[DATA-006 Level Layout|DATA-006]].
