---
id: CONTEXT-014
aliases:
  - CONTEXT-014
title: Addons & Ferramentas (Godot)
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-15
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
  - "[[CONTEXT-011 Engine & Plataforma|CONTEXT-011]]"
  - "[[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]]"
tags:
  - context
  - convention
  - godot
  - addons
  - ferramentas
---

# 🧩 [CONTEXT-014] Addons & Ferramentas (Godot)

> Curadoria do que **usamos**, do que é **nativo** (não instalar) e do que foi **descartado** — com o critério explícito.
> Instalar addon é decisão de arquitetura: **não** entra nada sem passar pelos critérios abaixo.

## 1. Critérios de Escolha
1. **Compatível com Godot 4.7** e com o renderer **Compatibility** ([[CONTEXT-011 Engine & Plataforma|CONTEXT-011]]).
2. **Alvos:** Android + **Web**. ⚠️ **GDExtension (C++) precisa de binário por plataforma** — inclusive **`.wasm`** para o build web. Por isso **preferimos addons em GDScript puro**, salvo ganho real.
3. **Mantido** (atualização recente) e com **licença permissiva** (MIT).
4. **Headless-friendly:** o addon não pode amarrar a lógica de `sim/` a nós/render ([[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]] §2).

## 2. Adotados
| Addon | Origem | Lic. | Papel | MoSCoW |
| :--- | :--- | :--- | :--- | :--- |
| **Phantom Camera** | `ramokz/phantom-camera` (3.6k★) | MIT | **Câmera (o "Cinemachine" do Godot):** follow + *deadzone*, **prioridade/transição suave**, zoom, **limites** → 🎯 usado para **travar a câmera no topo do footer** ([[CONTEXT-010 UI de Jogo|CONTEXT-010]] §3b) | **Must** |
| **BigNumber** | `ChronoDK/GodotBigNumberClass` (201★) | MIT | **Número gigante** (mantissa + expoente) para o idle — formatação em [[CONTEXT-004 Notacao Numerica\|CONTEXT-004]]. **GDScript puro** ✅ | **Must** |
| **Beehave** | `bitbrain/beehave` (3.3k★) | MIT | **Árvore de comportamento** para IA de mobs (patrulhar, não cair da plataforma, aggro, atacar). **GDScript puro** → roda no **web** ✅ | Should |
| **GUT** | `bitwes/Gut` (2.7k★) | MIT | **Testes headless** de `sim/` (CI) — casa com o *Headless First* | Should |
| **Godot MCP Toolkit** | `NPGameDev/godot-mcp-toolkit` | MIT | Loop de IA (roda/ver screenshot/logs) — já instalado | **Must** |

### Alternativas (avaliadas, ficam de reserva)
| Em vez de | Alternativa | Por que não (por ora) |
| :--- | :--- | :--- |
| Beehave (GDScript) | **LimboAI** (3k★) | C++ (**GDExtension**) → precisa de build/**.wasm**; mais poderoso, mas arriscado pro alvo web |
| GUT | **gdUnit4** (1.2k★) | Ambos ótimos; GUT é mais antigo/estabelecido. Trocar é barato |
| BigNumber (GDScript) | **`shoyguer/big-number`** (GDExtension) | Mais rápido, **mas** exige Godot **4.6** + binários nativos por plataforma |

## 3. Nativo — **NÃO** instalar addon
| Necessidade | O que o Godot 4.7 já dá |
| :--- | :--- |
| **Controle de toque / joystick** | **`VirtualJoystick`** (nó nativo — FIXED/DYNAMIC/FOLLOWING, deadzone) ✅ |
| **Tilemap 2D** | **`TileMapLayer`** (+ `TileSet` com **`one_way_collision`** → plataformas one-way de graça!) |
| **Save/load** | `ConfigFile` · `JSON` · `Resource` |
| **Animação / interpolação** | `AnimationPlayer` · `Tween` |
| **Debug de colisão** | Depurador → *Visible Collision Shapes* |
| **Localização / inputs** | `TranslationServer` · InputMap (remap) |
| **Profiler** | Depurador embutido |

## 4. Avaliado e **recusado**
| Addon | Por que não |
| :--- | :--- |
| Importadores **Aseprite/pixel art** | Nossa arte é **vetorial/emoji/código** ([[CONTEXT-009 Direcao de Arte|CONTEXT-009]]) |
| Importador **Tiled (.tmx)** | Nosso editor (`tools/level-editor.html`) → **loader próprio** (§5) |
| **Popochiu / Dialogue Manager** | Não temos point-and-click nem diálogo ramificado |

## 5. Ferramentas **nossas** (não são addons)
- **`sim/world/level_loader.gd`** — lê `data/levels/*.json` ([[DATA-006 Level Layout|DATA-006]]) → `TileMapLayer` (plataforma **one-way** / piso **sólido**) + instancia os prefabs (portais/interactables). O **editor de nível continua sendo o nosso** (`tools/level-editor.html`); o Godot só **consome** o JSON.
- **Camada de formatação numérica** — formata `BigNumber` na escada de [[CONTEXT-004 Notacao Numerica|CONTEXT-004]].
- **`tools/export-data.mjs`** — a ponte vault → `game/data/` ([[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]] §6).

## 6. Como instalar um addon
1. Os arquivos vão em **`game/addons/<nome>/`** (NÃO têm código nosso — não editar).
2. Ativar em `project.godot` → **`[editor_plugins] enabled`** (`res://addons/<nome>/plugin.cfg`), **ou** em *Projeto → Configurações → Plugins*.
3. **GDScript puro não precisa de plugin habilitado** se só expõe `class_name` — mas habilite para ter o tooling no editor.
4. Se o editor estava aberto, ele **precisa recarregar** (alguns casos: reabrir) para enxergar o plugin novo.
5. Atribuição/licença: manter o `LICENSE` do addon. Skills companheiras (GodotPrompter) existem para **Phantom Camera**, **Beehave**, **LimboAI**.

## 7. Relacionado
- Engine: [[CONTEXT-011 Engine & Plataforma|CONTEXT-011]] · Estrutura: [[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]].
- Câmera/footer: [[CONTEXT-010 UI de Jogo|CONTEXT-010]] §3b · Notação: [[CONTEXT-004 Notacao Numerica|CONTEXT-004]].
- Layout de nível: [[DATA-006 Level Layout|DATA-006]] · Assets/VFX: [[CONTEXT-016 Assets|CONTEXT-016]].
