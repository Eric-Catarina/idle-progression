---
id: DATA-016
aliases:
  - DATA-016
title: Loja de Gemas
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-039 Loja de Gemas|DESIGN-039]]"
dependencies:
  - "[[CONTEXT-013 Moeda Premium|CONTEXT-013]]"
  - "[[DESIGN-039 Loja de Gemas|DESIGN-039]]"
---

# [DATA-016] Loja de Gemas

> Preços e volumes da loja de **Gemas** ([[CONTEXT-013 Moeda Premium|CONTEXT-013]]). Valores `Draft` — calibrar.
> **Câmbio base:** `1 USD = 500 Gemas`. Pacotes maiores dão **bônus** (mais Gemas por dólar).

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `rateBase` | **500** Gemas por USD (câmbio base) |
| `gems(pack)` | Gemas totais do pacote (base + bônus) |
| `bonus(pack)` | bônus do pacote (Gemas extras vs. o câmbio base) |
| `gemsPerUsd(pack)` | `gems / price` — eficiência do pacote |

## 2. Pacotes (IAP)
| id | Pacote | Preço (USD) | Gemas | Gemas/USD | Bônus |
| :--- | :--- | --: | --: | --: | --: |
| `gem_start` | **Punhado** | 0.99 | **500** | 505 | — |
| `gem_small` | **Bolsinha** | 4.99 | **2.600** | 521 | +4% |
| `gem_medium` | **Saco** | 9.99 | **5.500** | 551 | +10% |
| `gem_large` | **Baú** | 19.99 | **12.000** | 600 | +20% |
| `gem_xl` | **Cofre** | 49.99 | **32.500** | 650 | +30% |
| `gem_xxl` | **Tesouro** | 99.99 | **70.000** | 700 | +40% |

- A eficiência **cresce** com o pacote (505 → 700 Gemas/USD) — incentivo clássico de IAP.
- **Preço local:** a loja define o preço em R$ (e demais moedas); o **volume de Gemas é o mesmo** em todo lugar.

## 3. Valores Derivados (o que as Gemas compram)
| Item | Gemas | **USD** |
| :--- | --: | --: |
| `shot_common` ([[DATA-015 Pets Odds\|DATA-015]] §5) | 100 | **$0.20** |
| `shot_epic` | 1.500 | **$3.00** |
| 1 ano de épicos **extras** (52 tiros) | 78.000 | **$156** |
| **Divino esperado** (100 épicos) | 150.000 | **$300** |

> 🧮 **Âncora de monetização:** o **Divino** sai, em média, depois de **100 tiros épicos** (~$300) pagando — enquanto o caminho **grátis** leva ~1.9 anos ([[DATA-015 Pets Odds|DATA-015]] §7). É o "atalho honesto": quem paga **compra tempo**, quem não paga **chega lá**.

## 4. Schema de Configuração (JSON)
```json
{
  "id": "gem_store",
  "rateBase": 500,
  "currencyDisplay": "USD",
  "packs": [
    { "id": "gem_start",  "price": 0.99,  "gems": 500 },
    { "id": "gem_small",  "price": 4.99,  "gems": 2600 },
    { "id": "gem_medium", "price": 9.99,  "gems": 5500 },
    { "id": "gem_large",  "price": 19.99, "gems": 12000 },
    { "id": "gem_xl",     "price": 49.99, "gems": 32500 },
    { "id": "gem_xxl",    "price": 99.99, "gems": 70000 }
  ]
}
```

## 5. Relacionados
- Convenção: [[CONTEXT-013 Moeda Premium|CONTEXT-013]] · Fluxo/UI: [[DESIGN-039 Loja de Gemas|DESIGN-039]].
- Consumidor: [[DESIGN-038 Pets|DESIGN-038]] (tiros) · Custos: [[DATA-015 Pets Odds|DATA-015]].
