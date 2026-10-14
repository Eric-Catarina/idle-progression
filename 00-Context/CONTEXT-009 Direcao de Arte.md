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

## 10. Ambientação (mood) — *proposta*
- **Arcano/Cristal**, **fundo escuro**: ruínas, cristais ([[DESIGN-014 Osiris|Osíris]]), glifos/contratos ([[DESIGN-034 Livro dos Contratos|Livro dos Contratos]]). Casa com **silhueta + glow**.

## 11. Relacionados
- Raridades: [[CONTEXT-007 Raridades|CONTEXT-007]] · Hierarquia: [[CONTEXT-006 Hierarquia|CONTEXT-006]].
- Consumidores: [[DESIGN-028 Equipamentos|DESIGN-028]] · [[DESIGN-016 Cartas|DESIGN-016]] · [[DESIGN-013 Selos|DESIGN-013]].
