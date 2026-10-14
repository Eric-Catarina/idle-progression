---
id: DESIGN-035
aliases:
  - DESIGN-035
title: "Essência (Recurso do Mundo)"
type: system-design
subtype: system
status: Draft
moscow: Should
moscow_note: Recurso-base do Mundo 1 (único recurso de mob); alimenta os 4 sistemas do mundo.
dependencies:
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
  - "[[DESIGN-013 Selos|DESIGN-013]]"
  - "[[DESIGN-014 Osiris|DESIGN-014]]"
  - "[[DESIGN-016 Cartas|DESIGN-016]]"
  - "[[DESIGN-034 Livro dos Contratos|DESIGN-034]]"
data_spec: "[[DATA-012 Essencia Custos|DATA-012]]"
---

# [DESIGN-035] Essência (Recurso do Mundo)

> Inspiração: recursos-base de **IdleOn** (craft/upgrade) · **etc-drops/quests** do MapleStory · **Forge/Pots** do RotMG — condensados num **recurso único por mundo**.

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** é o **combustível** que liga os sistemas do Mundo 1 entre si (farmar → gastar → evoluir). Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Em vez de **um recurso por mob**, cada **mundo** tem **uma essência**. Ela é o **único recurso dropado** pelos mobs e o **combustível** que move **todos** os sistemas do mundo. Isso concentra o farm num só recurso e cria **decisões** (em qual sistema gastar).

| Mundo | Essência |
| :--- | :--- |
| **Mundo 1** | **Essência Verde** 🟢 |

- **World-local:** a essência de um mundo não vale no outro (não há mistura entre mundos).

## 2. Obtenção
- **Todos** os mobs do Mundo 1 dropam **Essência Verde** (sem drops de recurso por mob).
- O **[[DESIGN-033 Multikill|Multikill]]** multiplica a essência: `essência × (1 + (tier−1) × MK%)`.

## 3. Sinks — a "espinha" do Mundo 1
A essência alimenta os **4 sistemas** do mundo:

| Sink | Sistema | O que compra |
| :--- | :--- | :--- |
| **Selos** | [[DESIGN-013 Selos\|DESIGN-013]] | subir o **nível** de um selo |
| **Cartas** | [[DESIGN-016 Cartas\|DESIGN-016]] | **forjar** uma carta específica (essência **+ poeira**) |
| **Osíris** | [[DESIGN-014 Osiris\|DESIGN-014]] | **Impulso**: acelerar a produção de cristais |
| **Livro dos Contratos** | [[DESIGN-034 Livro dos Contratos\|DESIGN-034]] | **Expandir** contrato (tier cap) / **Renegociar** (MK% por ponto) |

> Custos e curvas → [[DATA-012 Essencia Custos|DATA-012]]. Custos **exponenciais** (BigNumber), já que o Multikill faz a essência escalar.

## 4. Contrato Funcional (I/O)
- **Gatilho:** comprar upgrade em qualquer um dos 4 sistemas.
- **Pré-requisitos:** `essência ≥ custo`.
- **Saída:** `essência -= custo`; efeito do sink aplicado; persistido.

## 5. Casos de Borda
- **Saldo insuficiente** → ação bloqueada.
- **Overflow** de essência (BigNumber / [[CONTEXT-004 Notacao Numerica|CONTEXT-004]]).
- Essência é **world-local** — trocar de mundo zera o contexto (não há conversão entre mundos).
- Custos enormes em upgrades altos → **catch-up offline** usa a fórmula analítica.

## 6. UI/UX e Feedback
- HUD mostra a **Essência do mundo atual** (🟢) + a **taxa/s** (farm em tempo real).
- Cada tela de sistema mostra o **custo em Essência** e o **saldo**.

## 7. Ganchos para o Futuro
- **Trocar Essência ↔ Ouro** (válvula entre o mundo e a economia global).
- **Forja de gear** (craft/desmanche) usando essência — se promovermos [[DESIGN-028 Equipamentos|Equipamentos]] §9.
- Outras essências (outros mundos) com sinks próprios.

## 8. Relacionados
- Mundo: [[DESIGN-003 Mundo 1|DESIGN-003]] · Multikill: [[DESIGN-033 Multikill|DESIGN-033]] · Livro: [[DESIGN-034 Livro dos Contratos|DESIGN-034]].
- Sistemas: [[DESIGN-013 Selos|DESIGN-013]] · [[DESIGN-014 Osiris|DESIGN-014]] · [[DESIGN-016 Cartas|DESIGN-016]] · Custos: [[DATA-012 Essencia Custos|DATA-012]].
