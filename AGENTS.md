# Progression Idle — Instruções do Projeto

> **LEIA SEMPRE** o manifesto mestre antes de criar specs ou escrever código:
> `00-Context/CONTEXT-000_AI_MANIFEST.md`
> Este arquivo é carregado automaticamente em **todo prompt** (via `AGENTS.md`). O manifesto contém os detalhes completos, templates e glossário.

## Regras críticas (sempre em contexto)

- **Headless Simulation First:** lógica de jogo, física e estado existem **independentes** da renderização. Nunca misture lógica de jogo com UI.
- **4 pilares:** `CONTEXT` (`00-Context/`), `DESIGN` (`01-Design/`), `SYSTEM` (`02-Architecture/`), `DATA` (`03-Data/`).
- **Prioridade MoSCoW obrigatória:** todo `DESIGN` e `SYSTEM` declara `moscow: Must | Should | Could | Wont`. Escopo do protótipo = **Must + Should** apenas. Ver `00-Context/CONTEXT-001_MOSCOW_PRIORITIZATION.md`.
- **`Could` não gera código:** vira um design completo em `01-Design/backlog/` com `status: Backlog` e `promote_when`.
- **Frontmatter YAML obrigatório:** `id`, `aliases` (com o próprio ID), `title`, `type`, `status`, `moscow` (DESIGN/SYSTEM) e `dependencies`.
- **Ao renomear / mover / reordenar IDs:** atualize **TODAS** as referências (wikilinks, frontmatter, board `[[DESIGN-000]]`, templates, skill). Nunca deixe wikilink órfão — use token temporário ao trocar a ordem de dois IDs.
- **Nomenclatura de arquivos:** `PREFIXO-NNN_nome_curto.md`.
- **Precisão numérica:** use BigNumber/BreakEternity para qualquer variável que escale exponencialmente.

## Escopo deste arquivo

Aqui ficam **apenas diretrizes transversais, sempre válidas**. Nada **específico de feature** entra no `AGENTS.md` — detalhes de domínio, convenções e regras de jogo vivem no vault (`00-Context/`, `01-Design/`, `02-Architecture/`, `03-Data/`). Toda nova demanda é registrada no local adequado: **transversal → este arquivo**; **específico → documento correspondente no vault**.

## Detalhes

- Manifesto completo (templates, protocolos A/B/C, glossário): `00-Context/CONTEXT-000_AI_MANIFEST.md`
- Skill do projeto: `skills/progression-idle/SKILL.md`
