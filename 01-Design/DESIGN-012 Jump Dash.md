---
id: DESIGN-012
aliases:
  - DESIGN-012
title: "Mechanic: Jump Dash"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Habilidade de movimento do Guerreiro; melhora muito o feel, mas o core loop valida sem ela.
dependencies:
  - "[[DESIGN-006 Meta Espacial|DESIGN-006]]"
  - "[[DESIGN-025 Navegacao & Movimento|DESIGN-025]]"
skill_tags:
  - delivery:instant
  - target:self
  - role:mobility
  - archetype:all
---

# [DESIGN-012] Mechanic: Jump Dash

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** o core loop valida sem ela; melhora mobilidade/feel. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Um **dash horizontal no ar** (estilo dash aéreo de *MapleStory*). É a **habilidade de movimento do Guerreiro** ([[DESIGN-005 Classes|DESIGN-005]]), **desbloqueada ao virar Guerreiro** (nível 10) e **mantida** pelas sub-especializações (Guerreiro Bosser/Mobber/Suporte). Em **mapas horizontais**, é o que separa builds ágeis das lentas ([[DESIGN-006 Meta Espacial|DESIGN-006]]).

## 2. Definição Formal
- Em pleno ar, o dash aplica impulso horizontal `dashSpeed` por `dashDuration` ms, com cooldown `dashCooldown`.
- O dash **define a velocidade horizontal** e **interrompe o ganho de altura**: a partir do disparo, o arco passa a ser de **queda**. (É isso que torna o **timing** relevante — ver §4.)
- Não muda a **gravidade**; muda **quando** a subida para.

## 3. Input (manual)
- **No ar:** um **2º input de pulo** → **dash automático**.
- **No chão:** input do dash → **pula → pequena espera → dash**.
- Reusa o **mesmo input de pulo**.

## 4. Interações
- **Navegação:** o planejador ([[DESIGN-025 Navegacao & Movimento|DESIGN-025]] §6) usa 3 modos (sem dash / dash no ápice / dash antecipado) conforme a geometria do alvo. **Não** se usa o dash para subir plataformas em 90°.
- **Combate:** pode cancelar *knockback* recebido (a definir).

## 5. Parâmetros
- `dashSpeed`, `dashDuration`, `dashCooldown`, limite de dashes por salto; escalonamento por nível da habilidade → [[DATA-XXX]].

## 6. Casos de Borda
- Dash contra parede/tela; spam de input; dash durante skill; dash perto do teto (Modo 2); dash offline (catch-up ignora).

## 7. UI/UX e Feedback
- Rastro/afterimage; som curto de impulso.

## 8. Ganchos para o Futuro
- Variantes: dash vertical, dash teleporte, dashes encadeados por sub-classe.
