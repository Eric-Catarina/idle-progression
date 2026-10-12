---
id: DESIGN-XXX
aliases:
  - DESIGN-XXX
title: Nome da Feature
type: system-design
status: Draft | Spec Ready | Implemented | Backlog
moscow: Must | Should | Could | Wont
moscow_note: Justificativa curta da prioridade.
promote_when: "Somente para Could: condição que justifica promoção."
dependencies: []
tech_spec: "[[SYSTEM-XXX]]"
data_spec: "[[DATA-XXX]]"
---

# [DESIGN-XXX] Nome da Feature

## 0. Prioridade MoSCoW
- **Categoria:** Must | Should | Could | Wont
- **Justificativa:** Por que esta categoria e não a vizinha.
- **Critérios de Promoção:** (obrigatório para `Could`) o que precisa estar pronto no core loop.
- Ver [[CONTEXT-001]].

## 1. Visão & Propósito
- O que é a feature em termos funcionais e qual problema de game design ela resolve.

## 2. Contrato Funcional (I/O)
- **Gatilho / Input:** O que dispara a ação (ex: clique na coordenada X/Y, colisão, tick).
- **Pré-requisitos de Estado:** Condições necessárias para execução.
- **Saída / Modificação de Estado:** O que muda no estado global do jogo.

## 3. Lógica Passo a Passo
- Fluxo determinístico do algoritmo em lista enumerada.

## 4. Casos de Borda & Tratamento de Erros
- O que ocorre nos extremos, inputs rápidos simultâneos ou falha de pré-requisitos.

## 5. UI/UX e Feedback
- Animações, feedbacks sonoros, efeitos visuais e apresentação de dados.

## 6. Ganchos para o Futuro (Should/Could)
- Pontos de extensão que esta feature deve deixar prontos para não exigir refatoração depois.
