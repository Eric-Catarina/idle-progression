---
id: DESIGN-030
aliases:
  - DESIGN-030
title: "Star Force (Estrelas)"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Eixo de upgrade de gear com risco; profundo, mas o core loop valida sem ele.
dependencies:
  - "[[DESIGN-028 Equipamentos|DESIGN-028]]"
data_spec: "[[DATA-008 Star Force|DATA-008]]"
---

# [DESIGN-030] Star Force (Estrelas)

> Inspiração: **Star Force do MapleStory**. Referência bruta em `99-Inbox/reference/MAPLESTORY_GEAR_REFERENCE.md`.

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** o eixo de **upgrade com risco** (custo vs. recompensa) que dá "projeto de longo prazo" ao gear. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Cada peça recebe **estrelas (★)** pagando **Ouro**. As estrelas dão **stats flat** (STR/DEX/INT/LUK) e — a partir de **16★** — **Damage**. É um **loop de risco**: falhar pode **manter**, **derrubar ★** ou **destruir o item**. Existe um "ponto de ouro" (**21★**) onde o item "fica pronto".

## 2. Faixas de Estrela
| Faixa | Comportamento |
| :--- | :--- |
| **0★–15★** | custo relativamente baixo, risco gerenciável; +**stat flat** por ★ |
| **12★+** | existe risco de **destruição** (exceto **níveis de proteção**) |
| **após 15★** | falha pode **derrubar 1★** |
| **16★+** | ganha **Damage por ★**, **escalando com o nível do item** |
| **20★ → 21★** | **marco**: um dos maiores incrementos individuais de dano |
| **21★** | **ponto de ouro** ("item finalizado"), custo acessível |
| **22★** | **máximo de eficiência**, mas custo **desproporcional** (2 sucessos seguidos, risco alto) |

> Teto do sistema: **25★** (a definir se vai além).

## 3. Custo & Risco
- **Custo por tentativa:** cresce por ★ e **pelo nível do item** → [[DATA-008 Star Force|DATA-008]].
- **Resultado da tentativa:** `Sucesso` · `Mantém` · `−1★` · `Destruição`.
- **Proteção:** certos níveis têm proteção contra destruição; **Chance Time** (após falhas seguidas, o próximo tem chance aumentada) — ver [[DATA-008 Star Force|DATA-008]].
- **Destruição:** o item **desaparece** (perda real). Mitigação: **spares** (cópias) e eventos (ex.: *Shining Star Force*).

## 4. Bônus por Estrela
- **0–15★:** `statFlat = statPerStar × ★`, onde `statPerStar = f(nível do item)`.
- **16★+:** além do flat, `Damage = dmgPerStar × (★ − 15)` (escala com o nível do item).
- **Marco 21★:** incremento de **Damage** **maior** que o normal (o "salto").
- Fórmulas/tabelas → [[DATA-008 Star Force|DATA-008]].

## 5. Contrato Funcional (I/O)
- **Gatilho:** clicar **Star Force** num item.
- **Pré-requisitos:** Ouro ≥ custo; item não destruído.
- **Saída:** `item.stars` alterado; `item.destroyed` possível; stats recalculados; persistido.

## 6. Casos de Borda
- Destruição: item sai do inventário; **logs** e (futuro) recuperação via spare.
- Falha em **0★** → mantém em 0★.
- `Chance Time` no 21★+ (a definir se vale).
- Offline/catch-up: Star Force é **tempo-real** (ignorado no catch-up — [[DESIGN-025 Navegacao & Movimento|DESIGN-025]] §9 é o precedente).

## 7. UI/UX e Feedback
- Barra de **★** no item; **sanidade** visual (cor/glow) por faixa (15★, 16★, 21★, 22★).
- Confirmação explícita antes de tentativas com **risco de destruição**.
- Histórico/estatística de tentativas (opcional).

## 8. Ganchos para o Futuro
- **Eventos** de chance aumentada / scrolls de proteção.
- **Fora de escopo por enquanto:** transferência de ★ entre itens, Safeguard pago.

## 9. Relacionados
- Equipamentos: [[DESIGN-028 Equipamentos|DESIGN-028]] · Potential: [[DESIGN-029 Potential|DESIGN-029]] · Dano: [[DESIGN-031 Calculo de Dano|DESIGN-031]].
- Curvas: [[DATA-008 Star Force|DATA-008]].
