---
id: CONTEXT-017
aliases:
  - CONTEXT-017
title: Modelos & Papéis (IA)
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-16
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
  - "[[CONTEXT-016 Assets|CONTEXT-016]]"
tags:
  - context
  - convention
  - ia
  - modelos
  - workflow
---

# 🤖 [CONTEXT-017] Modelos & Papéis (IA)

> Qual modelo faz o quê. **Não** é "qual é o mais forte" — é **quem faz cada papel** pelo melhor custo/risco.
> ⚠️ O cenário muda rápido: **revalidar** quando entrar modelo novo ou a quota mudar.

## 1. Propósito
- Evitar os dois erros simétricos: **gastar frontier em trabalho braçal** e **deixar o barato decidir arquitetura**.
- Ter **IDs prontos** para configurar subagentes (`subagent({ model })`) sem procurar de novo.

## 2. A regra de decisão (uma pergunta)
> **"Esta tarefa precisa de JULGAMENTO ou de VOLUME?"**

| Resposta | Vai para |
| :--- | :--- |
| **Julgamento** (decidir, arquitetar, revisar, ler spec ambígua) | Orquestrador ou Programador |
| **Volume** (varrer, renomear, relatar, rodar, escrever script) | **Executor** |

## 3. Papéis (configuração atual)
| Papel | Modelo | `model` (id) | Variante | O que faz |
| :--- | :--- | :--- | :--- | :--- |
| 🧠 **Orquestrador / Arquiteto** | Gemini 4 Argon | `opencode-go/gemini-4-argon-contributor` | `high` | lê o vault, decompõe a fatia, decide arquitetura, **define o critério de aceite**, valida contra a spec |
| ⌨️ **Programador** | Kimi K2.7 Code | `opencode-go/kimi-k2.7-code` | — | GDScript das fatias de **risco** (P1 movimento, P4 progressão) |
| 🔧 **Executor (o "resto")** | DeepSeek V4.1 Flash | `opencode-go/deepseek-v4.1-flash` | `max` | recon · edições mecânicas · `tools/` (Node) · relatórios · validação · fatias mecânicas (P3) |
| 🔍 **Revisor** | Kimi K3 | `opencode-go/kimi-k3` | `high` | revisão **independente** (modelo diferente do autor) |
| 🆓 **Varredura bruta** | Beam Free | `opencode-go/beam-free` | — | só `ls`/`grep` trivial (para o resto, use o Executor) |

### Reserva
| Modelo | `model` | Quando |
| :--- | :--- | :--- |
| Step 5 Preview | `opencode-go/step-5-preview` | **só** se o Kimi K2.7 Code travar. ⚠️ é **Preview** e a quota é **promocional** ("4× mais uso, tempo limitado"). |

## 4. Orçamento de requests (por 5 h, por plano)
| Modelo | Go | Go Plus | Observação |
| :--- | --: | --: | :--- |
| Gemini 4 Argon | 220 | **440** | o mais **escasso** → só julgamento |
| Kimi K3 | 110 | 440 | escasso → só revisão |
| **Kimi K2.7 Code** | **1.350** | **4.050** | **3–9× mais quota** → feito para o loop |
| Step 5 Preview | 430 | 1.720 | promo temporária |
| DeepSeek V4.1 Flash · Beam Free | — | — | tier *flash*/free, não consome o limite de frontier |

**Custo por 1M tokens (in / out / cache read):**
| Modelo | in | out | cache |
| :--- | --: | --: | --: |
| Gemini 4 Argon | $4 | $20 | $0,20 |
| Kimi K3 | $3 | $15 | — |
| Kimi K2.7 Code | $0,95 | $4 | **$0,19** |
| **DeepSeek V4.1 Flash** | $0,15 | $0,60 | **$0,003** ← o mais barato |
| Beam Free | $0 | $0 | $0 |

> 💡 O `cache read` decide a conta em prompt longo: **DeepSeek $0,003 vs Argon $0,20 = 66×**. E o custo real de uma fatia de volume no DeepSeek fica em **~$1,1**.

## 5. A fronteira do **Executor** (não negociável)
O erro mortal é o modelo barato **decidir** porque é rápido.

| ✅ FAZ | ⛔ NÃO FAZ |
| :--- | :--- |
| Fan-out/recon: varrer vault e `game/`, mapear, resumir | **Decidir arquitetura** (camadas, colisão, navgraph) → Argon |
| Edições mecânicas: renomear + atualizar **todos** os wikilinks, substituições em lote, normalizar tabelas, atualizar boards | **Inventar regra/número no vault** — ele *aplica* decisões, não as toma |
| **`tools/`** (Node/JS): validadores, ponte de dados, solvers | **GDScript com API ambígua** (risco de inventar método) → Kimi/Argon |
| Relatórios (`RELATORIO-*.md`) consolidando o que os outros fizeram | Tocar em **`game/addons/`** (ninguém toca) |
| Rodar a verificação e resumir: `script_check`, `--headless`, `npm run validate`, `node tools/export-data.mjs` | Ser o **revisor final** do próprio código → Kimi K3 |
| Fatias mecânicas com spec fechada (ex.: P3 dano/HUD) | Assinar decisão de design no `DESIGN`/`DATA` |
| Testes headless em `game/tests/` a partir de spec clara | — |
| Housekeeping: `.gitignore`, assety, `.gdignore` | — |

## 6. Fluxo de uma fatia
```
Argon    → lê o vault, decompõe, escreve o critério de aceite verificável
Kimi     → implementa o GDScript de risco
DeepSeek → faz o resto (recon, edits mecânicos, tools/, relatório, roda a verificação)
Kimi K3  → revisa o diff (modelo ≠ autor)
Argon    → valida contra a spec e fecha (ou manda voltar)
```

## 7. Anti-padrões
- Usar o **mesmo modelo** como autor e revisor (viés de auto-revisão).
- Colocar **Preview/quota promocional** no caminho crítico de trabalho de vários dias.
- Gastar **Argon** (440 req) em varredura/boilerplate.
- Deixar o **Executor** tomar decisão de arquitetura ou de design.
- Esquecer de **conferir a quota** antes de uma maratona (estourar no meio da fatia é caro).
- Escolher o programador por benchmark de **conhecimento** em vez do benchmark do **loop** (o nosso é MCP).

## 8. Casos de Borda
- **Quota estourada** → baixe a variante (`high`→`medium`), faça o recon no Executor e retome.
- **Modelo indisponível** → o fluxo é degradável: Argon→Kimi K3 no scaffolding; Kimi→Step 5 no código.
- **Modelo novo melhor** → revalidar §3 com o mesmo critério (§2) e atualizar este doc.
- **Tarefa que o Executor errou** → **escale** (não repita o mesmo modelo): vira fatia de Programador/Orquestrador.

## 9. Evidência (por que estas escolhas)
| Modelo | Evidência |
| :--- | :--- |
| Gemini 4 Argon | **#1 Vals Index (68,9%)** · GraphWalks **84,2%** (contexto longo) · **alucinação 15%** (a menor do mercado) · ⚠️ perde em *coding agêntico* (Terminal-Bench 4.0 57,4% × Opus 66,4) |
| Kimi K2.7 Code | **#1 MCP Mark (81,1%)** — o benchmark do *nosso* loop · **SWE-bench Verified 78,2%** (#1 open-weight) · Terminal-Bench 2.1 67,0% |
| DeepSeek V4.1 Flash | **cache read $0,003** (o mais barato) → ideal para muitos turnos/contexto grande |
| Kimi K3 | Kimi Code Bench v2 **72,9%** (melhor da linha) — revisor de alto nível |

> Fontes: Vals AI, Artificial Analysis, Scale Labs, AnotherWrapper, benchlm, The Batch/DeepLearning.AI, docs do Google (out/2026).

## 10. Relacionado
- Manifesto: [[CONTEXT-000 Manifesto|CONTEXT-000]] · Licenças/asset: [[CONTEXT-016 Assets|CONTEXT-016]].
- Método de prompt (orquestrador + critério de aceite): skill `prompt-authoring` (`.opencode/skills/prompt-authoring/`).
