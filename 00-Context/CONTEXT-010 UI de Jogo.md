---
id: CONTEXT-010
aliases:
  - CONTEXT-010
title: UI de Jogo (Layout & Interação)
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-15
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
  - "[[CONTEXT-009 Direcao de Arte|CONTEXT-009]]"
tags:
  - context
  - convention
  - ui
  - ux
---

# 🖥️ [CONTEXT-010] UI de Jogo (Layout & Interação)

## 1. Propósito
Definir o **layout de UI do jogo** — que é **diferente de um site**.
*(Validação: a 1ª versão do protótipo usou **página + barra lateral**; o canvas ficou **espremido** e "não cabia" na tela deitada. Custou retrabalho.)*

## 2. Regra
> **O mundo ocupa a TELA INTEIRA; a UI FLUTUA por cima.** O canvas **nunca** é encolhido pra caber a UI.

## 3. Camadas
| Camada | Conteúdo | Comportamento |
| :--- | :--- | :--- |
| **Jogo** | cena (mundo) | **fullscreen**; redimensiona à janela |
| **HUD** | recursos, HP, XP, **cota de abate** | flutua no **topo**, semi-transparente |
| **Footer** | **UI principal**: infos principais + **ícones de acesso aos menus** | **fixo embaixo**, largura total |
| **Janelas** | cada sistema (Equipamento, Cartas, Osíris…) | **sobrepostas**, **arrastáveis**, com **✕** |

## 3b. Footer (UI principal inferior) — INVARIANTE
> **Referência:** MapleStory (HUD inferior com barras de HP/MP/EXP + barra de ícones). Salva em `99-Inbox/reference/` (ver §7).

- O **Footer** ocupa horizontalmente **toda a largura** e fica **colado no fundo** da tela: à esquerda as **informações principais** (nível, HP, XP, cota), à direita os **botões de acesso** aos outros menus (Equipamento, Skills, Cartas, Ítens, MAP, Chat, MENU…).
- **INVARIANTE (nunca violar):** o **piso** (a última plataforma de baixo) **NUNCA** pode ficar **abaixo do topo do Footer**. O **lugar onde o player pisa** fica **logo acima** do Footer, com um **pequeno padding**.

```text
┌───────────────────────────────────────┐  y = 0
│                                       │
│              MUNDO JOGÁVEL            │   ← área do mundo = altura − F
│        (câmera limitada aqui)         │
│   ══════════ PISO (última linha) ═════│   ← superfície: onde o player pisa
│                                       │   ↕ P (padding, 8)
├───────────────────────────────────────┤   ← TOPO DO FOOTER  (limite do mundo)
│ [Lv][HP▓▓][XP▓▓][cota]  [AUTO][SKILL] │   ↕ F (footer, 89)
└───────────────────────────────────────┘  y = H
```

### Medidas (base 1280×720 · escala Fibonacci — [[CONTEXT-008 Escala Visual|CONTEXT-008]])
| Constante | Valor | Papel |
| :--- | --: | :--- |
| `H` | 720 | altura base do viewport |
| `F` (footer) | **89** (F11) | altura do footer fixo |
| `P` (padding) | **8** (F6) | respiro entre a **superfície do piso** e o topo do footer |
| **Área do mundo** | `H − F` = **631** | região visível do mundo |
| **Superfície do piso** | `F + P` = **97** px do fundo | onde o **player pisa** |

### Consequências de implementação
- **Câmera:** o limite **inferior** da câmera do mundo é `topo do footer` — o mundo **nunca** é enquadrado abaixo dele.
- **Colisão:** o **piso é sólido**; o player não desce abaixo da superfície do piso ([[DESIGN-023 Plataformas & Portais|DESIGN-023]] §2).
- **Nunca sobrepor:** o piso **não** pode ser encoberto pelo footer (é a área de jogo do player).
- **Orientação/tamanho:** em telas com aspect ratio diferente, `F` escala com a altura (`F = H × 89/720`) e o **mundo absorve** o resto (stretch `canvas_items/expand`) — a **área do mundo** é o que cresce/diminui, nunca o footer.


## 4. Interação (toque & mouse)
- **Não bloquear o jogo:** só os **controles** capturam o toque (`pointer-events`); o resto **deixa passar** para o mapa.
- **Alvos generosos** (dedo): botões grandes, com **ícone + rótulo**.
- **Janelas arrastáveis** pela barra de título e fecháveis no **✕** — podem **ficar abertas sobre o jogo** (o jogo continua rodando).
- **Números de dano em camadas:** um acerto **multi-linha** empilha **um número por linha** (offset + *stagger*) — ver [[DESIGN-037 Linhas de Dano|DESIGN-037]].

## 5. Orientação & Tela
- **Sempre paisagem** no mobile.
- ⚠️ No **app nativo**, a orientação é definida no **`AndroidManifest`** (`screenOrientation`); o **`manifest.webmanifest`** (`orientation`) só vale pra **PWA**.
- O jogo **continua rodando** com a aba/app em **segundo plano** (essencial pra **idle**).

## 6. Relacionados
- Arte: [[CONTEXT-009 Direcao de Arte|CONTEXT-009]] · Acesso rápido: [[DESIGN-018 Menu de Acesso Rapido|DESIGN-018]] · Interactables: [[DESIGN-017 Interactables & Hub|DESIGN-017]].
- Escala (footer/padding): [[CONTEXT-008 Escala Visual|CONTEXT-008]] · Layout de nível: [[DATA-006 Level Layout|DATA-006]] · Estrutura Godot: [[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]].

## 7. Referência visual
- **MapleStory** (HUD inferior): salvar em `99-Inbox/reference/` e embedar aqui. Ver `99-Inbox/reference/UI_REFERENCIA_FOOTER.md`.
