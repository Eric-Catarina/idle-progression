---
id: DESIGN-001
aliases:
  - DESIGN-001
title: Múltiplos Personagens no Mesmo Mapa
type: system-design
status: Backlog
moscow: Could
moscow_note: Profundidade tática e coleção; não é necessário para validar o core loop.
promote_when: "Core loop (tap-to-move + combate + progressão + prestígio) validado E necessidade de composição de time para escalar DPS."
dependencies:
  - "[[DESIGN-000 Board MoSCoW|DESIGN-000]]"
  - "[[CONTEXT-001 MoSCoW|CONTEXT-001]]"
tech_spec: "[[SYSTEM-XXX]]"
data_spec: "[[DATA-XXX]]"
tags:
  - design
  - backlog
  - could
  - party
---

# [DESIGN-001] Múltiplos Personagens no Mesmo Mapa

> **Categoria MoSCoW: `Could`** — este documento está **guardado no backlog**. Nenhum código deve ser escrito até a promoção. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 0. Prioridade MoSCoW
- **Categoria:** Could
- **Justificativa:** O protótipo valida o core loop com **um único personagem** idle. Uma party introduz pathfinding concorrente, colisão personagem-personagem, agregação de DPS e balanceamento exponencial composto — custo alto sem validar a hipótese central.
- **Critérios de Promoção:** core loop validado; demanda do design por composição de time; arquitetura de simulação já preparada para múltiplas entidades.

## 1. Visão & Propósito
Permitir que **dois ou mais personagens** coexistam, naveguem e combatam no mesmo mapa simultaneamente, formando uma party que soma DPS e cobre mais plataformas. Resolve, no futuro, o teto de progressão de um personagem único ao introduzir sinergia e posicionamento tático.

## 2. Contrato Funcional (I/O)
- **Gatilho / Input:** desbloqueio do segundo slot de personagem; seleção da party na UI; comando tap-to-move aplicado ao **personagem ativo**.
- **Pré-requisitos de Estado:** `playerCount >= 2` desbloqueado; mapa com ao menos 2 nós de plataforma alcançáveis; entidades de simulação já suportam N personagens.
- **Saída / Modificação de Estado:** lista `characters[]` no estado global; DPS agregado por tick; `character.pos` individual; XP distribuído conforme regra de compartilhamento.

## 3. Lógica Passo a Passo
1. No tick, o `PartySystem` itera todos os personagens ativos.
2. Cada personagem executa seu próprio `MovementSystem` (tap-to-move) rumo ao seu destino individual.
3. Ao completar o deslocamento, o personagem ataca o alvo mais próximo dentro do alcance.
4. O dano total do tick é `Σ damage_i` de cada personagem.
5. XP e loot são agregados e distribuídos conforme a regra de compartilhamento (a definir em `DATA-XXX` na promoção).
6. Knockback é aplicado por personagem individualmente.

## 4. Casos de Borda & Tratamento de Erros
- **Personagens na mesma plataforma:** resolução de colisão lateral por separação mínima de `X` pixels (evitar sobreposição total).
- **Dois personagens no mesmo nó de destino:** o segundo enfileira ou escolhe o nó adjacente livre.
- **Morte de um personagem:** os demais continuam; o slot morto entra em cooldown de revive.
- **Overflow de DPS:** agregação usa BigNumber ([[CONTEXT-001 MoSCoW|CONTEXT-001]] §6 e manifesto §3).

## 5. UI/UX e Feedback
- Retratos da party em barra lateral com HP individual.
- Indicador do personagem ativo; linha de DPS agregado.
- Números de dano flutuantes por personagem (cores distintas).

## 6. Ganchos para o Futuro (Should/Could)
- O `MovementSystem` e o `CombatSystem` já operam sobre **entidades**, não sobre "o jogador" — a promoção reaproveita o mesmo pipeline.
- O `MovementSystem` original **deve** ser escrito para iterar uma coleção de entidades desde o início (mesmo com 1 item), evitando refatoração estrutural.

> **Status:** aguardando promoção. Nenhum `SYSTEM-XXX` ou `DATA-XXX` é criado até lá.
