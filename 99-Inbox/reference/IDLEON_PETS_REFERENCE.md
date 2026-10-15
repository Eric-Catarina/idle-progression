# 🐾 Referência: Pets no Legends of IdleOn

> **Dump de referência** (não é design nosso). Ler **somente** ao trabalhar no sistema de Pets.
> Fonte: `idleon.wiki/wiki/Pets` (verificado em 2026-10-15). Nosso design: [[DESIGN-038 Pets|DESIGN-038]].

## 1. O que é (IdleOn)
- **Pets são seguidores com bônus passivos account-wide** — o bônus fica **sempre ativo** para **todos** os personagens assim que obtido.
- Obtidos com **Doggy** (o corgi em Blunder Hills).
- **1 pull (tiro) grátis por dia.**

## 2. Chances dependem de "Pet Food" (tiers)
- Cada pet tem **chance por tier de comida** (Food 0→4). Comida melhor ⇒ mais chance.
  - Ex.: `King Doot` — 0.28% (Food0) → 0.85% (Food4); `Sheepie` — 11.11% → 27.04%.
- **Raridade do pet ≈ inverso da chance** (Doot raríssimo, Sheepie comum).

## 3. Recursos e sistemas satélites
| Elemento | Papel |
| :--- | :--- |
| **Pet Crystals** | Moeda **do sistema de pets**; obtida **reciclando** pets (não os grátis). |
| **Recycle** | Duplicata/pet reciclável → Crystals; reciclar a **última** cópia **remove o bônus** (exige confirmação). |
| **Upgrade Cost / Pet+** | Melhora o efeito do pet, pagando em Crystals. |
| **Pet Mart** | Loja que **vende pets** por Crystals. |
| **Tournament Power** | Estatística de força do pet (usada em torneios). |
| **Exclusive Pets** | Só por **trading/bundles/giveaway** (não saem no pull). |

## 4. Diferenças do **nosso** sistema (decididas pelo usuário)
| Aspecto | IdleOn | **Nosso** |
| :--- | :--- | :--- |
| Pull grátis | 1/dia | **1 tiro comum/dia** |
| Pull extra | — | **1 tiro épico/semana** |
| Sorte pelo tipo de pull | via Pet Food | **épico tem 20× mais chance nas raridades altas** |
| Topo da escala | (por chance) | **Divino: 1% fixo** no tiro épico |
| Compra | Crystals (fallback) | **compra com moeda premium** ([[CONTEXT-013 Moeda Premium|CONTEXT-013]]) |
| Raridades | por chance | **6 tiers** de [[CONTEXT-007 Raridades|CONTEXT-007]] |

## 5. O que **aproveitamos** como inspiração
- **Account-wide + sempre ativo** (bônus de coleção).
- **Pull diário grátis** (retenção).
- **Coleção com raridade** e dupes que viram recurso.
- Ciclo de longo prazo: **obter → colecionar → melhorar**.

> Elementos de IdleOn **não** adotados de primeira (ficam como gancho — ver DESIGN-038 §6): Pet+ (upgrade pago), Pet Mart, Tournament Power, Pet Food.
