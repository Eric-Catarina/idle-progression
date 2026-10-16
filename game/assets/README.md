# Assets (`game/assets/`)

| Pasta | O que vai aqui | Versionado? |
| :--- | :--- | :--- |
| `sprites/` | personagens, mobs, props | ✅ |
| `tiles/` | tilesets / plataformas | ✅ |
| `ui/` | botões, painéis, ícones, cursores | ✅ |
| `vfx/` | partículas, **smear**, flipbooks | ✅ |
| `audio/` | SFX e música | ✅ |
| `fonts/` | fontes (.ttf/.otf) | ✅ |
| `_raw/` | packs **sem licença confirmada** (staging) | ❌ gitignore + `.gdignore` |

## Instalado (todos **CC0** — Kenney.nl)
| Pacote | Onde |
| :--- | :--- |
| `kenney_ui-pack`, `kenney_ui-pack-adventure`, `kenney_board-game-icons`, `kenney_input-prompts-pixel-1-bit`, `kenney_ranks-pack` | `ui/` |
| `kenney_new-platformer-pack-1.1` | `tiles/` |
| `kenney_particle-pack`, `kenney_light-masks-1.0` | `vfx/` |
| `kenney_animal-pack-remastered`, `kenney_planets` | `sprites/` |
| `kenney_digital-audio`, `kenney_sci-fi-sounds` | `audio/` |

> Cada pacote mantém seu `License.txt` (CC0) e a estrutura original.

## ⚠️ Em `_raw/` (sem licença confirmada — **não usar ainda**)
| Pasta | O que é |
| :--- | :--- |
| `tex_packed/` | ~360 PNGs (tilesets/atlas, 460 MB) — origem a confirmar |
| `smear_vfx_01/` | fonte `.aseprite` + PNGs de smear — origem a confirmar |

## 📌 Notas de operação
- **Import:** o Godot importa **~5.750 PNGs** na primeira abertura (`ui/` sozinho tem ~3.900). É **custo de 1ª vez**; depois o scan é incremental. O `.godot/imported/` (não versionado) cresce ~centenas de MB.
- **Se ficar lento:** crie um arquivo vazio **`.gdignore`** dentro de qualquer pacote que você **não** está usando → o Godot para de importá-lo (reversível: só apagar o arquivo).
- **Fluxo para usar um sprite:** arraste do dock *FileSystem* (ele já funciona direto — é uma cena/prefab que referencia o PNG).
- Regras completas (licenças, smear, atlas): `../../00-Context/CONTEXT-016 Assets.md`.
