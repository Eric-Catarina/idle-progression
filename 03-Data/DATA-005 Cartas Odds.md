---
id: DATA-005
aliases:
  - DATA-005
title: "Cartas: Raridades, Drops e Pacotes"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-016 Cartas|DESIGN-016]]"
dependencies:
  - "[[DESIGN-016 Cartas|DESIGN-016]]"
  - "[[CONTEXT-007 Raridades|CONTEXT-007]]"
---

# [DATA-005] Cartas: Raridades, Drops e Pacotes

> Pesos de raridade, drops e odds de pacote das **cartas**. A escala de raridade é a de [[CONTEXT-007 Raridades|CONTEXT-007]].

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `raridade` | uma das 6 raridades ([[CONTEXT-007 Raridades|CONTEXT-007]]) |
| `peso` | peso relativo de sorteio/drop |
| `cartasPorPacote` | nº de cartas por pacote |

## 2. Raridades (peso base de drop)
| Raridade | Cor | Peso |
| :--- | :--- | :--- |
| Comum | cinza | 60 |
| Raro | azul fraco | 25 |
| Épico | roxo | 10 |
| Lendário | laranja dourado | 4 |
| Extraordinário | arco-íris | 0.9 |
| Divino | preto-branco brilhoso | 0.1 |

## 3. Formulação
- **Drop de mob:** `chance_drop = base × (1 + bônusDrop)` → sorteia `raridade` pelos pesos.
- **Pacote:** sorteia `cartasPorPacote` cartas pelos pesos; pacotes premium/cósmicos enviesam raridades altas.
- **Poeira:** duplicata dá `poeira = f(raridade)`.

## 4. Schema de Configuração (JSON)
```json
{
  "id": "cards_rarity",
  "packCards": 3,
  "dustByRarity": { "Comum": 1, "Raro": 4, "Epico": 12, "Lendario": 40, "Extraordinario": 150, "Divino": 600 }
}
```

## 5. Tipos de Pacote & Odds
Cartas por pacote: **3** (Comum/Premium/Mundo) · **5** (Cósmico). Odds em % (somam 100).

| Raridade | Comum | Premium | de Mundo | Cósmico |
| :--- | :--- | :--- | :--- | :--- |
| Comum | 60 | 40 | 55 | 0 |
| Raro | 25 | 30 | 26 | 20 |
| Épico | 10 | 18 | 12 | 35 |
| Lendário | 4 | 8 | 5 | 28 |
| Extraordinário | 0.9 | 3.2 | 1.8 | 12 |
| Divino | 0.1 | 0.8 | 0.2 | 5 |

**Notas:**
- **de Mundo:** pool restrito ao mundo (ajuda a **fechar sets**); Divino raro.
- **Cósmico:** endgame, sem Comum.
- **Diário:** 1 pacote grátis/dia com as odds do **Premium**.
- **Pity:** a cada **30 pacotes** sem **Lendário+**, o próximo garante **Lendário+**.

## 6. Gráfico — Peso por Raridade (Charts View)
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
    { raridade: 'Comum', peso: 60 },
    { raridade: 'Raro', peso: 25 },
    { raridade: 'Epico', peso: 10 },
    { raridade: 'Lendario', peso: 4 },
    { raridade: 'Extraordinario', peso: 0.9 },
    { raridade: 'Divino', peso: 0.1 }
  ];

#-----------------#
#- chart options -#
#-----------------#
options:
  xField: 'peso'
  yField: 'raridade'
  color: ['#9775fa']
```

> Formatação segue [[CONTEXT-004 Notacao Numerica|CONTEXT-004]]; gráficos usam **Charts View** (ver [[DATA-002 Selos Curvas|DATA-002]]). Valores `Draft` — calibrar.
