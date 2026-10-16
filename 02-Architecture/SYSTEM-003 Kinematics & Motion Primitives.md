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
  - "[[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]]"
---

# [SYSTEM-003] Kinematics & Motion Primitives

> ⚠️ **Revisado pela [[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]] §1.7:** a **matemática da física é do Godot** (`CharacterBody2D` + `move_and_slide` + `one_way_collision`). **Não reinventamos o solver AABB** — este doc define só **as regras que são nossas**.

## 1. Responsabilidade & Escopo
**O que é nosso:**
- A **máquina de estados** do corpo (`idle | walk | air | dash | blink | slide`).
- O **solver de primitivas de movimento**: converte um *hop* do grafo ([[SYSTEM-002 NavGraph & Pathfinding|SYSTEM-002]]) numa **timeline de intents** com o arco e o **timing do dash** (Modos 0/1/2 — [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] §6).
- As **regras de plataforma** (one-way + **down-jump**) — [[DESIGN-023 Plataformas & Portais|DESIGN-023]] §2.
- Os **parâmetros de movimento** (velocidade, gravidade, impulso de pulo, alcances) — números em [[DATA-018 Skills|DATA-018]] / [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] §4.

**O que NÃO é nosso (delegado ao motor):**
- Integração de colisão, deslizamento em paredes, `one_way_collision`, CCD/sweep, quadtree/broad-phase.
- **Consequência:** não há "fixed-step AABB" nosso; a simulação roda no **tick de física do Godot** (60 Hz, [[CONTEXT-011 Engine & Plataforma|CONTEXT-011]]).

## 2. Padrões de Projeto & Algoritmos
- **State Pattern** (`enum State`): `IDLE | WALK | AIR | DASH | BLINK | SLIDE`.
- **Motion Primitive solver** — por *hop*, decide **quando** o dash entra (é o que muda o arco):
  - **Modo 0** — não emite dash (mesma altura/degrau);
  - **Modo 1** — dash **no ápice** (alvo acima/na diagonal);
  - **Modo 2** — dash **antes do ápice** → arco raso (teto baixo).
- **IntentTimeline**: a execução é **determinística por tick** (encaixa no replay de [[SYSTEM-001 Input & Movement Intents|SYSTEM-001]]).
- **One-way + down-jump:** as plataformas ficam na **camada 2** (one-way) e o piso/paredes na **camada 1** (sólido). O **down-jump** = desligar a máscara da camada 2 por `DROP_TIME` (≈0,2 s) — hoje em `prefabs/actors/player.gd`.

## 3. Contratos de Dados & Interfaces (GDScript)
```gdscript
# sim/world/motion.gd — PURO (sem nós)
class_name Motion extends RefCounted

enum State { IDLE, WALK, AIR, DASH, BLINK, SLIDE }

class Step extends RefCounted:
	var at_tick: int
	var action: StringName      # &"walk" | &"jump" | &"dash" | &"blink" | &"slide" | &"release"
	var dir: int                # -1 | 0 | 1

## Converte um hop do grafo numa timeline de intents (determinística).
static func resolve_hop(from: Vector2, to: Vector2, caps: Dictionary, ceiling: float) -> Array[Step]
```

```gdscript
# prefabs/actors/player.gd — ADAPTADOR fino (nó)
# Lê o input (toque/teclado) -> pede a rota -> executa a timeline via move_and_slide().
# NÃO contém regra de jogo: só integra o que o sim/ decidiu.
```

## 4. Fluxo de Execução no Game Loop
1. **Física (60 Hz):** drena comandos ([[SYSTEM-001 Input & Movement Intents|SYSTEM-001]]) → a navegação ([[SYSTEM-002 NavGraph & Pathfinding|SYSTEM-002]]) define a **rota**.
2. Para a aresta atual, `Motion.resolve_hop()` gera a **timeline de intents**.
3. A **máquina de estados** aplica os intents; o **`CharacterBody2D` integra** (`move_and_slide`).
4. **Colisão:** one-way (sobe sempre; desce com down-jump) e piso **sólido** ([[DESIGN-023 Plataformas & Portais|DESIGN-023]]).
5. Fim da aresta → **próxima**; fim da rota → `IDLE`.
6. Emite a posição; o render **interpola**.

## 5. Pontos de Extensão & Escalabilidade (Should Futuro)
- Novas primitivas (**wall-jump**, *double jump*) via um registro — sem tocar no grafo.
- **Knockback / cancelamentos / i-frames** como *flags* de estado (o i-frame de 1 s do [[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]] §1.3 usa isso).
- *Seam* para **catch-up** offline (a locomoção é ignorada — [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] §9).
- Se um dia precisarmos de **colisão determinística própria** (replay bit-a-bit), o seam é trocar o corpo do `CharacterBody2D` por um solver nosso — **sem** mudar a timeline de intents.

## 6. Relacionados
- Design: [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] · [[DESIGN-023 Plataformas & Portais|DESIGN-023]] · [[DESIGN-012 Jump Dash|DESIGN-012]] · [[DESIGN-026 Blink|DESIGN-026]] · [[DESIGN-027 Slide Jump|DESIGN-027]].
- Irmãos: [[SYSTEM-001 Input & Movement Intents|SYSTEM-001]] · [[SYSTEM-002 NavGraph & Pathfinding|SYSTEM-002]] · [[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]].
