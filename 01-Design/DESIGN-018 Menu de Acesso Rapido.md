---
id: DESIGN-018
aliases:
  - DESIGN-018
title: "Menu de Acesso Rápido (Quick Access)"
type: system-design
subtype: system
status: Draft
moscow: Should
moscow_note: Atalho permanente para os sistemas desbloqueados; melhora muito a UX, mas o core loop valida sem.
dependencies:
  - "[[DESIGN-017 Interactables & Hub|DESIGN-017]]"
  - "[[DESIGN-013 Selos|DESIGN-013]]"
  - "[[DESIGN-014 Osiris|DESIGN-014]]"
  - "[[DESIGN-016 Cartas|DESIGN-016]]"
---

# [DESIGN-018] Menu de Acesso Rápido (Quick Access)

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Evita que o jogador tenha de **andar até o Hub** para abrir um sistema já liberado. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Uma **barra de atalhos sempre visível** com ícones dos **sistemas já desbloqueados**. Clicar (ou usar o hotkey) abre a interface do sistema **de onde o jogador estiver**, sem voltar ao Hub. Espelha o comportamento do Idleon (hotbar de acesso rápido).

## 2. Como Funciona
- Cada **sistema/mecânica** ([[DESIGN-013 Selos|Selos]], [[DESIGN-014 Osiris|Osíris]], [[DESIGN-016 Cartas|Cartas]]) vira uma **entrada** no menu quando `discovered[id]` = true (ver [[DESIGN-017 Interactables & Hub|DESIGN-017]]).
- Clicar na entrada abre a **mesma interface** que o interactable do Hub abriria.
- **Atalho de teclado** opcional por entrada (ex: tecla dedicada).
- Novas mecânicas (outros mundos) entram automaticamente conforme são descobertas.

## 3. Regras
1. Uma entrada fica **oculta** até o sistema ser **descoberto** (mesma flag `discovered` do [[DESIGN-017 Interactables & Hub|DESIGN-017]]).
2. O **Hub** continua sendo o **mundo físico** (onde você descobre e interage); o menu é apenas o **atalho global**.
3. Descoberta em qualquer mundo → a entrada aparece no menu.
4. Escala por mundo: cada novo sistema = uma nova entrada (sem limite fixo).

## 4. Estado / Flags
- `discovered[systemId]: bool` — **compartilhada** com o Hub (fonte única).

## 5. UI / UX
- **Barra inferior** (ou lateral) com **ícones**; tooltip com o nome do sistema.
- **Badge "novo"** quando um sistema é desbloqueado.
- Com muitos sistemas, permitir **scroll** ou **abas por mundo**.

## 6. Contrato Funcional (I/O)
- **Gatilho:** clique no ícone / hotkey.
- **Pré-requisito:** `discovered[systemId]`.
- **Saída:** abre a tela do sistema (pausa a navegação, se aplicável).

## 7. Casos de Borda
- Sistema desbloqueado **offline** → aparece ao carregar.
- Nenhum sistema desbloqueado ainda → menu oculto/vazio.
- Muitos ícones → scroll/abas.

## 8. Ganchos para o Futuro
- **Reordenar** entradas; favoritar; hotkeys custom.
- Agrupar por **mundo** quando houver vários.

## 9. Relacionados
- [[DESIGN-017 Interactables & Hub|DESIGN-017]] · [[DESIGN-013 Selos|DESIGN-013]] · [[DESIGN-014 Osiris|DESIGN-014]] · [[DESIGN-016 Cartas|DESIGN-016]].
