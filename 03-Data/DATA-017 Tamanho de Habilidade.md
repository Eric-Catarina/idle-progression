---
id: DATA-017
aliases:
  - DATA-017
title: "Tamanho de Habilidade: Fórmula & Escala por Tag"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-040 Tamanho de Habilidade|DESIGN-040]]"
dependencies:
  - "[[DESIGN-040 Tamanho de Habilidade|DESIGN-040]]"
  - "[[CONTEXT-015 Tags de Skill|CONTEXT-015]]"
---

# [DATA-017] Tamanho de Habilidade: Fórmula & Escala por Tag

> Números do stat **`Ability Size%`** ([[DESIGN-040 Tamanho de Habilidade|DESIGN-040]]).
> Valores `Draft` — calibrar com o solver ([[DATA-014 Populacao Mundo 1|DATA-014]]).

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `R_gen` | soma dos `+% Range` **genéricos** do jogador (fração: `+15%` → `0.15`) |
| `R_skill(s)` | soma dos `+% Range` **específicos da skill `s`** |
| `mult(s)` | multiplicador final aplicado às dimensões escaláveis de `s` |
| `SIZE_CAP` | **3.00** (×3 = +200%) — teto duro |
| `sizeAoeExponent` | **0.6** — como isso vira fator de área no *catch-up*/solver (§4) |

## 2. Formulação
```
mult(s) = clamp( 1 + R_gen + R_skill(s), 1, SIZE_CAP )        # composição ADITIVA

dimensao_final(s) = dimensao_base(s) * mult(s)                 # só nas dimensões escaláveis (§3)
```
- **Aditivo** (não multiplicativo) — é o padrão dos stats `+%` do projeto ([[DESIGN-028 Equipamentos|DESIGN-028]]).
- **Nunca** abaixo de `1` (não existe "range negativo").

## 3. O que escala, por **tag** ([[CONTEXT-015 Tags de Skill|CONTEXT-015]])
> A tag diz **qual** dimensão cresce. Sem tag escalável na skill, `mult` é simplesmente ignorado.

| Tag | Dimensão escalada | Exemplo (base → ×1.5) |
| :--- | :--- | :--- |
| `target:aoe` | **raio** da área | 40 px → 60 px |
| `target:line` | **comprimento** (varre) **+ largura** | coluna 441 → 661 px |
| `target:chain` | **distância entre saltos** | 60 px → 90 px |
| `target:single` / `multi` / `all` | **alcance de aquisição** do alvo | 120 px → 180 px |
| `delivery:melee` | **hitbox** (largura × altura) | 18×22 → 27×33 |
| `delivery:projectile` | **tamanho do projétil** (hitbox) — **não** a velocidade | 12 px → 18 px |
| `delivery:beam` | **largura** (comprimento, se finito) | 8 px → 12 px |
| `delivery:field` | **raio** da zona (ou altura, na coluna) | 20 px → 30 px |
| `delivery:aura` | **raio** | 60 px → 90 px |
| `delivery:summon` | **área de atuação** do invocado | 30 px → 45 px |
| `delivery:orbit` | **raio da órbita** | 24 px → 36 px |
| `role:mobility` (Blink/Dash/Slide) | **alcance** (`blinkRange`, `dashSpeed×dashDuration`, `slideJumpArc`) | 80 px → 120 px |

### O que **NUNCA** escala
| Não escala | Por quê |
| :--- | :--- |
| **`lines`** ([[DESIGN-037 Linhas de Dano\|DESIGN-037]]) | nº de linhas é outro eixo (é o que vence `capLinha`) |
| **dano** ([[DESIGN-031 Calculo de Dano\|DESIGN-031]]) | range é **cobertura**, não DPS |
| `cooldown`, `duração`, `cast time` | pertencem a outro eixo (cadência) |
| **velocidade** do projétil | é *trajectory*, não *range* (evita "range = DPS" por back-loading) |

## 4. Efeito no combate e no *catch-up*
Range não muda o **dano por acerto**, mas muda **quantos inimigos o acerto pega** — e isso **muda o clear speed**.

- No modelo do solver ([[DATA-014 Populacao Mundo 1|DATA-014]]), o fator de área é `AOE`:
  ```
  AOE_eff(s) = AOE_base * mult(s)^sizeAoeExponent      # sizeAoeExponent = 0.6
  ```
  **Por quê o expoente < 1:** a área cresce com `r²`, mas os mobs de um pack **não** enchem o plano — eles se aglomeram num corredor; a partir de certo ponto, aumentar o raio **não** acha mais mobs (satura). `0.6` é o ponto de partida a calibrar no solver.
- **Catch-up offline** usa `AOE_eff` (não simular cast a cast) — mesma regra do [[SYSTEM-006 Dados Imutáveis & Carregamento|SYSTEM-006]] §5.

## 5. Schema de Configuração (JSON)
```json
{
  "id": "ability_size",
  "cap": 3.0,
  "composition": "additive",
  "minMultiplier": 1.0,
  "aoeExponent": 0.6,
  "scalesByTag": {
    "target:aoe": "radius",
    "target:line": "length_width",
    "target:chain": "jump_distance",
    "target:single": "acquire_range",
    "target:multi": "acquire_range",
    "target:all": "acquire_range",
    "delivery:melee": "hitbox",
    "delivery:projectile": "hitbox_size",
    "delivery:beam": "width",
    "delivery:field": "radius",
    "delivery:aura": "radius",
    "delivery:summon": "area",
    "delivery:orbit": "orbit_radius",
    "role:mobility": "range"
  },
  "neverScales": ["lines", "damage", "cooldown", "duration", "projectile_speed"]
}
```

## 6. Tabela de Simulação — `mult(s)` por % acumulado
| `+% Range` total | `mult` | Efeito num raio de 40 px |
| :--- | --: | :--- |
| 0% | 1.00 | 40 px |
| +15% | 1.15 | 46 px |
| +50% | 1.50 | 60 px |
| +100% | 2.00 | 80 px |
| +200% | 3.00 | 120 px |
| +300% (capado) | **3.00** | **120 px** |

## 7. Relacionados
- Design: [[DESIGN-040 Tamanho de Habilidade|DESIGN-040]] · Tags: [[CONTEXT-015 Tags de Skill|CONTEXT-015]].
- Pool de stats: [[DESIGN-028 Equipamentos|DESIGN-028]] · Dano: [[DESIGN-031 Calculo de Dano|DESIGN-031]] · População: [[DATA-014 Populacao Mundo 1|DATA-014]].
