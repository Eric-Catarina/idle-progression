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
  - "[[CONTEXT-001 MoSCoW|CONTEXT-001]]"
tags:
  - design
  - priority
  - index
  - moscow
---

# 🎯 [DESIGN-000] MoSCoW Priority Board

> **Fonte de verdade da priorização do projeto.** Consulte antes de criar qualquer novo `DESIGN`.
> Regras completas em [[CONTEXT-001 MoSCoW|CONTEXT-001]]. Escopo do protótipo = **Must + Should**.

---

## 🔴 Must have — Escopo do Protótipo

Sem estes, o core loop não é validável. Implementação bloqueante.

| ID | Feature | Status | SYSTEM | DATA |
| :--- | :--- | :--- | :--- | :--- |
| [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] | Movimento **tap-to-move** (destino via grafo de nós) | Spec Ready | [[SYSTEM-002 NavGraph & Pathfinding|SYSTEM-002]] | [[DATA-XXX]] |
| [[DESIGN-031 Calculo de Dano|DESIGN-031]] | Cálculo de **dano multiplicativo** | Draft | — | [[DATA-009 Dano|DATA-009]] |
| [[DESIGN-036 Skills & Fila de Skills|DESIGN-036]] | **Skills & Fila de Skills** (combate idle) | Draft | — | [[DATA-009 Dano\|DATA-009]] · [[DATA-013 XP e Nivel\|DATA-013]] |
| [[DESIGN-038 Pets|DESIGN-038]] | **Pets** (coleção account-wide, tiros diário/semanal, premium) | Draft | [[SYSTEM-005 Pets & Gacha\|SYSTEM-005]] | [[DATA-015 Pets Odds\|DATA-015]] |
### Candidatos Must derivados do Core Loop (a especificar)
- ~~Movimento **tap-to-move** (destino via grafo de nós)~~ → ✓ especificado em [[DESIGN-025 Navegacao & Movimento|DESIGN-025]].
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
| [[DESIGN-012 Jump Dash|DESIGN-012]] | Habilidade de movimento — **Guerreiro** | Draft | Navegação ([[DESIGN-025 Navegacao & Movimento|DESIGN-025]]) |
| [[DESIGN-026 Blink|DESIGN-026]] | Habilidade de movimento — **Mago** | Draft | Navegação |
| [[DESIGN-027 Slide Jump|DESIGN-027]] | Habilidade de movimento — **Arqueiro** | Draft | Navegação |
| [[DESIGN-028 Equipamentos|DESIGN-028]] | **Slots, tipos e raridade** do gear (8 slots) | Draft | [[DESIGN-029 Potential\|DESIGN-029]] · [[DESIGN-030 Star Force\|DESIGN-030]] |
| [[DESIGN-029 Potential|DESIGN-029]] | **Linhas de Potential** (1–6) + reset com Ouro | Draft | [[DATA-007 Potentials\|DATA-007]] |
| [[DESIGN-030 Star Force|DESIGN-030]] | **Estrelas** (0–25) com risco de destruição | Draft | [[DATA-008 Star Force\|DATA-008]] |
| [[DESIGN-032 Gear Sets|DESIGN-032]] | **Sets de gear** (bônus por conjunto) | Draft | [[DATA-010 Gear Sets\|DATA-010]] |
| [[DESIGN-033 Multikill|DESIGN-033]] | **Multikill** (tiers de abate → recurso base) | Draft | [[DESIGN-034 Livro dos Contratos\|DESIGN-034]] |
| [[DESIGN-034 Livro dos Contratos|DESIGN-034]] | **Livro dos Contratos** (farm account-wide) | Draft | [[DATA-011 Multikill e Contratos\|DATA-011]] |
| [[DESIGN-035 Essencia|DESIGN-035]] | **Essência** (recurso do mundo; alimenta os 4 sistemas) | Draft | [[DATA-012 Essencia Custos\|DATA-012]] |
| [[DESIGN-037 Linhas de Dano|DESIGN-037]] | **Linhas de dano** (multi-hit + teto por linha) | Draft | [[DATA-009 Dano\|DATA-009]] |
| [[DESIGN-039 Loja de Gemas|DESIGN-039]] | **Loja de Gemas** (IAP, 1 USD = 500 gemas) | Draft | [[DATA-016 Loja de Gemas\|DATA-016]] |
| [[DESIGN-040 Tamanho de Habilidade|DESIGN-040]] | **Tamanho de Habilidade** (`+Ability Size%`, genérico + por skill) | Draft | [[DATA-017 Tamanho de Habilidade\|DATA-017]] |

---

## 🟢 Could have — Backlog (Guardado para o Futuro)

Documentado, **sem código**. Vive em `01-Design/backlog/`.

| ID | Feature | Arquivo | Promover Quando |
| :--- | :--- | :--- | :--- |
| DESIGN-001 | Múltiplos Personagens no Mesmo Mapa | [[DESIGN-001 Multi Personagens|DESIGN-001]] | Core loop validado e necessidade de profundidade tática. |

---

## ⚫ Won't have — Fora de Escopo (Fase Atual)

Documentado para evitar retrabalho e ambiguidade. Sem ganchos.

| Ideia | Motivo da Exclusão |
| :--- | :--- |
| Multiplayer online | Complexidade de rede desproporcional ao protótipo. |
| Renderização 3D | O jogo é 2D por design. |

---

## 📌 Como Usar

1. Ao criar uma feature, classifique com [[CONTEXT-001 MoSCoW|CONTEXT-001]].
2. `Must`/`Should` → criar `DESIGN-XXX` em `01-Design/`.
3. `Could` → criar `DESIGN-XXX` em `01-Design/backlog/` com `status: Backlog`.
4. `Wont` → registrar a exclusão aqui, sem criar arquivo.
5. Atualize esta tabela sempre que um item mudar de categoria.
