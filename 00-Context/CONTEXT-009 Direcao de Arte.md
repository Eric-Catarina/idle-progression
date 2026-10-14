---
id: CONTEXT-009
aliases:
  - CONTEXT-009
title: Direção de Arte (Estilo Visual)
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-14
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
  - "[[CONTEXT-007 Raridades|CONTEXT-007]]"
tags:
  - context
  - convention
  - art
---

# 🎨 [CONTEXT-009] Direção de Arte (Estilo Visual)

## 1. Propósito
Definir o **estilo visual** do jogo: **barato de produzir** (quase tudo por código + emoji), **coeso** e **engine-agnóstico** (não depende de Godot/Phaser/qualquer engine).

## 2. Os 3 Pilares (mistura)
| Pilar | Onde é usado | Como |
| :--- | :--- | :--- |
| **Flat Vetorial** | *mundo*, painéis, formas | formas chapadas, 2–3 tons, cantos arredondados, **sem textura** |
| **Silhueta + Glow** | *entidades* (player, mobs, NPCs) e acentos | **silhueta flat escura** + **glow** (cor de destaque) + olhos/pontos brilhantes |
| **Emoji / Símbolo** | *ícones* (item, card, selo, moeda, stat, skill, raridade) | glifo de emoji sobre um **token** (base arredondada) + contorno/tint |

## 3. Como se Combinam (camadas)
1. **Mundo** = flat vetorial (contraste baixo, cores apagadas).
2. **Entidades** = silhueta + glow (alto contraste, destacam do fundo).
3. **Ícones** = tokens de emoji (legibilidade imediata).
4. **Raridade** injeta **cor/glow** em qualquer camada ([[CONTEXT-007 Raridades|CONTEXT-007]]).

## 4. Shape Language (regra de coesão)
- **Cantos arredondados** em tudo; **1 contorno**; **sombra chata** (offset sólido, sem blur). Nada de gradiente complexo.
- **Paleta única** (~8–12 cores) + as **cores de raridade reservadas**.
- **Silhueta legível:** mesmo pintada de preto, a forma identifica a entidade.
- **Fundos escuros** (obsidiana) para o *glow* brilhar — casa com a raridade **Divino**.

## 5. Renderização de Emoji (2 modos)
| Modo | Uso | Como |
| :--- | :--- | :--- |
| **Token tingido** | ícones de item/recurso | emoji + base arredondada + contorno + *tint* de raridade (mantém a cor natural) |
| **Máscara de silhueta** | entidades/efeitos | glifo → **máscara de alpha** → 1 cor + glow |

> Assim um mesmo emoji serve como **ícone colorido** (💰) ou como **silhueta glow** (🌑💥), sem sair do estilo.

### Amostra (renderizada no Obsidian)
<div style="display:flex;gap:14px;align-items:center;flex-wrap:wrap;font-family:system-ui;padding:6px 0">
  <span style="display:inline-flex;width:44px;height:44px;align-items:center;justify-content:center;font-size:24px;background:#1b1f27;border:2px solid #6ea8fe;border-radius:12px;box-shadow:0 0 8px #6ea8fe">💰</span>
  <span style="display:inline-flex;width:44px;height:44px;align-items:center;justify-content:center;font-size:24px;background:#1b1f27;border:2px solid #a970ff;border-radius:12px;box-shadow:0 0 10px #a970ff">🎴</span>
  <span style="display:inline-flex;width:44px;height:44px;align-items:center;justify-content:center;font-size:24px;background:#1b1f27;border:2px solid #ffb300;border-radius:12px;box-shadow:0 0 12px #ffb300">💎</span>
  <span style="display:inline-block;width:22px;height:34px;background:#0f1218;border-radius:10px;box-shadow:0 0 10px #6ea8fe,inset 0 0 6px #6ea8fe"></span>
  <span style="display:inline-block;width:26px;height:26px;background:#0f1218;border-radius:50% 50% 40% 40%;box-shadow:0 0 12px #ff5f6d,inset 0 0 8px #ff5f6d"></span>
  <span style="display:inline-block;width:120px;height:10px;background:#2b303a;border-radius:6px"></span>
</div>

## 6. Emoji — Fontes & Licenças
- **Twemoji** (CC-BY 4.0) · **OpenMoji** (CC BY-SA 4.0) · **Noto Emoji** (OFL).
- **Bundle como atlas PNG/SVG** — **nunca** depender da fonte de emoji do SO (varia entre Windows/Android/iOS).
- **IA** gera **“emojis custom”** no mesmo estilo (SVG flat) para o que não existe em emoji (ex.: **Vorax**, **Osíris**).

## 7. Pipeline de Produção (barato)
1. **IA** → *concept*, paleta, **fundos**, texturas.
2. **Código** → formas/silhuetas (procedural) — consistência garantida.
3. **Emoji** → tokens / máscaras.
4. **Zero spritesheet**; animação por **transform**.

## 8. Animação
- **Tween** (squash/stretch/rotate/bob) + **pulso de glow**. Sem frames.
- Impactos: flash branco curto, *screen shake* leve, *scale punch*.

## 9. Engine (agnóstico)
- Efeitos descritos como **conceito**: `tint`, *additive blend*, *glow/bloom*, *outline*, *UV scroll*.
- Implementação conforme a **engine escolhida** — ainda **a decidir** (Godot provável).

## 10. Ambientação (mood) — **decidida**
**Cósmico/Sideral + Arcano (fantasia mágica)** — o "**mar astral**": ilhas e ruínas **flutuantes** à deriva num campo de estrelas/nebulosas, com **magia arcana** por cima (runas, glifos, cristais, círculos mágicos, contratos/pergaminhos).

- **Fundo escuro** (profundo) para o *glow* brilhar — casa com a raridade **Divino**.
- **Paleta base:** índigo/violeta profundo + **ciano** e **magenta** (glow) + **dourado** (acentos).
- **O arcano entra como magia** (não como cenário medieval): sigilos, runas, encantamentos e cristais *sobre* o cenário cósmico.

### Elementos visuais-chave
| Categoria | Elementos |
| :--- | :--- |
| **Cenário** | ilhas/ruínas flutuantes, campos de estrelas, nebulosas, *rifts* astrais |
| **Magia** | runas, glifos, círculos mágicos, cristais ([[DESIGN-014 Osiris\|Osíris]]), sigilos |
| **Acentos** | partículas estelares, brilho dourado, faíscas, *bloom* |

> Casa com a população **cristal/arcano** proposta ([[DESIGN-003 Mundo 1|Mundo 1]] §4).

## 11. Apêndice — Prompts de Concept (IA)

> Miolo de estilo **idêntico** nos três (flat vector + silhueta/glow + ícones emoji, fundo escuro); só muda a ambientação. Negative prompt comum ao fim.

**1 — Arcano/Cristal**
```text
2D side-scrolling idle platformer game screenshot, flat vector art, minimalist geometric shapes with rounded corners, flat colors, single thin outline, hard offset shadows (no soft blur), DARK obsidian background, strong neon glow accents. Scene: ancient arcane crystal ruins, floating stone platforms carved with glowing runes, giant glowing crystals sprouting from the ground, faint magical mist, floating contract scrolls. A small player character drawn as a dark SILHOUETTE with a glowing cyan outline stands on a platform; two enemies as dark silhouettes with glowing pink outlines; a simple HUD bar with flat emoji-style icons (coin, ticket, crystal). Palette: deep purple, teal, cyan and gold. Clean, cohesive, high contrast, no textures, minimal gradients, game UI, 16:9.
```

**2 — Cósmico/Sideral**
```text
2D side-scrolling idle platformer game screenshot, flat vector art, minimalist geometric shapes with rounded corners, flat colors, single thin outline, hard offset shadows (no soft blur), DARK deep-space background, strong neon glow accents. Scene: floating islands drifting in a starfield, an astral rift, distant planets and constellations, drifting star particles and nebula haze. A small player character drawn as a dark SILHOUETTE with a glowing violet outline stands on a floating rock; two enemies as dark silhouettes with glowing magenta outlines; a simple HUD bar with flat emoji-style icons (star, orb, card). Palette: deep indigo, violet, magenta and pale blue. Clean, cohesive, high contrast, no textures, minimal gradients, game UI, 16:9.
```

**3 — Tech/Neon**
```text
2D side-scrolling idle platformer game screenshot, flat vector art, minimalist geometric shapes with rounded corners, flat colors, single thin outline, hard offset shadows (no soft blur), DARK navy background, strong neon glow accents. Scene: cyberpunk facility, holographic panels, glowing circuit lines on the floor, pipes and terminals, floating data fragments. A small player character drawn as a dark SILHOUETTE with a glowing green outline stands on a metal platform; two enemies as dark silhouettes with glowing hot-pink outlines (a drone and a turret); a simple HUD bar with flat emoji-style icons (chip, coin, gear). Palette: deep navy, teal, cyan and hot pink. Clean, cohesive, high contrast, no textures, minimal gradients, game UI, 16:9.
```

**Negative (comum):**
```text
photorealistic, 3D render, pixel art, detailed textures, soft gradients, lens flare, watermark, text, realistic lighting, anime, painterly, cluttered
```

> Midjourney: `--ar 16:9 --style raw` (+ `--seed <n>` igual nos 3). Flux/SDXL: negative no campo próprio.

## 12. Relacionados
- Raridades: [[CONTEXT-007 Raridades|CONTEXT-007]] · Hierarquia: [[CONTEXT-006 Hierarquia|CONTEXT-006]].
- Consumidores: [[DESIGN-028 Equipamentos|DESIGN-028]] · [[DESIGN-016 Cartas|DESIGN-016]] · [[DESIGN-013 Selos|DESIGN-013]].
