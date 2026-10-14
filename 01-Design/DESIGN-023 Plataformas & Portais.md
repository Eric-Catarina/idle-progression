---
id: DESIGN-023
aliases:
  - DESIGN-023
title: "Plataformas & Portais"
type: system-design
subtype: mechanic
status: Spec Ready
moscow: Must
moscow_note: Comportamento base de colisão das plataformas + portal intrafase; sem isso o mapa não funciona.
dependencies:
  - "[[DESIGN-006 Meta Espacial|DESIGN-006]]"
---

# [DESIGN-023] Plataformas & Portais

## 0. Prioridade MoSCoW
- **Categoria:** Must
- **Justificativa:** Define como o personagem interage com o chão — base de toda navegação. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Padronizar a **colisão de plataformas** (todas com o mesmo comportamento) e o **Portal Intrafase** (teleporte dentro da própria fase), inspirado nos **portais amarelos do MapleStory**.

## 2. Plataformas (todas iguais — One-Way)
- **Atravessar de baixo → cima: SEMPRE** (você pula através da plataforma normalmente).
- **Atravessar de cima → baixo: opcional** — o jogador **pode** descer se quiser (input de "descer/soltar").
- **Exceção única:** a plataforma da **última linha** (o **piso**) é **sólida** — **não** se atravessa (nem para cima nem para baixo).
- Ou seja: existe **um único tipo** de plataforma (tile `1`); o comportamento "sólido" é pela **posição** (última linha), não por tile.

## 3. Portal Intrafase (tile `2`)
- **Portal amarelo** que teleporta para **outro ponto da mesma fase**.
- **Pareamento:** pares em **ordem de leitura** (1º ↔ 2º, 3º ↔ 4º…). Entrar em um leva ao par.
- **Uso principal:** subir/descer rápido em mapas **verticais** ([[DESIGN-006 Meta Espacial|DESIGN-006]]).
- Não muda de nível; para trocar de nível use os **Portais Entrada/Saída** (tiles `4`/`5`).

## 4. Contrato Funcional (I/O) — Portal
- **Gatilho:** o personagem entra na célula do Portal Intrafase.
- **Saída:** reposiciona o personagem na célula do **portal par** (+ pequeno offset).

## 5. Casos de Borda
- Nº **ímpar** de portais intrafase → o último fica **sem par** (inativo) — avisado no editor/DATA.
- Dois portais na **mesma célula** (sobreposição).
- Portal no **piso/última linha** (evitar).

## 6. Relacionados
- [[DESIGN-006 Meta Espacial|DESIGN-006]] · [[DATA-006 Level Layout|DATA-006]] (legend de tiles).
