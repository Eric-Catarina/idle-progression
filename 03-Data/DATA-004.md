---
id: DATA-004
aliases:
  - DATA-004
title: "Constelação: Pontos, Custos e Bônus"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-015]]"
dependencies:
  - "[[DESIGN-015]]"
---

# [DATA-004] Constelação: Pontos, Custos e Bônus

> Curvas de Pontos Estelares (PE), custos de nó e bônus. Ver [[DESIGN-015]].

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `PE` | Pontos Estelares disponíveis |
| `lvl` | nível do personagem |
| `prestiges` | Grandes Reinícios concluídos ([[DESIGN-014]]) |
| `k` | nº de nós já acesos |
| `g` | crescimento de custo por nó (base `1.30`) |

## 2. Formulação Matemática
- **PE ganho:** `PE = floor(lvl / 5) + 3 × prestiges + achievementsPE`
- **Custo do nó `k`:** `cost(k) = base × g^k` (`base = 1`)
- **Afinidade:** cada nó dá `+1` do seu tipo; constelação exige `afinidade_min`.
- **Poder ao completar:** bônus forte fixo por constelação (tabela §4).

## 3. Schema de Configuração (JSON)
```json
{
  "id": "constellation_curves",
  "points": { "perLevels": 5, "perPrestige": 3 },
  "node": { "baseCost": 1, "growth": 1.30 },
  "affinity": { "perNode": 1 }
}
```

## 4. Bônus (proposta, `Draft`)
| Bônus por nó | Valor |
| :--- | :--- |
| +dano / +crítico / +precisão | +1% cada |
| +drop rate | +0.5% |
| +cristais/s | +1% |
| +velocidade de movimento | +0.5% |

| Poder ao completar | Valor |
| :--- | :--- |
| A Fera (AoE) | +25% dano em área |
| O Caçador (Boss) | +25% dano em alvo único |
| A Moeda (drop) | +20% drop rate |
| A Colheita (raridade) | +10% chance de Fragmento Raro |
| A Forja (cristais) | +30% geração de Cristais |
| O Relojoeiro (offline) | +50% ganhos offline |
| O Vento (mobilidade) | +15% velocidade |
| A Escalada (vertical) | +20% dano em mapas verticais |

## 5. Gráfico — PE acumulado por nível (Charts View)
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
  const levels = [5, 10, 25, 50, 100, 200, 500, 1000];
  return levels.map(l => ({ nivel: l, pe: Math.floor(l / 5) }));

#-----------------#
#- chart options -#
#-----------------#
options:
  xField: 'nivel'
  yField: 'pe'
  smooth: true
  point:
    size: 3
  color: ['#ffd43b']
  legend:
    position: 'bottom'
```

> Formatação segue [[CONTEXT-004]]; gráficos usam **Charts View** (ver [[DATA-002]] §5). Valores `Draft` — calibrar.
