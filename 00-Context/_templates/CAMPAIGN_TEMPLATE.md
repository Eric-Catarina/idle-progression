---
id: DESIGN-XXX
aliases:
  - DESIGN-XXX
title: "Campanha: Nome"
type: system-design
subtype: campaign
status: Draft | Spec Ready | Implemented
moscow: Must | Should | Could | Wont
moscow_note: Justificativa curta da prioridade.
dependencies: []
---

# [DESIGN-XXX] Campanha: Nome

> Raiz da árvore de conteúdo. Não tem `parent`. Ver [[CONTEXT-006]].

## 0. Prioridade MoSCoW
- **Categoria:** Must | Should | Could | Wont
- **Justificativa:**
- Ver [[CONTEXT-001]].

## 1. Visão & Propósito
- Fantasia geral e escopo (quantos mundos, tema).

## 2. Regras de Estrutura
- Quantos **Mundos** por campanha.
- Quantos **Níveis** por mundo (ex: 5).

## 3. Desbloqueio entre Mundos
- Condição para liberar o próximo mundo.

## 4. Mapa da Árvore
```text
Campanha
└── Mundo 1
    └── Nível 1-1
```

## 5. Parâmetros
- Valores de balanceamento → [[DATA-XXX]].

## 6. Casos de Borda
- Progressão não-linear, retorno a mundos anteriores.
