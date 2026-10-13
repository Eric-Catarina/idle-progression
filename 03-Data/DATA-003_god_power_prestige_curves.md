---
id: DATA-003
aliases:
  - DATA-003
title: "Golem: Geração de Cristais, Custos e Megacristais"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-014]]"
dependencies:
  - "[[DESIGN-014]]"
---

# [DATA-003] Golem: Geração de Cristais, Custos e Megacristais

> Números da *enterprise* idle do Golem (modelo Orion). Ver [[DESIGN-014]].

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `C` | Cristais (moeda) |
| `L` | nível de uma melhoria |
| `g` | taxa de crescimento de custo (base `1.15`) |
| `resets` | nº de Reinícios de Cristal |
| `n` | nº do Grande Reinício (1..5) |

## 2. Formulação Matemática
- **Geração (cristal/s):** `gen = (Gen×1 + SuperProd×5) × (1 + 0.05×Multiplicador) × MG_geracao`
  - `MG_geracao` = `10` se tiver **Cristal Primordial**, senão `1`.
- **Custo de melhoria:** `cost(L) = base × g^L` (Barateadores reduzem `g`).
- **Reinício de Cristal:** multiplicador `= 3^(resets + 1)`.
- **Limiar do Grande Reinício:** `T(n) = T1 × r^(n-1)` (`T1 = 1e11`, `r = 10`).
- **Bônus do Golem (multiplicador):** base `1×`, → `2×` (Gêmeo) → `5×` (Divino) → `6×` (Fractal) `+0.5×/reset` extra.

## 3. Schema de Configuração (JSON)
```json
{
  "id": "golem_enterprise",
  "generation": { "perLevel": 1, "superPerLevel": 5, "multiplierPerLevel": 0.05 },
  "cost": { "growth": 1.15 },
  "restart": { "base": 3, "exponentOffset": 1 },
  "greatReset": { "T1": 100000000000, "r": 10 }
}
```

## 4. Tabela de Limiares do Grande Reinício
| n | Limiar `T(n)` | Megacristal concedido |
| :--- | :--- | :--- |
| 1 | 100 B | Cristal Primordial |
| 2 | 1 T | Cristal Gêmeo |
| 3 | 10 T | Cristal Divino |
| 4 | 100 T | Cristal do Artífice |
| 5 | 1 Qa | Cristal Fractal |

## 5. Efeitos dos Megacristais
| Megacristal | Efeito | Valor |
| :--- | :--- | :--- |
| Cristal Primordial | Multiplica toda geração | ×10 |
| Cristal Gêmeo | Multiplica os Bônus do Golem | ×2 |
| Cristal Divino | Bônus do Golem | ×5 |
| Cristal do Artífice | Crescimento de custo da Geração | −25% (mais lento) |
| Cristal Fractal | Bônus do Golem | ×6 (+0.5/reset) |

## 6. Gráfico — Limiar do Grande Reinício (Charts View)
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
  const T1 = 1e11, r = 10;
  const ns = [1, 2, 3, 4, 5];
  return ns.map(n => ({ grande: n, limiar: T1 * Math.pow(r, n - 1) }));

#-----------------#
#- chart options -#
#-----------------#
options:
  xField: 'grande'
  yField: 'limiar'
  smooth: true
  point:
    size: 4
  color: ['#b197fc']
  legend:
    position: 'bottom'
```

> Formatação segue [[CONTEXT-004]]; gráficos usam **Charts View** (ver [[DATA-002]] §5). Valores `Draft` — calibrar.
