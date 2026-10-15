---
id: CONTEXT-015
aliases:
  - CONTEXT-015
title: Tags de Skill (Taxonomia)
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-15
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
  - "[[DESIGN-036 Skills & Fila de Skills|DESIGN-036]]"
tags:
  - context
  - convention
  - skill
  - tags
  - taxonomia
---

# 🏷️ [CONTEXT-015] Tags de Skill (Taxonomia)

> Vocabulário **fechado** de tipos de skill. Toda skill (`subtype: skill`) declara suas **tags** — nunca descreve o tipo "em prosa".
> Inspiração: os arquétipos do **MapleStory** (summons, projéteis, buffs) e do **IdleOn**.

## 1. Propósito
- Uma skill é descrita por **dimensões independentes**, não por um "tipo" único. Ex.: *Meteoro* = **projétil** + **queda** + **coluna/AoE** + **dano** + **mobber**.
- Isso permite **filtrar, automatizar e combinar** (fila por arquétipo, builds anti-`capLinha`, sinergia de summons) sem código ad-hoc.

## 2. Regra
- Formato: **`dimensao:valor`** em `snake_case` (ex.: `delivery:summon`).
- Vai no frontmatter, em **`skill_tags:`** (lista) — **não** confundir com `tags:` (metadados do Obsidian).
- **Obrigatório:** ≥1 de **`delivery`**, ≥1 de **`target`**, ≥1 de **`role`** — vale para **toda habilidade ativa**: `subtype: skill` **e** `mechanic` de movimento (ex.: [[DESIGN-012 Jump Dash|DESIGN-012]]).
- **Opcional:** `trajectory` (só p/ projéteis), `behavior`, `archetype`.
- Uma skill pode ter **várias** tags na mesma dimensão (ex.: `trajectory:arc` + `trajectory:boomerang`).
- Tags são **declarativas**: descrevem regra, não implementação.

## 3. `delivery` — como o efeito alcança (obrigatório)
| Tag | Descrição | Exemplos |
| :--- | :--- | :--- |
| `delivery:melee` | Toque/corpo a corpo | Ataque básico ([[DESIGN-036 Skills & Fila de Skills\|DESIGN-036]] §2) |
| `delivery:projectile` | Projétil que **viaja** e acerta ao colidir | [[DESIGN-008 Machado\|DESIGN-008]], [[DESIGN-007 Meteoro\|DESIGN-007]] |
| `delivery:beam` | **Feixe** contínuo (linha/raio) | [[DESIGN-010 Raio Laser\|DESIGN-010]] |
| `delivery:instant` | Acerta **imediatamente** (hit-scan), sem viagem | Mobilidade ([[DESIGN-026 Blink\|DESIGN-026]]) |
| `delivery:summon` | Invoca **aliado(s)** que lutam por você | [[DESIGN-011 Summon Corredor\|DESIGN-011]] |
| `delivery:field` | **Zona fixa** no mapa (pilar, poça, mina) | [[DESIGN-009 Perfuracao Vertical\|DESIGN-009]] |
| `delivery:aura` | Efeito **contínuo** em volta do player | Buffs/auras de dano |
| `delivery:orbit` | Entidades **girando** em volta do player | Orbes do *MapleStory* |

## 4. `trajectory` — como o projétil se move (opcional)
| Tag | Descrição |
| :--- | :--- |
| `trajectory:straight` | Reto na horizontal |
| `trajectory:falling` | **Queda** (vertical, do topo) |
| `trajectory:arc` | Parábola (gravidade aparente) |
| `trajectory:boomerang` | **Ida e volta** |
| `trajectory:homing` | Persegue o alvo |
| `trajectory:bouncing` | Quica nas superfícies |
| `trajectory:spiral` | Trajetória espiral (orbes) |

## 5. `target` — quem é afetado (obrigatório)
| Tag | Descrição |
| :--- | :--- |
| `target:self` | O próprio player |
| `target:single` | Um alvo |
| `target:multi` | N alvos fixos (ex.: 3) |
| `target:aoe` | Área circular |
| `target:line` | Linha/coluna (varre o mapa no eixo) |
| `target:chain` | Ricocheteia entre alvos |
| `target:random` | Alvos **aleatórios** no alcance |
| `target:all` | Todos no alcance/tela |

## 6. `role` — o que a skill faz (obrigatório)
| Tag | Descrição |
| :--- | :--- |
| `role:damage` | Causa dano |
| `role:buff` | Melhora (self/party) |
| `role:debuff` | Piora o inimigo |
| `role:heal` | Cura/restaura |
| `role:mobility` | Movimento (dash, blink, slide) |
| `role:crowd_control` | Atordoa/lenta/empurra |
| `role:utility` | Utilidade (coleta, revelar, invocar pet) |

## 7. `behavior` — como se comporta no tempo (opcional)
| Tag | Descrição |
| :--- | :--- |
| `behavior:dot` | Dano **ao longo do tempo** (tick) |
| `behavior:channel` | **Canalizada** (dura enquanto segura) |
| `behavior:toggle` | **Liga/desliga** |
| `behavior:passive` | Sempre ativa (não casta) |
| `behavior:charge` | Acumula **cargas** |
| `behavior:combo` | Encadeia com outra skill |
| `behavior:on_hit` | Dispara **ao acertar** (ex.: explosão) |

## 8. `archetype` — a que build serve (opcional)
> Espelha os papéis de [[DESIGN-005 Classes|DESIGN-005]] (pastas `bosser/`, `mobber/`, `suporte/`).

| Tag | Descrição |
| :--- | :--- |
| `archetype:bosser` | Alvo único, DPS alto |
| `archetype:mobber` | Área, limpar packs |
| `archetype:suporte` | Buff/utilidade/CC |
| `archetype:all` | Universal (ex.: mobilidade) |

## 9. Como o motor usa
- **`sim/combat`** lê as tags para resolver o efeito (spawn de projétil/summon/field; área vs. único).
- **Fila ([[DESIGN-036 Skills & Fila de Skills|DESIGN-036]])**: as tags alimentam a **auto-fila por arquétipo** (gancho) — mobber prioriza `target:aoe/line`; bosser prioriza `target:single` + DPS.
- **Sinergia com [[DESIGN-037 Linhas de Dano|DESIGN-037]]:** skills `behavior:dot`/`channel` tendem a ter **mais `lines`** → melhores contra alvos com **`capLinha`**.
- **Summons:** contam como entidades próprias; `delivery:summon` é o gancho para limites/inventário de summons.

## 10. Exemplos (skills atuais)
| Skill | Papel (classe) | `skill_tags` |
| :--- | :--- | :--- |
| [[DESIGN-007 Meteoro\|DESIGN-007]] | mago/mobber | `delivery:projectile` · `trajectory:falling` · `target:line` · `target:aoe` · `role:damage` · `behavior:on_hit` · `archetype:mobber` |
| [[DESIGN-008 Machado\|DESIGN-008]] | guerreiro/mobber | `delivery:projectile` · `trajectory:arc` · `trajectory:boomerang` · `target:line` · `role:damage` · `archetype:mobber` |
| [[DESIGN-009 Perfuracao Vertical\|DESIGN-009]] | guerreiro/bosser | `delivery:field` · `target:line` · `role:damage` · `behavior:dot` · `archetype:bosser` |
| [[DESIGN-010 Raio Laser\|DESIGN-010]] | mago/bosser | `delivery:beam` · `target:line` · `role:damage` · `behavior:channel` · `behavior:dot` · `archetype:bosser` |
| [[DESIGN-011 Summon Corredor\|DESIGN-011]] | mago/suporte | `delivery:summon` · `trajectory:straight` · `target:line` · `role:damage` · `archetype:mobber` |
| [[DESIGN-012 Jump Dash\|DESIGN-012]] | guerreiro | `delivery:instant` · `target:self` · `role:mobility` · `archetype:all` |
| [[DESIGN-026 Blink\|DESIGN-026]] | mago | `delivery:instant` · `target:self` · `role:mobility` · `archetype:all` |
| [[DESIGN-027 Slide Jump\|DESIGN-027]] | arqueiro | `delivery:instant` · `target:self` · `role:mobility` · `archetype:all` |

## 11. Casos de Borda
- **Tag fora do vocabulário** → **erro** (não inventar; promover a tag nova aqui antes).
- **Skill sem `delivery`/`target`/`role`** → inválida.
- **`trajectory` sem `delivery:projectile`** → ignorada (aviso).
- Tag **nova** exige atualizar **este** documento **e** o motor no mesmo passo (integridade).

## 12. Relacionado
- Skills & fila: [[DESIGN-036 Skills & Fila de Skills|DESIGN-036]] · Linhas: [[DESIGN-037 Linhas de Dano|DESIGN-037]] · Classes: [[DESIGN-005 Classes|DESIGN-005]].
- Template: `00-Context/_templates/SKILL_TEMPLATE.md` · Manifesto: [[CONTEXT-000 Manifesto|CONTEXT-000]].
