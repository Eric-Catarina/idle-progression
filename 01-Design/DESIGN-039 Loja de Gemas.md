---
id: DESIGN-039
aliases:
  - DESIGN-039
title: Loja de Gemas
type: system-design
subtype: system
status: Draft
moscow: Should
moscow_note: A moeda premium e seu consumo já existem ([[CONTEXT-013 Moeda Premium|CONTEXT-013]]); a loja IAP é o que monetiza, mas o protótipo valida com Gemas semeadas em debug.
dependencies:
  - "[[CONTEXT-013 Moeda Premium|CONTEXT-013]]"
  - "[[DESIGN-038 Pets|DESIGN-038]]"
data_spec: "[[DATA-016 Loja de Gemas|DATA-016]]"
---

# [DESIGN-039] Loja de Gemas

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** O **conceito** (Gemas) e o **consumo** (tiros de pet) são `Must`; a **loja IAP** em si é um canal de monetização que não valida o core loop. No protótipo, Gemas entram por **debug**; a loja vem depois, com o **gancho** pronto.
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
- Ser o **único** lugar onde o jogador compra **Gemas** com **dinheiro real** ([[CONTEXT-013 Moeda Premium|CONTEXT-013]]).
- Simples e honesto: **sem loot box de dinheiro**, sem "moeda que expira" — você compra Gemas e escolhe onde gastar.
- Pacotes e volumes: [[DATA-016 Loja de Gemas|DATA-016]].

## 2. Contrato Funcional (I/O)
- **Gatilho:** abrir a Loja (pelo **Footer**) e tocar um **pacote**.
- **Pré-requisitos:** conexão com a **loja da plataforma** disponível; produto **carregado**.
- **Saída / Modificação de estado:**
  1. A plataforma processa o pagamento.
  2. **Sucesso** → `gems += gems(pack)` (idempotente por **transação**) e emite evento para a UI.
  3. **Falha/cancelamento** → **nada** muda no saldo ([[CONTEXT-013 Moeda Premium|CONTEXT-013]] §3).

## 3. Lógica Passo a Passo
1. Carrega os **produtos** da loja (ids de [[DATA-016 Loja de Gemas|DATA-016]] §4) e seus **preços locais**.
2. Exibe os pacotes com **Gemas** + **preço local** (a loja dá o preço formatado).
3. Jogador toca → envia a compra à plataforma.
4. **Callback de sucesso** com o **id da transação**: credita as Gemas **uma única vez** (guardar o id processado).
5. Restaura itens já comprados (**restore**) no boot/login, sem creditar de novo.

## 4. Casos de Borda & Tratamento de Erros
- **Cancelou** → nenhum crédito, nenhum estado alterado.
- **Double-tap** → trava o botão durante a transação.
- **Callback duplicado** (retry da loja) → **idempotência por `transaction_id`** (creditar 1×).
- **Reembolso** → política: **não** creditar novamente; tratar `gems` negativos apenas se o saldo permitir (BigNumber).
- **Sem rede / produto indisponível** → botão desabilitado com aviso ("loja indisponível"). Nunca trava o jogo.
- **Overflow** → `gems` é **BigNumber** ([[CONTEXT-004 Notacao Numerica|CONTEXT-004]]).

## 5. UI/UX e Feedback
- Acesso pelo **Footer** (ícone 💎) — [[CONTEXT-010 UI de Jogo|CONTEXT-010]].
- Cada pacote: **Gemas + bônus** em destaque e **preço local**; o maior leva selo de **melhor valor** (Gemas/USD — [[DATA-016 Loja de Gemas|DATA-016]] §2).
- Compra concluída → **flash + som** e o saldo **anima** subindo.

## 6. Ganchos para o Futuro (Should/Could)
- **Primeira compra** (bônus único) e **passe/assinatura** — `Could`.
- **Fonte in-game de Gemas** (login, conquista, evento) — `Could` ([[CONTEXT-013 Moeda Premium|CONTEXT-013]] §2).
- **Loja de Pets** ("compre X Gemas, leve Y tiros") — `Could`.
- **Não implementar agora** — só o gancho ([[CONTEXT-001 MoSCoW|CONTEXT-001]] §6).

## 7. Relacionados
- Convenção: [[CONTEXT-013 Moeda Premium|CONTEXT-013]] · Números: [[DATA-016 Loja de Gemas|DATA-016]].
- Consumidor principal: [[DESIGN-038 Pets|DESIGN-038]] · UI: [[CONTEXT-010 UI de Jogo|CONTEXT-010]].
