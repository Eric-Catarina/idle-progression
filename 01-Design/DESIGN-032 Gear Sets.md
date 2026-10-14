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
data_spec: "[[DATA-010 Gear Sets|DATA-010]]"
---

# [DESIGN-032] Gear Sets (Conjuntos)

> Camada de **build** sobre os equipamentos ([[DESIGN-028 Equipamentos|DESIGN-028]]): peças trazem um `set` e, ao vestir um nº de peças, ganham-se **bônus acumulativos**.
> **Único gancho de gear em escopo agora** (os outros ficaram fora — [[DESIGN-028 Equipamentos|DESIGN-028]] §9).

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** transforma "vestir o melhor item" em **escolha de build** (bossing vs. leveling vs. farm), dentro dos 8 slots. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Um conjunto é um grupo de peças com um **tema**. Vestir mais peças do mesmo set destrava **faixas de bônus**, incentivando builds focadas. Como os 8 slots são disputados, **sets competem entre si** — não dá para ter tudo.

## 2. Regras
1. Cada item declara `set: <setId>`.
2. Bônus são **acumulativos**: 2 peças → faixa 1; 3 peças → faixa 1 + 2; 4 peças → 1 + 2 + 3.
3. Sets concorrem pelos **mesmos slots**.
4. Bônus de set são **de conjunto** (não consomem linhas de Potential).

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
| **Relíquia de Vorax** | Chefe do Mundo 1 | 7 | bossing (topo do W1) |
| **Recruta** | Level1_1 / Level1_2 | 4 | **leveling/sobrevivência** — 1º a dropar |
| **Ganância** | Level1_3 / Level1_4 (mobs) | 4 | **loot**: dinheiro + drops |
| **Legado do Mundo 1** | Level1_4 / Level1_5 | 4 | **buffs** dos sistemas (Selos/Osíris/Cartas) |

### 4.1 Relíquia de Vorax (Boss Set)
- **Peças (7):** Capacete · Peitoral · Calça · Bota · Arma · Acessório · Badge.
- **3 peças:** +10% **Boss Damage** · +5% **IED**
- **5 peças:** +15% **Damage** · +5% **Crit Damage**
- **7 peças:** +15% **IED** · +10% **Final Damage**

### 4.2 Recruta
> O **primeiro** set a dropar e o **mais comum** (drop rate maior que os outros) — feito para **destravar o avanço** do jogador no Mundo 1.
- **2 peças:** +10% **DEF** · +10% **Max HP** · +5% **HP Regen** · +10% **XP (online)**
- **3 peças:** +10% **DEF** · +10% **Max HP** · +10% **XP (online)**
- **4 peças:** **+1 Multikill** ([[DESIGN-033 Multikill|Multikill]])

### 4.3 Ganância (loot)
- **2 peças:** +10% **Money from Monsters** · +10% **Drop Rate**
- **3 peças:** +15% **Stamp Drop Chance** ([[DESIGN-013 Selos|Selos]]) · +15% **Card Drop Chance** ([[DESIGN-016 Cartas|Cartas]])
- **4 peças:** +15% **Money from Monsters** · +15% **Drop Rate**

### 4.4 Legado do Mundo 1 (buffs dos sistemas)
> Não dá **drops** — **amplifica o efeito** dos sistemas transversais do Mundo 1.
- **2 peças:** +10% **efeito dos Selos** ([[DESIGN-013 Selos|Selos]])
- **3 peças:** +10% **produção do Osíris** (cristais) ([[DESIGN-014 Osiris|Osíris]])
- **4 peças:** +10% **efeito das Cartas** ([[DESIGN-016 Cartas|Cartas]])

> Valores/faixas → [[DATA-010 Gear Sets|DATA-010]]. **Ganância** vs **Legado**: um dá **mais drops**; o outro deixa os sistemas **mais fortes**.

## 5. Contrato Funcional (I/O)
- **Gatilho:** equipar/desequipar peça de set.
- **Saída:** contagem por `setId` → bônus de faixa aplicados ao agregado; stats recalculados ([[DESIGN-031 Calculo de Dano|DESIGN-031]]).

## 6. Casos de Borda
- Trocar peça quebrando o set → bônus **removidos** imediatamente.
- **Duas peças do mesmo set no mesmo slot-type** (não deveria ocorrer).
- Sets de mundos futuros convivem (mais linhas na tabela).

## 7. UI/UX e Feedback
- Painel de **Set** no paper-doll: peças vestidas / bônus ativos / **próxima faixa** ("+1 peça → +Multikill").
- Selo visual quando um set atinge a faixa cheia.

## 8. Ganchos para o Futuro
- Sets **por mundo** (Mundo 2+), sets de **bosses** futuros, sets **sazonais/evento**.
- Bônus de set que **escalam com estrelas** ou com o tier do Potential.

## 9. Relacionados
- Equipamentos: [[DESIGN-028 Equipamentos|DESIGN-028]] · Raridade: [[CONTEXT-007 Raridades|CONTEXT-007]].
- Sistemas do W1: [[DESIGN-013 Selos|DESIGN-013]] · [[DESIGN-014 Osiris|DESIGN-014]] · [[DESIGN-016 Cartas|DESIGN-016]].
- Valores: [[DATA-010 Gear Sets|DATA-010]].
