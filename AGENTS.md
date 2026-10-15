# Progression Idle — Instruções do Projeto

> **LEIA SEMPRE** o manifesto mestre antes de criar specs ou escrever código:
> `00-Context/CONTEXT-000 Manifesto.md`
> Este arquivo é carregado automaticamente em **todo prompt** (via `AGENTS.md`). O manifesto contém os detalhes completos, templates e glossário.

## Regras críticas (sempre em contexto)

- **Headless Simulation First:** lógica de jogo, física e estado existem **independentes** da renderização. Nunca misture lógica de jogo com UI.
- **4 pilares:** `CONTEXT` (`00-Context/`), `DESIGN` (`01-Design/`), `SYSTEM` (`02-Architecture/`), `DATA` (`03-Data/`).
- **Prioridade MoSCoW obrigatória:** todo `DESIGN` e `SYSTEM` declara `moscow: Must | Should | Could | Wont`. Escopo do protótipo = **Must + Should** apenas. Ver `00-Context/CONTEXT-001 MoSCoW.md`.
- **`Could` não gera código:** vira um design completo em `01-Design/backlog/` com `status: Backlog` e `promote_when`.
- **Frontmatter YAML obrigatório:** `id`, `aliases` (com o próprio ID), `title`, `type`, `status`, `moscow` (DESIGN/SYSTEM) e `dependencies`.
- **Ao renomear / mover / reordenar IDs:** atualize **TODAS** as referências (wikilinks, frontmatter, board `[[DESIGN-000]]`, templates, skill). Nunca deixe wikilink órfão — use token temporário ao trocar a ordem de dois IDs.
- **Nomenclatura de arquivos:** `<ID> <nome>.md` (ex: `CONTEXT-007 Raridades.md`).
- **Links:** use `[[<ID> <nome>|<ID>]]` (ex: `[[CONTEXT-007 Raridades|CONTEXT-007]]`) — resolve pelo **nome do arquivo**. Nunca `[[ID]]` curto.
- **Precisão numérica:** use BigNumber/BreakEternity para qualquer variável que escale exponencialmente.
- **Validação:** rode `npm run validate` antes de commitar (há hook de pré-commit em `.githooks/`).
- **Decomposição proativa:** em descrições de alto nível (mecânicas, skills, sistemas), extraia os elementos específicos e crie/atualize os documentos correspondentes no vault (`DESIGN`/`SYSTEM`/`DATA`) — sem esperar pedido.
- **Dados óbvios em `DATA`:** em documentos `DATA`, **implemente** o que for **óbvio** (caps, faixas, defaults, limites, tabelas derivadas das regras já definidas) **sem esperar pedido** — nunca preencha lacunas de **design** por conta própria.
- **Automação proativa:** ao executar algo que **vai se repetir** (ex: implementar níveis, mecânicas, specs), **já adiante a automação** no mesmo passo — template em `00-Context/_templates/` e/ou script em `tools/` (ex: `node tools/new-level.mjs LevelX_Y`). Nunca repita trabalho manual que dá pra padronizar.
- **Economia de contexto:** dumps de referência de outros jogos ficam em `99-Inbox/reference/` e **só** devem ser lidos quando se trabalha no sistema correspondente (ex: selos → `IDLEON_STAMPS_REFERENCE.md`). Nunca incluí-los em contexto sempre-carregado.
- **UI de jogo ≠ layout de site:** o **mundo ocupa a tela inteira**; a UI **flutua por cima** (HUD/menu/janelas sobrepostas). Ver `00-Context/CONTEXT-010 UI de Jogo.md`.
- **Engine de protótipo ≠ engine final:** o protótipo serve **só** para validar design; os aprendizados são **engine-agnósticos**.
- **Balanceamento por solver:** números de combate/progressão saem de um **script que resolve metas** (as metas vivem no `DATA`), **nunca** de chute.
- **`proto/` é descartável; o vault é a fonte de verdade:** o protótipo **consome** os dados do vault — **nada** de duplicar dados no protótipo.
- **Engine & jogo:** o jogo vive em **`game/`** (**Godot 4.7** + renderer **Compatibility** + **GDScript**) — ver `00-Context/CONTEXT-011 Engine & Plataforma.md`. O **vault** continua sendo a **fonte de verdade** dos dados (o jogo lê `03-Data/`).

## Escopo deste arquivo

Aqui ficam **apenas diretrizes transversais, sempre válidas**. Nada **específico de feature** entra no `AGENTS.md` — detalhes de domínio, convenções e regras de jogo vivem no vault (`00-Context/`, `01-Design/`, `02-Architecture/`, `03-Data/`). Toda nova demanda é registrada no local adequado: **transversal → este arquivo**; **específico → documento correspondente no vault**.

## Detalhes

- Manifesto completo (templates, protocolos A/B/C, glossário): `00-Context/CONTEXT-000 Manifesto.md`
- Skill do projeto: `skills/progression-idle/SKILL.md`
