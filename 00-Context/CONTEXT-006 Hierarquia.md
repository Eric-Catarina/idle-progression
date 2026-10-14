---
id: CONTEXT-006
aliases:
  - CONTEXT-006
title: Hierarchical Decomposition (Árvore de Ideias & Conteúdo)
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-12
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
  - "[[CONTEXT-003 Ciclo de Ideias|CONTEXT-003]]"
tags:
  - context
  - convention
  - hierarchy
  - decomposition
  - content
---

# 🌳 [CONTEXT-006] Hierarchical Decomposition

## 1. Propósito

Padronizar como um nó se decompõe em **filhos**, formando uma **árvore navegável** de ideias e de conteúdo. Sem isso, features e conteúdos viram listas planas, difíceis de racionalizar (ex: "vários níveis" vira uma sopa de arquivos sem relação).

## 2. Campos de Hierarquia

| Campo | Obrigatório | Descrição |
| :--- | :--- | :--- |
| `parent` | Não (a raiz não tem) | `"[[ID]]"` — **pai único** da decomposição (relação *parte-de*). |
| `path` | Recomendado | Breadcrumb legível: `"Campanha / Mundo 2 / Nível 3"`. |
| `children` | Não | **Derivado** — calculado a partir de quem aponta `parent` para você. Nunca escrever à mão. |

## 3. Regras

- Existe **um único nó raiz** por árvore (sem `parent`) — a **Campanha**.
- Todo nó não-raiz tem **exatamente um** `parent`, e o alvo **deve existir**.
- **Sem ciclos** (validado automaticamente).
- `parent` significa **decomposição (parte-de)**. Para vínculo de implementação use `implements` / `tech_spec` / `data_spec` — **nunca** `parent`.
- Filhos **herdam a prioridade** (`moscow`) do pai, salvo override explícito no filho.

## 4. Níveis de Conteúdo (profundidade)

| Prof. | `subtype` | Nó | Cardinalidade |
| :--- | :--- | :--- | :--- |
| 0 | `campaign` | Campanha | 1 |
| 1 | `world` | Mundo | N por campanha |
| 2 | `level` | Nível | 5 por mundo (regra do jogo) |
| 3 | `arena` | Arena / Segmento | N por nível (opcional) |

## 5. Desbloqueio (exemplo padronizado)

A regra do projeto é **"matar X monstros libera o próximo nível"**. Isso é expresso como:

- O **Nível** declara sua seção *Gating & Desbloqueio* com a condição (matar X monstros do próprio nível).
- **X** é um parâmetro numérico → vive num `DATA-XXX` (curva por nível/mundo), nunca hardcoded no DESIGN.
- Completar o último nível de um mundo desbloqueia o **próximo Mundo**.

## 6. Árvore (índice)

O nó raiz (**Campanha**) mantém a seção **"Mapa da Árvore"** listando seus filhos diretos; cada Mundo faz o mesmo com seus Níveis. Isso dá um índice navegável sem depender de plugin.

## 7. Exemplo Concreto

```text
Campanha (DESIGN-002)
└── Mundo 1 (DESIGN-003)
    ├── Nível 1-0 (DESIGN-004)
    ├── Nível 1-2 (DESIGN-005)
    ├── ...
    └── Nível 1-5 (DESIGN-008)
```

```yaml
# Nível 1-0
id: DESIGN-004
subtype: level
parent: "[[DESIGN-003]]"        # Mundo 1
path: "Campanha / Mundo 1 / Nível 1-0"
```

## 8. Relacionado

- [[CONTEXT-003 Ciclo de Ideias|CONTEXT-003]] — Ciclo de vida (ideia → spec).
- [[CONTEXT-000 Manifesto|CONTEXT-000]] — Manifesto mestre.
- [[DESIGN-002 Campanha|DESIGN-002]] — Campanha (raiz da árvore de conteúdo).
