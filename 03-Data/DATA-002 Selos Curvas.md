---
id: DATA-002
aliases:
  - DATA-002
title: "Selos: Curvas de Bônus"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-013 Selos|DESIGN-013]]"
dependencies:
  - "[[DESIGN-013 Selos|DESIGN-013]]"
---

# [DATA-002] Selos: Curvas de Bônus

> Curvas de ganho de bônus por nível de selo. Ver [[DESIGN-013 Selos|DESIGN-013]]. Custo em **Essência** para subir nível → [[DATA-012 Essencia Custos|DATA-012]] §2.1.

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `L` | nível do selo (≥ 1) |
| `k` | ganho **flat** por nível |
| `c` | teto assintótico do bônus % |
| `a` | constante de suavização (%) |

## 2. Formulação Matemática
- **Flat:** `B(L) = k × L`
- **Percentual com retorno decrescente:** `B(L)% = c × L / (a + L)` → tende a `c` quando `L → ∞`.

## 3. Schema de Configuração (JSON)
```json
{
  "id": "stamp_bonus_curves",
  "families": {
    "flat": { "formula": "k*L" },
    "diminishingPercent": { "formula": "c*L/(a+L)" }
  }
}
```

## 4. Tabela de Simulação

### Flat — Danos/Stats (`k = 1`)
| Nível | Bônus |
| :--- | :--- |
| 1 | +1 |
| 10 | +10 |
| 100 | +100 |
| 1.000 | +1.000 |

### Percentual — Dano Crítico (`c=8, a=40`)
| Nível | Bônus |
| :--- | :--- |
| 1 | +0.20% |
| 10 | +1.60% |
| 50 | +4.44% |
| 100 | +5.71% |
| 500 | +7.41% |
| ∞ | +8.00% |

### Percentual — Dano vs Bosses (`c=20, a=60`)
| Nível | Bônus |
| :--- | :--- |
| 1 | +0.33% |
| 50 | +9.09% |
| 200 | +15.38% |
| 1.000 | +18.87% |

> Formatação de exibição segue [[CONTEXT-004 Notacao Numerica|CONTEXT-004]] (percentuais com 2 casas). Valores `Draft` — calibrar em simulação.

## 5. Gráfico da Curva (Charts View + Dataview)

> **Requer os plugins** `Dataview` e **`Charts View`** (`obsidian-chartsview-plugin`).
> Os valores vêm de uma fonte `dataviewjs` (calculada da fórmula) — mudam ao editar `c` / `a` / `k`.

### Curvas percentuais (retorno decrescente)
```chartsview
#-----------------#
#- chart type    -#
#-----------------#
type: Line

#-----------------#
#- chart data    -#
#-----------------#
data: |
  dataviewjs:
  const L = [1, 10, 25, 50, 100, 200, 500, 1000, 2000];
  return L.map(x => ({
    nivel: x,
    critico: +(8 * x / (40 + x)).toFixed(3),
    boss: +(20 * x / (60 + x)).toFixed(3)
  }));

#-----------------#
#- chart options -#
#-----------------#
options:
  xField: 'nivel'
  yField: ['critico', 'boss']
  smooth: true
  point:
    size: 3
  color: ['#ff6b6b', '#4dabf7']
  legend:
    position: 'bottom'
```

### Curva flat (linear)
```chartsview
#-----------------#
#- chart type    -#
#-----------------#
type: Line

#-----------------#
#- chart data    -#
#-----------------#
data: |
  dataviewjs:
  const L = [1, 10, 25, 50, 100, 200, 500, 1000, 2000];
  return L.map(x => ({ nivel: x, base: x }));

#-----------------#
#- chart options -#
#-----------------#
options:
  xField: 'nivel'
  yField: 'base'
  smooth: false
  point:
    size: 3
  color: ['#51cf66']
  legend:
    position: 'bottom'
```

> **Como habilitar:** `Configurações → Plugins da comunidade → Procurar` → instale **Charts View** (e **Dataview**, com *Enable JavaScript Queries* ligado) → ative.
> **Se não renderizar:** rode `Charts View: Insert Template` para ver um exemplo válido da sua versão e me avise — ajusto os campos (`yField` vs `seriesField`/`colorField`).
