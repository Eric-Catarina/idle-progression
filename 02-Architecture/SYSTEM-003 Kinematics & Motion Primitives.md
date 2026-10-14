---
id: SYSTEM-003
aliases:
  - SYSTEM-003
title: "Kinematics & Motion Primitives"
type: tech-spec
status: Draft
moscow: Must
moscow_note: Herda de [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] (Must) — é a física/execução da locomoção.
implements: "[[DESIGN-025 Navegacao & Movimento|DESIGN-025]]"
dependencies:
  - "[[DESIGN-023 Plataformas & Portais|DESIGN-023]]"
  - "[[DESIGN-012 Jump Dash|DESIGN-012]]"
  - "[[DESIGN-026 Blink|DESIGN-026]]"
  - "[[DESIGN-027 Slide Jump|DESIGN-027]]"
---

# [SYSTEM-003] Kinematics & Motion Primitives

## 1. Responsabilidade & Escopo
A **máquina de estados** do corpo + a **física de passo fixo** + o **solver de primitivas** que converte um *hop* do grafo ([[SYSTEM-002 NavGraph & Pathfinding|SYSTEM-002]]) na **timeline de inputs** com arco fino — incluindo o **timing do dash** (Modos 0/1/2 de [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] §6).

## 2. Padrões de Projeto & Algoritmos
- **State Pattern**: `idle | walk | air | dash | blink | slide`.
- **Fixed-step kinematic AABB**: **chão cinemático**, **ar balístico**; colisão one-way e piso sólido ([[DESIGN-023 Plataformas & Portais|DESIGN-023]]).
- **Motion Primitive solver**: por *hop*, decide `dashAt`:
  - **Modo 0** — não emite dash (mesma altura/degrau);
  - **Modo 1** — dash **no ápice** (alvo acima/na diagonal);
  - **Modo 2** — dash **antes do ápice** → arco raso (teto próximo).
- **InputTimeline**: execução **determinística** por tick (encaixa no replay de [[SYSTEM-001 Input & Movement Intents|SYSTEM-001]]).

## 3. Contratos de Dados & Interfaces (TypeScript)
```ts
export type CharState = "idle" | "walk" | "air" | "dash" | "blink" | "slide";

export interface Body {
  pos: Vec2; vel: Vec2;
  facing: -1 | 1;
  state: CharState;
  onGround: boolean;
}

export interface TimelineStep {
  atTick: number;
  action: "walk" | "jump" | "dash" | "blink" | "slideRear" | "release";
  dir: -1 | 0 | 1;
}
export interface InputTimeline { steps: TimelineStep[]; }

export interface SolveCtx { body: Body; caps: Capabilities; ceiling?: number; }
export interface MotionPrimitive {
  id: PrimitiveId;
  costTicks(caps: Capabilities): number;
  solve(ctx: SolveCtx, from: Vec2, to: Vec2): InputTimeline;
}
export interface MotionSolver { resolve(edge: NavEdge, body: Body): InputTimeline; }
```

## 4. Fluxo de Execução no Game Loop
1. **Início do tick:** drena comandos ([[SYSTEM-001 Input & Movement Intents|SYSTEM-001]]) → navegação ([[SYSTEM-002 NavGraph & Pathfinding|SYSTEM-002]]) define a **rota**.
2. Para a aresta atual, `MotionSolver.resolve(edge, body)` gera a **`InputTimeline`**.
3. A **máquina de estados** aplica os inputs; a física **integra** (chão cinemático / ar balístico).
4. **Colisão**: one-way (passa p/ cima sempre; desce se quiser) e **piso sólido** ([[DESIGN-023 Plataformas & Portais|DESIGN-023]]).
5. Fim da aresta → **próxima**; fim da rota → `idle`.
6. Emite `Body.pos`; o render **interpola**.

## 5. Pontos de Extensão & Escalabilidade (Should Futuro)
- Novas primitivas (**wall-jump**, *double jump*) via `PrimitiveRegistry` — sem tocar no grafo.
- **Knockback/cancelamentos** e *i-frames* como *flags* de estado.
- *Seam* para **catch-up** offline (a locomoção é ignorada — [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] §9).
