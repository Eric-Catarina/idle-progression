---
id: CONTEXT-019
aliases:
  - CONTEXT-019
title: Conta & Personagem (Escopo)
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-16
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
  - "[[CONTEXT-006 Hierarquia|CONTEXT-006]]"
tags:
  - context
  - convention
  - conta
  - personagem
  - escopo
---

# 👥 [CONTEXT-019] Conta & Personagem (Escopo)

> **Todo sistema declara o seu ESCOPO: `conta` ou `personagem`.** Com **múltiplos personagens**, um sistema que não declara isso vira bug de arquitetura.
> Regra: **progresso e coleção são da CONTA**; o que é "vivo" (nível, equipamento vestido, posição) é do **PERSONAGEM**.

## 1. O modelo
```
account
├── inventory        (COMPARTILHADO — recursos, consumíveis, cartas, materiais…)
├── wallet           (ouro, essência, gemas)
├── collections      (cartas, selos, pets, contratos, cristais do Osíris)
├── world            (níveis destravados, cotas cumpridas)
└── characters[]
    ├── level / xp / class        (progressão própria)
    ├── equipment (equipado)      (só deste personagem)
    ├── equipmentBag              (mochila de gear — só deste personagem)
    └── position / state          (onde está, HP…)
```
- **Regra dura:** nada de "o jogador". O estado é sempre `account → characters[i]` — a simulação ([SYSTEM-003 Kinematics & Motion Primitives|SYSTEM-003] §5) já opera sobre **entidades**, nunca sobre um jogador único.

## 2. Escopo por sistema
| Sistema | Escopo | Por quê |
| :--- | :--- | :--- |
| **Inventário** (recursos/consumíveis/materiais/cartas) | 🟢 **CONTA** | compartilhado (decisão do usuário) |
| **Carteira** (ouro · essência · gemas) | 🟢 **CONTA** | é o que o inventário compartilhado move |
| **Equipamento** (vestido **e** a mochila de gear) | 🔴 **PERSONAGEM** | decisão do usuário — gear é do personagem |
| **Nível / XP / Classe** | 🔴 **PERSONAGEM** | cada um sobe a sua ([DATA-013 XP e Nivel\|DATA-013]) |
| **Cartas** | 🟢 conta (coleção) · 🔴 **equipadas por personagem** | já era assim ([DESIGN-016 Cartas\|DESIGN-016] §) |
| **Selos** | 🟢 **CONTA** | ([DESIGN-013 Selos\|DESIGN-013]) |
| **Pets** | 🟢 **CONTA** | ([DESIGN-038 Pets\|DESIGN-038]) |
| **Livro dos Contratos / Multikill** | 🟢 **CONTA** | ([DESIGN-034 Livro dos Contratos\|DESIGN-034]) |
| **Osíris** (Cristais/Megacristais) | 🟢 **CONTA** | mecânica de mundo ([DESIGN-014 Osiris\|DESIGN-014]) |
| **Gemas** | 🟢 **CONTA** | ([CONTEXT-013 Moeda Premium\|CONTEXT-013]) |
| **Mundo** (níveis destravados, cota cumprida) | 🟢 **CONTA** | destrava **uma vez**; todos os personagens têm acesso |
| **Posição / HP / buffs** | 🔴 **PERSONAGEM** | volátil |

> ⚠️ **Decisão pendente:** ouro. Aqui está como **conta** (casou com o inventário compartilhado). O **IdleOn** usa ouro **por personagem**. Trocar é barato — só precisa ser dito **uma** vez.

## 3. Regras do Roster (criação de personagens)
- **Criar personagem:** escolhe **nome** + **classe** ([[DESIGN-005 Classes|DESIGN-005]]); o nível começa em 1.
- **Slots:** o **primeiro** é grátis; slots extras são desbloqueáveis (`Should`/`Could` — a definir).
- **Troca de personagem:** livre, a qualquer momento (é idle — não perde nada).
- **Offset de entidade:** cada personagem só **simula** quando está **ativo**; os inativos ficam no **catch-up** ([CONTEXT-018 Decisoes de Implementacao|CONTEXT-018] §1.1).
- **Nunca** duplicar item da conta ao trocar de personagem (o inventário é **um só**).

## 4. Casos de Borda
- **Equipar algo já equipado por outro personagem** → impossível (o gear está na **mochila daquele** personagem).
- **Personagem novo** herda a **conta** (inventário/destravamentos) e **nada** de personagem — começa do zero, de propósito.
- **Dois personagens no mesmo mapa ao mesmo tempo:** **não** é escopo ([DESIGN-001 Multi Personagens\|DESIGN-001] é `Could`, party separada).
- **Morte** ([[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]] §1.6) → respawn no hub, **só aquele** personagem.

## 5. Relacionado
- Inventário: [[DESIGN-044 Inventario|DESIGN-044]] · Itens: [[DATA-019 Itens|DATA-019]].
- Party (outra feature): [[DESIGN-001 Multi Personagens|DESIGN-001]] · Decisões: [[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]].
