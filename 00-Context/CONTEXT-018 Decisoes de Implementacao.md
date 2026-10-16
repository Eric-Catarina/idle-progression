---
id: CONTEXT-018
aliases:
  - CONTEXT-018
title: Decisões de Implementação
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-16
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
  - "[[CONTEXT-017 Modelos & Papéis (IA)|CONTEXT-017]]"
tags:
  - context
  - convention
  - implementacao
  - decisoes
---

# 🧾 [CONTEXT-018] Decisões de Implementação

> As decisões que **fechavam as ambiguidades** antes da grande implementação. Aqui é o **contrato**: o que não está decidido aqui, **não existe** — o agente **não inventa**.
> Onde copiamos do **IdleOn**, os números exatos estão em `99-Inbox/reference/IDLEON_COMBAT_REFERENCE.md`.

## 1. As decisões (o que estava em aberto)
| # | Tema | **Decisão** | Onde vive |
| :-- | :--- | :--- | :--- |
| 1 | **Números das skills** | **Warrior do IdleOn**: Power Strike (**3 s**), Whirl (**5 s**, AoE), Firmly Grasp It (**30 s**, buff) + **Ataque Básico 0,7 s** + **Machado** (VS, boomerang) — `lines 3` | [[DATA-018 Skills\|DATA-018]] |
| 2 | **`capLinha`** (teto por linha) | **Comuns: sem teto.** **Elite/Boss: 1.500** (≈1,4× o golpe do fim do Mundo 1) | [[DATA-014 Populacao Mundo 1\|DATA-014]] |
| 3 | **Dano do mob** | **Contato**. Ao tomar dano, o player ganha **i-frame de 1 s** com **piscadinha** (blink) | [[DESIGN-031 Calculo de Dano\|DESIGN-031]] |
| 4 | **Spawn de mob** | **Lote 4–6**, teto **8 em tela**, respawn **1,5 s**, **presos à plataforma** (nunca caem), tick de movimento **0,5 s** (IdleOn) | [[DATA-014 Populacao Mundo 1\|DATA-014]] |
| 5 | **Cadência do combate** | **`combatTick` = 100 ms**; básico **0,7 s** (⚠️ **já está no solver** — não mudar sem recalibrar) | [[DATA-018 Skills\|DATA-018]] §1 |
| 6 | **Morte do jogador** | **Respawn no Hub de graça** (IdleOn). **Não** perde progresso nem cota | [[DESIGN-031 Calculo de Dano\|DESIGN-031]] |
| 7 | **Colisão** | **Física do Godot** (`CharacterBody2D` + one-way nativo). **Não reinventar** — o [[SYSTEM-003 Kinematics & Motion Primitives\|SYSTEM-003]] vira *regras de comportamento* | [[SYSTEM-003 Kinematics & Motion Primitives\|SYSTEM-003]] |
| 8 | **Arte** | **Sempre usar asset do projeto** (Kenney). Se faltar, **combinar assets existentes**; só se não houver, **placeholder** + anotar a lacuna | [[CONTEXT-016 Assets\|CONTEXT-016]] |
| 9 | **BigNumber** | Instalar e testar a melhor biblioteca atual (GDScript, web-safe) — **a instalar** | [[CONTEXT-004 Notacao Numerica\|CONTEXT-004]] |
| 10 | **Câmera** | **Phantom Camera** (ver §3) | [[CONTEXT-014 Addons & Ferramentas\|CONTEXT-014]] |
| 11 | **Skills do protótipo** | Warrior básico do IdleOn + **arremesso de machado** (Vampire Survivors) | [[DATA-018 Skills\|DATA-018]] |
| 12 | **Save** | Salva **por ação importante** (kill de chefe, level up, compra, portal) **e por tempo** (10 s) | [[DESIGN-036 Skills & Fila de Skills\|DESIGN-036]] |
| 13 | **Botões do footer** | **Usar a lógica**: cada botão abre/alterna a janela do sistema dele (as janelas ainda não existem → `TBD` visual) | [[CONTEXT-010 UI de Jogo\|CONTEXT-010]] |
| 14 | **Pets** | **Fora** desta fase (o board mantém `Must`, mas entra num corte próprio) | [[DESIGN-038 Pets\|DESIGN-038]] |
| 15 | **Interactables** | **Placeholders funcionais**: existem, colidem e abrem um log (`print`) | [[DESIGN-017 Interactables & Hub\|DESIGN-017]] |
| 16 | **Idioma** | **TUDO no jogo e nos arquivos do Godot em INGLÊS** (código, comentários, nomes, textos de UI). **O vault continua em PT-BR** | [[CONTEXT-012 Estrutura do Projeto Godot\|CONTEXT-012]] §4 |

## 2. Detalhes que fecham pontas soltas
- **Sem mobs à frente** → a fila **pula** a skill de dano (não gasta) — resolve o *"(a definir)"* do [[DESIGN-036 Skills & Fila de Skills|DESIGN-036]] §5.
- **Save é autoritativo em `sim/`** (headless) — o arquivo é só serialização [[SYSTEM-006 Dados Imutáveis & Carregamento|SYSTEM-006]].
- **i-frame de 1 s**: o player fica **invulnerável** e **pisca**; não acumula (re-cast renova).
- **`capLinha` só em elite/boss** → é o que faz o [[DESIGN-037 Linhas de Dano|DESIGN-037]] valer algo.

## 3. Câmera — por que **Phantom Camera**
| Vantagem | Vale para nós? |
| :--- | :--- |
| **Follow com deadzone** (framed) | ✅ tira o "grude" do lerp manual |
| **Prioridade + transição tween** entre câmeras | ✅ hub → nível → **arena de chefe** (zoom diferente por sala) |
| **Zoom por câmera** | ✅ a arena compacta (35×15) **precisa** de zoom |
| **Limits** por câmera | ✅ substitui o nosso cálculo manual |
| **Viewfinder** (o que a câmera vê) | ✅ debug sem rodar |

**Decisão:** adotar o **Phantom Camera** para a câmera de jogo; o **fit** (zoom de enquadramento) continua nosso e vira o `zoom` da `PhantomCamera2D`.

## 4. Trabalho que essas decisões geram
| Tarefa | Motivo |
| :--- | :--- |
| **Converter o jogo para inglês** (comentários, ids, textos de UI, labels do footer) | decisão §1.16 |
| **Instalar + testar BigNumber** | decisão §1.9 |
| Reescrever o **`SYSTEM-003`** como regras (a física é do Godot) | decisão §1.7 |
| Trocar o `Camera2D` por `PhantomCamera2D` + `PhantomCameraHost` | decisão §1.10 |
| `capLinha` no `DATA-014` + **spawn** especificado | decisões §1.2 e §1.4 |
| Anotar **lacunas de asset** (o que não existe nos Kenney) | decisão §1.8 |

## 5. Relacionado
- Modelos/papéis (quem implementa): [[CONTEXT-017 Modelos & Papéis (IA)|CONTEXT-017]].
- Referência do IdleOn (números exatos): `99-Inbox/reference/IDLEON_COMBAT_REFERENCE.md`.
- Skills/ritmo: [[DATA-018 Skills|DATA-018]] · Dano: [[DATA-009 Dano|DATA-009]] · População: [[DATA-014 Populacao Mundo 1|DATA-014]].
