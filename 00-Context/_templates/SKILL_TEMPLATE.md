---
id: DESIGN-XXX
aliases:
  - DESIGN-XXX
title: "Skill: Nome da Skill"
type: system-design
subtype: skill
status: Draft | Spec Ready | Implemented | Backlog
moscow: Must | Should | Could | Wont
moscow_note: Justificativa curta da prioridade.
promote_when: "Somente para Could: condição que justifica promoção."
dependencies: []
tech_spec: "[[SYSTEM-XXX]]"
data_spec: "[[DATA-XXX]]"
---

# [DESIGN-XXX] Skill: Nome da Skill

## 0. Prioridade MoSCoW
- **Categoria:** Must | Should | Could | Wont
- **Justificativa:**
- **Critérios de Promoção:** (obrigatório para `Could`)
- Ver [[CONTEXT-001]].

## 1. Visão & Fantasia
- O que a skill faz e a sensação que deve causar.

## 2. Contrato de Ativação (I/O)
- **Input:** tecla/gesto que ativa.
- **Pré-requisitos:** custo de recurso, cooldown (ms), estado exigido.
- **Saída:** dano/buff aplicado e mudança de estado.

## 3. Regras de Combate
- **Targeting:** único | área | self | projétil.
- **Alcance (px) / Hitbox:** valores exatos.
- **Knockback (px):** impulso horizontal aplicado.
- **Duração/ticks:** janelas em ms.

## 4. Escalonamento
- Como o efeito cresce (nível do personagem, upgrades). Fórmula → [[DATA-XXX]].

## 5. Casos de Borda
- Alvo morto no meio da animação, cooldown + spam de ativação, alvo fora de alcance, overflow de dano (BigNumber).

## 6. UI/UX & VFX
- Ícone, animação, som, número de dano flutuante (formato [[CONTEXT-004]]).

## 7. Ganchos para o Futuro
- Pontos de extensão para variantes/upgrades futuros.
