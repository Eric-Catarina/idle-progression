---
id: SYSTEM-000
aliases:
  - SYSTEM-000
title: "Navegação — Visão de Arquitetura (ADR-001)"
type: tech-spec
status: Approved
moscow: Must
moscow_note: Herda de [[DESIGN-025 Navegacao & Movimento|DESIGN-025]].
implements: "[[DESIGN-025 Navegacao & Movimento|DESIGN-025]]"
dependencies:
  - "[[SYSTEM-001 Input & Movement Intents|SYSTEM-001]]"
  - "[[SYSTEM-002 NavGraph & Pathfinding|SYSTEM-002]]"
  - "[[SYSTEM-003 Kinematics & Motion Primitives|SYSTEM-003]]"
---

# [SYSTEM-000] Navegação — Visão de Arquitetura (ADR-001)

## 1. Contexto
O [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] exige: **input por toque**, **planejamento adaptável às skills** do jogador e **Headless Simulation First** (sem DOM). Precisávamos decidir como **input** e **cálculo de movimento** se organizam.

## 2. Decisão
- **Input:** **fila de comandos (intents)** — o *render* projeta tela→mundo e **enfileira**; o *sim* consome **no tick**. (Alternativas: handler direto; event bus.)
- **Movimentação:** **híbrido** — **grafo grosso** (plataforma→plataforma) para **rotear** + **solver de primitivas** para o **arco fino** (timing do dash: ápice vs. antecipado).

## 3. Módulos
| Módulo | Papel |
| :--- | :--- |
| [[SYSTEM-001 Input & Movement Intents\|SYSTEM-001]] | ponteiro → `MoveIntent` → fila de comandos |
| [[SYSTEM-002 NavGraph & Pathfinding\|SYSTEM-002]] | *bake* do grafo + A* + capacidades |
| [[SYSTEM-003 Kinematics & Motion Primitives\|SYSTEM-003]] | máquina de estados + física + solver de arco |

```text
pointer → [SYSTEM-001] → CommandQueue
                              ↓ (início do tick)
                        [SYSTEM-002] NavGraph + A* → rota (NavEdge[] c/ timeline)
                              ↓
                        [SYSTEM-003] State + Kinematics → Body.pos → render (interpola)
```

## 4. Consequências
- **(+)** determinístico, testável e **headless**; log de input/replay; adapta-se às skills.
- **(+)** mantém a promessa de **"grafo de nós"** do [[DESIGN-000 Board MoSCoW|DESIGN-000]].
- **(−)** duas camadas (grafo + solver) com **contrato a manter**.
- **(−)** exige **passo fixo** e física **determinística**.

## 5. Alternativas rejeitadas
- **Input: handler direto** → acopla UI↔sim e quebra o *headless*.
- **Movimento: grafo + busca puro** → *timing* do dash aproximado; erra em geometria compacta.
- **Movimento: planner só por simulação de trajetórias** → CPU/complexidade altos sem o ganho do grafo.

## 6. Relacionados
- [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] · [[DESIGN-023 Plataformas & Portais|DESIGN-023]] · [[DATA-006 Level Layout|DATA-006]].
