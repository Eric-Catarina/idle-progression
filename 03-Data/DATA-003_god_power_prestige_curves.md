---
id: DATA-003
aliases:
  - DATA-003
title: "Deus Caído: Poder, Limiares e Relíquias"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-014]]"
dependencies:
  - "[[DESIGN-014]]"
---

# [DATA-003] Deus Caído: Poder, Limiares e Relíquias

> Curvas de Poder, limiares de confronto e bônus das relíquias. Ver [[DESIGN-014]].

## 1. Variáveis Base & Constantes
| Var | Descrição |
| :--- | :--- |
| `F` | Fragmentos de Cristal devolvidos |
| `P` | Poder do Golem |
| `n` | número do confronto (1..5) |
| `T(n)` | limiar de Poder para o confronto `n` |
| `r` | razão de escala dos limiares |

## 2. Formulação Matemática
- **Poder:** `P = F + baseNucleo` (linear; `baseNucleo` vem da relíquia Núcleo Ancestral).
- **Limiar:** `T(n) = T1 × r^(n-1)` (ex: `T1 = 1.000`, `r = 8`).
- **Fragmento Raro** vale `xM` fragmentos comuns (chance via Olho do Juízo).

## 3. Schema de Configuração (JSON)
```json
{
  "id": "fallen_god_curves",
  "power": { "formula": "F + baseNucleo" },
  "threshold": { "T1": 1000, "r": 8 },
  "rareFragmentMultiplier": 20
}
```

## 4. Tabela de Confrontos
| n | Limiar `T(n)` | Relíquia concedida |
| :--- | :--- | :--- |
| 1 | 1.000 | Coração de Cristal |
| 2 | 8.000 | Núcleo Ancestral |
| 3 | 64.000 | Olho do Juízo |
| 4 | 512.000 | Punho Divino |
| 5 | 4.096.000 | Alma Eterna |

## 5. Bônus das Relíquias (proposta)
| Relíquia | Efeito | Valor |
| :--- | :--- | :--- |
| Coração de Cristal | +velocidade de coleta | +25% |
| Núcleo Ancestral | `baseNucleo` | `T(n)/20` por ciclo |
| Olho do Juízo | +chance de Fragmento Raro | +5% |
| Punho Divino | +Poder de Combate no confronto | +100% |
| Alma Eterna | +ganhos offline do Golem | +50% |

## 6. Gráfico — Limiar de Confronto (Charts View)
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
  const T1 = 1000, r = 8;
  const ns = [1, 2, 3, 4, 5];
  return ns.map(n => ({ confronto: n, limiar: T1 * Math.pow(r, n - 1) }));

#-----------------#
#- chart options -#
#-----------------#
options:
  xField: 'confronto'
  yField: 'limiar'
  smooth: true
  point:
    size: 4
  color: ['#b197fc']
  legend:
    position: 'bottom'
```

> Formatação de exibição segue [[CONTEXT-004]]; gráficos usam **Charts View** (ver [[DATA-002]] §5). Valores `Draft` — calibrar.
