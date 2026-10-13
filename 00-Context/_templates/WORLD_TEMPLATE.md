---
id: DESIGN-XXX
aliases:
  - DESIGN-XXX
title: "Mundo N: Nome"
type: system-design
subtype: world
status: Draft | Spec Ready | Implemented
moscow: Must | Should | Could | Wont
moscow_note: Herda do pai salvo override.
parent: "[[DESIGN-campaign]]"
path: "Campanha / Mundo N"
dependencies: []
---

# [DESIGN-XXX] Mundo N: Nome

## 0. Prioridade MoSCoW
- **Categoria:** Must | Should | Could | Wont
- **Justificativa:**
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Tema & Visão
- Estética, ambientação e o que diferencia este mundo.

## 2. Níveis
- Lista dos níveis (ex: 5) e seus IDs.
- `parent` de cada nível aponta para este mundo.

## 3. Desbloqueio
- **Entrada:** condição para acessar este mundo.
- **Saída:** condição para liberar o próximo mundo (completar o último nível).

## 4. População & Inimigos
- Tipos de monstros, densidade, patrulhas.

## 5. Parâmetros
- Curvas de dificuldade/recompensa → [[DATA-XXX]].

## 6. Mapa da Árvore
```text
Mundo N
├── Nível N-1
└── Nível N-2
```

## 7. Mecânicas Transversais
- Lista de ~3 mecânicas transversais do mundo (ex: [[DESIGN-013 Selos|Selos]]).

## 8. Casos de Borda
- Mundo sem níveis, nível faltante, retorno.
