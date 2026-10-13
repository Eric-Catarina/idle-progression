---
id: DATA-002
aliases:
  - DATA-002
title: "Selos: Curvas de Bônus"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-013]]"
dependencies:
  - "[[DESIGN-013]]"
---

# [DATA-002] Selos: Curvas de Bônus

> Curvas de ganho de bônus por nível de selo. Ver [[DESIGN-013]].

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

> Formatação de exibição segue [[CONTEXT-004]] (percentuais com 2 casas). Valores `Draft` — calibrar em simulação.

## 5. Gráfico da Curva (Dinâmico — DataviewJS + Charts)

> **Requer os plugins** `Dataview` e `Obsidian Charts`.
> Os valores são **calculados da fórmula** — mudam sozinhos ao editar `c` / `a` / `k`, sem regerar pontos à mão.

### Curvas percentuais (retorno decrescente)
```dataviewjs
const L = [1, 10, 25, 50, 100, 200, 500, 1000, 2000];
const s = (c, a) => L.map(x => +(c * x / (a + x)).toFixed(3));
window.renderChart({
  type: 'line',
  data: {
    labels: L,
    datasets: [
      { label: 'Dano Crítico % (c=8, a=40)',    data: s(8, 40),  borderColor: '#ff6b6b', backgroundColor: 'rgba(255,107,107,0.15)', tension: 0.35, fill: false, pointRadius: 3 },
      { label: 'Dano vs Bosses % (c=20, a=60)', data: s(20, 60), borderColor: '#4dabf7', backgroundColor: 'rgba(77,171,247,0.15)',  tension: 0.35, fill: false, pointRadius: 3 }
    ]
  },
  options: {
    plugins: { legend: { labels: { color: '#cfcfcf' } } },
    scales: {
      x: { title: { display: true, text: 'Nivel do selo', color: '#cfcfcf' }, ticks: { color: '#cfcfcf' } },
      y: { title: { display: true, text: 'Bonus (%)', color: '#cfcfcf' }, ticks: { color: '#cfcfcf' }, beginAtZero: true }
    }
  }
}, this.container);
```

### Curva flat (linear)
```dataviewjs
const L = [1, 10, 25, 50, 100, 200, 500, 1000, 2000];
const k = 1; // ganho flat por nivel
window.renderChart({
  type: 'line',
  data: { labels: L, datasets: [
    { label: `Dano Base (k=${k})`, data: L.map(x => k * x), borderColor: '#51cf66', backgroundColor: 'rgba(81,207,102,0.15)', tension: 0, fill: false, pointRadius: 3 }
  ] },
  options: {
    plugins: { legend: { labels: { color: '#cfcfcf' } } },
    scales: {
      x: { title: { display: true, text: 'Nivel do selo', color: '#cfcfcf' }, ticks: { color: '#cfcfcf' } },
      y: { title: { display: true, text: 'Bonus', color: '#cfcfcf' }, ticks: { color: '#cfcfcf' }, beginAtZero: true }
    }
  }
}, this.container);
```

> **Como habilitar:** `Configurações → Plugins da comunidade → Procurar` → instale **Dataview** e **Charts** → ative ambos. Sem eles, os blocos aparecem como código.
> **Rascunho estático** (só com o plugin Charts, sem Dataview): troque o bloco por
> ````text
> ```chart
> { "type": "line", "labels": [1,10,50,100,200,500,1000],
>   "series": [{ "title": "Crit %", "data": [0.2,1.6,4.44,5.71,6.67,7.41,7.69] }] }
> ```
> ````
