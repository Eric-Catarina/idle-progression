---
id: DESIGN-005
aliases:
  - DESIGN-005
title: "Sistema de Classes & Especialização"
type: system-design
subtype: system
status: Spec Ready
moscow: Should
moscow_note: Camada de progressão da F2; o core loop valida com a classe Genérica.
dependencies:
  - "[[CONTEXT-006 Hierarquia|CONTEXT-006]]"
---

# [DESIGN-005] Sistema de Classes & Especialização

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** O core loop (mover → lutar → acumular → prestigiar) valida com a classe Genérica. A escolha de classe é profundidade de progressão (F2). Ver [[CONTEXT-005 Roadmap|CONTEXT-005]].
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
Organizar a identidade de combate do personagem em **três camadas** (Genérica → Base → Especialização), com uma **rota secreta** para quem domina o jogo "sem classe". Resolve o problema de "toda build vira igual" dando escolhas por papel (Boss/Mob/Suporte).

## 2. Faixas de Progressão (Gates)

| Faixa de nível | Estágio | Classe |
| :--- | :--- | :--- |
| **0–14** | Novo | **Genérica** (sem classe) |
| **15–49** | Base | **Guerreiro** \| **Arqueiro** \| **Mago** |
| **50–200** | Especialização | Base × { **Bossing**, **Mobbing**, **Suporte** } |
| — | **Secreta** | Desbloqueada ao atingir nível 50 **permanecendo Genérico** |

- O gate é por **nível**. Os limites (`15`, `50`, `200`) são constantes de design.
- As curvas de XP e os multiplicadores por classe → [[DATA-XXX]].

## 3. Contrato Funcional (I/O)
- **Gatilho:** `level` atinge um gate (15 ou 50).
- **Pré-requisitos:** `level >= gate` e escolha pendente.
- **Saída:** `player.class` atualizado; stats/skills da nova classe aplicados; persistido.

## 4. Lógica Passo a Passo
1. No level-up, checar gates (`15`, `50`).
2. Ao atingir **15**: abrir prompt de **Base** (Guerreiro/Arqueiro/Mago). A escolha pode ser **adiada** — o jogador permanece **Genérico**.
3. Ao atingir **50 com Base**: abrir prompt de **Especialização** (3 opções da Base).
4. Ao atingir **50 sem Base** (ainda Genérico): desbloquear a **Classe Secreta**.
5. Aplicar stats/multiplicadores/skills da classe escolhida.

## 5. Matriz de Especializações

| Base | Bossing | Mobbing | Suporte |
| :--- | :--- | :--- | :--- |
| **Guerreiro** | Guerreiro Bosser | Guerreiro Mobber | Guerreiro Suporte |
| **Arqueiro** | Arqueiro Bosser | Arqueiro Mobber | Arqueiro Suporte |
| **Mago** | Mago Bosser | Mago Mobber | Mago Suporte |

**Semântica:**
- **Bossing** — dano em alvo único / burst.
- **Mobbing** — dano em área / limpeza de hordas.
- **Suporte** — buffs, invocações, sobrevivência.

## 6. Classe Secreta
- **Nome:** _(a definir)_ — ex: "Inominado", "Andarilho".
- **Desbloqueio:** atingir nível **50** mantendo a classe **Genérica** (nunca escolher Base).
- **Fantasia:** recompensa por mastery do jogo "puro" (sem muletas de classe).

## 7. Casos de Borda
- **Gate atingido offline (catch-up):** pausar a progressão de nível e exigir a escolha quando o jogador voltar.
- **Respec:** definir regra (irreversível ou pago) — a definir.
- **Escolher Base depois do 50:** a Classe Secreta **deixa de ser** obtenível.
- **Overflow de nível:** `level` como BigNumber.

## 8. UI/UX e Feedback
- Tela de escolha com **cards** e preview de skills por especialização.
- **Badge** de classe no HUD.

## 9. Ganchos para o Futuro
- Cada classe pode virar um **nó filho** deste DESIGN (`parent` → [[DESIGN-005 Classes|DESIGN-005]]), com suas skills como netos (ver [[CONTEXT-006 Hierarquia|CONTEXT-006]]).
- **Sub-especializações** pós-200 (Should/Could).

## 10. Parâmetros
- Curvas de XP por faixa, multiplicadores por papel → [[DATA-XXX]].

## 11. Organização de Arquivos (Skills por Classe)
As skills de cada classe vivem em subpastas sob `01-Design/`:

```text
01-Design/classes/
├── generica/                 # classe Genérica (nível 0–14)
├── secreta/                  # classe secreta
├── guerreiro/
│   ├── bosser/  ├── mobber/  └── suporte/
├── arqueiro/
│   ├── bosser/  ├── mobber/  └── suporte/
└── mago/
    ├── bosser/  ├── mobber/  └── suporte/
```

- Regra: `01-Design/classes/<base>/{bosser,mobber,suporte}/DESIGN-XXX_nome.md`.
- Skills ainda **não atribuídas** a uma classe ficam na raiz de `01-Design/` (ex: mecânicas como [[DESIGN-012 Jump Dash|DESIGN-012]]).
- Mover é seguro: os vínculos usam o **ID** (`[[DESIGN-XXX]]`), não o caminho.
