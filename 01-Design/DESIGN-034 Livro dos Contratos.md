---
id: DESIGN-034
aliases:
  - DESIGN-034
title: "Livro dos Contratos"
type: system-design
subtype: system
status: Draft
moscow: Should
moscow_note: Progressão de farm account-wide; desbloqueado no chefe do Mundo 1. O core loop valida sem.
dependencies:
  - "[[DESIGN-033 Multikill|DESIGN-033]]"
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
data_spec: "[[DATA-011 Multikill e Contratos|DATA-011]]"
---

# [DESIGN-034] Livro dos Contratos

> Nosso equivalente ao **Death Note** do IdleOn (nome escolhido por ser **temático de contratos**: cada espécie de mob é um *contrato de abate*, e cumprir **tiers** = cumprir cláusulas).
> Alternativas consideradas: *Tomo dos Contratos*, *Livro dos Abates*, *Registro de Caça*.

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** transforma **farmar** em progressão **account-wide permanente** (pontos por espécie de mob → bônus no mundo). Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Um **livro account-wide** que registra os **abates por espécie de mob**. Cada **Tier de Abate** alcançado ([[DESIGN-033 Multikill|Multikill]]) rende **Pontos**. Os Pontos dão **+1% de Multikill por Damage Tier** ao **mundo** correspondente — quanto mais você farma, mais recursos por abate.

## 2. Desbloqueio
- **Gatilho:** ao **liberar o portal do Level1_5** (o chefe do Mundo 1 — [[DESIGN-024 Level1_5|Level1_5]]), o jogador desbloqueia o **Livro do Mundo 1**.
- **Mundos futuros:** cada mundo desbloqueia o **seu próprio** livro (com seu próprio total de pontos e bônus).

## 3. Regras
1. **Account-wide:** soma os abates de **todos os personagens**.
2. O livro lista **as espécies de mob do mundo** e o **tier recorde** alcançado em cada.
3. **Pontos:** concedidos quando o jogador **alcança um tier novo** numa espécie (1 ponto por tier conquistado).
4. **Cada mundo** tem seu **total de pontos** e seu **bônus de Multikill**.
5. **Bônus do mundo:** `MK% = pontos × 1%` (de *Multikill por Damage Tier*).
6. Efeito prático do `MK%` → [[DESIGN-033 Multikill|DESIGN-033]] §2.

## 4. Contrato Funcional (I/O)
- **Gatilho:** morte de mob com `tier ≥ 1`.
- **Pré-requisitos:** livro do mundo desbloqueado.
- **Saída:** `tierRecorde[mob]` atualizado (se maior); **pontos** adicionados; `MK%` do mundo recalculado; persistido.

## 5. Lógica Passo a Passo
1. Mob morre → calcula **tier** ([[DESIGN-033 Multikill|DESIGN-033]] §2).
2. Se `tier > tierRecorde[mob]`:
   - concede `tier − tierRecorde[mob]` **pontos**;
   - atualiza `tierRecorde[mob]`.
3. Recalcula `MK%` do mundo = `pontos × 1%`.
4. Aplica `MK%` nas mortes seguintes.

## 6. Casos de Borda
- **Livro bloqueado:** tiers não contam (nada acumula antes do desbloqueio) — *a definir se retroage*.
- **Mob de outro mundo:** conta no livro **daquele** mundo.
- **Mob removido/renomeado** (refator de população): preservar pontos por `mobId`.
- **Overflow** de pontos (BigNumber / [[CONTEXT-004 Notacao Numerica|CONTEXT-004]]).

## 7. UI/UX e Feedback
- **O Livro:** lista de mobs do mundo; para cada, **tier recorde** + pontos que faltam para o próximo tier.
- **Barra de pontos do mundo** e o **`MK%`** resultante.
- Selo ao **desbloquear** (na liberação do portal do Level1_5).

## 8. Ganchos para o Futuro
- Livros por mundo (Mundo 2+), **capítulos** (sets de mobs que dão bônus extras).
- **Recompensas por capítulo completo** (não só pontos).
- Ritual/reforço de contratos (gastar recursos para "renegociar" bônus).

## 9. Relacionados
- Multikill: [[DESIGN-033 Multikill|DESIGN-033]] · Mundo: [[DESIGN-003 Mundo 1|DESIGN-003]] · Chefe: [[DESIGN-024 Level1_5|Level1_5]].
- Sets: [[DESIGN-032 Gear Sets|DESIGN-032]] (o Recruta dá `+1 Multikill`) · Valores: [[DATA-011 Multikill e Contratos|DATA-011]].
