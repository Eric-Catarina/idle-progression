---
name: progression-idle
description: Use this skill for ANY task related to the Progression Idle game project — creating design specs (DESIGN), technical architecture (SYSTEM), data formulas (DATA), or implementing Godot game code. Always triggers when the user mentions Progression Idle, game mechanics, platformer systems, idle/incremental systems, tap-to-move, knockback, prestige, Godot, prefabs, or asks to create specs/code for this project.
---

# Progression Idle — Skill Personalizada

Esta skill contém as regras fundamentais do projeto **Progression Idle**. Antes de criar qualquer documento ou código, leia o manifesto completo em `00-Context/CONTEXT-000 Manifesto.md`.

## Visão Geral

- **Projeto:** Incremental / Idle com plataformas 2D (estilo MapleStory)
- **Paradigma:** Headless Simulation First — toda a lógica existe **independente** da renderização
- **Engine:** **Godot 4.7** + renderer **Compatibility** + **GDScript** — o jogo vive em **`game/`** (`00-Context/CONTEXT-011 Engine & Plataforma.md`)

## Os 4 Pilares da Documentação

| Prefixo | Pasta | Conteúdo |
|---------|-------|----------|
| `CONTEXT-XXX` | `00-Context/` | Manifestos, convenções, glossário, governança |
| `DESIGN-XXX` | `01-Design/` | Game Design de Baixo Nível (GDD) |
| `SYSTEM-XXX` | `02-Architecture/` | Arquitetura de Software, Patterns, TDD |
| `DATA-XXX` | `03-Data/` | Fórmulas, curvas, tabelas, schemas JSON |

## Estrutura do Jogo (Godot)

`game/` segue a convenção **`CONTEXT-012`** — leia antes de escrever código:
- `sim/` = **lógica pura headless** (sem nós/render) · `prefabs/` = cenas **reutilizáveis** · `scenes/` = cenas compostas · `ui/` = HUD/janelas · `data/` = **gerado** do vault (não editar).
- **Prefabs** (contrato/nós/sinais) → `02-Architecture/SYSTEM-004 Cenas & Prefabs.md`.
- **Nunca** duplique dados do vault no código: `node tools/export-data.mjs` gera `game/data/`.

## Prioridade (MoSCoW) — Obrigatório

Todo `DESIGN` e `SYSTEM` declara `moscow: Must | Should | Could | Wont` no frontmatter (ver `00-Context/CONTEXT-001 MoSCoW.md`).

- **Escopo do protótipo = `Must` + `Should`.** Só estes são implementados.
- **`Could`** vira design completo em `01-Design/backlog/` com `status: Backlog` e `promote_when`. **Zero código.**
- **`Wont`** é registrado no board `01-Design/DESIGN-000 Board MoSCoW.md`, sem arquivo.
- **`DATA`** herda a prioridade do `SYSTEM`.
- Sistemas `Must`/`Should` devem expor **pontos de extensão (seams)** para features `Should` futuras — sem implementá-las.

## Hierarquia de Conteúdo

`DESIGN` pode formar uma **árvore** com `parent` (único) e `path` (breadcrumb), conforme `00-Context/CONTEXT-006 Hierarquia.md`. Níveis de conteúdo: **Campanha (`campaign`) → Mundo (`world`) → Nível (`level`)**. `parent` = *parte-de*; para vínculo de implementação use `implements`/`tech_spec`/`data_spec`. Sem ciclos.

## Regras Inegociáveis

### Modo Specifier / Architect

1. **Decomponha** a ideia nos pilares — nunca misture DESIGN com SYSTEM ou DATA
2. **Elimine ambiguidades** — proibido "dano razoável" ou "dependendo da altura". Sempre especifique valores exatos
3. **Mapeie os 3 caminhos:** Happy Path, Failure Path, Edge Cases
4. **Use os templates** da seção 5 do manifesto

### Modo Implementer / Coder

1. **Ordem de leitura obrigatória:** DESIGN → SYSTEM → DATA
2. **Contrato de arquitetura:**
   - NÃO misture lógica de jogo com código de interface (`sim/` nunca importa `prefabs/`/`scenes/`/`ui/`)
   - Mantenha simulação desacoplada para cálculos offline
   - Use BigNumber/BreakEternity para variáveis exponenciais

## Nomenclatura

- **Arquivos do vault:** `<ID> <nome>.md` — **espaço** entre o ID e o nome (ex.: `DESIGN-023 Plataformas & Portais.md`)
- **Skills:** `name` igual ao nome da pasta, `kebab-case`
- **Godot:** ver `CONTEXT-012` §4 (cenas `snake_case`, nós `PascalCase`, autoloads `PascalCase`, sinais no passado)

## Frontmatter YAML Obrigatório

Todo arquivo Markdown do vault deve começar com:

```yaml
---
id: PREFIXO-NNN
aliases: [PREFIXO-NNN]
title: Nome do Documento
type: context-convention | system-design | tech-spec | data-spec
status: Draft | Spec Ready | Implemented | Approved | Done | Balanced
moscow: Must | Should | Could | Wont     # obrigatório em DESIGN e SYSTEM
dependencies: ["[[ID Nome|ID]]"]
---
```

## Notação de Multiplicadores

Formato estrito: `x + valor` com 2 casas decimais
- `+5%` → `x1.05`
- `+100%` → `x2.00`

## Wikilinks

Use **`[[<ID> <nome>|<ID>]]`** (resolve pelo **nome do arquivo**). **Nunca** `[[ID]]` curto.
Ex.: `[[DESIGN-023 Plataformas & Portais|DESIGN-023]]`.

## Glossário Rápido

| Termo | Definição |
|-------|-----------|
| **Headless Simulation** | Lógica pura em memória, sem renderizador ou nós |
| **Prefab** | Cena reutilizável instanciável (`prefabs/`) — ver `SYSTEM-004` |
| **One-Way Platform** | Plataforma com passagem livre de baixo para cima (+ down-jump) |
| **Tap-to-Move** | Destino via toque, caminho por Grafo de Nós |
| **Linhas de Dano** | Um acerto gera N números (`lines`, base 3); crítico **por linha** |
| **Catch-up Simulation** | Cálculo analítico de progresso offline (não simular 60fps) |

## Integridade de Referências

Ao renomear, mover ou **reordenar** qualquer ID/documento, atualize **todas** as referências no mesmo passo: wikilinks, frontmatter (`dependencies`, `tech_spec`, `data_spec`, `implements`, `system`), o board `[[DESIGN-000 Board MoSCoW|DESIGN-000]]`, os templates em `00-Context/_templates/`, esta skill e o `AGENTS.md`. Nunca deixe wikilink órfão — ao trocar a ordem de dois IDs, use um token temporário para evitar colisão.

---

**Lembre-se:** Leia `00-Context/CONTEXT-000 Manifesto.md` para os templates completos e detalhes adicionais.
