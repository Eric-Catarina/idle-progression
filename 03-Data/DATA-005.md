---
id: DATA-005
aliases:
  - DATA-005
title: "Cartas: Raridades, Drops e Pacotes"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-016]]"
dependencies:
  - "[[DESIGN-016]]"
---

# [DATA-005] Cartas: Raridades, Drops e Pacotes

> Pesos de raridade, drops e odds de pacote. Ver [[DESIGN-016]].

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `raridade` | uma das 10 raridades |
| `peso` | peso relativo de sorteio/drop |
| `cartasPorPacote` | nº de cartas por pacote |

## 2. Tabela de Raridades (peso e cor)
| Raridade | Peso | Cor |
| :--- | :--- | :--- |
| Comum | 55 | cinza |
| Bom | 22 | branco |
| Refinado | 12 | verde |
| Raro | 6 | azul |
| Épico | 3 | roxo |
| Único | 1.3 | laranja |
| Mítico | 0.5 | vermelho |
| Lendário | 0.15 | dourado |
| Extraordinário | 0.04 | prisma |
| Eterno | 0.01 | arco-íris |

## 3. Formulação
- **Drop de mob:** `chance_drop = base × (1 + bônusDrop)` → sorteia `raridade` pelos pesos.
- **Pacote:** sorteia `cartasPorPacote` cartas pelos pesos; pacotes premium multiplicam os pesos de raridade alta por `K`.
- **Poeira:** duplicata dá `poeira = f(raridade)`.

## 4. Schema de Configuração (JSON)
```json
{
  "id": "cards_rarity",
  "packCards": 3,
  "premiumHighRarityMult": 3,
  "dustByRarity": { "Comum": 1, "Bom": 2, "Refinado": 4, "Raro": 8, "Epico": 16, "Unico": 32, "Mitico": 64, "Lendario": 128, "Extraordinario": 256, "Eterno": 512 }
}
```

## 5. Gráfico — Peso por Raridade (Charts View)
```chartsview
#-----------------#
#- chart type    -#
#-----------------#
type: Bar

#-----------------#
#- chart data    -#
#-----------------#
data: |
  dataviewjs:
  return [
    { raridade: 'Comum', peso: 55 },
    { raridade: 'Bom', peso: 22 },
    { raridade: 'Refinado', peso: 12 },
    { raridade: 'Raro', peso: 6 },
    { raridade: 'Epico', peso: 3 },
    { raridade: 'Unico', peso: 1.3 },
    { raridade: 'Mitico', peso: 0.5 },
    { raridade: 'Lendario', peso: 0.15 },
    { raridade: 'Extraordinario', peso: 0.04 },
    { raridade: 'Eterno', peso: 0.01 }
  ];

#-----------------#
#- chart options -#
#-----------------#
options:
  xField: 'peso'
  yField: 'raridade'
  color: ['#9775fa']
```

> Formatação segue [[CONTEXT-004]]; gráficos usam **Charts View** (ver [[DATA-002]]). Valores `Draft` — calibrar.
