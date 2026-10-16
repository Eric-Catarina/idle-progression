---
id: CONTEXT-016
aliases:
  - CONTEXT-016
title: Assets — Fontes, Licenças & Técnicas
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-15
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
  - "[[CONTEXT-009 Direcao de Arte|CONTEXT-009]]"
  - "[[CONTEXT-014 Addons & Ferramentas|CONTEXT-014]]"
tags:
  - context
  - convention
  - assets
  - licencas
  - vfx
---

# 🎨 [CONTEXT-016] Assets — Fontes, Licenças & Técnicas

> De onde puxar arte/VFX prontos, o que **pode** e o que **não pode** ser reusado, e como tratamos **Smear** e **Atlas (texture packing)**.

## 1. ⚠️ Regra dura de licença (leia antes de baixar)
| Fonte | Pode usar no nosso jogo? |
| :--- | :--- |
| **CC0 / Domínio Público** | ✅ **Sim, sem obrigação** (nem crédito). Preferir sempre. |
| **CC-BY / MIT / OFL** | ✅ Sim — **exigindo atribuição** (guardar autor + link em `game/ASSETS.md`). |
| **Unity Asset Store** | ⚠️ **Evitar.** O EULA é **omisso sobre outras engines** e assets de *Editor Extension/Scripting* são **Unity-only**; o risco não compensa. |
| **Unreal / Fab (Epic) Marketplace** | ⛔ **Não.** O conteúdo é licenciado **para uso com o Unreal Engine**. Portar pra Godot **viola** a licença. |
| **Rips de jogos** (MapleStory, IdleOn, sprites de wiki) | ⛔ **Nunca.** É propriedade dos estúdios — serve só como **referência** (`99-Inbox/reference/`). |

> **Shaders de outras engines:** a **técnica/ideia** é livre (reimplementar do zero é ok); o **código** (HLSL/ShaderGraph/`.shader`) **não** pode ser copiado. Converter = **reescrever** em GDShader (inspirado), nunca traduzir linha a linha uma fonte licenciada.

## 1b. Onde os assets vivem (pasta)
- **`game/assets/`** = o que o **jogo USA** → **versionado**, em subpastas por tipo:
  `sprites/` · `tiles/` · `ui/` · `vfx/` · `audio/` · `fonts/`.
- **`game/assets/_raw/`** = packs **baixados** (staging) → **gitignored** e com **`.gdignore`** (o Godot **não** importa nem varre).
- **Fluxo:** baixar → jogar em `_raw/` → **copiar só o que usar** para a pasta do tipo → **registrar em `game/ASSETS.md`**.
- **Nunca** versionar packs crus — o repo não pode inchar (só entra o que o jogo referencia).
- Nome de arquivo em **`snake_case`** ([[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]] §4).
- ⚠️ `_raw/` **não** é backup: é staging. O que for usado **sai** de lá.

## 2. Fontes recomendadas (grátis)
| Site | O que tem | Licença |
| :--- | :--- | :--- |
| **kenney.nl/assets** | 🥇 **UI kits, botões, ícones, sprites 2D, VFX** | **CC0** |
| **itch.io/game-assets/free** | Pacotes de VFX, pixel art, UI (filtrar por free) | varia (**checar**) |
| **opengameart.org** | Sprites, tilesets, VFX | CC0/CC-BY |
| **game-icons.net** | +4.000 ícones vetoriais (skills, itens, status) | CC BY 3.0 |
| **godotshaders.com** | 🥇 **Biblioteca de shaders** da comunidade (glow, outline, dissolve, smear…) | por shader (checar) |
| **craftpix.net/freebies** | UI/VFX/tilesets | própria (uso livre em jogo) |
| **fonts.google.com** | Fontes | OFL |
| **lospec.com** | Paletas (cor por raridade — [[CONTEXT-007 Raridades\|CONTEXT-007]]) | CC0/varia |

- **Godot Asset Library** (`godotengine.org/asset-library`) — pequena, mas tem shaders/utilitários.
- ⚠️ Sempre registre a origem em **`game/ASSETS.md`** (nome, URL, licença, autor).

## 3. VFX — o que é **nativo** (não precisa asset)
- **`GPUParticles2D`** + `ParticleProcessMaterial` (fogo, poeira, faísca, rastro) — [[CONTEXT-014 Addons & Ferramentas|CONTEXT-014]] §3.
- **`AnimationPlayer`** + **sprite sheets** (flipbook).
- **Shaders** (glow/bloom/outline/dissolve) — o **Compatibility** suporta `canvas_item` shaders simples ([[CONTEXT-011 Engine & Plataforma|CONTEXT-011]]).
- **Desenho por código** (`_draw`) — nosso padrão atual ([[CONTEXT-009 Direcao de Arte|CONTEXT-009]]).

## 4. **Smear** (smear frame / arrasto de movimento)
> **O que é:** um "borrão direcional" que vende velocidade — o frame em que o golpe atravessa o ar (MapleStory/IdleOn usam muito em ataques).

**Como fazemos (3 níveis, do barato ao caro):**
1. **Eco (afterimage):** instanciar 2–3 cópias do sprite com `modulate.a` decrescente e posições atrasadas — **sem shader**. Já dá 90% do efeito. ✅ *nosso padrão inicial*
2. **Esticar (vertex stretch):** shader que **estica** o quad na direção do movimento (smear clássico de animação).
3. **Blur direcional:** shader de blur amostrando a textura na direção do vetor velocidade.

- **Regra:** o smear é **visual**, não mexe em colisão/dano ([[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]] §2).
- Implementação: `prefabs/fx/` (ex.: `afterimage.tscn`) + um `smear.gdshader`. **A definir quando houver skills com golpe.**

## 5. **Texture Packing (atlas)**
> **Por quê:** agrupar sprites numa **única textura** reduz trocas de estado → **menos draw calls** (importante no mobile/web).

| Abordagem | Quando usar |
| :--- | :--- |
| **`AtlasTexture`** (Região de outro PNG) | Ícones/UI esporádicos |
| **`TileSet` (atlas + tiles)** | Tiles/plataformas e **UI** com muitos elementos |
| **Sprite sheet + `SpriteFrames`** | Animação (flipbook) |
| **Atlas externo (`.atlas`/JSON)** | Pipeline de packer: `Rubonnek/gdx-texture-packer-atlas-importer` (12★) |

- **Ferramentas de packing:** [Free Texture Packer](https://free-tex-packer.com/), `glueit`, `texturepacker`. Saída: 1 PNG + 1 arquivo de coordenadas.
- **Import (Godot):** `filter = Nearest` (pixel art) **ou** `Linear` (vetorial) — decidir por asset; **Mipmaps off** para 2D de UI; **Compress** = `Lossless` p/ UI (VRAM comp ressiona mal texto/UI).
- ⚠️ **Padding de 1–2 px** entre sprites no atlas (evita "vazamento" de borda com filtro linear).
- ⚠️ **Não** otimizar antes de medir ([[SYSTEM-006 Dados Imutáveis & Carregamento|SYSTEM-006]] §6).

## 6. Checklist antes de commitar um asset
- [ ] Licença **verificada** e registrada em `game/ASSETS.md`
- [ ] Origem **não** é loja de outra engine (Unity/Fab) nem rip de jogo
- [ ] Nome no padrão `snake_case` ([[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]] §4)
- [ ] Tamanhos na escala Fibonacci ([[CONTEXT-008 Escala Visual|CONTEXT-008]])
- [ ] Cor/raridade coerente ([[CONTEXT-009 Direcao de Arte|CONTEXT-009]], [[CONTEXT-007 Raridades|CONTEXT-007]])

## 7. Relacionado
- Arte: [[CONTEXT-009 Direcao de Arte|CONTEXT-009]] · Raridades/cor: [[CONTEXT-007 Raridades|CONTEXT-007]] · Escala: [[CONTEXT-008 Escala Visual|CONTEXT-008]].
- Addons: [[CONTEXT-014 Addons & Ferramentas|CONTEXT-014]] · Engine: [[CONTEXT-011 Engine & Plataforma|CONTEXT-011]].
