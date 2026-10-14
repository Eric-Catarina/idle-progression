---
id: DESIGN-002
aliases:
  - DESIGN-002
title: "Campanha: Estrutura de Conteúdo (Mundos & Níveis)"
type: system-design
subtype: campaign
status: Spec Ready
moscow: Must
moscow_note: Estrutura raiz que organiza todo o conteúdo jogável.
dependencies:
  - "[[CONTEXT-006 Hierarquia|CONTEXT-006]]"
---

# [DESIGN-002] Campanha: Estrutura de Conteúdo

> **Raiz da árvore de conteúdo** (sem `parent`). Regras de hierarquia em [[CONTEXT-006 Hierarquia|CONTEXT-006]].

## 0. Prioridade MoSCoW
- **Categoria:** Must
- **Justificativa:** Sem uma estrutura de mundos/níveis não há como organizar o conteúdo nem o desbloqueio progressivo.
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
A campanha organiza todo o conteúdo jogável numa progressão **Mundo → Nível**. Cada nível é um desafio de plataformas 2D com layout próprio, e o avanço é gated por desempenho (matar monstros).

## 2. Regras de Estrutura
- Uma **Campanha** contém **N Mundos**.
- Cada **Mundo** contém **5 Níveis**.
- Cada **Mundo** tem **~3 Mecânicas Transversais** próprias (ex: Mundo 1 → [[DESIGN-013 Selos|Selos]]).
- Cada **Nível** tem um **layout de plataformas 2D único**.
- Completar o último nível de um Mundo desbloqueia o **próximo Mundo**.

## 3. Contrato Funcional (I/O)
- **Gatilho:** morte de um monstro no nível ativo.
- **Pré-requisito:** o nível está desbloqueado (`unlocked == true`).
- **Saída:** contador `kills` do nível; ao atingir `X`, `unlock(nextLevel)`.

## 4. Lógica Passo a Passo
1. Ao morrer um monstro no nível `L`, incrementa `L.kills`.
2. Se `L.kills >= L.requiredKills` e `!L.next.unlocked`, desbloqueia `L.next`.
3. Se `L` é o último do Mundo e foi concluído, desbloqueia o primeiro nível do próximo Mundo.
4. Persistir `kills` e `unlocked` no estado.

## 5. Casos de Borda
- Overflow de `kills` (BigNumber) — matar muito além de X.
- Retroceder a mundos anteriores (não relocka).
- Nível final da campanha (sem próximo).

## 6. Mapa da Árvore
```text
Campanha (DESIGN-002)
└── Mundo 1 (DESIGN-003)
    └── Level1_0 (DESIGN-004)
        └── ...
```

## 7. Parâmetros
- `requiredKills` por nível, níveis por mundo → [[DATA-XXX]].

## 8. Ganchos para o Futuro
- Modo endless, mundos alternativos, chefes (Should/Could) encaixam como novos nós filhos.
