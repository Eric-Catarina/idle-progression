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

| #   | Raridade                                                                                                                                                                                                                                                                                                            | Cor                   | Sensação         | Visual (CSS)                  | Shader (Phaser 3)        |
| :-- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :-------------------- | :--------------- | :---------------------------- | :----------------------- |
| 1   | <span class="rar rar-comum" style="display:inline-block;padding:2px 10px;border-radius:6px;font-weight:600;background:#9e9e9e;color:#111">Comum</span>                                                                                                                                                              | Cinza                 | básico           | `#9e9e9e` sólido              | — (*flat*)               |
| 2   | <span class="rar rar-raro" style="display:inline-block;padding:2px 10px;border-radius:6px;font-weight:600;background:#6ea8fe;color:#05122b;box-shadow:0 0 6px #6ea8fe">Raro</span>                                                                                                                                  | Azul fraco            | "achei algo bom" | `box-shadow: 0 0 6px #6ea8fe` | `addGlow(0x6ea8fe, 1.5)` |
| 3   | <span class="rar rar-epico" style="display:inline-block;padding:2px 10px;border-radius:6px;font-weight:600;background-image:linear-gradient(120deg,#5a2ea6,#a970ff,#e0c3ff,#a970ff,#5a2ea6);color:#12002b;box-shadow:0 0 10px #a970ff">Épico</span>                                                                 | Roxo                  | forte            | essência fluida               | flow (`uTime`) + glow    |
| 4   | <span class="rar rar-lendario" style="display:inline-block;padding:2px 10px;border-radius:6px;font-weight:600;background-image:linear-gradient(120deg,#7a5c00,#ffd700,#fff2b0,#ffd700,#7a5c00);color:#20160a;box-shadow:0 0 12px #ffb300">Lendário</span>                                                           | Laranja dourado       | cobiçado         | essência dourada              | `AddEffectShine` + flow  |
| 5   | <span class="rar rar-extraordinario" style="display:inline-block;padding:2px 10px;border-radius:6px;font-weight:600;background-image:repeating-linear-gradient(90deg,#ff5f6d,#ffc371,#47ffa0,#4facfe,#c86dd7,#ff5f6d,#ffc371,#47ffa0,#4facfe,#c86dd7);color:#111;box-shadow:0 0 12px #c86dd7">Extraordinário</span> | Arco-íris             | celebrado        | arco-íris **scrollando**      | UV scroll (GLSL)         |
| 6   | <span class="rar rar-divino" style="display:inline-block;padding:2px 10px;border-radius:6px;font-weight:600;background-image:linear-gradient(120deg,#000,#fff,#000,#fff,#000);color:#fff;text-shadow:0 1px 2px #000,0 0 3px #000,0 0 6px #000;box-shadow:0 0 14px #fff">Divino</span>                               | Preto-branco brilhoso | máximo / único   | obsidiana fluida + bloom      | `AddEffectBloom` + flow  |

> As **cores** acima aparecem direto (estilo inline). Para as **animações/brilho**, ative o snippet `raridades.css` em **Configurações → Aparência → Snippets CSS**.

### Exemplo (CSS — como ver no Obsidian)
```css
/* essência fluida: gradiente grande + background-position animado */
.rar-lendario {
  background-image: linear-gradient(120deg, #7a5c00, #ffd700, #fff2b0, #ffd700, #7a5c00);
  background-size: 260% 260%;
  box-shadow: 0 0 12px #ffb300;
  animation: rar-flow 4.5s ease-in-out infinite;
}
/* arco-íris scrollando (UV) */
.rar-extraordinario {
  background-image: repeating-linear-gradient(90deg, #ff5f6d,#ffc371,#47ffa0,#4facfe,#c86dd7,#ff5f6d,#ffc371,#47ffa0,#4facfe,#c86dd7);
  background-size: 300% 100%;
  animation: rar-uv 3s linear infinite;
}
@keyframes rar-flow { 0%,100% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } }
@keyframes rar-uv   { from { background-position: 0% 50%; } to { background-position: 300% 50%; } }
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
- Cada sistema pode dar um **significado mecânico** ao tier (ex: no sistema de **cartas**, o tier é **progressivo** — a carta **sobe de tier** acumulando cópias: [[DESIGN-016 Cartas|DESIGN-016]]).

## 4. Apresentação (juice)
- Cor padrão por tier (§2); **glow/animação proporcionais** ao tier.
- Raridade alta na abertura → flash + som (dopamina imediata).

## 5. Relacionado
- [[CONTEXT-000 Manifesto|CONTEXT-000]] — Manifesto mestre.
- [[DESIGN-016 Cartas|DESIGN-016]] — Cartas (primeiro consumidor).
