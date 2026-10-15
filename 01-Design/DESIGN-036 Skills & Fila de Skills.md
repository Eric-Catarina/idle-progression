---
id: DESIGN-036
aliases:
  - DESIGN-036
title: "Skills & Fila de Skills (Combate)"
type: system-design
subtype: system
status: Draft
moscow: Must
moscow_note: Sem skills não há combate; a fila é o modelo de execução idle.
dependencies:
  - "[[DESIGN-031 Calculo de Dano|DESIGN-031]]"
  - "[[DESIGN-005 Classes|DESIGN-005]]"
  - "[[DESIGN-023 Plataformas & Portais|DESIGN-023]]"
data_spec: "[[DATA-009 Dano|DATA-009]]"
---

# [DESIGN-036] Skills & Fila de Skills (Combate)

> **Validação (protótipo):** a **fila de skills** (auto-cast em ordem, respeitando cooldown) é o **modelo de combate** que funcionou.

## 0. Prioridade MoSCoW
- **Categoria:** Must
- **Justificativa:** sem skills **não há combate**; a fila é o que torna o combate **idle** (pouco APM). Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
O jogador **monta uma fila** de skills. Elas são **castadas automaticamente em ordem**, respeitando o **cooldown** de cada uma. O jogador não fica apertando botão — o jogo roda sozinho (idle).

## 2. Regras
1. O personagem tem **N skills desbloqueadas** (por classe/nível — [[DESIGN-005 Classes|DESIGN-005]]).
2. O jogador monta a **fila** (a **ordem importa**).
3. A cada janela de decisão, casta a **1ª skill da fila cujo cooldown está pronto**.
4. **Ataque básico = MELEE** — só acerta quando o player está **encostando/muito perto** de um mob.
   - ⚠️ *Validação:* no 1º protótipo o ataque básico era **de longo alcance** e acertava mobs "aleatórios" — **errado**.
   - **Alcance longo é uma SKILL** (ex.: **Onda de Corte**, em **área à frente**).
5. Skills têm **tipo**: `single` (alvo), `aoe` (área/projétil longo), `buff`, `heal`.
6. Cada skill declara **`lines`** (nº de linhas de dano por cast) — um acerto pode gerar **vários números** (ver [[DESIGN-037 Linhas de Dano|DESIGN-037]]).

## 3. Fila (UI)
- **Adicionar / remover / reordenar** skills; mostrar **cooldown** de cada uma.
- (Futuro) **presets** de fila por situação (boss/mobbing).

## 4. Contrato Funcional (I/O)
- **Entrada:** `queue: skillId[]`.
- **Saída:** skills castadas **em ordem**; cooldowns consumidos; efeitos aplicados.
- **Pré-requisitos:** skill desbloqueada.

## 5. Casos de Borda
- **Fila vazia** → só o **ataque básico** (melee).
- Skill de **área sem mobs** à frente → não desperdiçar? *(a definir)*.
- Skill **não desbloqueada** na fila → ignorada.
- **Offline/catch-up:** skills rodam analiticamente (DPS), sem simular cada cast.

## 6. UI/UX e Feedback
- Ícones com **cooldown** (radial/escurecido); feedback no cast (flash/som).
- HUD mostra a **fila ativa**.

## 7. Ganchos para o Futuro
- **Presets** de fila, **auto-fila** por papel (boss/mob), skills com **carga**/canais.
- Skills por classe: [[DESIGN-007 Meteoro|DESIGN-007]] … [[DESIGN-012 Jump Dash|DESIGN-012]].

## 8. Relacionados
- Dano: [[DESIGN-031 Calculo de Dano|DESIGN-031]] / [[DATA-009 Dano|DATA-009]] · Classes: [[DESIGN-005 Classes|DESIGN-005]] · Movimento: [[DESIGN-025 Navegacao & Movimento|DESIGN-025]].
