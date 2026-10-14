---
id: DESIGN-025
aliases:
  - DESIGN-025
title: "Navegação & Movimento (Tap-to-Move)"
type: system-design
subtype: system
status: Spec Ready
moscow: Must
moscow_note: Sem navegação não há exploração nem posicionamento — o core loop não é validável. É o "Movimento tap-to-move" prometido no board.
dependencies:
  - "[[DESIGN-023 Plataformas & Portais|DESIGN-023]]"
  - "[[DESIGN-005 Classes|DESIGN-005]]"
  - "[[DESIGN-006 Meta Espacial|DESIGN-006]]"
data_spec: "[[DATA-XXX]]"
---

# [DESIGN-025] Navegação & Movimento (Tap-to-Move)

## 0. Prioridade MoSCoW
- **Categoria:** Must
- **Justificativa:** É o **Movimento tap-to-move (destino via grafo de nós)** listado como `Must` no [[DESIGN-000 Board MoSCoW|DESIGN-000]]. Sem ele não há exploração nem posicionamento.
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
O jogador **não dirige** o personagem tecla a tecla: ele **aponta um destino** e o personagem **se locomove sozinho**, escolhendo a rota conforme as **habilidades de movimento desbloqueadas**. Isso mantém o jogo *idle-friendly* (pouco APM) e faz da locomoção um **problema de planejamento** — não de execução.

## 2. Modelo de Movimento
- **Baseline (todas as classes):** **Andar** e **Pular**.
- **Chão = cinemático:** a direção/velocidade muda livremente (andar para qualquer lado).
- **Ar = balístico (NÃO cinemático):** a trajetória é decidida **no salto** (`vx`, `vy` de decolagem). No ar o jogador **não** "dirige" — só uma **habilidade de movimento** pode alterar o arco.
- **Salto diagonal** é permitido (decolagem com `vx ≠ 0`).
- **Plataformas:** ver [[DESIGN-023 Plataformas & Portais|DESIGN-023]] (todas one-way; só o **piso/última linha** é sólido).

## 3. Habilidades de Movimento (por classe)
| Classe | Habilidade | Papel na navegação | Doc |
| :--- | :--- | :--- | :--- |
| **Genérica** | — | só andar/pular: vence desníveis pequenos | — |
| **Guerreiro** | **Jump Dash** | impulso horizontal no ar; estende o salto | [[DESIGN-012 Jump Dash\|DESIGN-012]] |
| **Mago** | **Blink** | teleporte curto (reposicionamento instantâneo) | [[DESIGN-026 Blink\|DESIGN-026]] |
| **Arqueiro** | **Slide Jump** | salto **raso e longo**: vãos horizontais largos | [[DESIGN-027 Slide Jump\|DESIGN-027]] |

- **Desbloqueio:** ao escolher a **classe Base** (nível 15 — [[DESIGN-005 Classes|DESIGN-005]]). As **sub-especializações mantêm** a habilidade.
- **Adaptação:** o algoritmo lê as **habilidades desbloqueadas e seus parâmetros atuais** (`skills upadas`) e monta o conjunto de movimentos disponíveis. Como os parâmetros podem **escalar com o nível** da habilidade, o alcance é **dinâmico** (§5).

## 4. Tap-to-Move (Fluxo)
1. **Gatilho:** clique/toque em um **ponto vazio** da tela (sem UI).
2. Converte o clique para **coordenada de mundo**.
3. Calcula o **ponto pisável válido mais próximo** desse alvo (célula sobre uma plataforma) → esse é o **destino**.
4. **Planeja a rota** no **grafo de nós** (§5) usando os movimentos disponíveis.
5. **Executa** a rota (andar → pular → habilidade → …) até parar no destino.
6. Clique em **interactable** → o destino é a célula do interactable ([[DESIGN-017 Interactables & Hub|DESIGN-017]] §3.6).

## 5. Grafo de Navegação (planejamento)
- **Nós** = **posições pisáveis** (células sobre plataformas), com `(x, y)`.
- **Arestas** = um movimento entre dois nós, com:
  - `tipo` (`walk | jump | jumpDash | blink | slideJump`);
  - `custo` (tipicamente **tempo**);
  - **pré-condição** (habilidade desbloqueada + parâmetros atuais no alcance).
- As arestas válidas **dependem do conjunto de movimentos do jogador** → a **mesma** origem/destino gera **rotas diferentes por classe**.
- **Busca:** minimizar **custo de tempo** (jogo idle prioriza o destino mais rápido). O algoritmo exato é decidido na **arquitetura** (A*, Dijkstra ponderado, etc.).
- **Alcance dinâmico:** ao subir de nível a habilidade, **recalcular** as arestas afetadas.

## 6. Regras de Uso do Jump Dash (Guerreiro)
> O dash **não** serve para subir plataformas em **90°** — para isso usa-se o **pulo** (e a passagem one-way de [[DESIGN-023 Plataformas & Portais|DESIGN-023]]).

O planejador classifica o alvo pela **geometria** e escolhe um dos três modos:

| Modo | Alvo (relativo ao jogador) | Uso do dash |
| :--- | :--- | :--- |
| **0 — Sem dash** | mesma altura / degrau pequeno (tiles `4`/`2` do exemplo) | **andar**, ou **andar + pular normal**. **Nunca** dash. |
| **1 — Dash no ápice** | **acima e na diagonal** (tile `3`) | **pular normal**; **no ápice** do pulo, dar o **dash na direção** → ganha alcance horizontal mantendo a altura. |
| **2 — Dash antecipado** | alvo logo abaixo de uma plataforma (não pode ultrapassar) | **andar + pular**; **no ar, antes do ápice**, dar o dash → arco mais **raso**, para **não pular alto demais e pousar sem querer na plataforma de cima**. |

> ⚠️ **Ambiguidade a confirmar:** o marcador `2` aparece nos **Modos 0 e 2** (provavelmente um dos dois é outro tile no exemplo). Além disso, o grid enviado **não contém os tiles `4`/`5`** — se o "JSON de exemplo custom" é outro, mande-o para eu fixar o mapeamento marcador → modo.

## 7. Input Manual da Habilidade
- **No ar:** um **2º input de pulo** → **dispara o dash** automaticamente.
- **No chão:** input do dash → **pula → aguarda um instante → dá o dash**.
- Detalhes da mecânica → [[DESIGN-012 Jump Dash|DESIGN-012]].

## 8. Contrato Funcional (I/O)
- **Entrada:** `target (x, y)` (do clique/toque).
- **Pré-requisitos:** nível carregado; conjunto de movimentos do jogador conhecido.
- **Saída:** uma **lista de passos** (segmentos de movimento) executada; ao fim, `player.pos = destino`.
- **Estado:** `player.pos`, `player.vel`, `player.facing`, `currentRoute`.

## 9. Casos de Borda
- Clique em **área vazia grande** → *snap* ao nó pisável mais próximo (ou ignora se além de um raio máximo).
- **Destino inalcançável** (ilha sem rota) → não se move, ou para o **ponto alcançável mais próximo**.
- **Clique repetido** → **cancela** a rota atual e **replaneja**.
- Alvo **acima com teto rente** → Modo 2 (dash antecipado).
- Dash contra **parede/tela** ; borda da tela; portal intrafase no meio da rota.
- **Offline / catch-up:** locomoção é **tempo real**; a simulação de catch-up **ignora** o movimento (resolve combate/drops analiticamente).
- Spawn/entrada **sobre** plataforma; piso **sólido**.

## 10. UI/UX e Feedback
- Marcador no ponto clicado; **preview** opcional da rota; *trail* de dash; som curto de impulso.

## 11. Ganchos para o Futuro
- Mais movimentos por classe; **wall-jump**; **double jump** genérico.
- Grafo **compartilhado por party** ([[DESIGN-001 Multi Personagens|DESIGN-001]]).
- Rotas com **custo de dano** (evitar zonas perigosas), não só tempo.

## 12. Relacionados
- [[DESIGN-023 Plataformas & Portais|DESIGN-023]] — colisão de chão/base do mapa.
- [[DESIGN-005 Classes|DESIGN-005]] — de onde vêm as habilidades.
- [[DESIGN-006 Meta Espacial|DESIGN-006]] — mapa favorece builds móveis.
- [[DESIGN-017 Interactables & Hub|DESIGN-017]] — clique em interactable = destino.
- Habilidades: [[DESIGN-012 Jump Dash|DESIGN-012]] · [[DESIGN-026 Blink|DESIGN-026]] · [[DESIGN-027 Slide Jump|DESIGN-027]].
- Valores (velocidades, alcances, cooldowns) → [[DATA-XXX]].
