# Assets — Registro de Origem e Licença

> **Toda** arte, VFX, fonte ou áudio de terceiros entra aqui. Ver `../00-Context/CONTEXT-016 Assets.md`.
> Formato: **arquivo · origem · licença · autor**.

## Addons (código)
| Item | Origem | Licença |
| :--- | :--- | :--- |
| Godot MCP Toolkit | `NPGameDev/godot-mcp-toolkit` | MIT (LICENSE no addon) |
| Phantom Camera | `ramokz/phantom-camera` | MIT (LICENSE no addon) |
| **Big** (BigNumber) | `ChronoDK/GodotBigNumberClass` | MIT (LICENSE no addon) |

## ✅ Kenney — CC0
Origem: **https://kenney.nl/assets** · Licença: **CC0** (livre, inclusive comercial) · Autor: **Kenney Vleugels**.

| Pacote | Pasta |
| :--- | :--- |
| `ui-pack` · `ui-pack-adventure` · `board-game-icons` · `input-prompts-pixel-1-bit` · `ranks-pack` | `assets/ui/` |
| `new-platformer-pack-1.1` | `assets/tiles/` |
| `particle-pack` · `light-masks-1.0` | `assets/vfx/` |
| `animal-pack-remastered` · `planets` | `assets/sprites/` |
| `digital-audio` · `sci-fi-sounds` | `assets/audio/` |

---

## 🗺️ Mapa de uso (o que usa o quê)
> Decisão [[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]] §1.8: **usar asset do projeto primeiro**; combinar se faltar; placeholder só em último caso.

| Precisa | Asset escolhido | Status |
| :--- | :--- | :--- |
| **Player** (idle/walk/jump/**duck**/**hit**) | `tiles/kenney_new-platformer-pack-1.1/Sprites/Characters/Default/character_*` | ✅ tem **todas** as animações que precisamos (`duck` = down-jump, `hit` = i-frame) |
| **Lesma** | `.../Sprites/Enemies/Default/snail_*` (walk/rest/shell) | ✅ animado |
| **Vespão** | `.../Sprites/Enemies/Default/bee_*` (a/b/rest) | ✅ animado |
| **Esquilo Coletor** | `.../Sprites/Enemies/Default/mouse_*` (walk/rest) | 🟡 **stand-in** (rato ≈ esquilo) |
| **Coruja Sábia** | `sprites/kenney_animal-pack-remastered/PNG/owl.png` | ✅ estático (ok: "sábia" fica parada) |
| **Plataformas / piso** | **desenhados por código** (`level_view.gd` `_draw`) | ✅ [[CONTEXT-009 Direcao de Arte\|CONTEXT-009]] |
| **UI (botões/painéis)** | `ui/kenney_ui-pack/PNG/**` + `ui/kenney_ui-pack-adventure` | ✅ |
| **Fonte (números de dano, HUD)** | `ui/kenney_ui-pack/Font/Kenney Future.ttf` | ✅ |
| **VFX (poeira, impacto, magia)** | `vfx/kenney_particle-pack` | ✅ |
| **Glow das raridades** | `vfx/kenney_light-masks-1.0` | ✅ [[CONTEXT-007 Raridades\|CONTEXT-007]] |
| **Smear (golpes)** | `vfx/smear/*.png` | ⚠️ origem/licença a confirmar |
| **Áudio (hit, level-up, portal)** | `audio/kenney_digital-audio` + `kenney_sci-fi-sounds` | ✅ |
| **Ícones de sistema (skill/item/moeda)** | `ui/kenney_board-game-icons` | ✅ |

## ⚠️ Lacunas (usar placeholder e anotar até resolver)
| Falta | Placeholder escolhido | Ação |
| :--- | :--- | :--- |
| **Cogumelo** (mob) — nenhum cogumelo nos packs | `Enemies/Default/slime_normal_*` (blob) + tint | trocar quando houver arte própria |
| **Vorax** (chefe) — nenhum asset de chefe | `animal-pack/gorilla.png` (ou `bear.png`) **em escala grande + tint roxo/magenta** + chifres **desenhados por código** ([[CONTEXT-009 Direcao de Arte\|CONTEXT-009]]) | trocar quando houver arte própria |
| **Estações do Hub** (NPCs) | ícones do `board-game-icons` sobre um `token` desenhado | `TBD` ([[DESIGN-017 Interactables & Hub\|DESIGN-017]]) |

> **Nada de arte própria inventada por código além de:** plataformas/piso, portais e chifres do Vorax — que a [[CONTEXT-009 Direcao de Arte|CONTEXT-009]] **já define** como vetor/código.

## ⚠️ Licença NÃO confirmada — **risco aceito pelo usuário** (2026-10-16)
| Pasta | O que é | Situação |
| :--- | :--- | :--- |
| `assets/tiles/tex_packed/` (142 MB, 281 arquivos) | pack **"tex packed"** | Sem LICENSE/README — origem desconhecida |
| `assets/vfx/smear/` (6 PNGs + `.aseprite`) | pack **"Smear VFX 01"** | Sem LICENSE — origem desconhecida |
