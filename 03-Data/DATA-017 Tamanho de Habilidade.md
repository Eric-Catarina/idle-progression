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
| `R_gen` | soma dos `+% Size` **genéricos** do jogador (fração: `+15%` → `0.15`) |
| `R_skill(s)` | soma dos `+% Size` **específicos da skill `s`** |
| `mult(s)` | multiplicador final aplicado às dimensões escaláveis de `s` |
| `SIZE_MAX` | **2.00** (+200%) — **assíntota** da curva de efeito (§2.1) |
| `SIZE_CAP` | **3.00** (= `1 + SIZE_MAX`) — teto duro de `mult` |
| `K` | **50** — meia-saturação: onde a curva de uma fonte atinge **+100%** |
| `costBase` / `costGrowth` | custo do nível: `cost(n) = costBase × costGrowth^n` (`1.15`) |
| `sizeAoeExponent` | **0.6** — como isso vira fator de área no *catch-up*/solver (§4) |

## 2. Formulação
```
mult(s) = clamp( 1 + R_gen + R_skill(s), 1, SIZE_CAP )        # composição ADITIVA

dimensao_final(s) = dimensao_base(s) * mult(s)                 # só nas dimensões escaláveis (§3)
```
- **Aditivo** (não multiplicativo) — é o padrão dos stats `+%` do projeto ([[DESIGN-028 Equipamentos|DESIGN-028]]).
- **Nunca** abaixo de `1` (não existe *size* negativo).

### 2.1 Curva de efeito de uma fonte (nível `n`)
```
R(n) = SIZE_MAX * n / (n + K)          # hiperbólica — mesmo shape dos Selos (DESIGN-013)
mult(n) = 1 + R(n)
```
- **Sobe rápido no começo, satura no fim:** chega a **+100%** com `n = K` e **vira um deserto** depois — ir de +100% a +200% é a maior parte do grind (e é **impossível** chegar em +200%: é assíntota).
- A **assíntota é o teto**, então o cap `×3.00` **nunca** é violado por uma fonte só.
- **Custo do nível** (para o grind ser sentido): `cost(n) = costBase × 1.15^n` — o **custo** cresce exponencial enquanto o **efeito** satura. É isso que faz "ficar muito difícil de subir" (§6.1).

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
| **dano** ([[DESIGN-031 Calculo de Dano\|DESIGN-031]]) | size é **cobertura**, não DPS |
| `cooldown`, `duração`, `cast time` | pertencem a outro eixo (cadência) |
| **velocidade** do projétil | é *trajectory*, não *size* (evita "size = DPS" por back-loading) |

## 4. Efeito no combate e no *catch-up*
Size não muda o **dano por acerto**, mas muda **quantos inimigos o acerto pega** — e isso **muda o clear speed**.

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
  "curve": { "type": "hyperbolic", "max": 2.0, "k": 50 },
  "costGrowth": 1.15,
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

## 6. Tabela de Simulação

### 6.1 Curva de efeito de **uma fonte** (nível `n`)
| `n` | `R(n)` | `mult` | Raio (base 40 px) |
| --: | --: | --: | --: |
| 1 | +3.9% | 1.04 | 42 px |
| 5 | +18.2% | 1.18 | 47 px |
| 10 | +33.3% | 1.33 | 53 px |
| 25 | +66.7% | 1.67 | 67 px |
| **50** | **+100.0%** | **2.00** | **80 px** |
| 75 | +120.0% | 2.20 | 88 px |
| 100 | +133.3% | 2.33 | 93 px |
| 200 | +160.0% | 2.60 | 104 px |
| 500 | +181.8% | 2.82 | 113 px |
| 1.000 | +190.5% | 2.90 | 116 px |
| ∞ | +200% *(assíntota)* | 3.00 | 120 px |

> **Leitura:** os primeiros **50 níveis** entregam **+100%**; os **950 seguintes** entregam só ~**+90%** a mais. É exatamente o "sobe rápido, depois fica muito difícil".

### 6.2 `mult` por **% acumulado** (várias fontes somadas)
| `+% Size` total | `mult` | Raio (base 40 px) |
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
