---
id: DESIGN-040
aliases:
  - DESIGN-040
title: Range de Habilidade
type: system-design
subtype: system
status: Draft
moscow: Should
moscow_note: Stat de cobertura (mobbing); agrega muita variedade de build, mas o core loop valida sem ele.
dependencies:
  - "[[CONTEXT-015 Tags de Skill|CONTEXT-015]]"
  - "[[DESIGN-028 Equipamentos|DESIGN-028]]"
  - "[[DESIGN-031 Calculo de Dano|DESIGN-031]]"
  - "[[DESIGN-037 Linhas de Dano|DESIGN-037]]"
data_spec: "[[DATA-017 Range de Habilidade|DATA-017]]"
---

# [DESIGN-040] Range de Habilidade

> Stat **`Ability Range%`**: aumenta o **tamanho/alcance** das skills — não o dano.

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** é um **stat de cobertura** (mobbing): deixa o jogador cobrir mais inimigos por cast. Enriquece build, mas o core loop valida sem. Gancho pronto (§6).
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
- Existe **um stat genérico** (`abilityRange`) que vale para **todas** as skills, e o **específico** (`abilityRangeSkill[<skill>]`) que vale para **uma** skill — do mesmo jeito que "+% Dano" e "+% Dano de Meteoro" coexistiriam.
- **Não** aumenta dano: aumenta **área/alcance** → mais inimigos atingidos por acerto ([[CONTEXT-015 Tags de Skill|CONTEXT-015]]).
- Por que existe: a fantasia do **mobbing** (limpar packs) precisa de um eixo próprio, separado do DPS de alvo único ([[DESIGN-005 Classes|DESIGN-005]] — *mobber* vs *bosser*).

## 2. Contrato Funcional (I/O)
- **Entrada:** stats agregados — `abilityRange` (genérico) e o mapa `abilityRangeSkill` (por skill).
- **Pré-requisitos:** a skill precisa declarar uma **dimensão de escala** na sua tag (§3 / [[DATA-017 Range de Habilidade|DATA-017]] §3).
- **Saída:** ao **instanciar o efeito** de uma skill, as dimensões marcadas como escaláveis são multiplicadas.
- **Estado:** nada persistente — é derivado no cast (e re-derivado no *catch-up* analítico).

## 3. Lógica Passo a Passo
1. Calcular `R_gen` (soma de todos os `+% Range` genéricos do jogador).
2. `R_skill(s) = Σ (+% Range de <s>)` para a skill `s`.
3. `mult(s) = clamp(1 + R_gen + R_skill(s), 1, RANGE_CAP)` — **aditivo**, com **teto** ([[DATA-017 Range de Habilidade|DATA-017]] §2).
4. Aplicar `mult(s)` **apenas** nas dimensões escaláveis da skill (tabela em [[DATA-017 Range de Habilidade|DATA-017]] §3).
5. O **alvo de navegação** (`targetX`) continua sendo escolhido pelo planejador ([[DESIGN-025 Navegacao & Movimento|DESIGN-025]]) — range **não** muda aonde o player vai, só o que o cast alcança.

## 4. Casos de Borda & Tratamento de Erros
- **Cap:** `mult` nunca passa de `RANGE_CAP` (senão a área cobre a tela e some a leitura visual).
- **Skill sem tag escalável** (ex.: `role:buff` com `target:self`) → `mult` é **ignorado** (sem erro).
- **`+% Range de <skill inexistente>`** → descartado com aviso (não quebra o cálculo).
- **Mobilidade** ([[DESIGN-026 Blink|DESIGN-026]], [[DESIGN-012 Jump Dash|DESIGN-012]], [[DESIGN-027 Slide Jump|DESIGN-027]]): escalar o alcance **muda a navegação** → o navgraph ([[SYSTEM-002 NavGraph & Pathfinding|SYSTEM-002]]) tem que ler o alcance **efetivo** do momento, nunca um valor fixo.
- **Catch-up offline:** o alcance afeta o **nº de inimigos por cast** (fator de área) → precisa entrar no cálculo analítico ([[DATA-017 Range de Habilidade|DATA-017]] §4).
- **Visual:** a área desenhada **é** a área real — VFX e colisão usam o mesmo `mult` (nada de "parece maior").

## 5. UI/UX e Feedback
- No **tooltip da skill**: a dimensão base e o valor **com** range (`Raio 40 → 60 px`).
- No **inventário/gear**: linhas de Potential mostram a skill alvo quando for específico (`+15% Range: Meteoro`).
- Feedback no cast: a área ampliada **é o próprio feedback** (a hitbox visível cresce).

## 6. Ganchos para o Futuro (Should/Could)
- **Fontes do stat:** linhas de **Potential** ([[DESIGN-029 Potential|DESIGN-029]]), gear ([[DESIGN-028 Equipamentos|DESIGN-028]]), **Selos** ([[DESIGN-013 Selos|DESIGN-013]]), **Cartas** ([[DESIGN-016 Cartas|DESIGN-016]]), **Pets** ([[DESIGN-038 Pets|DESIGN-038]]), **Osíris** ([[DESIGN-014 Osiris|DESIGN-014]]), **Gear Sets** ([[DESIGN-032 Gear Sets|DESIGN-032]]). Cada sistema decide **se e onde** expõe o stat (é só entrar no pool).
- **Range por tag específica** (`+% Range em skills `target:line` somente) — `Could`.
- **Não implementar agora:** só deixar o **stat no pool** e as skills declararem as dimensões escaláveis.

## 7. Relacionados
- Tags (o que escala por tag): [[CONTEXT-015 Tags de Skill|CONTEXT-015]] · Números/teto: [[DATA-017 Range de Habilidade|DATA-017]].
- Stats/pool: [[DESIGN-028 Equipamentos|DESIGN-028]] · Dano: [[DESIGN-031 Calculo de Dano|DESIGN-031]] · Linhas: [[DESIGN-037 Linhas de Dano|DESIGN-037]].
