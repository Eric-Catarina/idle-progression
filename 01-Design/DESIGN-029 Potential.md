---
id: DESIGN-029
aliases:
  - DESIGN-029
title: "Potential (Linhas de Bônus)"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Coração do poder de gear; sem ele o item raro não se diferencia. O core loop valida sem.
dependencies:
  - "[[DESIGN-028 Equipamentos|DESIGN-028]]"
  - "[[CONTEXT-007 Raridades|CONTEXT-007]]"
data_spec: "[[DATA-007 Potentials|DATA-007]]"
---

# [DESIGN-029] Potential (Linhas de Bônus)

> Inspiração: **Potential do MapleStory**. Referência bruta em `99-Inbox/reference/MAPLESTORY_GEAR_REFERENCE.md`.

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** é o **coração do poder de gear** — sem ele, dois itens da mesma raridade são idênticos. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Cada equipamento tem **linhas de Potential** (**1 a 6**, pela raridade do item). Cada linha dá um **bônus** cujo **valor depende da raridade da própria linha**. Rolar de novo (com **Ouro**) é o loop de otimização do endgame.

## 2. Estrutura
- **Nº de linhas = raridade do item** (Comum 1 … Divino 6) — [[DESIGN-028 Equipamentos|DESIGN-028]] §4.
- **Cada linha tem raridade própria** (escala de [[CONTEXT-007 Raridades|CONTEXT-007]]) → **o valor do bônus escala com a raridade da linha**.
- **Limite de roll:** um item de raridade `R` só pode ter linhas de raridade **`≤ R`**. Ex.: item **Épico** → linhas **Comum / Raro / Épico** (nunca Lendário+).

## 3. Valor por raridade da linha
Exemplo canônico (**ATT%**): o valor **cresce com a raridade da linha**:

| Raridade da linha | ATT% |
| :--- | :--- |
| Comum | **3%** |
| Raro | **6%** |
| Épico | **9%** |
| Lendário | **12%** |
| Extraordinário | **15%** |
| Divino | **25%** |

> Os demais stats (Boss Damage%, IED%, Damage%, Crit Dmg%, stat%, HP%…) seguem a **mesma lógica** porém com **suas próprias tabelas** → [[DATA-007 Potentials|DATA-007]].

## 4. Roll (sorteio das linhas)
1. Sorteia-se **1 raridade por linha** (peso decrescente; raridades altas são raras), limitada pela raridade do item.
2. Sorteia-se o **stat** dentro do **pool do tipo** de equipamento ([[DESIGN-028 Equipamentos|DESIGN-028]] §5).
3. Aplica-se o **valor** correspondente à raridade sorteada.
4. Linhas **podem repetir** o mesmo stat (empilha aditivamente dentro do bloco — ver [[DESIGN-031 Calculo de Dano|DESIGN-031]]).

## 5. Reset (reroll)
- **Custo em Ouro**, **crescente por raridade do item** (quanto melhor o item, mais caro).
- Reset **re-sorteia todas as linhas** do item (não dá pra travar linha — a definir no futuro).
- **Tabela de custo** → [[DATA-007 Potentials|DATA-007]].

## 6. Contrato Funcional (I/O)
- **Gatilho:** dropar/forjar item; clicar **Reset**; subir raridade do item.
- **Pré-requisitos:** Ouro suficiente.
- **Saída:** `item.potential[]` atualizado; stats do personagem recalculados; persistido.

## 7. Casos de Borda
- Item **Comum** (1 linha) → reset barato, impacto baixo.
- Linha sorteada com raridade maior que a do item → **impossível** (clamp).
- Reset sem Ouro → bloqueado.
- Subida de raridade do item → **ganha linha nova** (as antigas permanecem).

## 8. UI/UX e Feedback
- Cada linha exibe **cor/borda pela sua raridade** ([[CONTEXT-007 Raridades|CONTEXT-007]]).
- Botão **Reset** com custo visível; animação de "reroll" (dopamina).
- Preview do **Δ de dano** ao trocar uma linha (útil).

## 9. Ganchos para o Futuro
- **Linhas travadas** (lock) / **Cubes** que garantem raridade mínima.
- **Subir a raridade do item** (raro → épico) gastando recursos.
- Comparador de linhas por classe (ex.: WSE Calculator — `99-Inbox/reference`).

## 10. Relacionados
- Equipamentos: [[DESIGN-028 Equipamentos|DESIGN-028]] · Estrelas: [[DESIGN-030 Star Force|DESIGN-030]] · Dano: [[DESIGN-031 Calculo de Dano|DESIGN-031]].
- Valores: [[DATA-007 Potentials|DATA-007]].
