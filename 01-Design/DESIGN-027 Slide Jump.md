---
id: DESIGN-027
aliases:
  - DESIGN-027
title: "Mechanic: Slide Jump"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Habilidade de movimento do Arqueiro; o core loop valida sem ela.
dependencies:
  - "[[DESIGN-005 Classes|DESIGN-005]]"
  - "[[DESIGN-025 Navegacao & Movimento|DESIGN-025]]"
skill_tags:
  - delivery:instant
  - target:self
  - role:mobility
  - archetype:all
---

# [DESIGN-027] Mechanic: Slide Jump

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** mobilidade do Arqueiro; enriquece a build, mas o core loop valida sem. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Um **salto raso e longo** — a **habilidade de movimento do Arqueiro** ([[DESIGN-005 Classes|DESIGN-005]]), desbloqueada ao virar Arqueiro (nível 10) e mantida pelas sub-especializações. Na navegação, cobre **vãos horizontais largos** (e passa **por baixo** de plataformas/homens, por ser baixo).

## 2. Definição Formal
- **Slide** no chão (ganha velocidade) seguido de **pulo** → trajetória **longa e baixa** (`slideSpeed`, `slideJumpArc`).
- Comparado ao pulo normal: **mais alcance em X**, **menos altura em Y**.
- Chão: cinemático (o slide é no chão). No ar: balístico como qualquer salto ([[DESIGN-025 Navegacao & Movimento|DESIGN-025]] §2).

## 3. Interações
- Navegação ([[DESIGN-025 Navegacao & Movimento|DESIGN-025]]): aresta `slideJump` para vãos horizontais; útil sob tetos baixos.
- Combate: o slide pode ter i-frames/dano (a definir).

## 4. Parâmetros
- `slideSpeed`, `slideDuration`, `slideJumpArc`, `slideJumpCooldown`, escala por nível → [[DATA-XXX]].

## 5. Casos de Borda
- Slide contra parede/tela; slide na borda (cai); slide pendurado no vão.
- Slide no ar (inválido); spam; slide offline (catch-up ignora).

## 6. UI/UX e Feedback
- Poeira/rastro no slide; som de deslize + impulso.

## 7. Ganchos para o Futuro
- Slide **longo** (Arqueiro Bosser), slide **com recuo**, encadeamento slide→slide.
