---
id: DESIGN-044
aliases:
  - DESIGN-044
title: Inventario
type: system-design
subtype: system
status: Draft
moscow: Must
moscow_note: Sem inventário não há drops — e drops são o centro do idle. Entra no protótipo.
dependencies:
  - "[[CONTEXT-019 Conta & Personagem|CONTEXT-019]]"
  - "[[DESIGN-028 Equipamentos|DESIGN-028]]"
data_spec: "[[DATA-019 Itens|DATA-019]]"
---

# [DESIGN-044] Inventário

> **Ilimitado** (sem teto de slots) e **stacks infinitos**. **Compartilhado entre personagens** — com **uma** exceção: **equipamento é do personagem** ([[CONTEXT-019 Conta & Personagem|CONTEXT-019]]).

## 0. Prioridade MoSCoW
- **Categoria:** Must
- **Justificativa:** todo drop do jogo passa por aqui. Sem inventário não existe coleta — que é a fantasia do idle.
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
- **Uma** mochila para a **conta**: o que um personagem coleta, **todos** podem usar.
- **Zero fricção**: **sem limite de slots**, **stacks infinitos** — o jogador **nunca** precisa parar de jogar para "limpar a mochila" (é um idle: ficar cheio é punição, não desafio).
- **A única separação** é o **equipamento** → cada personagem tem **o seu** gear (vestido + mochila de gear) ✓.

## 2. Contrato Funcional (I/O)
- **Entrada:** `add(item_id, count)` · `remove(item_id, count)` · `equip(gear_id)` · `unequip(slot)`.
- **Pré-requisitos:** o `item_id` existe no catálogo ([[DATA-019 Itens|DATA-019]]).
- **Saída:**
  - **Conta** → `inventory` (compartilhado) e `wallet` (ouro/essência/gemas).
  - **Personagem** → `equipment` (vestido) e `equipmentBag` (gear não vestido).
- **Regra de roteamento (importante):**
  | Tipo de item | Vai para |
  | :--- | :--- |
  | Recurso, consumível, material, carta, selo, fragmento | **`inventory` da CONTA** |
  | **Gear** (arma/armadura/acessório) | **`equipmentBag` do PERSONAGEM ativo** |
  | Ouro / Essência / Gemas | **`wallet` da CONTA** |

## 3. Lógica Passo a Passo
1. **`add(id, n)`**: se `id` **já existe** no inventário → `count += n` (**stack infinito**); senão cria a entrada com `count = n`.
2. **`remove(id, n)`**: `count -= n`; se `count <= 0` → **remove a entrada**.
3. **`equip(gear)`**: tira da `equipmentBag`, põe em `equipment[slot]`; se já havia algo no slot → volta pra `equipmentBag` (troca).
4. **Contagem sempre por `id`** — nenhum item aparece duas vezes.
5. Eventos: `item_added` · `item_removed` · `item_equipped` (a UI escuta).

## 4. Casos de Borda & Tratamento de Erros
- **Contagem gigante:** `count` usa **BigNumber** ([[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]] §1.9) — um idle estoura `int` com facilidade.
- **Item desconhecido** → **ignorado com aviso** (não crasha, não inventa item).
- **`remove` de algo que não tem** → clamp em 0 (nunca negativo).
- **Gear de outro personagem** → **invisível** para quem não é o dono ([[CONTEXT-019 Conta & Personagem|CONTEXT-019]] §4).
- **Trocar de personagem com a mochila aberta** → a UI recarrega no novo escopo (conta = igual; gear = muda).
- **Nunca duplicar** ao trocar de personagem (o inventário da conta é **um só**).

## 5. UI/UX e Feedback
- **Abas**: `Resources` · `Consumables` · `Cards` · `Stamps` · `Materials` · **`Gear`** (esta é **do personagem**).
- **Stack**: `ícone × N`; **hover/tap** mostra nome + descrição + raridade ([[CONTEXT-007 Raridades|CONTEXT-007]]).
- **Busca + ordenar** (raridade, tipo, quantidade) — com inventário infinito, **achar** é o problema, não caber.
- **Item novo** ganha um brilho de "novo" até ser visto (dopamina de drop).
- **Cabeçalho:** o **ouro/essência/gemas** ficam na carteira (visível no **Footer** — [[CONTEXT-010 UI de Jogo|CONTEXT-010]]).

## 6. Ganchos para o Futuro (Should/Could)
- **Favoritos / travar item** (não vender por engano) — `Should`.
- **"Vender tudo abaixo de X"** e **venda em massa** — `Should`.
- **Storage / baú** (nem precisa: o inventário já é infinito) — `Wont` por ora.
- **Filtro por escopo** (ver o inventário da conta × o gear do personagem lado a lado) — `Could`.

## 7. Relacionados
- Escopo conta/personagem: [[CONTEXT-019 Conta & Personagem|CONTEXT-019]] · Catálogo/schema: [[DATA-019 Itens|DATA-019]].
- Gear: [[DESIGN-028 Equipamentos|DESIGN-028]] · Raridade: [[CONTEXT-007 Raridades|CONTEXT-007]] · UI: [[CONTEXT-010 UI de Jogo|CONTEXT-010]].
