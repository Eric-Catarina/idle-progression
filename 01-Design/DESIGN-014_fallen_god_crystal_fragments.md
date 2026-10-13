---
id: DESIGN-014
aliases:
  - DESIGN-014
title: "O Deus Caído (Golem dos Fragmentos)"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Mecânica transversal do Mundo 1; progressão permanente com prestígio próprio, mas o core loop valida sem ela.
dependencies:
  - "[[DESIGN-003]]"
  - "[[DESIGN-013]]"
data_spec: "[[DATA-003]]"
---

# [DESIGN-014] O Deus Caído (Golem dos Fragmentos)

> **Mecânica Transversal #2 do [[DESIGN-003]] (Mundo 1).**
> Inspirações: o confronto com **Muto** (Chu-Chu Island, *MapleStory*) e os itens permanentes tipo **"super-penas"** do *Idleon*.

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Progressão permanente com **prestígio próprio**; enriquece muito, mas o core loop valida sem ela (F2).
- Ver [[CONTEXT-001]].

## 1. Visão & Propósito
Um **deus caído** — esquecido, abandonado, destruído. Ao longo do jogo você recupera **Fragmentos de Cristal** e os **devolve a ele**, restaurando seu poder. Quando forte o bastante, ele **enfrenta uma divindade do mal** (seu prestígio); **volta destruído**, mas **traz uma Relíquia Divina** — um item **permanente que resiste ao prestígio**. Existem **5** dessas relíquias.

Isso dá ao Mundo 1 um *companheiro* que cresce e um **meta-loop de reset** que não apaga o progresso permanente.

## 2. Loop Principal
```text
Coletar Fragmentos de Cristal
        │
        ▼
Devolver ao Golem ──► + Poder
        │
        ▼  (Poder >= Limiar)
Confronto Divino (prestígio do Golem)
        │
        ├─ Golem VOLTA DESTRUÍDO (Poder reseta)
        └─ Traz +1 Relíquia Divina (PERMANENTE, resiste ao prestígio)
                 │
                 └─► acelera o próximo ciclo → novo confronto
```

## 3. Contrato Funcional (I/O)
- **Gatilho de Poder:** devolver fragmentos → `golem.power += ...`.
- **Gatilho de Confronto:** `golem.power >= threshold(n)`.
- **Saída do Confronto:** `golem.power` reseta ao valor-base; `relics.add(1)`; bônus permanentes aplicados.

## 4. Poder do Golem
- `power` cresce com os fragmentos devolvidos ([[DATA-003]]).
- O Golem concede **bônus ao jogador** enquanto restaurado (escopo a definir: conta/universal).
- **Núcleo Ancestral** (relíquia) adiciona um **poder-base** a cada ciclo → ciclos mais rápidos.

## 5. Prestígio (Confronto Divino)
- Cada confronto enfrenta uma **divindade do mal** mais forte.
- **Sucesso** → reseta o Poder, mas concede **1 Relíquia Divina**.
- **As Relíquias não resetam** — são a progressão permanente.
- Após as 5 relíquias, o confronto pode escalar infinitamente (Should/Could futuro).

## 6. As 5 Relíquias Divinas (permanentes)
| # | Relíquia | Efeito permanente |
| :--- | :--- | :--- |
| 1 | **Coração de Cristal** | +25% velocidade de coleta de Fragmentos |
| 2 | **Núcleo Ancestral** | Golem inicia cada ciclo com `power`-base |
| 3 | **Olho do Juízo** | +chance de **Fragmento Raro** (vale muito mais) |
| 4 | **Punho Divino** | +Poder de Combate no Confronto |
| 5 | **Alma Eterna** | +ganhos offline do Golem |

> Nomes/efeitos são proposta — ver [[DATA-003]] para os valores.

## 7. Casos de Borda
- Confronto **sem** atingir o limiar (não inicia); **falha** no confronto (a definir: perde parte do poder?).
- Devolver fragmentos com o Golem já no limiar (guardar para o próximo ciclo).
- Overflow de poder (BigNumber).
- Offline: ganho analítico de fragmentos + poder (Catch-up).

## 8. UI/UX e Feedback
- Estatuária do Golem que **se recompõe** visualmente (estágios).
- Cutscene curta do confronto; o Golem volta em pedaços + a relíquia brilhando.

## 9. Ganchos para o Futuro
- **5 divindades do mal** nomeadas (escalando), cada uma um confronto.
- Relíquias podem ter **sub-níveis** após esgotadas (Should/Could).
- Encaixe com os **Selos** ([[DESIGN-013]]): ambos dão progressão permanente no Mundo 1.

## 10. Relacionados
- Mundo: [[DESIGN-003]] · Selos: [[DESIGN-013]] · Curvas: [[DATA-003]].
