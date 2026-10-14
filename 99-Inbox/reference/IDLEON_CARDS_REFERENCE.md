# Referência: Cartas do IdleOn (jogo de origem)

> **ARQUIVO DE REFERÊNCIA BRUTO — NÃO faz parte do design do Progression Idle.**
> ⚠️ **NÃO deve ser carregado por IAs** salvo quando estivermos trabalhando em **Cartas** (ver `01-Design/DESIGN-016 Cartas.md`).
> Fonte: *IdleOn* (LavaFlame2) — wiki de Cards. Captura **simplificada** (mecânicas + 1 set de exemplo). A tabela exaustiva de cartas fica de fora para economizar espaço.
> Objetivo: servir de inspiração quando formos expandir as cartas além do **Mundo 1**.

---

## Mecânicas (texto do jogo)

Monsters and resources sometimes drop cards! Your card collection is shared by all your characters, and you can equip different combinations of cards onto each character! Collect enough of the same card, and it will Level Up! It's bonus will go up, and it'll get a shiny new border! Cards that you have not gotten at least one copy of will have a much more significant chance of dropping!

- **Levels 1, 2, 3, 4, 5** are unlocked at the beginning. A level 4 card can be immediately upgraded to a level 5 card with the **4 Star Cardifier** in the Gem Shop.
- **Level 6 (5-star Ruby Cards)** unlocked by reaching **Rift 46** (completing Rift 45) from The Rift. A level 5 card can be directly upgraded to level 6 with the **5 Star Cardifier** found occasionally in the Limited Specials section of the Gem Shop, even if it has not been unlocked from The Rift.
- **Level 7 (6-star Majestic Cards)** unlocked from the third tunnel in Spelunking.

### Card Sets
Once you have collected a number of cards within a set, you can equip the set to gain a bonus. Like standard cards, a card set is equipped at the **character-**, not account-level.

The number of cards you have collected within a set, **weighted by stars** on each card, determines the tier of the set. A card with no stars counts as 1 card, with its value increasing by one for each star rank: bronze cards count for 2, silver for 3, gold for 4, platinum for 5, and ruby for 6.

Once this star-weighted count is equal to the next multiple of the total number of cards in the set, the set reaches the next tier, and the set's bonus is magnified.

Example: the Yum-Yum Desert set (as of 1.30) consists of 14 cards. Collecting 4 cards to bronze star level, 2 cards to default level, and one to gold level yields a star-weighted count of `4*2 + 2*1 + 1*4 = 14`, sufficient to equip the set. Increasing to 28 (2*14) increases the set's tier.

### Loot Filter
Under the Card Set button is a loot filter docket where you can select up to **16 items to ignore** from the droptables (doesn't affect the chance to get any other items). To add an item, find it within the droptable of one of your collected cards and, while having the filter list open, click on the item. To remove, click it from the filter list.

### Presets
Once you reach **level 15** on a character, you unlock **2 card presets**. Presets allow you to set cards and easily swap between them. Initially each preset has **4 card slots** unlocked, with 4 more purchasable from the Gem Shop. You can unlock **5 more card presets** in the Gem Shop. (As of 2.03, presets are cross-platform cloud saved.)

### Passive Cards
Some cards state `(Passive)` or `(P)` at the end of their bonus. These bonuses are always in effect once you collect the cards. They don't require being equipped to give their bonus, and equipping will not give extra bonuses.

---

## Estrutura dos grupos de carta (categorias de set)

- Blunder Hills · Yum Yum Desert · Easy Resources · Medium Resources · Frostbite Tundra · Hard Resources · Hyperion Nebula · Smolderin' Plateau · Spirited Valley · Shimmerfin Deep · Dungeons · Bosses · Event

---

## Exemplo de set — Blunder Hills

Formato de cada carta: `Nome` / `Base <valores por star>` / `Dropchance` / `+{Bônus por tier}` / `Tier Requirements`.

| Carta | Dropchance | Bônus (por tier) | Tier Requirements |
| :--- | :--- | :--- | :--- |
| Green Mushroom | 1 in 500 | `+{12 per tier}` Base HP | 5/15/25/80/2.3K/73.3K |
| Red Mushroom | 1 in 10 | `+{3 per tier}` Base LUK | 10/30/50/160/4.59K/147K |
| Frog | 1 in 333 | `+{10 per tier}` Base MP | 6/18/30/96/2.76K/87.9K |
| Bored Bean | 1 in 250 | `+{7 per tier}` Base Damage | 7/21/35/112/3.22K/103K |
| Slime | 1 in 20 | `+{2 per tier}` Base WIS | 8/24/40/128/3.68K/118K |
| Baby Boa | 1 in 43.5 | `+{1 per tier}` Move Spd | 9/27/45/144/4.14K/132K |
| Carrotman | 1 in 50 | `+{2 per tier}` Base AGI | 10/30/50/160/4.59K/147K |
| Glublin | 1 in 55.6 | `+{2 per tier}%` Total HP | 10/30/50/160/4.59K/147K |
| Wode Board | 1 in 50 | `+{2 per tier}` Base STR | 10/30/50/160/4.59K/147K |
| Gigafrog | 1 in 100 | `+{5 per tier}%` Card Drop Chance | 10/30/50/160/4.59K/147K |
| Poop | 1 in 16.7K | `+{10 per tier}%` Crystal Mob Spawn Chance | 10/30/50/160/4.59K/147K |
| Rat | 1 in 20K | `+{1 per tier}%` Critical Chance | 10/30/50/160/4.59K/147K |
| Nutto | 1 in 20K | `+{5 per tier}%` Money from Monsters | 10/30/50/160/4.59K/147K |
| Crystal Carrot | 1 in 100 | `+{5 per tier}%` Total Drop Rate | 3/9/15/48/1.38K/44K |

Set Bonus do grupo: `+XP% if Below lvl 50` → 8 / 16 / 24 / 32 / 40 / 48.

---

## Padrões observáveis (para inspirar o nosso design)

- **Formato do bônus:** `+{X per tier} <Stat>` (flat) ou `+{X per tier}% <Stat>` (percentual) — cresce **linearmente com o tier**.
- **Tier Requirements** costumam ser **exponenciais** (ex.: `7/21/35/112/3.22K/103K`).
- **Sequência de tiers** por carta é fixa (definida por carta), variando de 3 a 6 upgrades.
- **Sets** dão bônus **multiplicativo** por tier do set, ponderado por stars.
- **Efeitos** cobrem quase tudo: stats base, %, dano, drop, EXP, AFK, skills, e **passivos**.
