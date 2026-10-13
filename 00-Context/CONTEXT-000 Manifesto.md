---
id: CONTEXT-000
aliases:
  - CONTEXT-000
title: AI Agent Manifest & System Directives
type: context-manifest
scope: global
status: Active
version: 1.3.0
last_updated: 2026-10-12
tags:
  - context
  - ai-instructions
  - architecture
  - governance
---

# 🤖 [CONTEXT-000] AI Agent Manifest & Global Directives

> **AVISO CRÍTICO PARA AGENTES DE IA (MCP / IDE / AGENTS):**
> Este é o arquivo mestre de contexto do projeto **Progression Idle**.
> Antes de criar, modificar especificações ou gerar código para este repositório, você **DEVE** processar, respeitar e seguir rigorosamente todas as regras, contratos e convenções estabelecidos neste manifesto.

---

## 1. Visão Geral do Projeto

* **Título:** *Progression Idle*
* **Gênero:** Incremental / Idle Game com movimentação e combate em plataformas 2D (estilo estético/mecânico inspirado em MapleStory).
* **Core Loop:** O personagem navega por plataformas estáticas via *tap-to-move*, combate monstros que patrulham plataformas, acumula recursos numéricos exponenciais, desbloqueia upgrades, escala multiplicadores e realiza prestígios matemáticos.
* **Paradigma de Engenharia:** **Headless Simulation First**. Toda a física, progressão temporal, cálculos matemáticos e estado existem independentemente da camada de renderização visual.

---

## 2. Topologia do Vault (Arquitetura do Conhecimento)

A documentação é dividida em **4 pilares obrigatórios** via pastas e IDs indexados:

```text
📁 / (Raiz do Vault)
├── 📁 00-Context/       -> [CONTEXT-XXX] Manifestos, convenções, glossário e governança.
│   ├── 📁 _templates/   -> Templates oficiais (DESIGN, SYSTEM, DATA, CONTEXT, SKILL, LEVEL, MECHANIC).
│   └── 📄 CONTEXT-005 Roadmap.md -> [CONTEXT-005] Fases de entrega (MVP -> Vertical Slice -> Escala).
├── 📁 01-Design/        -> [DESIGN-XXX] GDD de baixo nível. `subtype`: system | skill | level | mechanic.
│   ├── 📄 DESIGN-000 Board MoSCoW.md -> Board de priorização (fonte de verdade MoSCoW).
│   ├── 📁 classes/      -> Skills por classe: <base>/{bosser,mobber,suporte}/ (+ generica, secreta).
│   └── 📁 backlog/      -> [DESIGN-XXX] Features "Could" (MoSCoW) guardadas para o futuro.
├── 📁 02-Architecture/  -> [SYSTEM-XXX] Arquitetura de Software, Design Patterns, TDD e ADRs.
├── 📁 03-Data/          -> [DATA-XXX] Fórmulas, curvas de escala, tabelas de dados e schemas JSON.
├── 📁 99-Inbox/         -> Ideias brutas (BRAINSTORM_STREAM.md). Consolidação via Modo C.
│   └── 📁 reference/    -> Dumps de referência de outros jogos. NÃO carregar salvo quando relevante.
└── 📁 tools/            -> Scripts de controle do vault (validate-vault.mjs).
```

### Regras de Vinculação Bidirecional (Wikilinks)

- Nenhuma especificação de sistema (DESIGN) existe sem referenciar seu suporte técnico (SYSTEM) e matemático (DATA).
- Formato padrão de referência cruzada: [[DESIGN-XXX]], [[SYSTEM-XXX]], [[DATA-XXX]], [[CONTEXT-XXX]].
- Cada documento declara seu próprio ID como `alias` no frontmatter, para que os wikilinks curtos (`[[CONTEXT-001]]`) resolvam corretamente no Obsidian.
- Hierarquia usa o campo `parent` (*parte-de*), não um wikilink solto: ver [[CONTEXT-006]].

---

## 3. Protocolos de Atuação da IA

Você atuará em dois modos possíveis dependendo do comando do usuário:

### Modo A: "Specifier / Architect" (Criação de Documentação)

Quando o usuário trouxer ideias, mecânicas ou ajustes conceituais:

1. **Decomponha** a ideia nos pilares cabíveis: nunca misture regra de negócio (DESIGN) com implementação de engine (SYSTEM) ou balanceamento bruto (DATA).
2. **Elimine abstrações e "hand-waving":** É proibido usar termos vagos como "o monstro toma um dano razoável" ou "o pulo funciona dependendo da altura". Especifique valores exatos, limites em pixels, janelas em milissegundos e fórmulas.
3. **Mapeie sempre os 3 caminhos:**
   - Happy Path (execução nominal).
   - Failure Path (o que ocorre quando falha, recurso insuficiente, input inválido).
   - Edge Cases (spam de clique, limites da tela, troca de cena, números gigantes/overflow).
4. **Classifique a prioridade (MoSCoW):** Todo documento `DESIGN` e `SYSTEM` **deve** declarar `moscow` no frontmatter conforme [[CONTEXT-001]]. O escopo do protótipo é **apenas Must + Should**. Features `Could` vão para `01-Design/backlog/` com `status: Backlog` e **não** geram código.
5. **Crie os arquivos** seguindo estritamente os templates oficiais da seção 6 deste documento (ou copie de `00-Context/_templates/`).
6. **Decomposição proativa:** extraia elementos citados de passagem (ex: uma skill mencionada como exemplo) e crie/atualize os documentos correspondentes (`DESIGN`/`SYSTEM`/`DATA`) — sem esperar ser solicitado.

### Modo B: "Implementer / Coder" (Geração de Código)

Quando o usuário solicitar a implementação de uma funcionalidade:

1. **Ordem Obrigatória de Leitura:**
   - Leia primeiro o DESIGN-XXX da feature para entender o comportamento esperado e as regras de borda.
   - Leia o SYSTEM-XXX associado para respeitar os Design Patterns, interfaces e fluxo de eventos.
   - Leia o DATA-XXX para utilizar as fórmulas matemáticas exatas e tipos de dados.
2. **Contrato de Arquitetura:**
   - NÃO misture lógica de jogo com código de interface ou visual.
   - Mantenha a simulação desacoplada para suportar cálculos de progresso offline instantâneos.
   - Utilize bibliotecas de precisão numérica arbitrária (BigNumber / BreakEternity) para qualquer variável que escale exponencialmente.
3. **Respeite a Prioridade:** Não implemente features `Could` ou `Wont`. Ao tocar um módulo `Must`/`Should`, exponha os pontos de extensão previstos para features `Should` futuras **sem** implementá-las (ver [[CONTEXT-001]] §6).

### Modo C: "Inbox Processor" (Consolidação de Ideias Brutas)

Quando solicitado a processar itens da pasta `99-Inbox/`:
1. **Identificação:** Procure notas com status `pending` ou itens de checkbox `- [ ]` não marcados.
2. **Resolução de IDs:** Verifique os últimos IDs existentes em `01-Design/`, `02-Architecture/` e `03-Data/` para gerar os próximos números sequenciais corretos (ex: se o último foi `DESIGN-003`, o próximo é `DESIGN-004`).
3. **Decomposição:**
   - Crie o(s) arquivo(s) `DESIGN-XXX` correspondente(s) em `01-Design/`.
   - Crie o(s) arquivo(s) `SYSTEM-XXX` correspondente(s) em `02-Architecture/`.
   - Crie o(s) arquivo(s) `DATA-XXX` correspondente(s) em `03-Data/`.
4. **Fechamento:**
   - Marque o checkbox como concluído `- [x]` no `BRAINSTORM_STREAM.md` e adicione o link gerado (ex: `- [x] Sistema de Runas -> [[DESIGN-004]]`).
   - Se for um arquivo solto, altere o frontmatter para `status: processed` e mova para `99-Inbox/_archive/`.

---

## 4. Convenções e Regras Inegociáveis do Projeto

1. **Notação de Multiplicadores na Interface:**
   - Conforme [[CONTEXT-002]], todos os bônus percentuais e multiplicadores exibidos ao usuário na UI devem seguir o formato estrito: x + valor com 2 casas decimais.
   - Exemplo: +5% → x1.05 | +100% → x2.00.
2. **Padrão de Nomenclatura de Arquivos:**
   - O nome do arquivo é `<ID> <nome_curto>.md` (ex: `DESIGN-001 Multi Personagens.md`); o `id`/`aliases` garante que os wikilinks curtos `[[ID]]` resolvam no Obsidian:
     - `DESIGN-001 Multi Personagens.md`
     - `SYSTEM-001 Kinematics.md`
     - `DATA-001 Speed Curves.md`
3. **Prioridade Obrigatória (MoSCoW):**
   - Todo documento `DESIGN-XXX` e `SYSTEM-XXX` **deve** declarar `moscow: Must | Should | Could | Wont` no frontmatter. Ver [[CONTEXT-001]].
   - O escopo do protótipo é **Must + Should**. `Could` é documentado no backlog sem código; `Wont` registra a exclusão consciente.
   - `DATA-XXX` herda a prioridade do seu `system`.
4. **Frontmatter YAML Obrigatório:**
   - Todo documento dos 4 pilares deve começar com frontmatter YAML contendo: `id`, `aliases` (com o próprio ID), `title`, `type`, `status`, `moscow` (em DESIGN/SYSTEM) e `dependencies`.
   - `DESIGN` declara também `subtype: system | skill | mechanic | campaign | world | level`.
   - Arquivos operacionais (raiz: `README.md`, `AGENTS.md`; e `99-Inbox/`) são isentos.
5. **Integridade de Referências (Renomear / Mover / Reordenar IDs):**
   - Sempre que um `ID`, nome de arquivo, pasta ou escopo de documento mudar, atualize **todas** as referências afetadas no mesmo passo: wikilinks (`[[...]]`), frontmatter (`dependencies`, `tech_spec`, `data_spec`, `implements`, `system`), o board [[DESIGN-000]], os templates de `00-Context/_templates/`, a skill `skills/progression-idle/SKILL.md` e o `AGENTS.md`.
   - Ao **trocar a ordem de dois IDs** (ex: `001` ⇄ `002`), nunca substitua em sequência — use um token temporário para evitar colisão durante a troca.
   - Nunca deixe um wikilink órfão: ao final, busque pelas referências antigas para confirmar que não sobrou nenhuma.
6. **Governança de Regras (onde registrar cada coisa):**
   - O `AGENTS.md` contém **apenas** diretrizes **transversais e sempre válidas** (paradigma, topologia, convenções globais). Nada **específico de feature** ou de uma regra isolada de jogo entra nele.
   - Toda nova demanda/regra deve ser registrada no local mais adequado: **transversal** → `AGENTS.md`; **específico** (feature, fórmula, convenção de domínio) → o documento correspondente no vault (`00-Context/`, `01-Design/`, `02-Architecture/`, `03-Data/`).
   - Convenções de domínio viram um documento `CONTEXT-XXX`; regras de uma feature vivem no `DESIGN`/`SYSTEM`/`DATA` dela.
7. **Ciclo de Vida das Ideias:**
   - Toda ideia segue o pipeline de [[CONTEXT-003]]: `raw → triaged → specified → prioritized → implemented | backlog`.
   - Captura em `99-Inbox/BRAINSTORM_STREAM.md`; consolidação pelo Modo C.
8. **Validação do Vault (obrigatória):**
   - Toda alteração deve passar por `npm run validate` (ou pelo hook de pré-commit em `.githooks/`), que verifica frontmatter, wikilinks órfãos, referências cruzadas e IDs.
9. **Formatação Numérica:**
   - Valores exponenciais seguem a escada de sufixos de [[CONTEXT-004]]: armazenar cru (BigNumber) e formatar apenas na exibição.
10. **Hierarquia & Decomposição:**
    - Todo nó pode ter `parent` único e `path`; a árvore segue [[CONTEXT-006]] (`parent` = *parte-de*, nunca vínculo de implementação).
    - Filhos herdam a prioridade (`moscow`) do pai, salvo override explícito.
11. **Escala de Raridade Única:**
    - Todos os sistemas (cartas, itens, potencial, monstros, mundos) usam a escala de [[CONTEXT-007]] (Comum→Divino). Nunca criar escalas paralelas; **pesos/odds** ficam no `DATA` de cada sistema.

---

## 5. Prioridade de Features (MoSCoW)

O projeto usa a técnica **MoSCoW** para decidir o que entra no protótipo e o que é guardado para o futuro. As regras completas vivem em [[CONTEXT-001]]; o estado consolidado vive no [[DESIGN-000]].

| Categoria | Papel no Protótipo | Destino |
| :--- | :--- | :--- |
| **Must** | Sem isso o core loop não é validável. Implementar. | `01-Design/` |
| **Should** | Agrega valor; implementar se houver tempo. Deixar gancho. | `01-Design/` |
| **Could** | Desejável, adiado. | `01-Design/backlog/` |
| **Wont** | Fora de escopo nesta fase. | Registrado no board |

**Regra transversal de escalabilidade:** todo `SYSTEM` que pode receber features `Should` futuras deve expor **pontos de extensão** documentados ([[CONTEXT-001]] §6), mas **nunca** implementar a feature futura especulativamente.

---

## 6. Templates Oficiais de Documentação

> Versões prontas para copiar em `00-Context/_templates/`. Os templates abaixo são a referência canônica.

### Template: Game Systems Design (DESIGN)

```yaml
---
id: DESIGN-XXX
aliases:
  - DESIGN-XXX
title: Nome da Feature
type: system-design
subtype: system | skill | mechanic | campaign | world | level
status: Draft | Spec Ready | Implemented | Backlog
moscow: Must | Should | Could | Wont
moscow_note: Justificativa curta da prioridade.
promote_when: "Somente para Could: condição que justifica promoção."
dependencies: []
tech_spec: "[[SYSTEM-XXX]]"
data_spec: "[[DATA-XXX]]"
---
```

```markdown
# [DESIGN-XXX] Nome da Feature

## 0. Prioridade MoSCoW
- **Categoria:** Must | Should | Could | Wont
- **Justificativa:** Por que esta categoria e não a vizinha.
- **Critérios de Promoção:** (obrigatório para Could)
- Ver [[CONTEXT-001]].

## 1. Visão & Propósito
- O que é a feature em termos funcionais e qual problema de game design ela resolve.

## 2. Contrato Funcional (I/O)
- **Gatilho / Input:** O que dispara a ação (ex: clique na coordenada X/Y, colisão, tick).
- **Pré-requisitos de Estado:** Condições necessárias para execução.
- **Saída / Modificação de Estado:** O que muda no estado global do jogo.

## 3. Lógica Passo a Passo
- Fluxo determinístico do algoritmo em lista enumerada.

## 4. Casos de Borda & Tratamento de Erros
- O que ocorre nos extremos, inputs rápidos simultâneos ou falha de pré-requisitos.

## 5. UI/UX e Feedback
- Animações, feedbacks sonoros, efeitos visuais e apresentação de dados.

## 6. Ganchos para o Futuro (Should/Could)
- Pontos de extensão que esta feature deve deixar prontos para não exigir refatoração depois.
```

### Template: Technical Architecture (SYSTEM)

```yaml
---
id: SYSTEM-XXX
aliases:
  - SYSTEM-XXX
title: Nome do Módulo Técnico
type: tech-spec
status: Draft | Approved | Done
moscow: Must | Should | Could | Wont
moscow_note: Herda a prioridade do DESIGN que implementa, salvo exceção justificada.
implements: "[[DESIGN-XXX]]"
dependencies: []
---
```

```markdown
# [SYSTEM-XXX] Nome do Módulo Técnico

## 1. Responsabilidade & Escopo
- O que este componente de software gerencia.

## 2. Padrões de Projeto & Algoritmos
- Padrão arquitetural (ex: State Pattern, Event Bus, ECS, A* NavGraph).

## 3. Contratos de Dados & Interfaces (TypeScript)
\`\`\`typescript
// Interfaces estritas de entrada, saída e estado
\`\`\`

## 4. Fluxo de Execução no Game Loop
- Passo a passo de processamento dentro do ciclo de tick / FixedUpdate.

## 5. Pontos de Extensão & Escalabilidade (Should Futuro)
- Seams que permitem adicionar features Should/Could futuras sem refatoração estrutural.
- NÃO implementar a feature futura — apenas expor o ponto de extensão.
```

### Template: Data & Economy (DATA)

```yaml
---
id: DATA-XXX
aliases:
  - DATA-XXX
title: Nome da Estrutura de Dados
type: data-spec
status: Draft | Balanced
moscow: Herda de [[SYSTEM-XXX]] (declarar apenas se divergir)
system: "[[DESIGN-XXX]]"
---
```

```markdown
# [DATA-XXX] Nome da Estrutura de Dados

## 1. Variáveis Base & Constantes
- Listagem dos valores primários sem modificadores.

## 2. Formulação Matemática
- Fórmulas analíticas explícitas.

## 3. Schema de Configuração (JSON)
\`\`\`json
{
  "id": "config_example"
}
\`\`\`

## 4. Tabela de Simulação
| Nível / Ponto | Valor Calculado | Formatação UI |
| :--- | :--- | :--- |
```

### Templates de Domínio (variantes de DESIGN)

- `_templates/CAMPAIGN_TEMPLATE.md` — raiz da árvore de conteúdo.
- `_templates/WORLD_TEMPLATE.md` — mundos (agrupam níveis).
- `_templates/LEVEL_TEMPLATE.md` — níveis (layout, população, desbloqueio).
- `_templates/SKILL_TEMPLATE.md` — habilidades (ativação, targeting, escalonamento).
- `_templates/MECHANIC_TEMPLATE.md` — mecânicas transversais.

Todos usam `id: DESIGN-XXX` com o campo `subtype` correspondente.

---

## 7. Glossário Semântico do Projeto

| Termo | Definição no Contexto deste Jogo | Uso Proibido / Incorreto |
| :--- | :--- | :--- |
| **Headless Simulation** | Simulação de lógica que roda pura em memória sem renderizador ou DOM. | Não confundir com backend em nuvem (roda local no client ou worker). |
| **One-Way Platform** | Plataforma que permite passagem livre de baixo para cima e suporte ao pisar. | Não chamar de "piso sólido". |
| **Tap-to-Move** | Sistema onde o destino é apontado via toque e o caminho é traçado por Grafo de Nós. | Não confundir com teletransporte ou joystick virtual. |
| **Knockback** | Impulso horizontal aplicado a monstros em X ao sofrerem dano de habilidades. | Não é animação cosmética; altera a posição física e pode derrubá-los de plataformas. |
| **Catch-up Simulation** | Cálculo temporal acumulado quando o jogo passa tempo em segundo plano/offline. | Não rodar 60 frames por segundo simulados no carregamento; usar fórmulas analíticas de acúmulo. |
| **Must have (MoSCoW)** | Feature sem a qual o core loop não é validável. Escopo bloqueante do protótipo. | Não classificar como Must por vaidade; na dúvida, é Should. |
| **Should have (MoSCoW)** | Feature importante que agrega valor, mas o protótipo funciona sem. | Não é "Must disfarçado"; não bloqueia a entrega. |
| **Could have (MoSCoW)** | Feature desejável e adiada; documentada no backlog, sem código. | Não confundir com "descartada" — ela é guardada para o futuro. |
| **Won't have (MoSCoW)** | Feature explicitamente fora de escopo nesta fase. | Não é "talvez"; é uma exclusão consciente e documentada. |
| **Backlog** | Pasta `01-Design/backlog/` com designs `Could` congelados até promoção. | Não é lixeira; é fila de promoção. |
| **Ponto de Extensão (Seam)** | Gancho de arquitetura que permite encaixar uma feature Should/Could futura sem refatoração. | Não é implementação especulativa da feature futura. |
| **Subtype (DESIGN)** | Variante de um DESIGN: `system`, `skill`, `level` ou `mechanic`. | Não cria prefixo de ID próprio; o ID continua `DESIGN-XXX`. |
| **Vertical Slice (F2)** | Fase onde uma zona inteira é polida (`Should`). | Não confundir com o MVP (`Must`). |
| **Hierarquia (parent)** | Relação *parte-de*; no máximo um `parent` por nó. | Não confundir com `implements`/`tech_spec` (vínculo de implementação). |
| **Campanha** | Nó raiz da árvore de conteúdo (subtype `campaign`). | Não é uma feature; é a estrutura. |
| **Mundo** | Agrupador de níveis (subtype `world`), ex: 5 níveis cada. | — |
| **Nível** | Unidade de conteúdo 2D (subtype `level`): layout + desbloqueio. | Não confundir com nível de personagem/upgrade. |
| **Selo (Stamp)** | Upgrade passivo permanente dropado de mobs; account-wide. Ver [[DESIGN-013]]. | Não confundir com "bribe" (buff comprado). |
| **Cartas & Pacotinhos** | Coleção com raridades; 3ª mecânica transversal do Mundo 1. Ver [[DESIGN-016]]. | — |
| **Raridade** | Escala única reutilizável (6 tiers: Comum→Divino). Ver [[CONTEXT-007]]. | Não criar escalas de raridade paralelas por sistema. |

---

### Como usar este arquivo:

1. No seu Obsidian, as pastas `00-Context/`, `01-Design/`, `02-Architecture/`, `03-Data/` e `99-Inbox/` já existem.
2. Este manifesto é a nota `00-Context/CONTEXT-000 Manifesto.md`.
3. As instruções para agentes vivem no `AGENTS.md` (raiz, carregado automaticamente em todo prompt) e na skill `skills/progression-idle/SKILL.md`:
   ```text
   Always read and adhere to 00-Context/CONTEXT-000 Manifesto.md before designing specs or writing game code.
   ```
4. Se usar Claude Code ou agentes via terminal, este documento servirá como contexto base de leitura obrigatória em qualquer prompt de inicialização.
