# 🎮 Progression Idle

> Incremental / Idle Game com movimentação e combate em plataformas 2D — estilo estético/mecânico inspirado em **MapleStory**.

Este repositório é, antes de tudo, um **vault Obsidian de documentação e design** e — futuramente — o código do jogo. Toda a arquitetura de conhecimento vive em Markdown versionado, pensado para ser lido tanto por humanos quanto por agentes de IA.

---

## 🧭 Visão Geral

* **Título:** *Progression Idle*
* **Gênero:** Incremental / Idle com plataformas 2D.
* **Core Loop:** O personagem navega por plataformas estáticas via *tap-to-move*, combate monstros que patrulham as plataformas, acumula recursos numéricos exponenciais, desbloqueia upgrades, escala multiplicadores e realiza prestígios matemáticos.
* **Paradigma de Engenharia:** **Headless Simulation First** — toda física, progressão temporal, cálculo e estado existem **independentemente** da camada de renderização visual. Isso permite *catch-up simulation* (progresso offline) instantâneo.

---

## 🤖 Comece por aqui: IA & Contexto

**Antes de criar qualquer spec ou código, leia o manifesto mestre:**

📄 **[`00-Context/CONTEXT-000_AI_MANIFEST.md`](00-Context/CONTEXT-000_AI_MANIFEST.md)**

O arquivo **[`AGENTS.md`](AGENTS.md)** é carregado automaticamente por agentes (OpenCode/Codex) em **todo prompt** e contém as regras críticas + ponteiro para o manifesto. Há também a skill do projeto em [`skills/progression-idle/SKILL.md`](skills/progression-idle/SKILL.md).

---

## 🗂️ Topologia do Vault (4 Pilares)

A documentação é dividida em **4 pilares obrigatórios**, identificados por prefixo de ID:

```text
📁 / (Raiz do Vault)
├── 📁 00-Context/       -> [CONTEXT-XXX] Manifestos, convenções globais, glossário e governança.
│   └── 📁 _templates/   -> Templates oficiais (DESIGN, SYSTEM, DATA, CONTEXT).
├── 📁 01-Design/        -> [DESIGN-XXX] Especificações de Game Design de Baixo Nível (GDD).
│   ├── 📄 DESIGN-000_MOSCOW_BOARD.md -> Board de priorização (fonte de verdade MoSCoW).
│   └── 📁 backlog/      -> [DESIGN-XXX] Features "Could" guardadas para o futuro.
├── 📁 02-Architecture/  -> [SYSTEM-XXX] Arquitetura de Software, Design Patterns, TDD e ADRs.
├── 📁 03-Data/          -> [DATA-XXX] Fórmulas, curvas de escala, tabelas e schemas JSON.
└── 📁 99-Inbox/         -> Ideias brutas, consolidadas pelo "Modo C" do manifesto.
```

### Regras de vinculação

* Nenhuma spec de sistema (`DESIGN`) existe sem referenciar seu suporte técnico (`SYSTEM`) e matemático (`DATA`).
* Referências cruzadas via wikilinks curtos: `[[DESIGN-XXX]]`, `[[SYSTEM-XXX]]`, `[[DATA-XXX]]`, `[[CONTEXT-XXX]]`. Cada nota declara seu ID em `aliases` no frontmatter para que os links resolvam no Obsidian.

---

## 🎯 Priorização (MoSCoW)

Toda feature declara `moscow: Must | Should | Could | Wont`. Regras completas em [`00-Context/CONTEXT-001_MOSCOW_PRIORITIZATION.md`](00-Context/CONTEXT-001_MOSCOW_PRIORITIZATION.md).

| Categoria | Papel no Protótipo | Destino |
| :--- | :--- | :--- |
| **Must** | Sem isso o core loop não é validável. | `01-Design/` |
| **Should** | Agrega valor; implementar se houver tempo. Deixar gancho. | `01-Design/` |
| **Could** | Desejável, adiado. Documentar, sem código. | `01-Design/backlog/` |
| **Wont** | Fora de escopo nesta fase. | Registrado no board |

> **O escopo do protótipo é composto apenas por itens `Must` + `Should`.**

Consulte o estado consolidado no **[`DESIGN-000` MoSCoW Board](01-Design/DESIGN-000_MOSCOW_BOARD.md)**.

---

## 📏 Convenções Essenciais

* **Nomenclatura de arquivos:** `PREFIXO-NNN_nome_curto.md` (ex: `DESIGN-001_multi_character_same_map.md`).
* **Frontmatter YAML obrigatório:** `id`, `aliases`, `title`, `type`, `status`, `moscow` (em DESIGN/SYSTEM) e `dependencies`.
* **Multiplicadores na UI:** formato estrito `x1.05` (2 casas decimais) — ver [`CONTEXT-002`](00-Context/CONTEXT-002_MULTIPLIER_NOTATION.md).
* **Integridade de referências:** ao renomear/mover/reordenar IDs, atualize **todas** as referências (wikilinks, frontmatter, board, templates, skill).

---

## 🚧 Status

📐 **Fase atual: documentação e design.** A estrutura do vault, o sistema de priorização MoSCoW e as convenções globais estão prontos. As especificações de features (`DESIGN`/`SYSTEM`/`DATA`) serão criadas a partir do core loop.

---

## 🧰 Desenvolvimento

O repositório é também um vault [Obsidian](https://obsidian.md). Abra a pasta raiz como vault para navegar pela documentação com wikilinks, grafo e templates.

```powershell
git clone https://github.com/Eric-Catarina/idle-progression.git
```
