---
id: DATA-015
aliases:
  - DATA-015
title: "Pets: Tiros, Odds e Custos"
type: data-spec
status: Draft
moscow: Should
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
  "roster": { "1": [], "2": [], "3": [], "4": [], "5": [], "6": [] }
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

## 8. Relacionados
- Design: [[DESIGN-038 Pets|DESIGN-038]] · Técnico: [[SYSTEM-005 Pets & Gacha|SYSTEM-005]].
- Raridades: [[CONTEXT-007 Raridades|CONTEXT-007]] · Moeda premium: [[CONTEXT-013 Moeda Premium|CONTEXT-013]].
- Referência (IdleOn): `99-Inbox/reference/IDLEON_PETS_REFERENCE.md`.
