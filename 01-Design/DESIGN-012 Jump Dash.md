---
id: DESIGN-012
aliases:
  - DESIGN-012
title: "Mechanic: Jump Dash"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Mobilidade horizontal estilo MapleStory; melhora o feel, mas o core loop valida sem ela.
dependencies:
  - "[[DESIGN-006 Meta Espacial|DESIGN-006]]"
---

# [DESIGN-012] Mechanic: Jump Dash

## 0. Prioridade MoSCoW
- **Categoria:** Should · **Justificativa:** o core loop valida sem ela; melhora mobilidade/feel. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Um **dash horizontal no ar** (estilo dash aéreo de *MapleStory*), que dá mobilidade e reposicionamento. Em **mapas horizontais**, é o que separa builds ágeis das lentas ([[DESIGN-006 Meta Espacial|DESIGN-006]]).

## 2. Definição Formal
- Em pleno ar, o dash aplica impulso horizontal de `dashSpeed` por `dashDuration` ms, com cooldown `dashCooldown`.
- Não altera a gravidade vertical (mantém a queda).

## 3. Interações
- Combina com tap-to-move e com a mobilidade esperada em mapas largos.
- Pode cancelar knockback recebido (a definir).

## 4. Parâmetros
- `dashSpeed`, `dashDuration`, `dashCooldown`, limite de dashes por salto → [[DATA-XXX]].

## 5. Casos de Borda
- Dash contra parede/tela; spam de input; dash durante skill; dash offline (catch-up ignora).

## 6. UI/UX e Feedback
- Rastro/afterimage; som curto de impulso.

## 7. Ganchos para o Futuro
- Variantes: dash vertical, dash teleporte, dashes encadeados por classe ([[DESIGN-005 Classes|DESIGN-005]]).
