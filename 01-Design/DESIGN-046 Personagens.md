---
id: DESIGN-046
aliases:
  - DESIGN-046
title: Personagens (Roster)
type: system-design
subtype: system
status: Draft
moscow: Should
moscow_note: Múltiplos personagens enriquecem muito (coleção + AFK paralelo), mas o core loop valida com um.
dependencies:
  - "[[CONTEXT-019 Conta & Personagem|CONTEXT-019]]"
  - "[[DESIGN-041 Level1_Boss1|DESIGN-041]]"
  - "[[DESIGN-047 AFK & Ganhos Offline|DESIGN-047]]"
---

# [DESIGN-046] Personagens (Roster)

> **Vários personagens, cada um com a sua jornada** — a **conta** é compartilhada ([[CONTEXT-019 Conta & Personagem|CONTEXT-019]]).
> Não confundir com **party no mesmo mapa** ([[DESIGN-001 Multi Personagens|DESIGN-001]], `Could`).

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** é o que transforma o jogo em *conta* (inventário/ouro divididos, AFK paralelo). O core loop valida com **um** personagem. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
- Criar **N personagens**, cada um com **nível, classe, gear e desbloqueios próprios**.
- **A conta é o que os une:** inventário, ouro, essência, coleções ([[CONTEXT-019 Conta & Personagem|CONTEXT-019]]).
- Motivação idle: **cada personagem acumula AFK em paralelo** ([[DESIGN-047 AFK & Ganhos Offline|DESIGN-047]]) — voltar ao jogo = **vários** relatórios de uma vez ✅

## 2. Contrato Funcional (I/O)
- **Criar:** `name` + `class` ([[DESIGN-005 Classes|DESIGN-005]]) → nasce no **Hub do Mundo 1** (nível 1, sem gear).
- **Trocar:** livre (idle — não perde nada); o personagem que sai começa a acumular **AFK**.
- **Pré-requisito do 2º slot:** **derrotar Vorax** ([[DESIGN-041 Level1_Boss1|DESIGN-041]]) ✅ *(decisão do usuário)*.
- **Saída:** lista `characters[]` na conta; só o **ativo** roda online; os outros **acumulam AFK**.

## 3. Regras
1. **Desbloqueio de mapa é do PERSONAGEM** ✅ — todos começam no Hub do 1 (decisão de 2026-10-17).
2. **Ouro/inventário são da CONTA** ✅ — gasto por qualquer personagem.
3. **Gear é do personagem** — nunca compartilhado ([[DESIGN-044 Inventario|DESIGN-044]] §2).
4. **AFK é por personagem** ([[DATA-022 AFK|DATA-022]]).
5. **Slots:** 1º grátis · **2º = matar Vorax** · demais `Could` (comprar com gemas?).

## 4. Casos de Borda & Tratamento de Erros
- **Apagar personagem:** exige **confirmar digitando o nome**; o **gear dele** vai embora (a conta fica).
- **APAGAR** o que está no AFK → o relatório dele é **descartado** (aviso antes).
- **Criar com nome repetido** → blocado.
- **Personagem parado no Hub** → AFK = 0 (não há mobs — [[DESIGN-047 AFK & Ganhos Offline|DESIGN-047]] §4).
- **Trocar de personagem no meio de um mapa** → permitido; o que saiu passa a acumular AFK **naquele mapa**.

## 5. UI/UX e Feedback
- **Tela de Roster:** um **card** por personagem (nome · classe · nível · **onde está**) + `＋ Novo personagem` (com o **cadeado** até matar Vorax).
- **Trocar** = 1 toque no card.
- O card mostra o **tempo de AFK acumulado** ("6 h fora — toque para ver").
- **Primeiro personagem** já existe por padrão (sem tela de criação no boot).

## 6. Ganchos para o Futuro (Should/Could)
- **Slots extras** (gemas/conquista) — `Could`.
- **Party no mesmo mapa** — [[DESIGN-001 Multi Personagens|DESIGN-001]] (`Could`, arquitetura já preparada).
- **Personagem "de ferramenta"** (profissões) — `Could`.

## 7. Relacionados
- Escopo: [[CONTEXT-019 Conta & Personagem|CONTEXT-019]] · AFK: [[DESIGN-047 AFK & Ganhos Offline|DESIGN-047]] · Inventário: [[DESIGN-044 Inventario|DESIGN-044]].
- Desbloqueio: [[DESIGN-041 Level1_Boss1|DESIGN-041]] · Classes: [[DESIGN-005 Classes|DESIGN-005]].
