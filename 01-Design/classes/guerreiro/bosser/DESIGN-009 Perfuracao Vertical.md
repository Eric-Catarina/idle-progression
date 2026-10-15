---
id: DESIGN-009
aliases:
  - DESIGN-009
title: "Skill: Perfuração Vertical"
type: system-design
subtype: skill
status: Draft
moscow: Should
moscow_note: Skill vertical de perfuração; brilha em mapas altos.
dependencies:
  - "[[DESIGN-006 Meta Espacial|DESIGN-006]]"
skill_tags:
  - delivery:field
  - target:line
  - role:damage
  - behavior:dot
  - archetype:bosser
---

# [DESIGN-009] Skill: Perfuração Vertical

## 0. Prioridade MoSCoW
- **Categoria:** Should · **Justificativa:** profundidade de skill (F2). Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Fantasia
Uma estaca/feixe **vertical** irrompe e **perfura tudo no eixo Y**, atravessando plataformas e inimigos empilhados. Recompensa mapas verticais ([[DESIGN-006 Meta Espacial|DESIGN-006]]).

## 2. Contrato de Ativação (I/O)
- **Input:** skill na barra / automática.
- **Pré-requisitos:** custo + cooldown.
- **Saída:** zona de dano fixa (coluna) por N ms.

## 3. Regras de Combate
- **Forma:** coluna vertical em `targetX`, altura = mapa.
- **Acerto:** dano a todos na coluna; **piercing** total.
- **Knockback:** para cima/baixo (opcional).

## 4. Escalonamento
- Dano, largura, duração por nível → [[DATA-XXX]].

## 5. Casos de Borda
- Alvo sai da coluna; mapa horizontal (skill inútil — intencional); overflow.

## 6. UI/UX & VFX
- Feixe/estaca brilhante, partículas ascendentes.

## 7. Ganchos para o Futuro
- Variantes: perfuração em X, cruz (+), múltiplas colunas.
