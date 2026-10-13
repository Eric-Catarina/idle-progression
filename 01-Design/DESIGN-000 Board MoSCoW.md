---
id: DESIGN-000
aliases:
  - DESIGN-000
title: MoSCoW Priority Board
type: system-design
status: Active
moscow: Must
moscow_note: O board é a fonte de verdade de priorização; deve existir desde o início.
dependencies:
  - "[[CONTEXT-001]]"
tags:
  - design
  - priority
  - index
  - moscow
---

# 🎯 [DESIGN-000] MoSCoW Priority Board

> **Fonte de verdade da priorização do projeto.** Consulte antes de criar qualquer novo `DESIGN`.
> Regras completas em [[CONTEXT-001]]. Escopo do protótipo = **Must + Should**.

---

## 🔴 Must have — Escopo do Protótipo

Sem estes, o core loop não é validável. Implementação bloqueante.

| ID | Feature | Status | SYSTEM | DATA |
| :--- | :--- | :--- | :--- | :--- |
| _DESIGN-XXX_ | _A especificar (ver candidatos abaixo)_ | — | — | — |

### Candidatos Must derivados do Core Loop (a especificar)
- Movimento **tap-to-move** (destino via grafo de nós).
- **One-Way Platforms** (colisão e passagem de baixo para cima).
- **Combate básico** com **Knockback** horizontal.
- **Progressão numérica** exponencial (acúmulo de recursos + upgrades).
- **Prestígio** matemático (reset com multiplicador permanente).
- **Catch-up Simulation** (progresso offline analítico).

---

## 🟡 Should have — Protótipo se Houver Tempo

Agrega valor real; o protótipo funciona sem. Deixar **ganchos** prontos nos `SYSTEM`.

| ID | Feature | Status | Gancho Técnico |
| :--- | :--- | :--- | :--- |
| _DESIGN-XXX_ | _A especificar_ | — | — |

---

## 🟢 Could have — Backlog (Guardado para o Futuro)

Documentado, **sem código**. Vive em `01-Design/backlog/`.

| ID | Feature | Arquivo | Promover Quando |
| :--- | :--- | :--- | :--- |
| DESIGN-001 | Múltiplos Personagens no Mesmo Mapa | [[DESIGN-001]] | Core loop validado e necessidade de profundidade tática. |

---

## ⚫ Won't have — Fora de Escopo (Fase Atual)

Documentado para evitar retrabalho e ambiguidade. Sem ganchos.

| Ideia | Motivo da Exclusão |
| :--- | :--- |
| Multiplayer online | Complexidade de rede desproporcional ao protótipo. |
| Renderização 3D | O jogo é 2D por design. |

---

## 📌 Como Usar

1. Ao criar uma feature, classifique com [[CONTEXT-001]].
2. `Must`/`Should` → criar `DESIGN-XXX` em `01-Design/`.
3. `Could` → criar `DESIGN-XXX` em `01-Design/backlog/` com `status: Backlog`.
4. `Wont` → registrar a exclusão aqui, sem criar arquivo.
5. Atualize esta tabela sempre que um item mudar de categoria.
