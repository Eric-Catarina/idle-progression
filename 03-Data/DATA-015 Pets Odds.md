---
id: DATA-015
aliases:
  - DATA-015
title: "Pets: Tiros, Odds e Custos"
type: data-spec
status: Draft
moscow: Must
system: "[[DESIGN-038 Pets|DESIGN-038]]"
dependencies:
  - "[[DESIGN-038 Pets|DESIGN-038]]"
  - "[[CONTEXT-007 Raridades|CONTEXT-007]]"
  - "[[CONTEXT-013 Moeda Premium|CONTEXT-013]]"
---

# [DATA-015] Pets: Tiros, Odds e Custos

> Números do sistema de pets ([[DESIGN-038 Pets|DESIGN-038]]). A **raridade** usa [[CONTEXT-007 Raridades|CONTEXT-007]].
> Valores `Draft` — calibrar. **Derivação:** as odds do tiro **épico** são as do comum **× 20** para `tier ≥ 3`; o Divino cai **exatamente em 1%** por construção.

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `tier` | raridade do pet (1..6) = [[CONTEXT-007 Raridades\|CONTEXT-007]] |
| `oddsComum[tier]` | chance (%) do **tiro comum** |
| `M` | multiplicador do tiro épico nos tiers altos = **20** |
| `tierMin` | primeiro tier afetado por `M` = **3** (Épico) |
| `strengthenReq[n]` | cópias necessárias p/ o nível `n` de fortalecimento |
| `shatterFragments[tier]` | fragmentos de Gema ganhos ao **quebrar** uma duplicata (**100 = 1 Gema**) |
| `gemCost[kind]` | custo em **Gemas** ([[CONTEXT-013 Moeda Premium\|CONTEXT-013]]) |

## 2. Tokens & Períodos
| Token | Ganho grátis | Período | Acumula? |
| :--- | :--- | :--- | :--- |
| `shot_common` | **1** | **diário** (00:00) | ❌ máx. 1 |
| `shot_epic` | **1** | **semanal** (segunda 00:00) | ❌ máx. 1 |

## 3. Odds por Tiro
**Comum (base):** soma exata **100%**; o Divino é `1/M` = **0.05%** por construção.

| tier | Raridade | **Tiro Comum** |
| :--- | :--- | --: |
| 1 | Comum | **68.00%** |
| 2 | Raro | **28.00%** |
| 3 | Épico | **3.00%** |
| 4 | Lendário | **0.80%** |
| 5 | Extraordinário | **0.15%** |
| 6 | Divino | **0.05%** |

**Épico:** `oddsEpico[t] = oddsComum[t] × M` para `t ≥ 3`; tiers 1–2 preenchem o resto mantendo a razão.

| tier | Raridade | **Tiro Épico** | vs. comum |
| :--- | :--- | --: | --: |
| 1 | Comum | 14.17% | ×0.208 |
| 2 | Raro | 5.83% | ×0.208 |
| 3 | Épico | **60.00%** | **×20** |
| 4 | Lendário | **16.00%** | **×20** |
| 5 | Extraordinário | **3.00%** | **×20** |
| 6 | Divino | **1.00%** | **×20** |

- `P(tier ≥ 3)`: comum **4.00%** · épico **80.00%** (**×20** exato).
- `P(Divino)`: comum 0.05% · épico **1.00%** (o "**ainda assim, só 1%**").

### Algoritmo do sorteio
```text
resto = 100 - sum(odds[t] for t >= tierMin)          # 20% (épico) / 96% (comum)
para t < tierMin:  oddsEpico[t] = oddsComum[t] * resto / sum(oddsComum[t<3])
para t >= tierMin: oddsEpico[t] = oddsComum[t] * M    # Divino: 0.05 * 20 = 1.00% ✅
# sorteia o tier por pesos inteiros (odds * 100 → base 10000)
```

## 4. Duplicatas — Fortalecer OU Quebrar
Um pet **repetido** gera **1 cópia**. O jogador escolhe, **por cópia**:
- **Fortalecer (padrão):** a cópia acumula no pet; ao cruzar o limiar, o pet sobe de **nível de fortalecimento** (1→6) e o bônus multiplica — **mesma escada das cartas** ([[DATA-005 Cartas Odds|DATA-005]] §2).
- **Quebrar:** converte a cópia em **fragmentos de Gema** (`gemFragments`, **100 = 1 Gema**) — uma **fração** da moeda premium ([[CONTEXT-013 Moeda Premium|CONTEXT-013]]).

`Bonus(pet) = base(pet) × nível` · **limiar cumulativo de cópias** (espelha as cartas):

| nível | 1 | 2 | 3 | 4 | 5 | 6 |
| :--- | --: | --: | --: | --: | --: | --: |
| Cópias acumuladas | 1 | 7 | 21 | 35 | 112 | 3.22 K |
| Multiplicador do bônus | ×1 | ×2 | ×3 | ×4 | ×5 | ×6 |

**Fragmentos por quebra (por raridade):**

| tier | 1 Comum | 2 Raro | 3 Épico | 4 Lendário | 5 Extraord. | 6 Divino |
| :--- | --: | --: | --: | --: | --: | --: |
| `gemFragments` | 1 | 4 | 12 | 40 | 150 | 600 |
| = **Gemas** | 0.01 | 0.04 | 0.12 | 0.40 | 1.50 | 6.00 |

> 🎯 **Escolha do jogador:** fortalecer um pet **raro** (bônus alto) ou quebrar pets **comuns** que não usa para acumular Gemas aos poucos.

## 5. Custos em Gemas (compra de tiros)
| Tiro | Gemas (`gemCost`) |
| :--- | --: |
| `shot_common` | **100** |
| `shot_epic` | **1.500** |

> ⚠️ **Calibrar** com a tabela de pacotes IAP ([[CONTEXT-013 Moeda Premium|CONTEXT-013]]) — valores iniciais.

## 6. Schema de Configuração (JSON)
```json
{
  "id": "pets",
  "tokens": {
    "common": { "perPeriod": 1, "period": "daily" },
    "epic": { "perPeriod": 1, "period": "weekly" }
  },
  "gemCost": { "common": 100, "epic": 1500 },
  "oddsCommon": [68.0, 28.0, 3.0, 0.8, 0.15, 0.05],
  "epicMultiplier": 20,
  "epicBoostFromTier": 3,
  "strengthenReq": [1, 7, 21, 35, 112, 3220],
  "shatterFragmentsByTier": [1, 4, 12, 40, 150, 600],
  "fragmentsPerGem": 100,
  "roster": {
    "1": ["pet_slug", "pet_shroom", "pet_wasp", "pet_nutty", "pet_owl", "pet_pebble"],
    "2": ["pet_slime", "pet_bookrat", "pet_fairy", "pet_snail", "pet_bee"],
    "3": ["pet_golem", "pet_scarecrow", "pet_reaper", "pet_merchant"],
    "4": ["pet_dragon", "pet_relic", "pet_ghost"],
    "5": ["pet_market_hand", "pet_schrodinger"],
    "6": ["pet_void"]
  },
  "pets": [
    { "id": "pet_slug", "tier": 1, "effects": [{ "stat": "classXp", "value": 5, "unit": "pct" }] },
    { "id": "pet_shroom", "tier": 1, "effects": [{ "stat": "totalDamage", "value": 4, "unit": "pct" }] },
    { "id": "pet_wasp", "tier": 1, "effects": [{ "stat": "critChance", "value": 2, "unit": "pct" }] },
    { "id": "pet_nutty", "tier": 1, "effects": [{ "stat": "moneyFromMonsters", "value": 6, "unit": "pct" }] },
    { "id": "pet_owl", "tier": 1, "effects": [{ "stat": "skillXp", "value": 5, "unit": "pct" }] },
    { "id": "pet_pebble", "tier": 1, "effects": [{ "stat": "baseHp", "value": 10, "unit": "flat" }] },
    { "id": "pet_slime", "tier": 2, "effects": [{ "stat": "moneyFromMonsters", "value": 12, "unit": "pct" }] },
    { "id": "pet_bookrat", "tier": 2, "effects": [{ "stat": "skillXp", "value": 10, "unit": "pct" }] },
    { "id": "pet_fairy", "tier": 2, "effects": [{ "stat": "classXp", "value": 12, "unit": "pct" }] },
    { "id": "pet_snail", "tier": 2, "effects": [{ "stat": "totalDamage", "value": 7, "unit": "pct" }] },
    { "id": "pet_bee", "tier": 2, "effects": [{ "stat": "cardDropChance", "value": 6, "unit": "pct" }] },
    { "id": "pet_golem", "tier": 3, "effects": [{ "stat": "totalDamage", "value": 12, "unit": "pct" }] },
    { "id": "pet_scarecrow", "tier": 3, "effects": [{ "stat": "dropRate", "value": 10, "unit": "pct" }] },
    { "id": "pet_reaper", "tier": 3, "effects": [{ "stat": "critChance", "value": 3, "unit": "pct" }, { "stat": "critDamage", "value": 15, "unit": "pct" }] },
    { "id": "pet_merchant", "tier": 3, "effects": [{ "stat": "moneyFromMonsters", "value": 15, "unit": "pct" }, { "stat": "essence", "value": 8, "unit": "pct" }] },
    { "id": "pet_dragon", "tier": 4, "effects": [{ "stat": "totalDamage", "value": 20, "unit": "pct" }] },
    { "id": "pet_relic", "tier": 4, "effects": [{ "stat": "dropRate", "value": 15, "unit": "pct" }], "special": "auto_loot" },
    { "id": "pet_ghost", "tier": 4, "effects": [{ "stat": "classXp", "value": 12, "unit": "pct" }, { "stat": "skillXp", "value": 12, "unit": "pct" }], "special": "farm_offline" },
    { "id": "pet_market_hand", "tier": 5, "effects": [{ "stat": "dropRate", "value": 25, "unit": "pct" }], "special": "extra_drop_roll" },
    { "id": "pet_schrodinger", "tier": 5, "effects": [{ "stat": "totalDamage", "value": 18, "unit": "pct" }, { "stat": "dropRate", "value": 18, "unit": "pct" }] },
    { "id": "pet_void", "tier": 6, "effects": [{ "stat": "totalDamage", "value": 10, "unit": "pct" }], "special": "extra_line" }
  ]
}
```
> `roster` é **conteúdo** (a definir) — o padrão é 1 pet por tier por mundo, como as [[DESIGN-016 Cartas|Cartas]].

## 7. Tabela de Simulação
| Métrica | Tiro Comum | Tiro Épico |
| :--- | --: | --: |
| `P(Divino)` por tiro | 0.05% | 1.00% |
| `P(tier ≥ 3)` por tiro | 4.00% | 80.00% |
| Tiros esperados p/ 1 Divino | 2.000 | 100 |
| Grátis: `P(≥1 Divino)` em 1 ano | **16.68%** (365 tiros) | **40.70%** (52 tiros) |
| Tempo esperado p/ Divino (só grátis) | ~5.5 anos | ~1.9 anos |

> O **gap** entre o grátis e os **1.9 anos** do épico é o que dá sentido à compra com **Gemas** (monetização honesta).

## 8. Roster do Mundo 1 — **21 pets** (pirâmide 1·2·3·4·5·6)
> Ideias roubadas sem vergonha do **IdleOn** e do **MapleStory**, com tempero cósmico-arcano ([[CONTEXT-009 Direcao de Arte|CONTEXT-009]]).
> **Bônus** são sempre **account-wide e permanentes** ([[DESIGN-038 Pets|DESIGN-038]] §1).
> **Escala de fortalecimento:** `bônus = valor × nível` (×1…×6). **Habilidades especiais** (linha extra, auto-coleta, offline) **NÃO** escalam — são fixas.

### 8.1 ⚪ Comum (6)
| id | Pet | Efeito | Sabor |
| :--- | :--- | :--- | :--- |
| `pet_slug` | **Lesminha de Estimação** | `+5%` XP de Classe | Deixa uma trilha brilhante. Ajuda e suja o chão. |
| `pet_shroom` | **Cogumelo Resmungão** | `+4%` Dano Total | Sporeja raiva. Literalmente. |
| `pet_wasp` | **Vespinha Nervosa** | `+2%` Chance de Crítico | Zoa o inimigo na hora errada (pra ele). |
| `pet_nutty` | **Esquilo Tesoureiro** | `+6%` Ouro de Monstros | Enterra o ouro e esquece onde. Cobra pra achar. |
| `pet_owl` | **Corujinha Cansada** | `+5%` XP de Skill | Estudou a vida toda, dorme em pé. |
| `pet_pebble` | **Pedrinha com Olhos** | `+10` HP Base | Não faz nada. Mas te observa. Sempre. |

### 8.2 🔵 Raro (5)
| id | Pet | Efeito | Sabor |
| :--- | :--- | :--- | :--- |
| `pet_slime` | **Slime de Bolso** | `+12%` Ouro de Monstros | Come moedas e digere em câmbio. |
| `pet_bookrat` | **Rato de Biblioteca** | `+10%` XP de Skill | Já leu todos os teus livros. Do fim pro começo. |
| `pet_fairy` | **Fada Desempregada** | `+12%` XP de Classe | Bênção de freela; trabalha por gorjeta. |
| `pet_snail` | **Caracol Blindado** | `+7%` Dano Total | Chega atrasado, mas chega batendo. |
| `pet_bee` | **Abelha Contadora** | `+6%` Chance de Carta | Faz mel e planilha. O favo é auditado. |

### 8.3 🟣 Épico (4)
| id | Pet | Efeito | Sabor |
| :--- | :--- | :--- | :--- |
| `pet_golem` | **Golem de Bolso** | `+12%` Dano Total | Feito de pedrinha e má vontade. |
| `pet_scarecrow` | **Espantalho Vivo** | `+10%` Drop Rate | Espanta corvos; os drops caem de medo. |
| `pet_reaper` | **Ceifador Mirim** | `+3%` Chance de Crítico · `+15%` Dano Crítico | Ainda está na fase de treinamento. Ceifa de propósito. |
| `pet_merchant` | **Mercador Errante** | `+15%` Ouro · `+8%` Essência | Vende teu loot **antes** de você pegar. |

### 8.4 🟠 Lendário (3)
| id | Pet | Efeito | Sabor |
| :--- | :--- | :--- | :--- |
| `pet_dragon` | **Dragão de Guarda-Roupa** | `+20%` Dano Total | Mora no cabide. Queima o que não veste. |
| `pet_relic` | **Relicário Ambulante** | `+15%` Drop Rate · **Auto-coleta** *(fixo)* | Anda com a mala cheia e as costas doendo. |
| `pet_ghost` | **Fantasma do Farm** | `+12%` XP de Classe e Skill · **Farm offline** *(fixo)* | Já morreu. Continua batendo ponto. |

### 8.5 🌈 Extraordinário (2)
| id | Pet | Efeito | Sabor |
| :--- | :--- | :--- | :--- |
| `pet_market_hand` | **Mão do Mercado** | `+25%` Drop Rate · **+1 roll de drop** por morte *(fixo)* | Uma mão sai do chão e revira o mob. Ninguém sabe de quem é. |
| `pet_schrodinger` | **Gato de Schrödinger** | `+18%` Dano Total · `+18%` Drop Rate | Existe e não existe. **Invisível** no mundo até você olhar. |

### 8.6 ⚫ Divino (1)
| id | Pet | Efeito | Sabor |
| :--- | :--- | :--- | :--- |
| `pet_void` | **Vazinho, o Eco do Vazio** | **+1 linha de dano** em todos os acertos *(fixo)* · `+10%` Dano Total | Um buraco negro de coleira. Come o número e cospe o resto. |

> 💀 **Sinergia de design:** o **Vazinho** é o único pet que mexe em **linhas de dano** ([[DESIGN-037 Linhas de Dano|DESIGN-037]]) — contra alvos com **teto por linha** ([[DATA-014 Populacao Mundo 1|DATA-014]]), ele é o pet **matematicamente mais valioso** do jogo. É o troféu divino que justifica os **1.9 anos** de épicos grátis ([[DATA-015 Pets Odds|DATA-015]] §7).

> Valores `Draft` — calibrar. Nomes e sabores são proposta.

## 9. Relacionados
- Design: [[DESIGN-038 Pets|DESIGN-038]] · Técnico: [[SYSTEM-005 Pets & Gacha|SYSTEM-005]].
- Raridades: [[CONTEXT-007 Raridades|CONTEXT-007]] · Moeda premium: [[CONTEXT-013 Moeda Premium|CONTEXT-013]].
- Referência (IdleOn): `99-Inbox/reference/IDLEON_PETS_REFERENCE.md`.
