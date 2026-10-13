---
id: DESIGN-008
aliases:
  - DESIGN-008
title: "Skill: Lançamento de Machado"
type: system-design
subtype: skill
status: Draft
moscow: Should
moscow_note: Skill de física com retorno (estilo Vampire Survivors); brilha em mapas abertos.
dependencies:
  - "[[DESIGN-006 Meta Espacial|DESIGN-006]]"
---

# [DESIGN-008] Skill: Lançamento de Machado

## 0. Prioridade MoSCoW
- **Categoria:** Should · **Justificativa:** profundidade de skill (F2). Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Fantasia
Um machado é arremessado, viaja com **física em arco**, **perfura** inimigos e **retorna** às mãos do personagem (padrão do machado de *Vampire Survivors*).

## 2. Contrato de Ativação (I/O)
- **Input:** skill na barra.
- **Pré-requisitos:** cooldown; sem custo contínuo.
- **Saída:** projétil com trajetória de ida-e-volta; dano por contato (piercing).

## 3. Regras de Combate
- **Trajetória:** parábola (gravidade aparente) + retorno.
- **Acerto:** perfura (não para no primeiro alvo); dano por toque com recarga interna por alvo (i-frames).
- **Relação com o mapa:** quanto mais **aberto/vertical**, mais tempo em tela → mais acertos.

## 4. Escalonamento
- Dano, nº de machados, velocidade, alcance por nível → [[DATA-XXX]].

## 5. Casos de Borda
- Sem inimigos próximos; machado preso fora dos limites do mapa; múltiplos machados; overflow.

## 6. UI/UX & VFX
- Rotação contínua, rastro leve, som de "zunido".

## 7. Ganchos para o Futuro
- Variantes: machado bumerangue duplo, machado explosivo.
