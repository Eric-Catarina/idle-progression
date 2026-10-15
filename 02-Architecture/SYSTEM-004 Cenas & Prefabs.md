---
id: SYSTEM-004
aliases:
  - SYSTEM-004
title: Cenas & Prefabs
type: tech-spec
status: Draft
moscow: Must
moscow_note: Define como o jogo é montado no Godot — base de todas as features visíveis.
implements: "[[DESIGN-023 Plataformas & Portais|DESIGN-023]]"
dependencies:
  - "[[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]]"
  - "[[DESIGN-023 Plataformas & Portais|DESIGN-023]]"
  - "[[DESIGN-037 Linhas de Dano|DESIGN-037]]"
---

# [SYSTEM-004] Cenas & Prefabs

## 1. Responsabilidade & Escopo
- Define **como as cenas são compostas** no Godot e o **catálogo de prefabs** reutilizáveis.
- Segue a estrutura de [[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]]: `sim/` (lógica) × `prefabs/` (apresentação).
- **Não** define regras de jogo (essas vivem em `01-Design/` + `03-Data/`); aqui só o **contrato de montagem**.

## 2. Padrão — Composição & Adaptador Fino
- **Sem ECS, sem herança profunda.** Composição de nós + **sinais**.
- Cada prefab = **um** `Area2D`/`CharacterBody2D` raiz + nós-membros + **script adaptador**:
  1. lê o mundo → 2. chama a função **pura** em `sim/` → 3. aplica o resultado (visual/sinais).
- Estado **autoritativo** vive em `sim/` + autoloads (`GameState`), **nunca** no nó.
- Fluxo de dados: **`sim/` é soberana**; os nós apenas **espelham**.

## 3. Catálogo de Prefabs

### 3.1 Portal de Fase — `prefabs/props/portal_fase.tscn`
Teletransporta entre **níveis** (tiles `4` Entrada / `5` Saída — [[DATA-006 Level Layout|DATA-006]]).
```
PortalFase (Area2D)          # script: portal_fase.gd
├── Shape (CollisionShape2D) # RectangleShape2D 1 célula
├── Sprite (AnimatedSprite2D)# Entrada/Saída (azul/vermelho)
└── Glow (PointLight2D)      # silhueta/brilho cósmico (CONTEXT-009)
```
| Contrato | Tipo | Descrição |
| :--- | :--- | :--- |
| `@export kind` | enum `ENTRADA \| SAIDA` | Papel do portal. |
| `@export target_level` | `String` | Nível destino (`"Level1_2"`); vazio = corrente. |
| `@export target_portal` | `String` (`"entrada"`) | Onde o player **nasce** no destino. |
| `signal portal_requested` | `(kind, target_level, target_portal)` | A cena de nível escuta e **pede** a transição. |

- **Regra:** ao entrar num **Portal Saída**, o player nasce no **Portal Entrada** do nível destino (DESIGN-023 §3).

### 3.2 Portal Intrafase — `prefabs/props/portal_intrafase.tscn`
Teleporta **dentro da mesma fase** (tile `2`, par em ordem de leitura — [[DESIGN-023 Plataformas & Portais|DESIGN-023]]).
```
PortalIntrafase (Area2D)         # script: portal_intrafase.gd
├── Shape (CollisionShape2D)
├── Sprite (AnimatedSprite2D)    # **amarelo**
└── Glow (PointLight2D)
```
| Contrato | Tipo | Descrição |
| :--- | :--- | :--- |
| `@export pair_id` | `int` | **Mesmo `pair_id` = par** (2 portais com o mesmo id). |
| `@export spawn_offset` | `Vector2` | Offset pequeno na chegada (evita re-trigger). |
| `signal teleport_requested` | `(from_id, to_id)` | A sim resolve a posição do par. |

- **Autoridade do par:** resolvida em `sim/world/portals.gd` a partir da grade (não da cena) — a cena só **espelha**.
- **Casos de borda:** nº **ímpar** → último **inativo**; dois na **mesma célula** → aviso no export; portal no **piso** → evitar.

### 3.3 Player — `prefabs/actors/player.tscn`
```
Player (CharacterBody2D)         # player_view.gd
├── Shape (CollisionShape2D)
├── Sprite (AnimatedSprite2D)
├── Hurtbox (Area2D)             # recebe dano
└── Camera (Camera2D)
```
- Movimento/pulo/down-jump: [[SYSTEM-003 Kinematics & Motion Primitives|SYSTEM-003]]; intents de input: [[SYSTEM-001 Input & Movement Intents|SYSTEM-001]].
- Lógica pura em `sim/world/` (tap-to-move + grafo: [[SYSTEM-002 NavGraph & Pathfinding|SYSTEM-002]]).

### 3.4 Mob — `prefabs/actors/mob.tscn`
```
Mob (CharacterBody2D)            # mob_view.gd
├── Shape (CollisionShape2D)
├── Sprite (AnimatedSprite2D)
└── Hitbox (Area2D)              # aplica dano ao player
```
- **Nunca cai da plataforma** (clamp à plataforma de origem) — ver população/quota em [[DATA-014 Populacao Mundo 1|DATA-014]].
- Stats (`hp`, `atk`, `xp`, `capLinha`) vêm de `data/` ([[DATA-006 Level Layout|DATA-006]] → bridge).

### 3.5 Damage Number — `prefabs/fx/damage_number.tscn`
Número flutuante **por linha** ([[DESIGN-037 Linhas de Dano|DESIGN-037]]); vários por acerto, em camadas.
```
DamageNumber (Node2D)            # damage_number_view.gd
├── Label (Label)                # valor + cor (crítico)
└── Anim (AnimationPlayer|Tween)
```
| Contrato | Tipo | Descrição |
| :--- | :--- | :--- |
| `@export value` | `int` | Dano da linha. |
| `@export is_crit` | `bool` | Marca visual do crítico (rolado **por linha**). |
| `@export layer_index` | `int` | Ordem da linha no acerto (stagger/fade). |

### 3.6 Interactable — `prefabs/props/interactable.tscn`
NPC / estação (camada `interactables` — [[DESIGN-017 Interactables & Hub|DESIGN-017]]).
```
Interactable (Area2D)            # interactable.gd
├── Shape (CollisionShape2D)
├── Sprite (Sprite2D)            # emoji/ícone (CONTEXT-009)
└── Prompt (Label)               # "!" / nome
```
| Contrato | Tipo | Descrição |
| :--- | :--- | :--- |
| `@export interactable_id` | `String` | `osiris`, `cartas`, `selos`, … |
| `signal interact_requested` | `(interactable_id)` | Abre a janela correspondente (UI `Should`/`Could`). |

## 4. Contratos Globais (GDScript)
```gdscript
# sim/world/portals.gd — lógica pura (sem nós)
class_name Portals extends RefCounted
static func resolve_pair_index(grid: Array, cols: int, rows: int) -> Dictionary
static func pair_position(pair_id: int, grid: Array, cols: int) -> Vector2  # ✱ pura/testável
```

```gdscript
# autoload/GameState.gd — estado autoritativo (headless)
var player_level: int = 1
var player_xp: int = 0
func apply_damage_lines(lines: Array[int], cap_per_line: int) -> int  # DESIGN-037
```

## 4b. Composição de Tela (`Main`): Mundo + Footer
- `scenes/main.tscn` = **2 camadas** ([[CONTEXT-010 UI de Jogo|CONTEXT-010]] §3b):
  - **World** (`Node2D` + `Camera2D`): a cena do nível. A **câmera** tem o **limite inferior no topo do footer** — o mundo nunca aparece abaixo dele.
  - **Footer** (`CanvasLayer`, `layer = 10`): a **UI principal** fixa (infos + botões de menu). `F = 89` px, padding `P = 8`.
- O nível ancora a **última linha (piso)** na **superfície do piso** (`F + P` do fundo) — [[DATA-006 Level Layout|DATA-006]].
- **Janelas** de sistema abrem em camada **acima** do footer ([[CONTEXT-010 UI de Jogo|CONTEXT-010]]).

## 5. Fluxo de Execução
1. **`Main`** (`scenes/main.tscn`) carrega o nível via `DataDB` (`data/levels/*.json`).
2. `LevelView` **instancia** os prefabs a partir da **grade** (tiles → prefabs) na montagem.
3. **Física** (60 ticks/s) move `Player`/`Mob`; a `sim/` resolve colisão/navegação.
4. **Entrar num portal** → prefab emite `*_requested` → `LevelView`/`GameState` decide → troca de nível/teleporte.
5. **Dano** → `sim/combat` calcula linhas → `fx/damage_number` instanciado **por linha**.

## 6. Pontos de Extensão & Escalabilidade (Should Futuro)
- **Novo tile/prefab:** registre em `tile → prefab` (tabela de montagem) — sem tocar no núcleo.
- **Portal de Fase — variantes** (Should): animação de transição, custo de entrada, portal bloqueado (cota não batida — [[DATA-014 Populacao Mundo 1|DATA-014]]).
- **`Could`:** portais com destino parametrizável por evento; não implementar agora ([[CONTEXT-001 MoSCoW|CONTEXT-001]]).

## 7. Relacionados
- Estrutura: [[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]] · Portais: [[DESIGN-023 Plataformas & Portais|DESIGN-023]].
- Navegação: [[SYSTEM-002 NavGraph & Pathfinding|SYSTEM-002]] · Kinematics: [[SYSTEM-003 Kinematics & Motion Primitives|SYSTEM-003]].
- Dano por linha: [[DESIGN-037 Linhas de Dano|DESIGN-037]] · Layout/tiles: [[DATA-006 Level Layout|DATA-006]].
