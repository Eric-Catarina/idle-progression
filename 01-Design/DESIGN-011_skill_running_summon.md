---
id: DESIGN-011
aliases:
  - DESIGN-011
title: "Skill: Summon Corredor"
type: system-design
subtype: skill
status: Draft
moscow: Should
moscow_note: Invocação horizontal (Suporte/Mobbing); brilha em mapas largos.
dependencies:
  - "[[DESIGN-006]]"
---

# [DESIGN-011] Skill: Summon Corredor

## 0. Prioridade MoSCoW
- **Categoria:** Should · **Justificativa:** profundidade de skill; encaixa no papel Suporte/Mobbing ([[DESIGN-005]]). Ver [[CONTEXT-001]].

## 1. Visão & Fantasia
Invoca um aliado que **corre muito rápido na horizontal**, atropelando inimigos ao longo do caminho. Ideal para builds de Suporte/Mobbing em **mapas largos**.

## 2. Contrato de Ativação (I/O)
- **Input:** skill na barra.
- **Pré-requisitos:** custo; duração/limite de invocações simultâneas.
- **Saída:** entidade summon que se move em X, causando dano por contato.

## 3. Regras de Combate
- **Movimento:** corrida horizontal rápida; ao atingir a borda, **retorna** ou desaparece.
- **Acerto:** piercing contínuo; i-frames por alvo.
- **Knockback:** empurra na direção da corrida.

## 4. Escalonamento
- Dano, velocidade, nº de summons, duração por nível → [[DATA-XXX]].

## 5. Casos de Borda
- Mapa vertical (pouca utilidade); summons empilhados; overflow de entidades.

## 6. UI/UX & VFX
- Rastro de poeira, silhueta distinta do jogador.

## 7. Ganchos para o Futuro
- Variantes: summon voador (atravessa plataformas), summon que fica parado atirando.
