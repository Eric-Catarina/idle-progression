---
id: CONTEXT-011
aliases:
  - CONTEXT-011
title: Engine & Plataforma (Decisão)
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-15
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
  - "[[CONTEXT-010 UI de Jogo|CONTEXT-010]]"
tags:
  - context
  - convention
  - engine
  - platform
---

# ⚙️ [CONTEXT-011] Engine & Plataforma (Decisão)

## 1. Decisão
- **Engine:** **Godot 4.7.x-stable** (4.7.2 na adoção).
- **Renderer:** **Compatibility** (OpenGL 3.3 / GLES 3.0 / WebGL2).
- **Linguagem:** **GDScript** (não C#).
- **Projeto:** pasta **`game/`** **dentro deste repo** (monorepo **docs + jogo**).
- **Fluxo com IA:** **Godot MCP Toolkit** (addon p/ Godot **4.2–4.7**, com **canal de runtime**: inicia o jogo, inspeciona nós, simula input, lê logs e **tira screenshot do jogo rodando**).

## 2. Por quê
- **Performance mobile + compatibilidade:** o renderer **Compatibility** é o recomendado para **jogos 2D** e para **hardware modesto/antigo**, e dá "o melhor desempenho possível em todos os dispositivos". Roda de **low-end a topo** e o **mesmo renderer serve o web** (→ dá pra manter um build **PWA** de brinde).
- **IA:** GDScript é a linguagem mais "treinada" e o **MCP com runtime** fecha o loop (o agente **joga e vê**) — o ponto fraco do fluxo anterior era o agente **não conseguir ver a tela**.
- **Monorepo:** o jogo lê os dados do vault (`03-Data/levels/*.json`) **sem duplicar** — casa com "o vault é a fonte de verdade".

## 3. Configuração aplicada (`game/project.godot`)
| Setting | Valor | Motivo |
| :--- | :--- | :--- |
| `renderer/rendering_method` | `gl_compatibility` | 2D + mobile + web |
| `display/window/handheld/orientation` | `4` (**sensor_landscape**) | **sempre deitado** ([[CONTEXT-010 UI de Jogo\|CONTEXT-010]]) |
| `display/window/stretch/mode` / `aspect` | `canvas_items` / `expand` | **fullscreen** |
| `application/run/low_processor_mode` | `true` | jogo **idle** (bateria) |
| `physics/common/physics_ticks_per_second` | `60` | sim de **passo fixo** (Headless First) |
| `display/window/size/viewport_*` | `1280×720` | base 16:9 |

## 4. Alternativas avaliadas
- **Forward+ / Mobile**: exigem **Vulkan/D3D12/Metal** (hardware novo); desnecessário para **2D**. O Godot 4.4+ ainda faz *fallback* automático.
- **Godot 3.5 (GLES2)**: só se o alvo fossem celulares **muito** antigos (pré-GLES3) — mas perde o **MCP/IA**.
- **C#**: export Android ainda **experimental**; GDScript é melhor para IA e gera **APK menor**.
- **Outros motores** (Unity e afins): avaliados e descartados — trocam o **controle de runtime** e o **loop de IA** por editores pesados. Os aprendizados do protótipo descartável já estão documentados (engine-agnósticos).
- **Outros MCPs de Godot** (ex.: Coding-Solo/godot-mcp, ~6k★): existem e são maduros, mas **não** rodamos dois MCPs controlando o mesmo editor. O **Toolkit** fica por ter o **canal de runtime** (roda/ver screenshot) + `discover_tools` + **API de extensão** em GDScript. Ver [[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]] §7.

## 5. Relacionados
- UI: [[CONTEXT-010 UI de Jogo|CONTEXT-010]] · Arte: [[CONTEXT-009 Direcao de Arte|CONTEXT-009]] · Hierarquia: [[CONTEXT-006 Hierarquia|CONTEXT-006]].
