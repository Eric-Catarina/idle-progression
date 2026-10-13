---
id: DESIGN-006
aliases:
  - DESIGN-006
title: "Map Spatial Layout & Combat Meta"
type: system-design
subtype: mechanic
status: Spec Ready
moscow: Should
moscow_note: Mecânica fundamental de design, mas o core loop valida num único mapa; vira Must se layouts variados entrarem no MVP.
dependencies:
  - "[[CONTEXT-006 Hierarquia|CONTEXT-006]]"
data_spec: "[[DATA-001 Mapas e Rates|DATA-001]]"
---

# [DESIGN-006] Map Spatial Layout & Combat Meta

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** O core loop valida num único mapa; o meta espacial é profundidade de build (F2). Pode ser promovido a Must se o MVP exigir mapas verticais e horizontais distintos.
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
A **forma e o tamanho** do mapa definem quais builds são fortes. O objetivo é que **layout seja uma decisão de build**, não só cenário: o mesmo personagem rende diferente em mapas verticais, horizontais ou quadrados.

## 2. Taxonomia de Formatos

| Formato | Aspecto | Favorece | Prejudica |
| :--- | :--- | :--- | :--- |
| **Vertical / alto** | h ≫ w | Skills verticais (queda/física/alcance em Y): [[DESIGN-007 Meteoro|DESIGN-007]], [[DESIGN-009 Perfuracao Vertical|DESIGN-009]] | Skills horizontais |
| **Horizontal / largo** | w ≫ h | Feixes em X ([[DESIGN-010 Raio Laser|DESIGN-010]]), summons corredores ([[DESIGN-011 Summon Corredor|DESIGN-011]]), alta mobilidade ([[DESIGN-012 Jump Dash|DESIGN-012]]) | Skills verticais |
| **Quadrado** | ≈ 1:1, área grande | Qualquer build (neutro) | — |
| **Compacto / apertado** | área pequena | Farm genérico fácil | Recebe **menos** mobrate/droprate |

## 3. Regras
- Mapa vertical favorece skills que **percorrem o eixo Y** e skills **baseadas em física** (queda).
- Mapa horizontal favorece skills no **eixo X** e **alta mobilidade** (jump dash).
- Mapas **compactos/quadrados** são trivialmente farmáveis → **mobrate/droprate reduzidos** ([[DATA-001 Mapas e Rates|DATA-001]]).

## 4. Contrato Funcional (I/O)
- Cada mapa declara `shape` (`vertical | horizontal | square | compact`) e `area`.
- O motor aplica um `rateMultiplier` (spawn/drop) conforme [[DATA-001 Mapas e Rates|DATA-001]] — sem alterar o dano base das skills.

## 5. Lógica Passo a Passo
1. Ao carregar o mapa, ler `shape` e `area`.
2. Calcular `rateMultiplier` via [[DATA-001 Mapas e Rates|DATA-001]].
3. Aplicar aos spawns e drops.
4. Skills resolvem colisão **física** conforme o eixo; o layout decide quem brilha.

## 6. Casos de Borda
- Mapa com áreas mistas; forma que muda em tempo real; overflow de contagem de spawns.

## 7. UI/UX e Feedback
- Indicador opcional de "farm rating" do mapa (útil para o jogador escolher onde farmar).

## 8. Ganchos para o Futuro
- Modificadores de build por mapa; eventos que alteram a forma.

## 9. Relacionados
- Skills: [[DESIGN-007 Meteoro|DESIGN-007]], [[DESIGN-008 Machado|DESIGN-008]], [[DESIGN-009 Perfuracao Vertical|DESIGN-009]], [[DESIGN-010 Raio Laser|DESIGN-010]], [[DESIGN-011 Summon Corredor|DESIGN-011]], [[DESIGN-012 Jump Dash|DESIGN-012]].
- Valores: [[DATA-001 Mapas e Rates|DATA-001]].
