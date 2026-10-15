---
id: DESIGN-038
aliases:
  - DESIGN-038
title: Pets
type: system-design
subtype: system
status: Draft
moscow: Must
moscow_note: Decisão do usuário (2026-10-15) — Pets entram no protótipo: eixo de coleção + monetização, com tiros grátis (diário/semanal).
dependencies:
  - "[[CONTEXT-007 Raridades|CONTEXT-007]]"
  - "[[CONTEXT-013 Moeda Premium|CONTEXT-013]]"
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
tech_spec: "[[SYSTEM-005 Pets & Gacha|SYSTEM-005]]"
data_spec: "[[DATA-015 Pets Odds|DATA-015]]"
---

# [DESIGN-038] Pets

> Mecânica de **coleção account-wide** inspirada no sistema de Pets do **Legends of IdleOn**
> (ver `99-Inbox/reference/IDLEON_PETS_REFERENCE.md`), com as adaptações definidas abaixo.

## 0. Prioridade MoSCoW
- **Categoria:** Must
- **Justificativa:** Decisão do usuário — é o eixo de **coleção + monetização** do jogo e entra no protótipo. Roster inicial (21 pets) em [[DATA-015 Pets Odds|DATA-015]] §8.
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
- **Pets** concedem **bônus passivos permanentes, account-wide e sempre ativos** (como no IdleOn) — obtê-los **melhora todo o progresso**, não só um personagem.
- O jogador os obtém por **tiros** (pulls) que consome **tokens** ou **Gemas** ([[CONTEXT-013 Moeda Premium|CONTEXT-013]]).
- Resolve o **coletar** (fantasia idle) e cria uma **parede de retenção diária/semanal** sem ser pay-to-win barato: os tiros grátis existem, o premium **acelera**.

## 2. Contrato Funcional (I/O)
- **Tokens (grátis):**
  | Token | Ganho | Período |
  | :--- | :--- | :--- |
  | `shot_common` | **1** | **diário** |
  | `shot_epic` | **1** | **semanal** |
  - Não **acumulam**: no máximo **1** de cada (não há estoque de grátis).
- **Gatilho / Input:** usar um token (`Atirar Comum` / `Atirar Épico`) **ou** comprar o tiro com **Gemas** e atirar.
- **Pré-requisitos de estado:** token do tipo disponível **ou** `gems ≥ custo` (ver [[DATA-015 Pets Odds|DATA-015]]).
- **Saída / Modificação de estado:**
  1. Consome o token **ou** debita `gems` (atômico).
  2. Sorteia **1 pet** por raridade ([[CONTEXT-007 Raridades|CONTEXT-007]]) — odds em [[DATA-015 Pets Odds|DATA-015]].
  3. Pet **novo** → entra na **coleção** e seu bônus passa a valer (**imediato**, account-wide).
  4. Pet **repetido** → vira **1 cópia** do pet: o jogador escolhe **Fortalecer** (acumula → sobe o nível, como nas [[DESIGN-016 Cartas|Cartas]]) **ou Quebrar** (→ **fragmentos de Gema**, uma fração da premium).
  5. Emite evento para a UI (popup de resultado / escolha de duplicata).

## 3. Lógica Passo a Passo
1. Jogador aciona **Atirar** (tipo `common` | `epic`).
2. Resolve a **fonte de pagamento**: token do tipo → senão compra com gemas (se saldo).
3. `roll = RNG(tipo)` → devolve o **tier** (1..6) segundo [[DATA-015 Pets Odds|DATA-015]].
4. Dentro do tier, sorteia um **pet** do roster daquele tier (**uniforme**; se vazio → re-sorteia o tier abaixo, ver §4).
5. Se **novo** → adiciona à coleção; se **duplicado** → acumula **1 cópia** e o jogador decide **Fortalecer** (nível do pet) ou **Quebrar** (fragmentos de Gema).
6. Aplica o bônus do pet (se novo) ao agregado account-wide e atualiza a UI.

## 4. Casos de Borda & Tratamento de Erros
- **Token já usado no período** → botão desabilitado com *countdown* até o reset (não consome gemas por engano).
- **Reset de período:** diário às **00:00** e semanal na **segunda 00:00** (fuso do dispositivo — jogo single-player).
- **Saldo insuficiente de gemas** → bloqueia; **nunca** saldo negativo ([[CONTEXT-013 Moeda Premium|CONTEXT-013]] §3).
- **Double-tap** no Atirar → **idempotência** (1 tiro por toque; ignora reentrada).
- **Tier sem pets** (roster incompleto) → **re-sorteia** o tier abaixo; se nenhum tier tiver pet → erro de configuração (não consome token).
- **Salvar/recarregar** no meio do tiro → o **RNG é semeado e o resultado é estado** ([[SYSTEM-005 Pets & Gacha|SYSTEM-005]]); não re-sortear.
- **Números grandes:** `gems`, `gemFragments` e a contagem de cópias usam **BigNumber** ([[CONTEXT-004 Notacao Numerica|CONTEXT-004]]).

## 5. UI/UX e Feedback
- **Janela de Pets** (overlay arrastável — [[CONTEXT-010 UI de Jogo|CONTEXT-010]]): grade da **coleção** (obtidos coloridos, faltantes em silhueta), raridade pela cor/glow de [[CONTEXT-007 Raridades|CONTEXT-007]].
- **Botão Atirar:** mostra o **tipo** (comum/épico), **tokens restantes** e *countdown* do reset.
- **Animação do tiro:** projétil → quebra do cristal → **flash + som pela raridade** (juice — [[CONTEXT-007 Raridades|CONTEXT-007]] §4).
- **Divino:** *bloom* + celebração (o momento "uau").
- **Duplicata:** dois botões — **Fortalecer** (mostra `cópias / limiar` e o bônus novo) e **Quebrar** (`+{fragmentos}` de Gema). Padrão = **Fortalecer**.

## 6. Ganchos para o Futuro (Should/Could)
- **Fortalecimento (cópias):** já implementado no núcleo (nível 1..6, como as cartas) — os **valores** de bônus por pet é que são conteúdo.
- **Pet Mart:** loja que **vende pets** (por Gemas) — `Should`.
- **Pity:** garantia após `N` tiros sem raridade alta — `Should`.
- **Quebra em lote** ("quebrar todas as duplicatas de tier ≤ X") — `Should` (QoL).
- **Pets exclusivos** (evento/bundle) e **Pet Food** (tiers que mudam as odds, como no IdleOn) — `Could`.
- **Fonte in-game de Gemas** (login/conquista) — `Could` ([[CONTEXT-013 Moeda Premium|CONTEXT-013]] §2).
- **Não implementar agora** — só deixar o gancho ([[CONTEXT-001 MoSCoW|CONTEXT-001]] §6).

## 7. Relacionados
- Raridades: [[CONTEXT-007 Raridades|CONTEXT-007]] · Moeda premium: [[CONTEXT-013 Moeda Premium|CONTEXT-013]].
- Técnico: [[SYSTEM-005 Pets & Gacha|SYSTEM-005]] · Odds/dados: [[DATA-015 Pets Odds|DATA-015]].
- Referência (IdleOn): `99-Inbox/reference/IDLEON_PETS_REFERENCE.md`.
