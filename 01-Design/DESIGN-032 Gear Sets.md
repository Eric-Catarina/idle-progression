---
id: DESIGN-032
aliases:
  - DESIGN-032
title: "Gear Sets (Conjuntos)"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Único gancho de gear promovido ao escopo atual. Camada de build sobre os equipamentos.
dependencies:
  - "[[DESIGN-028 Equipamentos|DESIGN-028]]"
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
  - "[[DESIGN-006 Meta Espacial|DESIGN-006]]"
data_spec: "[[DATA-010 Gear Sets|DATA-010]]"
---

# [DESIGN-032] Gear Sets (Conjuntos)

> Camada de **build** sobre os equipamentos ([[DESIGN-028 Equipamentos|DESIGN-028]]): peças trazem um `set` e, ao vestir um nº de peças, ganham-se **bônus acumulativos**.
> **Único gancho de gear em escopo agora** (os outros ficaram fora — [[DESIGN-028 Equipamentos|DESIGN-028]] §9).

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** transforma "vestir o melhor item" em **escolha de build** (bossing vs. mobbing vs. economia), dentro dos 8 slots. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Um conjunto é um grupo de peças com um **tema** (níveis, sistemas do Mundo 1, ou **forma do mapa** — [[DESIGN-006 Meta Espacial|DESIGN-006]]). Vestir mais peças do mesmo set destrava **faixas de bônus**, incentivando builds focadas. Como os 8 slots são disputados, **sets competem entre si** — não dá para ter tudo.

## 2. Regras
1. Cada item declara `set: <setId>`.
2. Bônus são **acumulativos**: 2 peças → faixa 1; 3 peças → faixa 1 + 2; 4 peças → 1 + 2 + 3.
3. Sets concorrem pelos **mesmos slots** → vetar 2 sets grandes (ex.: dois sets de 4 peças não cabem nos 4 slots de armadura).
4. Bônus de set são **de conjunto** (não consomem linhas de Potential).
5. Bônus podem ser **condicionais** (ex.: "+% dano em mapas verticais") — mudam por mapa.

## 3. Estrutura de Faixas
| Peças equipadas | Bônus |
| :--- | :--- |
| 2 | faixa 1 |
| 3 | + faixa 2 |
| 4 | + faixa 3 |
| ℹ️ Boss set | 3 / 5 / 7 peças |

## 4. Sets do Mundo 1

| Set | Fonte | Peças | Tema |
| :--- | :--- | :--- | :--- |
| **Relíquia de Vorax** | Chefe do Mundo 1 | 7 | top do W1 (bossing) |
| **Recruta** | Level1_1 / Level1_2 | 4 | leveling / sobrevivência |
| **Selador** | Level1_2 (selos) | 4 | farm de **Selos** |
| **Minerador** | Level1_3 (Osíris) | 4 | economia / **cristais** |
| **Colecionador** | Level1_4 (cartas) | 4 | farm de **Cartas** |
| **Caçador** | mobs gerais | 4 | **mobbing** |
| **Alpinista** | Level1_4 | 4 | **mapas verticais** |
| **Corredor** | Level1_5 | 4 | **mapas horizontais** |

### 4.1 Relíquia de Vorax (Boss Set)
- **Peças (7):** Capacete · Peitoral · Calça · Bota · Arma · Acessório · Badge.
- **3 peças:** +10% **Boss Damage** · +5% **IED**
- **5 peças:** +15% **Damage** · +5% **Crit Damage**
- **7 peças:** +15% **IED** · +10% **Final Damage**

### 4.2 Recruta
- **2 peças:** +10% **HP** · **3 peças:** +10% **EXP from Monsters** · **4 peças:** +15% **DEF**, +10% **HP**

### 4.3 Selador
- **2 peças:** +10% **Drop Rate** · **3 peças:** +15% **Stamp Drop Chance** ([[DESIGN-013 Selos|Selos]]) · **4 peças:** +10% **EXP**, +10% **Drop Rate**

### 4.4 Minerador
- **2 peças:** +10% **Money from Monsters** · **3 peças:** +10% **Crystal gain** ([[DESIGN-014 Osiris|Osíris]]) · **4 peças:** +15% **Drop Rate**, +10% **Money**

### 4.5 Colecionador
- **2 peças:** +10% **Card Drop Chance** ([[DESIGN-016 Cartas|Cartas]]) · **3 peças:** +10% **Drop Rate** · **4 peças:** +15% **Card Drop Chance**, +5% **Crit Chance**

### 4.6 Caçador (mobbing)
- **2 peças:** +10% **Damage vs Monsters** · **3 peças:** +10% **Crit Chance** · **4 peças:** +15% **Damage vs Monsters**, +10% **Crit Damage**

### 4.7 Alpinista (mapas **verticais**)
- **2 peças:** +10% **Damage em mapas verticais** · **3 peças:** +10% **Damage vs Monsters** · **4 peças:** +15% **Damage em mapas verticais**, +5% **Crit Chance**

### 4.8 Corredor (mapas **horizontais**)
- **2 peças:** +10% **Damage em mapas horizontais** · **3 peças:** +10% **EXP** · **4 peças:** +15% **Damage em mapas horizontais**, +5% **Crit Chance**

> Valores/faixas → [[DATA-010 Gear Sets|DATA-010]]. Os sets **Alpinista/Corredor** casam com o meta espacial ([[DESIGN-006 Meta Espacial|DESIGN-006]]): builds diferentes brilham em mapas diferentes.

## 5. Contrato Funcional (I/O)
- **Gatilho:** equipar/desequipar peça de set.
- **Saída:** contagem por `setId` → bônus de faixa aplicados ao agregado; stats recalculados ([[DESIGN-031 Calculo de Dano|DESIGN-031]]).

## 6. Casos de Borda
- **Duas peças do mesmo set no mesmo slot-type** (não deveria ocorrer).
- Bônus **condicional** fora do contexto (ex.: "+% em vertical" num mapa horizontal) → **inativo**.
- Trocar peça quebrando o set → bônus **removidos** imediatamente.
- Sets de mundos futuros convivem (mais linhas na tabela).

## 7. UI/UX e Feedback
- Painel de **Set** no paper-doll: peças vestidas / bônus ativos / **próxima faixa** ("+1 peça → +15% Damage").
- Selo visual quando um set atinge a faixa cheia.

## 8. Ganchos para o Futuro
- Sets **por mundo** (Mundo 2+), sets de **bosses** futuros, sets **sazonais/evento**.
- Bônus de set que **escalam com estrelas** ou com o tier do Potential.

## 9. Relacionados
- Equipamentos: [[DESIGN-028 Equipamentos|DESIGN-028]] · Raridade: [[CONTEXT-007 Raridades|CONTEXT-007]].
- Sistemas do W1: [[DESIGN-013 Selos|DESIGN-013]] · [[DESIGN-014 Osiris|DESIGN-014]] · [[DESIGN-016 Cartas|DESIGN-016]].
- Meta espacial: [[DESIGN-006 Meta Espacial|DESIGN-006]] · Valores: [[DATA-010 Gear Sets|DATA-010]].
