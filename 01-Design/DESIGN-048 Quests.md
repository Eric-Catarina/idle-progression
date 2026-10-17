---
id: DESIGN-048
aliases:
  - DESIGN-048
title: Quests
type: system-design
subtype: system
status: Draft
moscow: Should
moscow_note: Dá sentido ao mapa e guia o jogador (estilo Scripticus do IdleOn); o core loop valida sem.
dependencies:
  - "[[DESIGN-017 Interactables & Hub|DESIGN-017]]"
  - "[[DESIGN-044 Inventario|DESIGN-044]]"
  - "[[DESIGN-046 Personagens|DESIGN-046]]"
data_spec: "[[DATA-023 Quests Mundo 1|DATA-023]]"
---

# [DESIGN-048] Quests

> **Simples como o Scripticus do IdleOn:** um NPC com **`!`** te dá uma tarefa; você cumpre **jogando**; volta e entrega. **Sem ramificação, sem diálogo, sem escolha.**

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** a quest é a **trilha de migalhas** que dá sentido a cada mapa e ensina o loop. O jogo funciona sem — mas fica **sem direção**. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
- **Uma quest por mapa** + uma **cadeia tutorial** no Hub ([[DATA-023 Quests Mundo 1|DATA-023]]).
- **Zero fricção:** o progresso é **automático** (o jogo já conta kills/coleta) — o jogador **não** faz nada além de jogar.
- **Recompensa clara:** ouro + item; a última dá o **2º personagem** ([[DESIGN-046 Personagens|DESIGN-046]] §2) ✅

## 2. Contrato Funcional (I/O)
- **Gatilho:** tocar no NPC ([[DESIGN-017 Interactables & Hub|DESIGN-017]]).
- **Objetivos suportados:** `kill` (mob, N) · `collect` (item, N) · `equip` (1 gear) · `level` (alcançar nível) · `boss` (derrotar).
- **Estados:** `available` → `active` → `ready` → `done`.
- **Saída:** XP + ouro + item, e (na última) **destrava um slot de personagem**.
- **Persistência:** por **conta** (a quest é da jornada, não do personagem) ✅

## 3. Lógica Passo a Passo
1. O NPC mostra **`!`** quando há quest `available` (e o pré-requisito foi cumprido).
2. Tocar → **aceita** (vai pra `active`) — **sem diálogo**, só um flash e o ícone muda pra **`…`**.
3. **Progresso automático:** cada kill/coleta incrementa o contador da quest ativa correspondente.
4. Ao cumprir → o NPC mostra **`?`** (e um **alerta no Footer**).
5. Tocar de novo → **entrega**: paga a recompensa e (se houver) **libera a próxima** da cadeia.
6. Fim da cadeia → `done` (fica **registrada** no diário).

## 4. Casos de Borda & Tratamento de Erros
- **Objetivo já cumprido antes de aceitar** (ex.: você já matou 300 no 1-5) → ao aceitar, entra **direto em `ready`** ✅ (o jogo **olha o histórico**, não só o futuro).
- **`collect`** → **consome** os itens na entrega (o item é um item normal do inventário — [[DESIGN-044 Inventario|DESIGN-044]]); **`kill`** nunca consome nada.
- **Limite de quests ativas** → **3** (cadeia do Hub + a do mapa atual).
- **NPC com 2 quests** (pré-requisito em cadeia) → mostra a **próxima assim que a anterior é entregue**.
- **Item de quest como drop raro** → as quantidades são baixas (10) e a **taxa é alta** perto do mapa (não trava).

## 5. UI/UX e Feedback
- **Ícone no NPC:** `!` (disponível) · `…` (em andamento) · `?` (pronta).
- **Card da quest** (no diário): título · objetivo com **progresso** (`7 / 10`) · recompensa com ícones.
- **Janela `QUESTS`** (no Footer — [[CONTEXT-010 UI de Jogo|CONTEXT-010]]): ativas + concluídas.
- **Entrega:** popup curto com **o que você ganhou** (mesma linguagem visual do loot do chefe — [[DATA-021 Loot do Chefe|DATA-021]]).

## 6. Ganchos para o Futuro (Should/Could)
- **Dailies** (1 por dia no Hub) — `Should`.
- **Cadeia longa por mundo** e **reputação de NPC** — `Could`.
- **Escolha de recompensa** (1 de 3) — `Could` (quebra a simplicidade; só se valer).

## 7. Relacionados
- Conteúdo: [[DATA-023 Quests Mundo 1|DATA-023]] · Hub/NPCs: [[DESIGN-017 Interactables & Hub|DESIGN-017]].
- Inventário: [[DESIGN-044 Inventario|DESIGN-044]] · Roster: [[DESIGN-046 Personagens|DESIGN-046]] · UI: [[CONTEXT-010 UI de Jogo|CONTEXT-010]].
