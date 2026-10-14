---
id: SYSTEM-001
aliases:
  - SYSTEM-001
title: "Input & Movement Intents"
type: tech-spec
status: Draft
moscow: Must
moscow_note: Herda de [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] (Must) — sem input não há navegação.
implements: "[[DESIGN-025 Navegacao & Movimento|DESIGN-025]]"
dependencies:
  - "[[DESIGN-025 Navegacao & Movimento|DESIGN-025]]"
---

# [SYSTEM-001] Input & Movement Intents

## 1. Responsabilidade & Escopo
A **fronteira** entre o *render* (que conhece tela/câmera) e a **simulação headless** (que **não** conhece tela). Converte o **ponteiro** em **intenções de mundo** (`MoveIntent`) e as **enfileira** como comandos; o sim as **consome no tick**. **Nenhum DOM** entra no sim.

## 2. Padrões de Projeto & Algoritmos
- **Adapter** (render → sim): a **única** peça que conhece a câmera.
- **Command (fila)**: intenções **imutáveis** e **serializáveis** (log/replay/teste).
- **Produtor único / consumidor único**: a fila é **drenada uma vez** no início do tick.

## 3. Contratos de Dados & Interfaces (TypeScript)
```ts
export interface Vec2 { x: number; y: number; }

/** Fora do sim: o render projeta tela → mundo usando a câmera. */
export interface PointerAdapter { toWorld(screen: Vec2): Vec2; }

/** Intenção imutável (serializável) — base do log de input/replay. */
export interface MoveIntent {
  readonly kind: "move";
  readonly target: Vec2;  // coordenada de MUNDO
  readonly tick: number;  // tick em que foi enfileirada
}
export type Command = MoveIntent; // união extensível

export interface CommandQueue {
  push(c: Command): void;
  /** Consumido UMA vez no início do tick; devolve e esvazia. */
  drain(): Command[];
}
```

## 4. Fluxo de Execução no Game Loop
1. **Render:** `pointerdown` → `PointerAdapter.toWorld(screen)` → `CommandQueue.push({ kind: "move", target, tick })`.
2. **Sim — início do tick:** `drain()` recebe os comandos acumulados.
3. Para cada `MoveIntent`, o **NavigationSystem** ([[SYSTEM-002 NavGraph & Pathfinding|SYSTEM-002]]) resolve destino/rota — **cancelando** a rota atual.
4. O restante do tick consome a rota ([[SYSTEM-003 Kinematics & Motion Primitives|SYSTEM-003]]).
5. O render **interpola** a posição para exibir.

## 5. Pontos de Extensão & Escalabilidade (Should Futuro)
- Novos comandos na união (`attack`, `interact`, `openMenu`) **sem tocar** no sim de movimento.
- **Log de input / replay** — as intenções já são serializáveis → testes determinísticos.
- Multi-touch / prioridade de fila (**último clique vence**).
