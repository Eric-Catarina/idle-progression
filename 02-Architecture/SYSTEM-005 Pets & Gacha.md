---
id: SYSTEM-005
aliases:
  - SYSTEM-005
title: Pets & Gacha
type: tech-spec
status: Draft
moscow: Must
moscow_note: Herda a prioridade do DESIGN-038 (Must).
implements: "[[DESIGN-038 Pets|DESIGN-038]]"
dependencies:
  - "[[DESIGN-038 Pets|DESIGN-038]]"
  - "[[CONTEXT-013 Moeda Premium|CONTEXT-013]]"
  - "[[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]]"
---

# [SYSTEM-005] Pets & Gacha

## 1. Responsabilidade & Escopo
- Gerencia a **coleção de pets**, o **sorteio (gacha)** dos tiros, os **tokens** (cooldown diário/semanal) e o **saldo/consumo de Gemas**.
- **Headless:** vive em **`sim/`** — sem nós/render; determinístico e testável ([[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]]).
- **Não** decide arte/UI (isso é `ui/`) nem os **números** (esses vivem em [[DATA-015 Pets Odds|DATA-015]]).

## 2. Padrões de Projeto & Algoritmos
- **RNG semeado e determinístico:** o resultado do tiro é **estado**, não sorteado de novo. Semente derivada de `(save_seed, shot_index)` → **reproduzível** (testes, save/load, catch-up).
- **Peso × tier:** sorteio por **pesos inteiros** (soma conhecida) — sem floats acumulados.
- **Event Bus:** emite `pet_obtained` / `pet_doubled` / `shot_blocked` para a UI desacoplar.
- **Transação atômica:** debitar token/gemas **e** creditar pet no **mesmo passo** (nunca meio-caminho).

## 3. Contratos de Dados & Interfaces (GDScript)
```gdscript
# sim/pets/pet_gacha.gd — PURO (sem nós)
class_name PetGacha extends RefCounted

enum ShotKind { COMMON, EPIC }

## Sorteia 1 tier (1..6) por pesos. Determinístico pela seed.
static func roll_tier(kind: ShotKind, rng: RandomNumberGenerator, odds: Dictionary) -> int

## Executa o tiro: valida pagamento, sorteia, aplica. Devolve o resultado.
static func shoot(kind: ShotKind, state: PetState, odds: Dictionary, rng: RandomNumberGenerator) -> Dictionary
# -> { "ok": bool, "reason": String, "tier": int, "pet_id": String, "duplicate": bool }
```

```gdscript
# autoload/GameState.gd — estado autoritativo (account-wide)
var pets_owned: Dictionary = {}      # pet_id -> { "copies": int, "level": int }
var pet_copies: Dictionary = {}      # pet_id -> int (cópias acumuladas)
var gem_fragments: Variant = 0       # fragmentos de Gema (100 = 1 Gema)
var gems: Variant = 0                # BigNumber (CONTEXT-013)
var shot_tokens: Dictionary = { "common": 1, "epic": 1 }
var pet_bonus_aggregate: Dictionary = {}  # stat -> valor somado
```

```gdscript
# autoload/PetClock.gd — reset de período (headless, sem Timer de cena)
func next_reset_utc(kind: ShotKind) -> int   # epoch do próximo reset (diário 00:00 / seg 00:00)
func refresh_tokens(now_epoch: int) -> void  # recarrega tokens se o período virou
```

## 4. Fluxo de Execução no Game Loop
1. **Boot / Catch-up:** `PetClock.refresh_tokens(now)` — se passou do período, recarrega (`common` diário, `epic` semanal). Feito **analiticamente** (não tick a tick).
2. **Acão do jogador:** `shoot(kind)`:
   1. valida token do tipo → senão valida `gems ≥ cost(kind)`;
   2. consome (token ou gemas);
   3. `roll_tier()` + sorteio do pet do tier;
   4. novo → `pets_owned[pet] = ...` + **recalcula** `pet_bonus_aggregate`; duplicado → **+1 cópia** e o jogador escolhe `strengthen(pet)` (nível) ou `shatter(pet)` (`gem_fragments += ...`);
   5. emite o evento do resultado.
3. **Bônus:** `pet_bonus_aggregate` entra no cálculo de stats do jogador (junto de cartas/selos) — **1 vez por frame de simulação**, não por nó.
4. **Persistência:** `pets_owned`, tokens e o **contador de tiros** (`shot_index`, para a seed) são salvos.

## 5. Pontos de Extensão & Escalabilidade (Should Futuro)
- **Fortalecer/Quebrar:** já expostos (`strengthen`/`shatter`) — os **valores** de bônus por pet são conteúdo.
- **Auto-conversão:** `gem_fragments ≥ 100` → `gems += 1` (mantém o saldo premium inteiro na UI).
- **Pet Mart:** lê o roster de `data/`; compra = transação análoga a `shoot`.
- **Pity:** um contador no `PetState` + uma checagem antes do `roll_tier` — **não** implementar agora.
- **Pet Food / tiers de comida:** trocar a tabela de `odds` por um parâmetro `food_tier` — hook.
- **Fontes de Gema in-game:** `CONTEXT-013` §2 (`Could`).
