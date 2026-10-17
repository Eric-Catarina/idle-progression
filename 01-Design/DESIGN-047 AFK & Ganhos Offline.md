---
id: DESIGN-047
aliases:
  - DESIGN-047
title: AFK & Ganhos Offline
type: system-design
subtype: system
status: Draft
moscow: Must
moscow_note: É o coração do idle — o jogo tem que "jogar por você" enquanto você está fora.
dependencies:
  - "[[CONTEXT-019 Conta & Personagem|CONTEXT-019]]"
  - "[[DESIGN-045 Gate de Avanco (Accuracy & Defense)|DESIGN-045]]"
  - "[[DESIGN-044 Inventario|DESIGN-044]]"
data_spec: "[[DATA-022 AFK|DATA-022]]"
---

# [DESIGN-047] AFK & Ganhos Offline

> **Sem cap. Infinito. Por personagem.** Ao voltar, o jogador vê **exatamente** o que aquele personagem ganhou.
> Decisão do usuário (2026-10-17).

## 0. Prioridade MoSCoW
- **Categoria:** Must
- **Justificativa:** sem ganhos offline não é um idle — é um platformer com números. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
- O jogador **fecha o jogo** e o personagem **continua lutando** no mapa onde estava.
- **Sem teto de tempo** ✅ — voltar depois de uma semana dá **uma semana** de loot (é a fantasia do gênero).
- **Por personagem** ✅ — cada um acumula o seu ([[CONTEXT-019 Conta & Personagem|CONTEXT-019]]).
- **A tela de retorno** é o **momento de recompensa** do idle: tudo que entrou, item por item.

## 2. Contrato Funcional (I/O)
- **Entrada:** `character.lastSeen` (epoch) · o **mapa** e o **DPS** atuais daquele personagem.
- **Saída (por personagem):** `kills` · `xp` (+ **níveis ganhos**) · `gold` · `essence` · **drops** (cartas/selos/gear/fragmentos) · tempo decorrido.
- **Pré-requisitos:** o personagem está **vivo** e parado num mapa com mobs.
- **Estado:** salvo **por ação** + **por tempo** ([[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]] §1.12).

## 3. Lógica Passo a Passo
1. Ao carregar o personagem, `dt = agora − lastSeen` (em segundos).
2. **Calcula a taxa:** `kills/s = DPS_do_personagem ÷ HP_do_mob_do_mapa` (**analítico** — nunca simular tick a tick, [[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]]).
3. `kills = floor(taxa × dt)`; aplica **XP**, **ouro**, **essência** e **rola os drops** com as **mesmas odds** do online.
4. **Aplica os níveis** com a curva de [[DATA-013 XP e Nivel|DATA-013]] — o nível **converge** (o XP exigido cresce `~lvl^2,2`, o do mob é fixo): voltar 100 dias **não** dá nível infinito ✅.
5. Exibe a **tela de retorno** (§5) e **credita a conta** ([[CONTEXT-019 Conta & Personagem|CONTEXT-019]]).

## 4. Casos de Borda & Tratamento de Erros
- **🔴 MORREU offline:** se a **Defense** não aguenta o `attack` do mob, o personagem **morre** — e o offline **para ali**. A tela mostra *"caiu após 42 min"* e diz **o que faltou** (Defense).
  > É por isso que o gate de [[DESIGN-045 Gate de Avanco (Accuracy & Defense)|DESIGN-045]] e o AFK **casam**: sem armadura, **não existe farm offline** ✅
- **Accuracy baixa** offline → a taxa de kills **cai junto** (a `HitChance` multiplica o DPS) ✅
- **Mapa sem mobs** (hub) → offline = **0** (nada a farmar).
- **Relógio do sistema adulterado** (`dt < 0`) → trata como 0 (não dá loot por voltar o relógio).
- **`dt` gigante** (anos) → **BigNumber** e a tela **agrupa** (não lista 50 M de kills).
- **Trocou de mapa antes de sair** → vale o mapa **em que estava**.
- **Personagem novo** (nível 1, sem gear) → offline **zera rápido** (morre) — o esperado.

## 5. UI/UX e Feedback — a **tela de retorno**
- **Um card por personagem** (só os que ganharam algo), com **tempo fora** e o **resumo**:

```text
┌─ Bem-vindo de volta ────────────────────────────────┐
│  LesmaHunter · nível 12 → 19  (1-1)   ·  fora 6 h 12 min │
│  ─────────────────────────────────────────────────────── │
│  💀 1.482 kills          💰 12.430 ouro                 │
│  🟢 1.482 essência       📈 +178.900 XP                 │
│  ────────────────────────────────────────────────────── │
│  🎴 Carta da Lesma ×1     🔖 Selo: Escudo ×1            │
│  🛡️ Short Sword (Raro)    🪨 Pedra de Upgrade ×3        │
└─────────────────────────────────────────────────────────┘
```
- **Nível** destacado; **itens novos** com o brilho de "novo" ([[DESIGN-044 Inventario|DESIGN-044]] §5).
- **"Você caiu"** aparece em **vermelho** com a dica (`Defense 12 → 3` no nível do mob).
- **Um botão**: `Coletar tudo` (sempre habilitado — não há escolha a fazer).

## 6. Ganchos para o Futuro (Should/Could)
- **Múltiplos personagens offline ao mesmo tempo** resolve sozinho: a tela **empilha** os cards ✅ (já previsto).
- **"Auto-avançar de mapa"** offline (passar de nível sozinho) — `Could`, muda muito o balanceamento.
- **Cap opcional configurável** (`Wont` enquanto o balanceamento aguentar — §4 do [[DATA-022 AFK|DATA-022]]).

## 7. Relacionados
- Números: [[DATA-022 AFK|DATA-022]] · Personagens: [[CONTEXT-019 Conta & Personagem|CONTEXT-019]] ([[DESIGN-046 Personagens|DESIGN-046]]).
- Gate: [[DESIGN-045 Gate de Avanco (Accuracy & Defense)|DESIGN-045]] · Curvas: [[DATA-013 XP e Nivel|DATA-013]] · População: [[DATA-014 Populacao Mundo 1|DATA-014]].
