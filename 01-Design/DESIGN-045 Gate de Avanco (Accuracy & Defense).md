---
id: DESIGN-045
aliases:
  - DESIGN-045
title: "Gate de Avanço (Accuracy & Defense)"
type: system-design
subtype: mechanic
status: Draft
moscow: Must
moscow_note: É o ÚNICO softlock de progressão (sem poções/comida) — sem isto os níveis não têm parede.
dependencies:
  - "[[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]]"
  - "[[DESIGN-028 Equipamentos|DESIGN-028]]"
  - "[[DESIGN-031 Calculo de Dano|DESIGN-031]]"
data_spec: "[[DATA-020 Accuracy & Defense|DATA-020]]"
---

# [DESIGN-045] Gate de Avanço (Accuracy & Defense)

> **Decisão (2026-10-17):** **não há poções nem comida.** O avanço é travado por **duas** coisas, e só elas:
> **Accuracy** (você **acerta**?) e **Defense** (você **sobrevive**?). IdleOn puro.

## 0. Prioridade MoSCoW
- **Categoria:** Must
- **Justificativa:** sem poção o jogador **não** morre por gestão de recurso — ele morre por **não conseguir acertar** ou **levar dano demais**. Esse **é** o softlock. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
- **Sem itens de cura.** O jogador é **auto-suficiente**: quem manda é o **gear + nível**.
- **Duas paredes, dois remédios:**
  | Parede | Sintoma | Remédio |
  | :--- | :--- | :--- |
  | **Accuracy baixa** | você **erra** muito → a cota **não acaba nunca** | subir **estatística secundária** / **gear de Accuracy** |
  | **Defense baixa** | o mob **te mata** → respawn no hub | **armadura** / **nível** |
- **Efeito no design:** a progressão fica **leitura + farm**, não **sustain**. É o que faz um idle **idle** (você não fica clicando poção).

## 2. Contrato Funcional (I/O)
- **Entrada:** `player.accuracy` (stat secundário + gear) · `player.defense` (armadura + nível) · `mob.accRequired` · `mob.attack`.
- **Saída:**
  - **Chance de acerto** por golpe (fórmula do IdleOn — [[DATA-020 Accuracy & Defense|DATA-020]] §2).
  - **Dano recebido** por contato (fórmula do IdleOn — [[DATA-020 Accuracy & Defense|DATA-020]] §3).
- **Estado:** nada persistente — é derivado.

## 3. Lógica Passo a Passo
1. **No golpe:** rola a **chance de acerto** (`HitChance`); se **errar**, o golpe **não** aplica dano (mas **gasta** o cooldown — errar custa tempo).
2. **No contato do mob:** calcula o **dano recebido**; aplica (respeitando o **i-frame de 1 s** — [[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]] §1.3).
3. **Se o HP chega a 0** → **respawn no hub** ([[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]] §1.6), sem perder progresso.
4. **A parede é intencional:** entrar num nível **sub-nivelado** dá **hit chance baixíssima** (< 50%) e **dano alto** — o jogador **volta** e farma.
5. O `accReq` de cada mob é igualado à **estatística secundária esperada no FIM** daquele nível ([[DATA-020 Accuracy & Defense|DATA-020]] §4) → quem está **no nível certo** acerta ~100%; quem está atrás, sofre.

## 4. Casos de Borda & Tratamento de Erros
- **Hit chance < 5%** → **conta como 0** (não existe "acerto impossível") — regra do IdleOn.
- **`Defense > mob.attack`** → **dano ZERO** (imune) — regra do IdleOn.
- **Dano sempre ≥ 1** quando não é imune? **Não:** fica o valor da fórmula (pode ser 0 por arredondamento) — [[DATA-020 Accuracy & Defense|DATA-020]] §3.
- **Específico de skill:** a **accuracy** vale por **alvo**; skills `target:aoe` rolam **por alvo** atingido (não um roll único).
- **Chefe:** usa as **mesmas** fórmulas; a `accReq` dele é a **maior** do mundo (a parede final).
- **`Could` futuro:** *double hit* (IdleOn) e *crit* **não** interagem com accuracy (o crit só decide o multiplicador **quando acerta**).

## 5. UI/UX e Feedback
- **Chance de acerto** aparece no **tooltip do nível/mob** (`Hit: 87%`) — o jogador **vê** a parede.
- **Erro** mostra um texto curto **`MISS`** (não um número) — contraste imediato com o acerto.
- **Barra de HP** já existe no Footer ([[CONTEXT-010 UI de Jogo|CONTEXT-010]]); a **Defense** aparece na ficha ([[DESIGN-028 Equipamentos|DESIGN-028]]).
- **Cor por faixa de hit:** ≥95% verde · 50–94% amarelo · <50% vermelho (o "você não deveria estar aqui").

## 6. Ganchos para o Futuro (Should/Could)
- **`Boss Damage%`** já existe e **não** substitui accuracy ([[DESIGN-031 Calculo de Dano|DESIGN-031]]).
- **Requisito de nível de entrada** por portal (`Should`) — uma segunda barreira, mais explícita.
- **Poções/comida** ficam **`Wont`** nesta fase (foram removidas de propósito).

## 7. Relacionados
- Números: [[DATA-020 Accuracy & Defense|DATA-020]] · Dano: [[DESIGN-031 Calculo de Dano|DESIGN-031]] · Gear: [[DESIGN-028 Equipamentos|DESIGN-028]].
- Decisões: [[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]] · População: [[DATA-014 Populacao Mundo 1|DATA-014]].
