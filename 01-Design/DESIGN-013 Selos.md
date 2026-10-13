---
id: DESIGN-013
aliases:
  - DESIGN-013
title: "Selos (Stamps)"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Mecânica transversal do Mundo 1; agrega valor permanente, mas o core loop valida sem ela.
dependencies:
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
data_spec: "[[DATA-002 Selos Curvas|DATA-002]]"
---

# [DESIGN-013] Selos (Stamps)

> **Mecânica Transversal #1 do [[DESIGN-003 Mundo 1|DESIGN-003]] (Mundo 1).**
> Referência do jogo de origem (Idleon): `99-Inbox/reference/IDLEON_STAMPS_REFERENCE.md` — **não carregar** salvo quando trabalhando em selos.

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Mecânica transversal que dá progressão permanente, mas o core loop valida sem ela (F2).
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
**Selos** são upgrades passivos **permanentes**, obtidos ao **dropar de mobs**, que concedem bônus de combate e (no futuro) de outras atividades. Criam uma **coleção** que recompensa farmar diferentes mapas/mobs e dão um eixo de progressão que persiste além de um personagem.

## 2. Como Funcionam
- **Drop:** mobs dropam selos; cada selo é único na coleção.
- **Nível:** selos são **upgradeáveis com moedas**; o bônus escala com o nível ([[DATA-002 Selos Curvas|DATA-002]]).
- **Account-wide:** o progresso vale para a **conta**, não por personagem.
- **Persistência:** nível de cada selo salvo no estado global.

## 3. Contrato Funcional (I/O)
- **Gatilho:** morte de um mob → roll de drop.
- **Pré-requisitos:** —
- **Saída:** selo adicionado à coleção **ou** `level++` (se já possui); bônus recalculado.

## 4. Set Básico de Combate (ESTÁVEL — não será trocado)
Apenas os selos cujo papel são **pilares numéricos** e que não mudam. Fórmulas em [[DATA-002 Selos Curvas|DATA-002]].

| Selo | Bônus | Fórmula |
| :--- | :--- | :--- |
| **Sword** | Dano Base | `+1 × nível` |
| **Longsword** | Dano Base | `+2 × nível` |
| **Heart** | HP Base | `+1 × nível` |
| **Mana** | MP Base | `+1 × nível` |
| **Target** | Precisão Base | `+1 × nível` |
| **Shield** | Defesa Base | `+1 × nível` |
| **Kapow** | Dano Crítico % | `+8 × nível / (40 + nível)` |
| **Critical** | **Chance de Crítico %** | `+c × nível / (a + nível)` |
| **Battleaxe** | Dano Total % | `+10 × nível / (40 + nível)` |
| **Armor Pen** | **Penetração de Armadura %** | `+c × nível / (a + nível)` |
| **Sukka Foo** | Dano contra Bosses % | `+20 × nível / (60 + nível)` |
| **Feather** | Velocidade de Movimento % | `+5 × nível / (50 + nível)` |
| **Stat Graph** | Todos os Stats (STR/AGI/WIS/LUK) | `+1 × nível` |

## 5. Aplicação no Cálculo
- Ordem de camadas: **Flat → % → Total** (a ordem exata define o dano; documentar no SYSTEM na implementação).
- Bônus de selos são **aditivos entre si** por camada, salvo indicação.

## 6. Casos de Borda
- **Drop duplicado:** converte em moedas/materiais.
- **Overflow de nível / bônus gigantes:** BigNumber.
- **Upgrades offline (catch-up):** custo acumulado por fórmula analítica, sem simular tick a tick.

## 7. UI/UX e Feedback
- Coleção em **grid** com nível, bônus atual e próximo bônus; toast de "novo selo!" no drop.

## 8. Ganchos para o Futuro
- **Outros selos** (não-combate: profissões, coleta, etc.) e **Bribes** (buffs account-wide comprados): guardados **apenas como referência** e especificados quando trabalharmos esses sistemas.
- Selos por **raridade** — usar a escada de raridades quando definida.

## 9. Relacionados
- Mundo: [[DESIGN-003 Mundo 1|DESIGN-003]] · Curvas: [[DATA-002 Selos Curvas|DATA-002]] · Referência: `99-Inbox/reference/IDLEON_STAMPS_REFERENCE.md`.
