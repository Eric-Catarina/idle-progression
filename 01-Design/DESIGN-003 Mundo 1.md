---
id: DESIGN-003
aliases:
  - DESIGN-003
title: "Mundo 1: A Árvore Gigante"
type: system-design
subtype: world
status: Draft
moscow: Should
moscow_note: Conteúdo da F2 (Vertical Slice); a estrutura é Must, mas o tema do mundo é adiável.
parent: "[[DESIGN-002 Campanha|DESIGN-002]]"
path: "Campanha / Mundo 1"
dependencies:
  - "[[CONTEXT-006 Hierarquia|CONTEXT-006]]"
---

# [DESIGN-003] Mundo 1: A Árvore Gigante

> Mundo inicial: **floresta** numa ilha flutuante do **mar astral**; a campanha do mundo é a **subida da Árvore Gigante** até a **copa** (chefe **Vorax**). Hierarquia: [[CONTEXT-006 Hierarquia|CONTEXT-006]].

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Pertence à F2 (Vertical Slice). Ver [[CONTEXT-005 Roadmap|CONTEXT-005]].
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Tema & Visão
- **Bioma: Floresta** — ilha verde flutuante no **mar astral** ([[CONTEXT-009 Direcao de Arte|CONTEXT-009]]).
- **A jornada:** subir a **Árvore Gigante** até a **copa** no topo, onde está o **chefe Vorax**.
- Fauna **fofa/selvagem** nos níveis iniciais; o **arcano/autômato** fica para **mundos tardios**.

## 2. Níveis — a Jornada da Árvore
| Nível | Papel | No mapa |
| :--- | :--- | :--- |
| **Level1_0** | **Hub** (base da Árvore) | [[DESIGN-004 Level1_0\|DESIGN-004]] |
| **Level1_1** | 1º combate — **raízes/solo** | [[DESIGN-020 Level1_1\|DESIGN-020]] |
| **Level1_2** | combate — **mata baixa** (NPC `selos`) | [[DESIGN-019 Level1_2\|DESIGN-019]] |
| **Level1_3** | combate — **mata média** (NPC `osiris`) | [[DESIGN-021 Level1_3\|DESIGN-021]] |
| **Level1_4** | **escalada dentro do tronco** (vertical) | [[DESIGN-022 Level1_4\|DESIGN-022]] |
| **Level1_5** | **copa** — chefe **Vorax** | [[DESIGN-024 Level1_5\|DESIGN-024]] |

- `parent` de cada nível aponta para este mundo.

## 3. Desbloqueio
- **Entrada:** início da campanha.
- **Saída:** completar o Level1_5 libera o Mundo 2.

## 4. População & Inimigos
Roleta **F1 — Bichinhos da Mata**:

| Nível | Mob | Recurso base | Carta (bônus por tier) |
| :--- | :--- | :--- | :--- |
| 1-1 | **Lesma** | **Gosma** | `+{12/tier}` Base HP |
| 1-2 | **Cogumelo** | **Esporo** | `+{7/tier}` Base Damage |
| 1-3 | **Vespão** | **Ferrão** | `+{1/tier}%` Crit Chance |
| 1-4 | **Esquilo Coletor** | **Avelã** | `+{5/tier}%` Money from Monsters |
| 1-5 | **Coruja Sábia** | **Pena** | `+{5/tier}%` Card Drop Chance |

- **Chefe:** **Vorax** (copa da Árvore, **Level1_5**) → dá a **Relíquia de Vorax** ([[DESIGN-032 Gear Sets|DESIGN-032]]).
- Nome das **cartas** = nome do mob ([[DESIGN-016 Cartas|DESIGN-016]]); o **recurso base** alimenta o [[DESIGN-034 Livro dos Contratos|Livro dos Contratos]].

## 5. Parâmetros
- Curvas → [[DATA-XXX]].

## 6. Mecânicas Transversais
- **#1 — [[DESIGN-013 Selos|Selos (Stamps)]]** (coleção dropada de mobs; account-wide).
- #2 — [[DESIGN-014 Osiris|Osíris (Golem dos Cristais)]]
- #3 — [[DESIGN-016 Cartas|Cartas & Pacotinhos]]
- **#4 — [[DESIGN-034 Livro dos Contratos|Livro dos Contratos]]** (tracking de abates → **Multikill**; desbloqueado no **chefe do Mundo 1**).
- **Hub (1-1):** [[DESIGN-017 Interactables & Hub|DESIGN-017]] — NPCs/estações dos sistemas (Selos, Osíris, Cartas).
- **Acesso Rápido:** [[DESIGN-018 Menu de Acesso Rapido|DESIGN-018]] — atalhos na UI para os sistemas já desbloqueados.

## 7. Mapa da Árvore
```text
Mundo 1 — a Jornada da Árvore
├── Level1_0 (Hub — base da Árvore)
├── Level1_1 (raízes/solo)
├── Level1_2 (mata baixa)
├── Level1_3 (mata média)
├── Level1_4 (escalada no tronco — vertical)
└── Level1_5 (copa — chefe Vorax)
```
