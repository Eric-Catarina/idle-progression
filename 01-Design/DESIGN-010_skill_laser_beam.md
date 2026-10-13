---
id: DESIGN-010
aliases:
  - DESIGN-010
title: "Skill: Raio Laser"
type: system-design
subtype: skill
status: Draft
moscow: Should
moscow_note: Skill horizontal de linha; brilha em mapas largos.
dependencies:
  - "[[DESIGN-006]]"
---

# [DESIGN-010] Skill: Raio Laser

## 0. Prioridade MoSCoW
- **Categoria:** Should · **Justificativa:** profundidade de skill (F2). Ver [[CONTEXT-001]].

## 1. Visão & Fantasia
Um **feixe horizontal** atravessa o mapa inteiro, queimando tudo na linha. Símbolo de build horizontal ([[DESIGN-006]]).

## 2. Contrato de Ativação (I/O)
- **Input:** skill na barra / canalizada.
- **Pré-requisitos:** custo + cooldown (ou custo por segundo se canalizada).
- **Saída:** zona de dano horizontal por N ms.

## 3. Regras de Combate
- **Forma:** linha horizontal em `targetY`.
- **Acerto:** dano contínuo (tick) a todos na linha; **piercing**.
- Ideal em **mapas horizontais**.

## 4. Escalonamento
- Dano/tick, duração, largura por nível → [[DATA-XXX]].

## 5. Casos de Borda
- Mapa vertical (linha curta — intencional); alvos acima/abaixo da linha; overflow.

## 6. UI/UX & VFX
- Feixe com "bloom", carregamento e disparo; tremor leve.

## 7. Ganchos para o Futuro
- Variantes: laser que varre (sweep), laser refletido, três raios.
