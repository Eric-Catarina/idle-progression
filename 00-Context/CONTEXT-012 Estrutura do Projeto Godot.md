---
id: CONTEXT-012
aliases:
  - CONTEXT-012
title: Estrutura do Projeto Godot
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-15
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
  - "[[CONTEXT-011 Engine & Plataforma|CONTEXT-011]]"
  - "[[CONTEXT-010 UI de Jogo|CONTEXT-010]]"
tags:
  - context
  - convention
  - godot
  - estrutura
  - organizacao
---

# 📐 [CONTEXT-012] Estrutura do Projeto Godot

> **Este é o "Context do Godot".** Convenção global de **organização do projeto em `game/`** — vale para **humano e IA**.
> Foco: **escalabilidade, integridade e organização**. Nada de estrutura ad-hoc.

## 1. Propósito
- Eliminar a ambiguidade de **onde cada coisa vive** no projeto Godot.
- Garantir o **Headless First** ([[CONTEXT-000 Manifesto|CONTEXT-000]]): lógica de jogo **desacoplada** de nós/render.
- Manter **integridade**: o **vault é a fonte de verdade**; o jogo **consome**, nunca duplica.
- Dar à IA (e ao humano) um **mapa previsível** — toda feature nova cai num lugar óbvio.

## 2. Regra de Ouro — 3 camadas
| Camada | Pasta | Pode depender de | **NUNCA** |
| :--- | :--- | :--- | :--- |
| **Simulação (headless)** | `sim/` | GDScript puro (RefCounted/Resource) | Árvore de nós, render, input, tela |
| **Apresentação (prefabs)** | `prefabs/`, `scenes/`, `ui/` | `sim/`, nós, render | Regra de jogo (só **espelha**) |
| **Dados (gerados)** | `data/`, `resources/` | — | Ser editado à mão |

> **Regra dura:** `sim/` **nunca** importa `prefabs/`/`scenes/`/`ui/`. A dependência é **sempre de mão única**: apresentação → simulação.

## 3. Estrutura de Pastas (`game/`)
```
game/
├── project.godot
├── addons/              # 🔌 plugins (Godot MCP Toolkit) — NÃO editar
├── autoload/            # Singletons globais (GameState, EventBus, DataDB)
├── sim/                 # 🔒 HEADLESS — lógica pura, sem nós/render
│   ├── combat/          #   dano, skills, fila de skills, linhas
│   ├── progression/     #   xp, nível, drops, essência
│   └── world/           #   colisão (AABB), navgraph, spawner, portais
├── prefabs/             # 🧩 "PREFABS" — cenas reutilizáveis INSTANCIÁVEIS
│   ├── actors/          #   player.tscn, mob.tscn
│   ├── props/           #   portal_fase.tscn, portal_intrafase.tscn, interactable.tscn
│   └── fx/              #   damage_number.tscn, floating_text.tscn
├── scenes/              # 🎬 cenas COMPOSTAS (main.tscn, level_view.tscn)
├── ui/                  # 🖥️ HUD e janelas (flutuam sobre o mundo — CONTEXT-010)
├── resources/           # 📦 Custom Resources (.tres): defs de skill/mob/tema
├── data/                # 🔄 GERADO do vault (gitignore) — níveis e tabelas
└── tests/               # 🧪 testes headless (lógica de `sim/`)
```

### A diferença "prefab" × "cena"
- **Prefab** (`prefabs/`) = peça **reutilizável** que se **instancia** em vários lugares (como os *prefabs* da Unity). Ex.: **um** portal que aparece em N mapas.
- **Cena** (`scenes/`) = composição **única** de topo que **monta** prefabs (ex.: o `Main`, o `LevelView`).
- **Regra:** se **repete** no jogo → **prefab**. Se **existe uma vez** → **cena**.

## 4. Convenções de Nomes
| Item | Convenção | Exemplo |
| :--- | :--- | :--- |
| Arquivo de cena/prefab | `snake_case.tscn` | `portal_fase.tscn` |
| Script anexado à cena | **mesmo nome**, ao lado | `portal_fase.gd` |
| Lógica pura | `snake_case.gd` em `sim/` | `sim/world/portals.gd` |
| Autoload | `PascalCase` | `GameState`, `EventBus`, `DataDB` |
| Classe GDScript | `class_name PascalCase` | `class_name PortalFase` |
| Nó na árvore | `PascalCase` | `Sprite`, `Hitbox`, `CollisionShape2D` |
| Sinal | `snake_case`, **no passado** | `portal_entered`, `damage_dealt` |
| Custom Resource | `snake_case.tres` + `class_name` | `skill_def.tres` / `class_name SkillDef` |

## 5. Prefabs (contrato geral)
- Um prefab é **autossuficiente**: não assume onde foi instanciado; recebe contexto via `@export` ou sinal.
- Expõe **o mínimo** de nós; o resto é `private` (`_` no início do nome).
- Comunica para fora **só** por **sinais** — nunca chama a cena-mãe diretamente.
- A **regra de jogo** do prefab vive em `sim/`; o script do prefab é um **adaptador fino** (ler estado → pedir à `sim/` → desenhar).
- Catálogo de prefabs e seus nós/sinais: [[SYSTEM-004 Cenas & Prefabs|SYSTEM-004]].

## 6. Integridade dos Dados (vault → jogo)
- O jogo **não** contém números de design hardcoded (HP, XP, cota, layout).
- **Ponte:** `tools/export-data.mjs` gera `game/data/**` a partir do vault:
  - `03-Data/levels/*.json` → `game/data/levels/*.json` (cópia fiel).
  - blocos ```` ```json ```` dos docs `03-Data/*.md` → `game/data/tables/*.json`.
- `game/data/` é **gerado** e **gitignored** — regenera-se com o script; **nunca** editar lá.
- **Nunca** copiar tabela do vault para dentro do código. Se o valor muda no vault, o jogo muda no próximo export.
- Detalhes do schema: [[DATA-006 Level Layout|DATA-006]]; balanceamento: [[DATA-013 XP e Nivel|DATA-013]], [[DATA-014 Populacao Mundo 1|DATA-014]].

## 7. Fluxo de Trabalho com IA
1. **Ler** o DESIGN/SYSTEM/DATA relevante no vault **antes** de codar (ordem: DESIGN → SYSTEM → DATA).
2. **Escrever** lógica pura em `sim/` **primeiro** (testável headless).
3. **Montar** o prefab/cena e ligar (adaptador fino).
4. **Rodar** pelo **Godot MCP** (`game_start`) e **verificar screenshot + logs** — nunca "achar que rodou".
5. **Testar** `sim/` em `tests/` (headless) quando houver regra não trivial.
- **Fontes de consulta (IA):**
  - **Docs do Godot (Context7):** `library_id = /godotengine/godot-docs`, versão **`4.7`** (44k+ trechos, reputação *High*). Consultar **antes** de codar APIs novas.
  - **Skills locais** (`.opencode/skills/`): `godot-mcp-toolkit`, `mcp-extension-creator`, `progression-idle` + vendorizadas do **GodotPrompter** (`hud-system`, `player-controller`, `physics-system`, `2d-essentials`, `resource-pattern`, `mobile-development`, `scene-organization`, `component-system`). Atribuição em `.opencode/skills/ATTRIBUTION.md`.
- **Um MCP por vez:** só o **Godot MCP Toolkit** controla o editor. **Não** rodar dois MCPs de Godot simultâneos (conflito de edição/runtime).

## 8. Escalabilidade (regras para crescer)
- **Feature nova:** crie `sim/<area>/`; o prefab/cena correspondente vai para `prefabs/` ou `scenes/`.
- **Novo mundo:** nenhuma pasta muda — os dados vêm de `data/` (por mundo/nível). Estrutura **não** cresce com conteúdo.
- **Nada de pastas por nível/mundo** no código: o conteúdo é **dado**, não estrutura.
- **Seams (Should):** exponha pontos de extensão em `sim/` sem implementar a feature futura ([[CONTEXT-001 MoSCoW|CONTEXT-001]]).

## 9. Casos de Borda
- **Cena de teste embutida** em addon → ignorar (não é a nossa).
- **Script de `sim/` que precisa de tempo** → receba `delta` por parâmetro; **nunca** use `_process` (deve rodar headless).
- **Prefab que só existe uma vez** → pode virar cena (`scenes/`); o inverso também vale.

## 10. Relacionado
- Engine/plataforma: [[CONTEXT-011 Engine & Plataforma|CONTEXT-011]] · UI: [[CONTEXT-010 UI de Jogo|CONTEXT-010]].
- Cenas/prefabs técnicos: [[SYSTEM-004 Cenas & Prefabs|SYSTEM-004]] · Navegação: [[SYSTEM-000 Navegacao (ADR-001)|SYSTEM-000]].
- Manifesto: [[CONTEXT-000 Manifesto|CONTEXT-000]].
