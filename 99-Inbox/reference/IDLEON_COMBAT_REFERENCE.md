# ⚔️ Referência: Combate & Talents do IdleOn (números exatos)

> **Dump de referência.** Ler **só** ao trabalhar em combate/skills/progressão. Fonte: `idleon.wiki` (Game Mechanics Combat, Game Mechanics, Warrior) — consultado **2026-10-16**. Nosso design: [[DESIGN-036 Skills & Fila de Skills|DESIGN-036]], [[DATA-018 Skills|DATA-018]].

## 1. Warrior — talents básicos (NÚMEROS EXATOS)
| Talent | Mana | **Action Time** | **Cooldown** | Efeito (fórmula exata) |
| :--- | --: | --: | --: | :--- |
| **Power Strike** | 3 | **0,45 s** | **3 s** | Slash à frente: `{130 + 3/nível}%` de dano em até **2** monstros |
| **Whirl** | 5 | **0,45 s** | **5 s** | Gira em volta: `{60 + 1,5/nível}%` em até `{5 + 1 a cada 40 níveis}` monstros |
| **Firmly Grasp It** | 5 | **1,5 s** | **30 s** | Buff: `+{15 + 1/nível}` STR base por `{2 + 1 a cada 4 níveis}` **minutos** |
| **Big Pick** | 10 | 1,5 s | 12 s | (mining — fora de escopo) |
| **Double Strike** | — | passivo | — | Ataque básico: `{110 × nível ÷ (50+nível)}%` de chance de **acertar 2×** |
| **Critikill** | — | passivo | — | `+{52 × nível ÷ (50+nível)}%` de **Crit Damage** |
| **Meat Shank** | — | passivo | — | `+{100 × nível ÷ (80+nível)}%` de dano **por potência de 10 de Max HP** |
| **Idle Brawling** | — | passivo | — | `+{20 × nível ÷ (50+nível)}%` de ganho AFK de luta |
| **Strength In Numbers** | — | passivo | — | Efeito da STR em dano/HP `+{0,75/nível}%` |

> **Ritmo de referência:** ataque básico = **"Weapon Speed"** (não tabelada na wiki); ability = **Action Time 0,45 s** + cooldown próprio.

## 2. Dano — fórmulas EXATAS
```
MaxDmg = [ (1/9) × WP² + FlatDmgBonus ] × Damage_%        # WP = Weapon Power
minDmg = Mastery × MaxDmg                                  # Mastery base 35%, cap 80%
```
- **Fontes de `Damage_%` multiplicam entre si** (não somam): `XX × (1,25) × (1,50) = XX × 1,875`.
- **Crítico** = Mastery base **35%** → minDmg 35% do max.
- **Dano do stat principal:** `1 + (stat^0.7)/100` (em teste na wiki).

## 3. Dano **recebido** — fórmula EXATA
```
DanoTomado = floor( 0,6 + (Attack − 2,5 × Defense^0,8) / (1 + Defense^2,5 / Attack / 100) )
```
- **Se `Defense > Attack` do mob → dano = ZERO** (imune).
- **Comida cura** com cooldown de **30 s**.
- Referências de Defence: **40** tanka o Mundo 1 · **180** o Mundo 2 · **2.000** o Mundo 3.

## 4. Morte / respawn
> *"Insta Res **uma vez por dia**; ou **respawn na town de graça**."*
- → **Morrer = voltar para a town (hub), de graça** ✅ (é o comportamento que vamos copiar)

## 5. Mana
- Regenera **1% do máximo por segundo** (`1 a cada 100 de Mana máx.`).
- Escala com **WIS**; talvez o custo de habilidade.

## 6. Stats principais (mapa por classe)
| Classe | Stat principal | Stat de **acurácia** | Secundário dá |
| :--- | :--- | :--- | :--- |
| **Warrior** | STR | WIS | +Crit Damage, +HP |
| **Archer** | AGI | STR | +Crit Chance, +velocidade |
| **Mage** | WIS | AGI | +Boss Damage, +Mana |
| **Beginner** | LUK | — | +drop, +Class XP |

## 7. Acurácia / chance de acerto
```
HitChance(%) = 142,5 × SuaAcc ÷ AccReq − 42,5      # mínimo 5%; abaixo disso = 0%
```

## 8. Spawn & ritmo de mobilidade
- **"A cada 0,5 s, os monstros se movem na sua direção"** ⇒ o tick de movimento de mob do IdleOn é **0,5 s** ✅
- **Spawn Rate** é um stat **%** (Merits até **+20%**, Star Sign Grim Reaper **+2%**).
- **Kill Caps**: existe uma tabela de "mortes/hora com spawn rate no máximo, 100% AFK" (não extraída).

## 9. O que **NÃO** achamos (nem no IdleOn)
| Item | Situação |
| :--- | :--- |
| **Weapon Speed base exata** | Não tabelada. **Nosso solver já assume `1/0,7 s`** → é o valor que vamos usar |
| **Tempo de respawn de mob** | Não tabelado. Estimativa: **1,5 s** |
| **Teto de dano por linha** | Não é mecânica do IdleOn — é **nossa** ([[DESIGN-037 Linhas de Dano\|DESIGN-037]]). Estimativa: **1.500** |
| **Action Time do ataque básico** | Não tabelado; usa "Weapon Speed" |

## 10. Relacionado
- Nosso combate: [[DESIGN-036 Skills & Fila de Skills|DESIGN-036]] · [[DESIGN-031 Calculo de Dano|DESIGN-031]] · [[DESIGN-037 Linhas de Dano|DESIGN-037]].
- Dados: [[DATA-009 Dano|DATA-009]] · [[DATA-014 Populacao Mundo 1|DATA-014]] · [[DATA-018 Skills|DATA-018]].
- Decisões: [[CONTEXT-018 Decisoes de Implementacao|CONTEXT-018]].
