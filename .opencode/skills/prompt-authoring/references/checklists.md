# Checklists por Missão — Progression Idle

> Leia **só** o bloco da missão antes de escrever o prompt. Cada item vira o "o que procurar"
> de um subagente. O **porquê** de cada item está no `AGENTS.md` e no manifesto.

---

## 0. Template canônico (esqueleto do prompt)

```text
Você é o ORQUESTRADOR de uma <MISSÃO> do projeto Progression Idle (monorepo: vault Obsidian + jogo Godot em game/).

NÃO OBJETIVOS (fase atual = <auditoria|planejamento>):
- NÃO modifique arquivos, NÃO commite, NÃO rode o jogo. Entregue só o relatório.

FASE 1 — CONTEXTO (você, orquestrador, antes de disparar qualquer subagente):
Leia AGENTS.md, 00-Context/CONTEXT-000 Manifesto.md e .opencode/skills/progression-idle/SKILL.md.
Mapeie a topologia do vault (CONTEXT/DESIGN/SYSTEM/DATA), a estrutura de game/ (CONTEXT-012) e as ferramentas em tools/.
Diga em 1 parágrafo o que existe hoje e o que NÃO existe. Não invente caminho/ID: se não verificou, use <ESCOPO>.

FASE 2 — FAN-OUT (<N> subagentes em paralelo, escopos SEM sobreposição):
- Subagente 1 — <escopo exato>: procure por <itens do checklist>.
- Subagente 2 — ...
Cada um: somente leitura; devolva achados no SCHEMA abaixo; nada de prosa solta.

FASE 3 — CONSOLIDAÇÃO (você):
Valide cada achado, DESCARTE falso-positivo, DEDUPLIQUE sobreposições, priorize por severidade × esforço.
Rode as verificações objetivas que couberem (npm run validate / node tools/export-data.mjs / node tools/balance-sim.mjs)
e use o resultado como EVIDÊNCIA.

SCHEMA DO ACHADO:
- Onde: <arquivo>:<linha> | <ID do doc> (§seção)
- Categoria | Severidade (crítica/alta/média/baixa) + justificativa
- Evidência: <trecho verbatim curto>
- Por que dói AQUI: <impacto no projeto, não teoria>
- Viola: <[[CONTEXT-xxx|CONTEXT-xxx]] / regra>  (ou "sem regra ainda")
- Ação sugerida: <1 linha>

ENTREGÁVEL ÚNICO: <caminho/nome>. Ordenado por prioridade. Em PT-BR.
FORA DE ESCOPO NESTA FASE: <corrigir | implementar | rebalancear>.
```

---

## A. Integridade do Vault (`00-Context/`, `01-Design/`, `02-Architecture/`, `03-Data/`)

- **Frontmatter:** todo doc dos 4 pilares tem `id`, `aliases` (com o próprio ID), `title`, `type`, `status`; `DESIGN`/`SYSTEM` têm `moscow`.
- **MoSCoW válido:** só `Must|Should|Could|Wont`; `Could` **tem** que estar em `01-Design/backlog/`; filhos herdam do pai salvo override.
- **IDs:** sem duplicata; sequência sem buraco inexplicado; `aliases` sem colisão.
- **Wikilinks:** nenhum órfão; formato `[[<ID> <nome>|<ID>]]` (não `[[ID]]` curto); nada apontando para arquivo renomeado.
- **Referências cruzadas:** `tech_spec`/`data_spec`/`implements`/`system`/`parent` resolvem; sem ciclo de `parent`.
- **Cobertura por pilar:** existe `DESIGN` de feature sem `DATA` correspondente? `SYSTEM` sem `implements`?
- **Contradição entre docs:** o mesmo número/regra escrito diferente em dois lugares (ex.: legend de tiles, `lines` base, cotas).
- **Órfãos de conteúdo:** doc que ninguém linka e que não é raiz (campanha/mundo).
- **Evidência objetiva:** `npm run validate` (rode e cite a saída).

## B. Código Godot (`game/`)

- **Headless First:** `game/sim/` **não** pode importar `prefabs/`, `scenes/` nem `ui/`; nada de `_process` em `sim/` (recebe `delta`).
- **Adaptador fino:** script de prefab só lê → chama `sim/` → desenha; **nenhuma regra de jogo** no nó.
- **Dados hardcoded:** número de design (HP, XP, cota, odds, layout) escrito no código em vez de vir de `game/data/`.
- **`game/data/` editado à mão:** é **gerado** — se alguém editou, é defeito.
- **Nomeação (CONTEXT-012 §4):** cena/prefab `snake_case`, script ao lado com mesmo nome, autoload `PascalCase`, nó `PascalCase`, sinal no passado.
- **Prefab vs cena:** o que se repete é **prefab**; o que existe uma vez é **cena**.
- **`game/addons/`** intocado (código de terceiros).
- **Cena principal:** `main.tscn` compõe Mundo (`SubViewport`, altura `H−F`) + Footer; a câmera não enquadra abaixo do footer (CONTEXT-010 §3b).
- **Uso do motor:** em vez de reimplementar, usa o que é nativo (TileMapLayer, VirtualJoystick, Tween...)? Ver CONTEXT-014 §3.

## C. Consistência Design ↔ Código ↔ DATA

- Todo `DESIGN` `Must`/`Should` tem `SYSTEM` **e** `DATA`? E existe código correspondente em `game/`?
- O que está implementado em `game/` tem `DESIGN`/`SYSTEM` que o descreva? (código órfão de spec)
- Fonte de verdade única: o valor no `.md` bate com o JSON em `game/data/tables/*.json` e com o que o código usa?
- `DESIGN-000` (board) reflete o estado real (status, SYSTEM, DATA) dos docs citados?
- Extensões `Could` **não** estão implementadas (só o gancho existe)?

## D. Licenças & Segurança

- Todo asset de terceiros está registrado em `game/ASSETS.md` com **origem + licença + autor** (CONTEXT-016)?
- Existe asset **sem licença** ou vindo de loja de outra engine (Unity/Fab) ou rip de jogo? (violação)
- Segredos/credenciais no repo (`.env`, token, chave) — inclusive no histórico?
- IAP/Gemas: idempotência por transação, saldo nunca negativo (CONTEXT-013).

## E. Balanceamento (solver × DATA)

- Os números de `03-Data/` vêm do **solver** (`node tools/balance-sim.mjs`) ou foram chutados?
- Solver roda sem erro e reproduz os valores publicados em `DATA-013`/`DATA-014`?
- Metas de design respeitadas: tempos por nível (2/5/7/9/12 min), **sem one-shot** nos mobs fortes (11–25 → 3–7 golpes)?
- Odds/percentuais **somam 100**? Cap por linha (`capLinha`) coerente com as `lines` de `DESIGN-037`?
- Escala exponencial usa BigNumber (CONTEXT-004), não `float` cru?

## F. Dívida técnica geral (canônica adaptada)

- **Duplicação:** mesma regra/número/constante em dois lugares.
- **Acoplamento:** módulo que conhece demais outro (camadas, dependências invertidas).
- **Coesão:** arquivo que faz coisas demais (ou nome que não diz o que faz).
- **Dead code:** função/nó/arquivo que ninguém usa.
- **Tratamento de erro:** caminho de falha ausente (recurso insuficiente, input inválido, offline).
- **Performance:** trabalho por frame onde caberia cache; alocação por frame no idle.
- **Testes:** regra não trivial em `sim/` sem teste headless.
- **Documentação:** decisão não registrada (vai virar retrabalho).

## G. Assets & Addons (CONTEXT-014 / CONTEXT-016)

- Addon instalado mas **não** habilitado em `project.godot` (`[editor_plugins]`)? Ou habilitado e quebrado?
- Packs crus versionados (deveriam estar em `_raw/` com `.gdignore`)?
- Algo pesado versionado que deveria estar em staging (ver "menor arquivo possível no repo")?
- Pasta que o Godot importa sem necessidade (`.gdignore` faltando)?
