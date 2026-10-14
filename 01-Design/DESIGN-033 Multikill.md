---
id: DESIGN-033
aliases:
  - DESIGN-033
title: "Multikill"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Camada de recompensa de farm; dá valor a builds de dano alto. O core loop valida sem.
dependencies:
  - "[[DESIGN-031 Calculo de Dano|DESIGN-031]]"
  - "[[DESIGN-034 Livro dos Contratos|DESIGN-034]]"
  - "[[DESIGN-016 Cartas|DESIGN-016]]"
data_spec: "[[DATA-011 Multikill e Contratos|DATA-011]]"
---

# [DESIGN-033] Multikill

> Inspiração: **Multikill do IdleOn**. Referência: mecânica descrita no `99-Inbox/reference/` (Death Note).
> Nome do sistema-tracking: **[[DESIGN-034 Livro dos Contratos|Livro dos Contratos]]**.

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** dá **valor a builds de dano alto** (overkill vira recurso) — profundidade de farm. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Quando alguém causa **dano muito acima do HP** de um mob, esse "excesso" vira recompensa. **Multikill** converte os **Tiers de Abate** (danos de 100%, 200%, 300%… do HP do mob) em **mais recurso base**.

## 2. Definição Formal
- **Tier de Abate:** `tier = max(1, floor(dano_do_golpe / HP_max_do_mob))`.
  - Ex.: um golpe de 3× o HP do mob → **tier 3**.
- **Efeito:** o **recurso base** do mob é multiplicado:
  `recursoBase × (1 + (tier − 1) × MK%)`
  - onde `MK%` = bônus de Multikill (do mundo, via [[DESIGN-034 Livro dos Contratos|Livro dos Contratos]]) + fontes de gear ([[DESIGN-032 Gear Sets|Recruta]]).
- Ex.: `MK% = 100%`, `tier = 3` → `×3` no recurso base.

## 3. Interações
- **Dano** ([[DESIGN-031 Calculo de Dano|DESIGN-031]]): builds de dano alto (overkill) se beneficiam.
- **Livro dos Contratos** ([[DESIGN-034 Livro dos Contratos|DESIGN-034]]): concede o `MK%` **por mundo**.
- **Drops:** só o **recurso base** (1º item da drop table do mob) é afetado.
- **Contagem de kills:** o Multikill **aumenta o kill count** (ajuda a destravar coisas por contagem) — **sem** XP/moeda extra.

## 4. O que **NÃO** é afetado
- **Cartas** ([[DESIGN-016 Cartas|DESIGN-016]]) — **nunca** duplicadas por Multikill.
- **XP** e **moedas** — os **kills extras não dão XP nem moeda**.
- **Itens além do recurso base** (recursos secundários, equipamentos, etc.).

## 5. Parâmetros
- `MK%` por mundo, tabela de tiers, recurso base por mob → [[DATA-011 Multikill e Contratos|DATA-011]].

## 6. Casos de Borda
- **Golpe exato** (100% do HP) → `tier = 1` (sem bônus).
- Dano **< HP** (mob sobrevive) → não conta tier.
- **Overkill gigantesco** (ex.: 1e6×) → tier altíssimo; **cap de tier** a definir ([[DATA-011 Multikill e Contratos|DATA-011]]).
- **Mob com 0 recursos base** → Multikill não faz nada.

## 7. UI/UX e Feedback
- Nº de **tier** flutuando sobre o mob no abate; flash quando `tier ≥ 3`.
- Indicador de **`MK%`** do mundo atual no HUD.

## 8. Ganchos para o Futuro
- Efeitos por tier (loot bônus temáticos), Multikill afetando recursos secundários via nós.
- Sinergia com skills de **dano em área** (matar vários com tier alto).

## 9. Relacionados
- Livro: [[DESIGN-034 Livro dos Contratos|DESIGN-034]] · Dano: [[DESIGN-031 Calculo de Dano|DESIGN-031]] · Sets: [[DESIGN-032 Gear Sets|DESIGN-032]].
- Cartas (não afetadas): [[DESIGN-016 Cartas|DESIGN-016]] · Valores: [[DATA-011 Multikill e Contratos|DATA-011]].
