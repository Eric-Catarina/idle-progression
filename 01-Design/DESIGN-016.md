---
id: DESIGN-016
aliases:
  - DESIGN-016
title: "Cartas & Pacotinhos"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Mecânica transversal #3 do Mundo 1; coleção com raridades, mas o core loop valida sem ela.
dependencies:
  - "[[DESIGN-003]]"
  - "[[DESIGN-013]]"
  - "[[CONTEXT-007]]"
data_spec: "[[DATA-005]]"
---

# [DESIGN-016] Cartas & Pacotinhos

> **Mecânica Transversal #3 do [[DESIGN-003]] (Mundo 1).**
> Inspiração: *Monster Collection* (MapleStory) + pacotes de cartas com raridade (gacha).

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Eixo de coleção/dopamina que dá motivo para farmar mapas, mas o core loop valida sem ela (F2).
- Ver [[CONTEXT-001]].

## 1. Visão & Propósito
Uma **coleção de cartas** com **raridades**. Você obtém cartas ao **derrotar mobs** e ao abrir **pacotinhos**. Cada carta dá um bônus passivo; **completar conjuntos (sets)** dá bônus maiores. É o eixo "gacha/coleção" dopaminérgico que **conversa com mapas, mobs e drops**.

## 2. Como Funcionam
- **Cartas:** cada carta é única na coleção e pertence a um **mob/mapa** e a uma **raridade**.
- **Obtenção:** drop de mobs (chance por mob/mapa) **ou** abertura de **pacotinhos**.
- **Coleção & Sets:** completar um conjunto (por mob, tema ou mundo) concede bônus.
- **Duplicatas:** viram **poeira de carta** (moeda para forjar cartas específicas).

## 3. Contrato Funcional (I/O)
- **Gatilho:** morte de mob (roll de drop) / abrir pacote.
- **Pré-requisitos:** —
- **Saída:** carta adicionada (ou poeira); bônus de carta/set recalculados; persistido.

## 4. Raridades
Escala compartilhada de [[CONTEXT-007]]: **Comum → Raro → Épico → Lendário → Extraordinário → Divino** (cores fixas). Pesos/odds das cartas em [[DATA-005]].

## 5. Pacotinhos
- **Tipos:** Comum, Premium, de **Mundo** (temático) e **Cósmico** (endgame) — odds em [[DATA-005]].
- Cada pacote concede `N` cartas com pesos por raridade; premium/cósmico aumentam as raridades altas.
- **Diário:** 1 pacote grátis por dia (odds de Premium).
- **Pity:** a cada **30 pacotes** sem **Lendário+**, o próximo garante um.
- **Fonte:** moedas do jogo, recompensas de nível/mundo e dailies.

## 6. Sets & Bônus
| Set | Requisito | Bônus (ex.) |
| :--- | :--- | :--- |
| Cartas do Mundo 1 | coletar X cartas | +% drop rate no Mundo 1 |
| Set de Mobbing | cartas de mobs | +% dano em área |
| Set de Boss | cartas de chefes | +% dano vs bosses |

Cada **carta individual** dá um bônus pequeno; o **set completo** dá um bônus forte.

## 7. Casos de Borda
- Pacote sem cartas novas → converte em poeira.
- Duplicata de raridade alta → poeira proporcional.
- Overflow de bônus (BigNumber).

## 8. UI/UX e Feedback
- **Álbum** de cartas com cor por raridade; brilho na rara; **animação de abertura** de pacote (dopamina).
- Contador de coleção e sets em progresso.

## 9. Ganchos para o Futuro
- Cartas por mundo; **fusão** de duplicatas; cartas-assinatura.
- Amarração com **Selos** ([[DESIGN-013]]) e **Osíris** ([[DESIGN-014]]): três eixos permanentes no Mundo 1.

## 10. Relacionados
- Mundo: [[DESIGN-003]] · Selos: [[DESIGN-013]] · Curvas: [[DATA-005]].
