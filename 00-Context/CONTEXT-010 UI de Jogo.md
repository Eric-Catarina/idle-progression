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
| **Menu** | atalhos dos sistemas (ícones) | **embaixo** |
| **Janelas** | cada sistema (Equipamento, Cartas, Osíris…) | **sobrepostas**, **arrastáveis**, com **✕** |

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
