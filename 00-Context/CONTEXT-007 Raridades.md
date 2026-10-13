---
id: CONTEXT-007
aliases:
  - CONTEXT-007
title: Raridades (Escala Compartilhada)
type: context-convention
scope: global
status: Active
version: 1.1.0
last_updated: 2026-10-13
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
tags:
  - context
  - convention
  - rarity
---

# 💎 [CONTEXT-007] Raridades (Escala Compartilhada)

## 1. Propósito

Definir uma **escala única de raridade** reutilizável por **todos** os sistemas do jogo (cartas, itens, potencial de itens, monstros, mundos). **Nomes e cores são fixos**; **pesos/odds são por sistema** (cada um no seu `DATA`).

## 2. Os 6 Tiers (nome, cor, visual, shader)

| # | Raridade | Cor | Sensação | Visual (CSS) | Shader (Phaser 3) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | **Comum** | Cinza | básico | `#9e9e9e` sólido | — (*flat*) |
| 2 | **Raro** | Azul fraco | "achei algo bom" | `box-shadow: 0 0 6px #6ea8fe` | `addGlow(0x6ea8fe, 1.5)` |
| 3 | **Épico** | Roxo | forte | glow + pulso | Glow + **pulso** (`uPulse`) |
| 4 | **Lendário** | Laranja dourado | cobiçado | `gradient` + *shine sweep* | `addGlow(0xffb300, 2)` + `AddEffectShine` |
| 5 | **Extraordinário** | Arco-íris | celebrado | `conic-gradient` + `filter: hue-rotate` anim | **hue-shift** (GLSL) + brilho |
| 6 | **Divino** | Preto-branco brilhoso | máximo / único | `linear-gradient(135deg,#000,#fff)` + bloom pulsante | `AddEffectBloom` + `addDisplacement(0.02)` |

### Exemplo (CSS — como ver no Obsidian)
```css
.rar-lendario {
  background: linear-gradient(135deg, #b8860b, #ffd700, #b8860b);
  box-shadow: 0 0 12px #ffb300;
  animation: shine 1.6s ease-in-out infinite;
}
@keyframes shine { 0%,100% { filter: brightness(1); } 50% { filter: brightness(1.35); } }
```

### Exemplo (Phaser 3 — no jogo)
```javascript
// Raro — brilho suave (FX embutida)
sprite.postFX.addGlow(0x6ea8fe, 1.5, 0, 1);
// Lendário — brilho dourado + varredura
sprite.postFX.addGlow(0xffb300, 2);
this.actions.addEffectShine(sprite, { duration: 1200 });
```

> **Obsidian** renderiza via **CSS snippets/inline**; shaders reais rodam só no **jogo** (Phaser 3, WebGL). Ver `99-Inbox/reference/PHASER3_SHADERS_REFERENCE.md`.

## 3. Uso Compartilhado

- **Mesma escala, sistemas diferentes:** Cartas ([[DESIGN-016 Cartas|DESIGN-016]]), Itens, **Potencial de Itens**, Monstros, Mundos.
- Cada sistema declara **seus próprios pesos** no respectivo `DATA`; **nomes e cores são idênticos** em todos.
- Raridade é **ortogonal ao tipo de conteúdo**: uma carta Divina e um item Divino compartilham a mesma identidade visual.
- Cada sistema pode dar um **significado mecânico** ao tier (ex: no sistema de cartas, tiers altos concedem keywords/efeitos únicos).

## 4. Apresentação (juice)
- Cor padrão por tier (§2); **glow/animação proporcionais** ao tier.
- Raridade alta na abertura → flash + som (dopamina imediata).

## 5. Relacionado
- [[CONTEXT-000 Manifesto|CONTEXT-000]] — Manifesto mestre.
- [[DESIGN-016 Cartas|DESIGN-016]] — Cartas (primeiro consumidor).
