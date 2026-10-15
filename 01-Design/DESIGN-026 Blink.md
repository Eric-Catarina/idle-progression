---
id: DESIGN-026
aliases:
  - DESIGN-026
title: "Mechanic: Blink"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Habilidade de movimento do Mago; o core loop valida sem ela.
dependencies:
  - "[[DESIGN-005 Classes|DESIGN-005]]"
  - "[[DESIGN-025 Navegacao & Movimento|DESIGN-025]]"
skill_tags:
  - delivery:instant
  - target:self
  - role:mobility
  - archetype:all
---

# [DESIGN-026] Mechanic: Blink

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** mobilidade do Mago; enriquece a build, mas o core loop valida sem. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
**Teleporte curto** (reposicionamento instantâneo) — a **habilidade de movimento do Mago** ([[DESIGN-005 Classes|DESIGN-005]]), desbloqueada ao virar Mago (nível 10) e mantida pelas sub-especializações. Na navegação, é a **aresta instantânea** do grafo: ignora a distância/tempo do caminho no ar.

## 2. Definição Formal
- Reposiciona o personagem **instantaneamente** até `blinkRange` px na direção do movimento (ou na direção do alvo clicado), com `blinkCooldown`.
- Não consome tempo de trajeto para o planejador (custo ≈ cooldown).
- **Atravessa paredes/sólidos?** _(a definir)_ — se sim, permite rotas impossíveis às outras classes.

## 3. Interações
- Navegação ([[DESIGN-025 Navegacao & Movimento|DESIGN-025]]): aresta `blink`, com pré-condição = habilidade desbloqueada + alcance atual.
- Combate: pode conceder *i-frames* breves (a definir).
- Pode/quando usar no ar vs. no chão (a definir).

## 4. Parâmetros
- `blinkRange`, `blinkCooldown`, `blinkIFrames`, escala por nível da habilidade → [[DATA-XXX]].

## 5. Casos de Borda
- Blink para **dentro de parede / fora do mapa** (clamp ou cancelar).
- Blink **através de teto/piso**.
- Blink perto da borda da tela; spam; blink offline (catch-up ignora).

## 6. UI/UX e Feedback
- Flash/partículas no ponto de origem e destino; som curto.

## 7. Ganchos para o Futuro
- Blink **longo** (Mago Bosser), blink **em cadeia**, blink **ofensivo** (teleporte + dano).
