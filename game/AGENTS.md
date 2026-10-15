# AGENTS.md — Projeto Godot (`game/`)

> Contexto **local** para agentes que trabalham dentro do projeto Godot.
> A **fonte de verdade** é o vault (pasta pai). Regras globais: `../AGENTS.md`.

## Ordem de leitura
1. `../00-Context/CONTEXT-012 Estrutura do Projeto Godot.md` — **estrutura e organização** (leia primeiro).
2. `../02-Architecture/SYSTEM-004 Cenas & Prefabs.md` — prefabs, nós e sinais.
3. O `DESIGN`/`SYSTEM`/`DATA` da feature (ordem: DESIGN → SYSTEM → DATA).

## Regras do motor
- **Headless First:** lógica **pura** em `sim/` (sem nós/render). `sim/` **nunca** importa `prefabs/`/`scenes/`/`ui/`.
- **Prefabs** = peças reutilizáveis (`prefabs/`); **cenas** = composição de topo (`scenes/`).
- Script do prefab = **adaptador fino** (lê → chama `sim/` → desenha). Sem regra de jogo nos nós.
- **Não duplique dados do vault.** Rode `node ../tools/export-data.mjs` para gerar `data/` (gitignored). Valores de design vêm de `data/`.
- **GDScript**, renderer **Compatibility**, orientação **landscape**, 60 ticks/s.

## Ferramentas de IA
- **MCP:** Godot MCP Toolkit (addon em `addons/`) — precisa do editor aberto. Use `discover_tools` para achar ferramentas; **rode o jogo** (`game_start`) e **verifique screenshot/logs**.
- **Addons/ferramentas:** ver `../00-Context/CONTEXT-014 Addons & Ferramentas.md` (Phantom Camera, BigNumber, Beehave, GUT). Preferir **GDScript puro** (alvo web).
- **Skills:** `.opencode/skills/` (ver `ATTRIBUTION.md`).
- **Docs do Godot:** Context7 `/godotengine/godot-docs` (versão `4.7`).
