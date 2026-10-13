---
id: CONTEXT-001
aliases:
  - CONTEXT-001
title: MoSCoW Prioritization & Backlog Governance
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-12
dependencies:
  - "[[CONTEXT-000]]"
tags:
  - context
  - convention
  - priority
  - moscow
  - backlog
  - governance
---

# 🎯 [CONTEXT-001] MoSCoW Prioritization & Backlog Governance

## 1. Propósito

Definir **como o projeto decide o que fazer agora e o que guardar para o futuro**. Toda feature, sistema ou dado deve declarar sua prioridade usando a técnica **MoSCoW** (Must / Should / Could / Won't have). Isso impede que ideias ambiciosas (ex: vários personagens no mesmo mapa) atrasem a validação do core loop, sem descartá-las — elas ficam **documentadas e adiadas**, não esquecidas.

> **Regra de ouro:** O escopo do **protótipo** é composto **apenas** por itens `Must` e `Should`. Todo item `Could` vira um documento de design guardado no backlog. Todo item `Wont` fica documentado como fora de escopo para evitar retrabalho e ambiguidade.

## 2. As Quatro Categorias

| Categoria | Definição no Projeto | Política de Protótipo | Onde Vive |
| :--- | :--- | :--- | :--- |
| **Must have** | Sem isso o core loop **não é validável**. É o mínimo jogável: movimento, combate básico, progressão, prestígio. | **Implementar agora.** Bloqueia a entrega. | `01-Design/`, `02-Architecture/`, `03-Data/` |
| **Should have** | Importante e esperado, agrega valor real, mas o protótipo **funciona sem**. Ex: feedback visual, QoL, uma segunda habilidade. | **Implementar se o cronograma permitir.** Nunca bloqueia, mas o arquiteto deve **deixar o gancho** pronto. | `01-Design/`, `02-Architecture/`, `03-Data/` |
| **Could have** | Diferencial / desejável, mas não necessário para validar a hipótese. Ex: múltiplos personagens simultâneos no mapa. | **NÃO implementar.** Documentar o design e arquivar. Zero código. | `01-Design/backlog/` |
| **Won't have** (agora) | Explicitamente fora de escopo nesta fase. Ex: multiplayer online, 3D. | **Não implementar** — nem deixar gancho. Apenas documentar a exclusão. | Registrado no próprio DESIGN ou no board. |

## 3. Regras de Classificação

Ao receber uma ideia, faça estas perguntas **na ordem**:

1. **O protótipo falha na validação do core loop sem isso?** → `Must`.
2. **O protótipo funciona, mas fica claramente pior/mais lento de validar sem isso?** → `Should`.
3. **É desejável, mas pode esperar uma fase futura sem prejuízo da validação?** → `Could`.
4. **Está fora do escopo atual por decisão consciente (custo, risco, plataforma)?** → `Wont`.

> **Não existe "Must" por vaidade.** Se você hesita entre `Must` e `Should`, provavelmente é `Should`. Entre `Could` e `Wont`, escolha aquele que você documentaria hoje para não esquecer.

## 4. Frontmatter Obrigatório

Todo documento `DESIGN-XXX` e `SYSTEM-XXX` deve declarar a prioridade no frontmatter:

```yaml
moscow: Must | Should | Could | Wont
moscow_note: Justificativa curta de 1 linha.
```

Para itens `Could`, adicionar também o gatilho de promoção:

```yaml
promote_when: "Condição objetiva que justifica promover para Should."
```

`DATA-XXX` **herda** a prioridade do seu `system` — não declara `moscow` próprio, a menos que a estrutura de dados sirva a múltiplos sistemas com prioridades diferentes.

## 5. Política de Backlog (Could)

- Toda feature `Could` **deve** virar um documento `DESIGN-XXX` completo, não uma linha solta.
- Ele é salvo em **`01-Design/backlog/`** com `status: Backlog`.
- O documento **deve** conter uma seção **"Critérios de Promoção"** — o que precisa estar pronto/validado no core loop para que ela saia do backlog.
- Features `Could` **não** geram `SYSTEM` ou `DATA` até serem promovidas. Nenhum código especulativo.
- O design guardado serve como contrato congelado: quando promovido, ele é revisado, não reescrito do zero.

## 6. Escalabilidade para Should Futuro

Sistemas `Must` que podem receber features `Should` no futuro **devem expor pontos de extensão (seams)**, documentados no `SYSTEM-XXX` (seção 5 — *Pontos de Extensão*). Exemplos de seam: uma interface plugável de estratégia, um enum extensível, um evento publicado no barramento.

> **Proibido:** implementar a feature futura especulativamente "só para garantir". O gancho é **contrato e documentação**, não código morto. O objetivo é que a feature `Should` futura encaixe **sem refatoração estrutural**.

## 7. Fluxo de Promoção

```text
Could (backlog)  --promote_when atingido-->  Should  -->  Must
   │                                            │
   └── status: Backlog                          └── status: Spec Ready / Implemented
```

Ao promover um item:

1. Atualizar `moscow` no frontmatter do DESIGN.
2. Se estava em `backlog/`, mover o arquivo para `01-Design/` (o wikilink por basename permanece válido).
3. Criar/atualizar o `SYSTEM-XXX` correspondente (respeitando os pontos de extensão já existentes).
4. Criar/atualizar o `DATA-XXX` se houver novas fórmulas.
5. Atualizar o board [[DESIGN-000]].

## 8. Board de Prioridades

O estado consolidado de todas as features por categoria vive em **`01-Design/DESIGN-000.md`**. Consulte-o antes de criar qualquer novo DESIGN para evitar duplicidade.

## 9. Exemplos

| Ideia | Classificação | Motivo |
| :--- | :--- | :--- |
| Movimento tap-to-move | `Must` | Sem ele não há exploração nem posicionamento. |
| One-Way Platform | `Must` | Estrutura base do mapa de plataformas. |
| Combate básico + Knockback | `Must` | Núcleo do acúmulo de recursos. |
| Prestígio | `Must` | Fecha o core loop incremental. |
| Segunda habilidade ativa | `Should` | Enriquece combate, mas o protótipo valida com uma. |
| Múltiplos personagens no mesmo mapa | `Could` | Profundidade tática; não valida a hipótese central. → `backlog/`. |
| Multiplayer online | `Wont` | Fora de escopo nesta fase. |

## 10. Relacionado

- [[CONTEXT-000]] — Manifesto mestre.
- [[DESIGN-000]] — Board MoSCoW.
- [[CONTEXT-002]] — Notação de multiplicadores.
