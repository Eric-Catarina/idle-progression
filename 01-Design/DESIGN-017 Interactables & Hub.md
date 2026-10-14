---
id: DESIGN-017
aliases:
  - DESIGN-017
title: "Interactables & Hub (Descoberta/Desbloqueio)"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Liga exploração a progressão (descobrir → desbloquear no Hub); enricha muito, mas o core loop valida sem.
dependencies:
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
  - "[[DESIGN-013 Selos|DESIGN-013]]"
  - "[[DESIGN-014 Osiris|DESIGN-014]]"
  - "[[DESIGN-016 Cartas|DESIGN-016]]"
---

# [DESIGN-017] Interactables & Hub

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** A "costura" que faz o jogador explorar para desbloquear os sistemas no Hub (estilo Idleon). Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Os **sistemas permanentes** do Mundo 1 ([[DESIGN-013 Selos|Selos]], [[DESIGN-014 Osiris|Osíris]], [[DESIGN-016 Cartas|Cartas]]) são acessados via **interactables** (NPCs/estações). O **Hub = Nível 1-1** é onde eles ficam disponíveis. Explorar os **níveis seguintes** e interagir pela 1ª vez **descobre** um interactable, que então **aparece no Hub**.

> Modelo: *Idleon* — você encontra o sistema no mapa e ele fica disponível na sua base.

## 2. Conceitos
- **Interactable:** ponto no mapa com `id`, `sistema` e posição `(x,y)`. Ao interagir, abre a interface do sistema.
- **Descoberta:** `discovered[id] = true` na **primeira interação** (persistente, account-wide).
- **Hub (1-1):** exibe os interactables **descobertos** (ou já disponíveis desde o início).

## 3. Regras
1. Cada interactable tem um `id` único (ex: `selos`, `osiris`, `cartas`).
2. Interagir pela **1ª vez** em qualquer nível → marca `discovered[id]`.
3. O **Hub** mostra um interactable se `discovered[id]` (ou se é desbloqueado desde o início).
4. Sistemas "de base" (ex: Selos/Altar) já vêm desbloqueados no Hub; sistemas "de campo" (Osíris, Cartas) começam **ocultos** e são **descobertos** explorando.
5. Interactables **podem repetir** em vários níveis (atalhos); descobrir uma vez basta.

## 4. Tabela de Interactables (Mundo 1)
| id | Sistema | Aparece em | Desbloqueia no Hub |
| :--- | :--- | :--- | :--- |
| `selos` | [[DESIGN-013 Selos|DESIGN-013]] | Hub (1-1) | já disponível |
| `osiris` | [[DESIGN-014 Osiris|DESIGN-014]] | 1-2 | sim (após 1ª interação) |
| `cartas` | [[DESIGN-016 Cartas|DESIGN-016]] | 1-3 | sim (após 1ª interação) |

## 5. Estado / Flags
- `discovered[interactableId]: bool` — persistente.
- O Hub resolve seus **slots** contra `discovered` ao carregar.

## 6. Como fazer no Editor de Level
1. Selecione a ferramenta **🔗 Interact.** e escolha o interactável no **dropdown** (lista editável — escala para N interactables por mundo, sem tile fixo por tipo).
2. Pinte no mapa → o editor grava uma **entidade** `{x, y, slot}` (camada separada da grade) e a exporta no JSON em `interactables`.
3. O **comportamento** (sistema, condição de desbloqueio, diálogo) vive **aqui (DESIGN)** e no `DATA` — a entidade só dá **posição + qual**.
4. No Hub (1-1), deixe os **slots** dos interactables de campo presentes (ocultos até serem descobertos).

## 7. Casos de Borda
- Interagir 2× (não re-descobre; só abre).
- Interactable descoberto mas Hub não carregado (reaparece no próximo load).
- Save/offline: `discovered` persiste independente do nível.

## 8. Ganchos para o Futuro
- Outros mundos adicionam interactables (mais linhas na tabela).
- Interactables com **requisito** (nível/moeda) antes de abrir.

## 9. Relacionados
- [[DESIGN-003 Mundo 1|DESIGN-003]] (Hub) · [[DESIGN-013 Selos|DESIGN-013]] · [[DESIGN-014 Osiris|DESIGN-014]] · [[DESIGN-016 Cartas|DESIGN-016]].
