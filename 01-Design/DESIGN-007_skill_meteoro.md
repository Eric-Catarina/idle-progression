---
id: DESIGN-007
aliases:
  - DESIGN-007
title: "Skill: Meteoro"
type: system-design
subtype: skill
status: Draft
moscow: Should
moscow_note: Skill de Mobbing vertical; brilha em mapas altos (meta espacial).
dependencies:
  - "[[DESIGN-006]]"
---

# [DESIGN-007] Skill: Meteoro

## 0. Prioridade MoSCoW
- **Categoria:** Should · **Justificativa:** profundidade de skill (F2). Ver [[CONTEXT-001]].

## 1. Visão & Fantasia
Um meteoro é invocado no topo e **atravessa o mapa inteiro na vertical**, explodindo ao impactar. Símbolo de build vertical/física ([[DESIGN-006]]).

## 2. Contrato de Ativação (I/O)
- **Input:** skill na barra.
- **Pré-requisitos:** custo de MP + cooldown (ms) — `[[DATA-XXX]]`.
- **Saída:** spawn de projétil vertical no X-alvo; dano em coluna + explosão.

## 3. Regras de Combate
- **Trajetória:** queda vertical pelo `targetX`, **ignorando one-way platforms**.
- **Acerto:** dano em todos os inimigos da coluna + **AoE** no impacto.
- **Knockback:** empurra levemente para os lados.
- Ideal em **mapas verticais**.

## 4. Escalonamento
- Dano, raio do AoE e cooldown por nível → [[DATA-XXX]].

## 5. Casos de Borda
- Alvo móvel (X muda no meio da queda); mapa sem topo; múltiplos meteoros simultâneos; overflow de dano (BigNumber).

## 6. UI/UX & VFX
- Rastro ígneo, tremor de tela no impacto, número de dano (formato [[CONTEXT-004]]).

## 7. Ganchos para o Futuro
- Variantes: meteoro dividido, chuva de meteoros (Should/Could).
