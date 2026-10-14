---
id: SYSTEM-002
aliases:
  - SYSTEM-002
title: "NavGraph & Pathfinding"
type: tech-spec
status: Draft
moscow: Must
moscow_note: Herda de [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] (Must) — é o "grafo de nós" prometido.
implements: "[[DESIGN-025 Navegacao & Movimento|DESIGN-025]]"
dependencies:
  - "[[SYSTEM-003 Kinematics & Motion Primitives|SYSTEM-003]]"
  - "[[SYSTEM-001 Input & Movement Intents|SYSTEM-001]]"
  - "[[DATA-006 Level Layout|DATA-006]]"
---

# [SYSTEM-002] NavGraph & Pathfinding

## 1. Responsabilidade & Escopo
Transformar o **nível** (JSON do editor — [[DATA-006 Level Layout|DATA-006]]) + as **capacidades** do jogador ([[DESIGN-025 Navegacao & Movimento|DESIGN-025]] §3) num **grafo de navegação** e responder uma **rota** entre dois pontos. É o **"grafo grosso"** da arquitetura híbrida ([[SYSTEM-000 Navegacao (ADR-001)|SYSTEM-000]]).

## 2. Padrões de Projeto & Algoritmos
- ***Bake*** do grafo no **load** do nível (e ao **mudar capacidades**).
- **Node graph** plataforma→plataforma (cantos/junções), **não** grid bruto.
- **A*** (heurística = distância euclidiana); *Dijkstra* se os custos não forem admissíveis.
- **Strategy**: `Capabilities → conjunto de arestas` (a **mesma** origem/destino muda por classe).
- As arestas são **resolvidas pelo solver de primitivas** ([[SYSTEM-003 Kinematics & Motion Primitives|SYSTEM-003]]).

## 3. Contratos de Dados & Interfaces (TypeScript)
```ts
export interface Capabilities {
  walk: boolean;
  jump: { maxHeight: number; maxDistance: number };
  jumpDash?: { speed: number; duration: number; cooldown: number };
  blink?: { range: number; cooldown: number };
  slideJump?: { distance: number; arc: number };
}

export type PrimitiveId = "walk" | "jump" | "jumpDash" | "blink" | "slideJump";

export interface NavNode { id: number; x: number; y: number; solidTop: boolean; }
export interface NavEdge {
  from: number; to: number;
  primitive: PrimitiveId;
  costTicks: number;              // custo em TEMPO
  timeline: InputTimeline;        // preenchido por SYSTEM-003
}
export interface NavGraph {
  nodes: NavNode[];
  adj: NavEdge[][];
  nearestStandable(p: Vec2): NavNode | null;  // snap do clique
}
export interface NavBaker { bake(level: LevelData, caps: Capabilities): NavGraph; }
export interface Pathfinder { path(from: number, to: number): NavEdge[] | null; }
```
> `LevelData`, `Vec2` e `InputTimeline` vêm dos módulos vizinhos ([[SYSTEM-001 Input & Movement Intents|SYSTEM-001]], [[SYSTEM-003 Kinematics & Motion Primitives|SYSTEM-003]]).

## 4. Fluxo de Execução no Game Loop
1. **Load do nível** → `NavBaker.bake(level, caps)` → `NavGraph`.
2. **`MoveIntent`** → `nearestStandable(target)` (se `null`, ignora ou usa o mais próximo).
3. `Pathfinder.path(nóAtual, nóAlvo)` → **rota** (`NavEdge[]`, cada um com sua `timeline`).
4. O executor ([[SYSTEM-003 Kinematics & Motion Primitives|SYSTEM-003]]) **toca** as *timelines*.
5. **Skill up** → `caps` muda → **rebake** (ou *patch* só das arestas afetadas).

## 5. Pontos de Extensão & Escalabilidade (Should Futuro)
- **Party / multi-agente** ([[DESIGN-001 Multi Personagens|DESIGN-001]]) — um grafo, N agentes.
- **Custo por perigo** (evitar zonas) em vez de só tempo.
- **Obstáculos dinâmicos** (mobs) via *patch* local; *cache* do grafo por nível.
