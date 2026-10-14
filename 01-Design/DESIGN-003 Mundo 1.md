---
id: DESIGN-003
aliases:
  - DESIGN-003
title: "Mundo 1: Rascunho"
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

# [DESIGN-003] Mundo 1: Rascunho

> Nó-semente de exemplo para demonstrar a hierarquia ([[CONTEXT-006 Hierarquia|CONTEXT-006]]). Renomear/expandir quando o tema for definido.

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Pertence à F2 (Vertical Slice). Ver [[CONTEXT-005 Roadmap|CONTEXT-005]].
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Tema & Visão
- _(a definir)_ tema visual e ambientação.

## 2. Níveis
- **Hub (Level1_0)** + **5 níveis com inimigos (Level1_1…Level1_5)** (`parent` aponta para este mundo). Semente: [[DESIGN-004 Level1_0|DESIGN-004]].

## 3. Desbloqueio
- **Entrada:** início da campanha.
- **Saída:** completar o Level1_5 libera o Mundo 2.

## 4. População & Inimigos
- _(a definir)_.

## 5. Parâmetros
- Curvas → [[DATA-XXX]].

## 6. Mecânicas Transversais
- **#1 — [[DESIGN-013 Selos|Selos (Stamps)]]** (coleção dropada de mobs; account-wide).
- #2 — [[DESIGN-014 Osiris|Osíris (Golem dos Cristais)]]
- #3 — [[DESIGN-016 Cartas|Cartas & Pacotinhos]]
- **Hub (1-1):** [[DESIGN-017 Interactables & Hub|DESIGN-017]] — NPCs/estações dos sistemas (Selos, Osíris, Cartas).
- **Acesso Rápido:** [[DESIGN-018 Menu de Acesso Rapido|DESIGN-018]] — atalhos na UI para os sistemas já desbloqueados.

## 7. Mapa da Árvore
```text
Mundo 1
├── Level1_0 (Hub)
├── Level1_1
├── Level1_2
├── Level1_3
├── Level1_4
└── Level1_5 (fecha o mundo)
```
