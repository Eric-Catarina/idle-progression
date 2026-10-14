# Referência: Death Note / Multikill do IdleOn (jogo de origem)

> **ARQUIVO DE REFERÊNCIA BRUTO — NÃO faz parte do design do Progression Idle.**
> ⚠️ **NÃO deve ser carregado por IAs** salvo quando estivermos trabalhando em **Multikill / Livro dos Contratos** (ver `01-Design/DESIGN-033 Multikill.md` e `DESIGN-034 Livro dos Contratos.md`).
> Fonte: *IdleOn* (LavaFlame2). Texto informativo capturado do usuário.

---

## Death Note / Multikill

The **Death Note** is available from **World 3** through **Construction**. This mechanic allows collecting more resources by hitting **damage tiers above 100% of the monster's health** (similar to the *Prowess* effect for skilling).

- Only the **base resource** — the first one in the monster's drop table — is affected by the bonus. *Spore Cap* for Green Mushrooms, *Frog Legs* for Frogs, etc.
- Some items, such as the **Villager Statue** and **Dragon Warrior Statue**, are affected by multikill only via **AFK claims**.
- **Cards are not affected.**

Multikill bonuses also **increase kill count**, which helps **unlock portals**, get **Apocalypses** for Barbarians, and **scale the Death Note faster**. These **extra kills do not give additional experience or coins**.

- The Death Note **tracks the amount of kills of every mob from all characters**.
- **Points are awarded for each kill tier** that is achieved for each **individual type of monster**.
- **Each world has its own point total and multikill bonus.**
- **One point adds +1% Multikill per Damage Tier** to that world.

---

## Padrões observáveis (para inspirar o nosso design)

- **Damage tier** = quão acima de 100% do HP do mob o dano chega (200%, 300%…).
- **Só o recurso base** (1º drop) é multiplicado; secundários e **cartas** não.
- O multikill **aumenta a contagem de kills** (destrava coisas), mas **não** dá **XP nem moedas** extras.
- O tracker é **account-wide** e **por mundo** (pontos → bônus do mundo).
- **1 ponto = +1% Multikill per Damage Tier** no mundo.
