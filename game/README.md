# Idle Progression — projeto Godot

Projeto do jogo: **Godot 4.7.x** · renderer **Compatibility** · **GDScript**.
Faz parte do **monorepo** — o **vault** de design/planejamento fica na **pasta pai** (`../`).

## ▶️ Abrir o editor

```powershell
C:\Users\ormen\Documents\dev\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64.exe --path . --editor
```
> ⚠️ O zip foi extraído numa **pasta com o nome do exe** — o caminho tem o nome repetido duas vezes.
(ou, no Godot: **Import → `project.godot`**)

## ⚙️ Settings já aplicadas (`project.godot`)

| Setting | Valor | Por quê |
| :--- | :--- | :--- |
| `renderer/rendering_method` | `gl_compatibility` | 2D + mobile (baixo/antigo) + web |
| `display/window/handheld/orientation` | `4` (**sensor_landscape**) | **sempre deitado** |
| `display/window/stretch/mode` / `aspect` | `canvas_items` / `expand` | **fullscreen** |
| `application/run/low_processor_mode` | `true` | jogo **idle** (bateria) |
| `physics/common/physics_ticks_per_second` | `60` | sim de **passo fixo** |

## 🤖 IA — Godot MCP Toolkit (v1.0.4)

- Addon em **`addons/godot_mcp_toolkit`** (habilitado em `project.godot` → `[editor_plugins]`).
- Config do cliente: **`.mcp.json`** (aqui) + **`../opencode.jsonc`** (servidor `godot`).
- **Ao abrir o editor**, o dock mostra `[MCPServer] listening on 127.0.0.1:6550` → aí o agente consegue
  **criar cena, rodar o jogo, ver *screenshot* e ler os logs** (fecha o loop de IA: o agente **joga e vê**).
- Skill companheira do agente: `../.opencode/skills/godot-mcp-toolkit/`.

## 📚 Dados de design (vault)

- O **vault** (fonte de verdade) fica em **`../`**: `00-Context/`, `01-Design/`, `02-Architecture/`, `03-Data/`.
- **Níveis:** `../03-Data/levels/*.json` (formato em `03-Data/DATA-006 Level Layout.md`).
- Decisão de engine: `00-Context/CONTEXT-011 Engine & Plataforma.md`.
