---
name: progression-idle
description: Use this skill for ANY task related to the Progression Idle game project — creating design specs (DESIGN), technical architecture (SYSTEM), data formulas (DATA), or implementing game code. Always triggers when the user mentions Progression Idle, game mechanics, platformer systems, idle/incremental systems, tap-to-move, knockback, prestige, or asks to create specs/code for this project.
---

# Progression Idle — Skill Personalizada

Esta skill contém as regras fundamentais do projeto **Progression Idle**. Antes de criar qualquer documento ou código, leia o manifesto completo em `00-Context/CONTEXT-000_AI_MANIFEST.md`.

## Visão Geral

- **Projeto:** Incremental / Idle Game com plataformas 2D (estilo MapleStory)
- **Paradigma:** Headless Simulation First — toda a lógica existe independente da renderização

## Os 4 Pilares da Documentação

| Prefixo | Pasta | Conteúdo |
|---------|-------|----------|
| `CONTEXT-XXX` | `00-Context/` | Manifestos, convenções, glossário, governança |
| `DESIGN-XXX` | `01-Design/` | Game Design de Baixo Nível (GDD) |
| `SYSTEM-XXX` | `02-Architecture/` | Arquitetura de Software, Patterns, TDD |
| `DATA-XXX` | `03-Data/` | Fórmulas, curvas, tabelas, schemas JSON |

## Prioridade (MoSCoW) — Obrigatório

Todo `DESIGN` e `SYSTEM` declara `moscow: Must | Should | Could | Wont` no frontmatter (ver `00-Context/CONTEXT-001_MOSCOW_PRIORITIZATION.md`).

- **Escopo do protótipo = `Must` + `Should`.** Só estes são implementados.
- **`Could`** vira design completo em `01-Design/backlog/` com `status: Backlog` e `promote_when`. **Zero código.**
- **`Wont`** é registrado no board `01-Design/DESIGN-000_MOSCOW_BOARD.md`, sem arquivo.
- **`DATA`** herda a prioridade do `SYSTEM`.
- Sistemas `Must`/`Should` devem expor **pontos de extensão (seams)** para features `Should` futuras — sem implementá-las.

## Regras Inegociáveis

### Modo Specifier / Architect

1. **Decomponha** a ideia nos pilares — nunca misture DESIGN com SYSTEM ou DATA
2. **Elimine ambiguidades** — proibido "dano razoável" ou "dependendo da altura". Sempre especifique valores exatos
3. **Mapeie os 3 caminhos:** Happy Path, Failure Path, Edge Cases
4. **Use os templates** da seção 5 do manifesto

### Modo Implementer / Coder

1. **Ordem de leitura obrigatória:** DESIGN → SYSTEM → DATA
2. **Contrato de arquitetura:**
   - NÃO misture lógica de jogo com código de interface
   - Mantenha simulação desacoplada para cálculos offline
   - Use BigNumber/BreakEternity para variáveis exponenciais

## Nomenclatura

- Arquivos: `PREFIXO-NNN_nome_curto.md` (snake_case ou kebab-case)
- Exemplos: `DESIGN-001_one_way_platforms.md`, `SYSTEM-001_kinematics_physics.md`

## Frontmatter YAML Obrigatório

Todo arquivo Markdown deve começar com:

```yaml
---
id: PREFIXO-NNN
title: Nome do Documento
type: context-manifest | system-design | tech-spec | data-spec
status: Draft | Spec Ready | Implemented | Approved | Done | Balanced
---
```

## Notação de Multiplicadores

Formato estrito: `x + valor` com 2 casas decimais
- `+5%` → `x1.05`
- `+100%` → `x2.00`

## Glossário Rápido

| Termo | Definição |
|-------|-----------|
| **Headless Simulation** | Lógica pura em memória, sem renderizador ou DOM |
| **One-Way Platform** | Plataforma com passagem livre de baixo para cima |
| **Tap-to-Move** | Destino via toque, caminho por Grafo de Nós |
| **Knockback** | Impulso horizontal em monstros ao sofrer dano |
| **Catch-up Simulation** | Cálculo analítico de progresso offline (não simular 60fps) |

## Wikilinks

Sempre referencie documentos cruzados: `[[DESIGN-XXX]]`, `[[SYSTEM-XXX]]`, `[[DATA-XXX]]`, `[[CONTEXT-XXX]]`

## Integridade de Referências

Ao renomear, mover ou **reordenar** qualquer ID/documento, atualize **todas** as referências no mesmo passo: wikilinks, frontmatter (`dependencies`, `tech_spec`, `data_spec`, `implements`, `system`), o board `[[DESIGN-000]]`, os templates em `00-Context/_templates/`, esta skill e o `AGENTS.md`. Nunca deixe wikilink órfão — ao trocar a ordem de dois IDs, use um token temporário para evitar colisão.

---

**Lembre-se:** Leia `00-Context/CONTEXT-000_AI_MANIFEST.md` para os templates completos e detalhes adicionais.
