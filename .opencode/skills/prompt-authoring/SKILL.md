---
name: prompt-authoring
description: >-
  Use when the user asks to create, write, or improve a prompt — especially an orchestrator prompt
  for multi-agent audits, reviews, or scoped investigations. Triggers on: "cria um prompt",
  "prompt de auditoria", "prompt pra revisar o jogo/repo/vault", "briefing de subagente",
  "orchestrator prompt", "transforma isso num prompt", "melhora esse prompt",
  "quero auditar X com vários agentes". Also use to turn a vague or rambling request into a
  structured multi-agent prompt for THIS project (Progression Idle). This skill only WRITES the
  prompt; it never runs it unless the user explicitly asks to run/launch it afterwards.
---

# Autoria de Prompts (Orquestrador)

> Skill do projeto **Progression Idle**. Irma das skills `progression-idle` e `godot-mcp-toolkit`.

## Regra dura

**Escreva o prompt. Não execute.** Só rode se o usuário disser explicitamente depois ("roda",
"executa", "aplica", "manda ver"). Ao escrever, **não** modifique o vault, o jogo nem crie o
arquivo de saída (ex.: `AUDITORIA.md`) — isso é consequência de *executar*, não de *escrever*.

Por que: o valor do artefato é você poder revisar/ajustar o prompt antes de gastar agentes nele.
Se eu já executo, você perde o ponto de controle.

## Quando usar

Gatilhos: *"cria um prompt"*, *"prompt de auditoria"*, *"briefing de subagente"*, *"orquestrador"*,
*"transforma isso num prompt decente"*, *"quero auditar X"*, *"revisa o projeto com vários agentes"*.
Também quando o pedido chega **bagunçado** e o certo é estruturá-lo num prompt.

Para **executar** a tarefa (não escrever o prompt), use os fluxos normais do projeto — não esta skill.

## O que um bom prompt **nosso** tem

1. **Papel de orquestrador** — coordena, valida e consolida; **não** faz a auditoria inteira sozinho.
2. **Descoberta separada da mutação** — a fase atual é *read-only* (auditar/planejar) **ou** *implementar*, dito em uma linha.
3. **Fan-out sem sobreposição** — cada subagente com **escopo exato** (arquivo/pasta/domínio).
4. **Formato de achado padronizado** — para poder **juntar** os relatórios (§"Schema do achado").
5. **Filtro de falso-positivo + deduplicação** antes de entregar.
6. **Entregável único e nomeado** + o que está **fora de escopo nesta fase**.

## Fluxo de autoria

### 1. Fixe a missão (infira o que for óbvio; pergunte só o que trava)
| Campo | Exemplo |
| :--- | :--- |
| **Objetivo** | integridade do vault / revisão do `game/` / mapa de arquitetura / licenças / balanceamento |
| **Fase** | auditar apenas / planejar / implementar |
| **Escopo** | repo inteiro · `00-Context/..03-Data/` · `game/sim/` · `game/prefabs/` · um DESIGN específico |
| **Entregável** | `00-Context/_auditorias/<NOME>.md` · comentário · checklist |
| **Restrições** | não commitar · não rodar o jogo · PT-BR · não tocar `game/addons/` |

Se o usuário já colou um modelo, **preserve a estrutura e o vocabulário dele** — adapte, não dilua.

### 2. Bloco de contexto do projeto (todo prompt deve mandar carregar)
Instrua o orquestrador a **descobrir antes** de disparar subagentes:
- `AGENTS.md` (regras transversais) e `00-Context/CONTEXT-000 Manifesto.md` (governança/templates).
- `.opencode/skills/progression-idle/SKILL.md` (regras do projeto).
- A topologia do vault: 4 pilares, IDs (`CONTEXT/DESIGN/SYSTEM/DATA-NNN`), **MoSCoW**, wikilinks.
- O jogo: `00-Context/CONTEXT-012` (estrutura) e `02-Architecture/SYSTEM-004` (cenas/prefabs).
- As ferramentas: `node tools/validate-vault.mjs`, `node tools/export-data.mjs`, `node tools/balance-sim.mjs`.
- **Idioma:** tudo em **PT-BR**.

### 3. Desenhe o fan-out
- Infira **N** do tamanho do escopo; **prefira menos subagentes com escopos que não se sobrepõem**.
- Use o agente **`explore`** (rápido) para **coleta/varredura** e **`general`** para análise que exige julgamento.
- Rode em **paralelo** (`background: true`) quando os escopos forem independentes.
- Cada subagente recebe: **escopo exato**, **o que procurar** (checklist), **formato de saída** e a ordem de **não editar nada**.

### 4. Escolha o checklist da missão
Os checklists prontos (vault, jogo, design↔código, licenças, balanceamento, dívida técnica geral)
estão em **[references/checklists.md](references/checklists.md)** — leia o arquivo e use o bloco da missão.
Se a missão não estiver lá, **monte um checklist análogo** mantendo o esqueleto.

### 5. Trave o schema do achado (nosso)
```
- Onde: <arquivo>:<linha>  |  <ID do doc> (§seção)
- Categoria: <do checklist>
- Severidade: crítica | alta | média | baixa  — + justificativa
- Evidência: <trecho curto, verbatim>
- Por que dói AQUI: <impacto no Progression Idle, não teoria genérica>
- Viola: <[[CONTEXT-xxx|CONTEXT-xxx]] / regra do AGENTS.md>  (ou "sem regra ainda")
- Ação sugerida: <1 linha, sem implementar>
```
Sem `Onde` + `Evidência` + `Por que dói AQUI`, o achado **não** entra no relatório.

### 6. Pós-processamento do orquestrador (sempre incluir)
- **Validar** cada achado e **descartar falso-positivo** (o agente que achou costuma ser otimista).
- **Deduplicar** relatos que se sobrepõem entre subagentes.
- **Priorizar** por `severidade × esforço de correção`.
- Rodar **verificação objetiva** quando existir: `npm run validate` (vault), `node tools/export-data.mjs`
  (integridade dos JSONs), `node tools/balance-sim.mjs` (números). Resultado vira **evidência**, não opinião.
- Emitir **um** artefato consolidado. Nada de "cada subagente escreve sua parte".

### 7. Entregue ao usuário
1. **Título** do prompt (1 linha)
2. **Prompt pronto para colar** num bloco único ```text```
3. **Nota de uso** (1–2 linhas: fase read-only? paralelizar? onde salvar)
4. **Variantes** só se ajudarem (escopo menor, só segurança, só vault)

## Regras do projeto que todo prompt deve embutir
Estas vêm do `AGENTS.md`/manifesto — o prompt precisa repeti-las, senão os subagentes improvisam:
- **PT-BR** em doc, commit e relatório.
- **Vault é fonte de verdade** — o jogo **consome** `03-Data/`; **nunca** duplicar número no código.
- **MoSCoW** obrigatório em `DESIGN`/`SYSTEM`; `Could` vai pro `01-Design/backlog/` e **não gera código**.
- **Headless First:** lógica pura em `game/sim/`; `sim/` **nunca** importa `prefabs/`, `scenes/` ou `ui/`.
- **Nada de hand-waving:** "dano razoável", "funciona bem" e afins são proibidos — exija valor/fórmula exata.
- **Wikilinks** no formato `[[<ID> <nome>|<ID>]]`.
- **Não editar** `game/addons/` (código de terceiros).
- **Validar antes de commitar** (`npm run validate`).
- **Nunca** deletar/sobrescrever trabalho do usuário sem confirmar.

## Anti-padrões ao escrever
- Pedir a **um** agente que "revise tudo".
- Misturar **auditar** e **refatorar** na mesma fase sem dizer.
- Deixar o subagente **escrever o relatório final** (quem consolida é o orquestrador).
- Mandar "seja minucioso" **sem escopo**.
- **Inventar caminho/ID** que você não verificou — use `<ESCOPO>` ou mande descobrir na fase 1.
- Colocar **passos de implementação** num prompt de auditoria.
- **Executar** subagentes enquanto escreve o prompt.

## Barra de qualidade

Um prompt bom começa com papel + não-objetivos ("NÃO modifique arquivos nesta fase"), separa
descoberta de execução, proíbe queixa vaga ("viola SOLID" → qual princípio, onde, por quê aqui),
exige o impacto **neste** projeto, e termina com **um** artefato nomeado e a fronteira da fase.

**Exemplo de transformação**

> Entrada do usuário: *"dá uma olhada no projeto e ve se ta tudo certo"*

> Prompt gerado: **"Auditoria de integridade do vault — fase read-only"** → papel de orquestrador;
> 3 `explore` em paralelo (`00-Context/`, `01-Design/`, `02..03`); checklist de integridade;
> schema de achado; orquestrador valida/desduplica/prioriza; roda `npm run validate` como evidência;
> entrega **um** `00-Context/_auditorias/AUDITORIA-INTEGRIDADE.md`; fora de escopo: corrigir.

## Referências
- **[references/checklists.md](references/checklists.md)** — checklists por missão + template canônico.
  Leia o bloco da missão antes de escrever o prompt.
