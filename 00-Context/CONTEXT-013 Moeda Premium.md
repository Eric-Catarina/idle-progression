---
id: CONTEXT-013
aliases:
  - CONTEXT-013
title: Moeda Premium (Gemas)
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-15
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
tags:
  - context
  - convention
  - economia
  - premium
---

# 💎 [CONTEXT-013] Moeda Premium (Gemas)

## 1. Propósito
- Definir **o que é** a moeda premium, **onde** o jogador a obtém e **como** os sistemas a consomem — para **nenhum sistema inventar** sua própria "moeda premium".

## 2. Regra
- **Gemas** (`gems`) é a **única** moeda premium do jogo.
- **Natureza:** comprada com **dinheiro real** (IAP). É o **canal de monetização principal**.
- **Aquisição:** loja de gemas (pacotes IAP). Fontes **in-game** (login, conquistas, eventos) são **`Could`** — não implementar agora; deixar o **gancho**.
- **Consumo:** sistemas **gastam** gemas em trocas explícitas (ex.: comprar tiros de pet — [[DESIGN-038 Pets|DESIGN-038]]). **Nunca** consumir gemas automaticamente.
- **Nunca** é dropável, tradeável, nem ganha por tempo de jogo (parede de monetização honesta).
- **Fragmentos de Gema** (`gemFragments`, **100 = 1 Gema**): é a **fração** da moeda premium — obtida ao **quebrar duplicatas de pet** ([[DESIGN-038 Pets|DESIGN-038]]). Acumula e **auto-converte** em Gemas ao completar 100. **Não** é uma moeda separada: é o troco fracionário das Gemas.

### Moedas do projeto (não confundir)
| Moeda | Escopo | Onde vive |
| :--- | :--- | :--- |
| **Gemas** (`gems`) | **Premium** (IAP) | Este documento |
| **Ouro/Moedas** | Base (drop de mob) | [[DESIGN-029 Potential\|DESIGN-029]], [[DESIGN-033 Multikill\|DESIGN-033]] |
| **Essência** | Recurso de mundo (sinks account-wide) | [[DESIGN-035 Essencia\|DESIGN-035]] |
| **Cristais** | **Interna do Osíris** (reseta no prestígio) | [[DESIGN-014 Osiris\|DESIGN-014]] |

## 3. Casos de Borda
- **Saldo insuficiente** → botão comprar **desabilitado** com o **faltante** exibido (nunca estourar saldo negativo).
- **Compra duplicada** (double-tap) → **idempotência**: debitar **uma** vez; validar saldo no servidor/cliente a cada transação.
- **Reembolso/IAP falho** → **não** creditar gemas; reverter estado.
- **Overflow:** saldo usa **BigNumber** ([[CONTEXT-004 Notacao Numerica|CONTEXT-004]]).

## 4. Relacionado
- Manifesto: [[CONTEXT-000 Manifesto|CONTEXT-000]] · Primeiro consumidor: [[DESIGN-038 Pets|DESIGN-038]].
- Notação numérica: [[CONTEXT-004 Notacao Numerica|CONTEXT-004]] · Arte/ícone: [[CONTEXT-009 Direcao de Arte|CONTEXT-009]].
