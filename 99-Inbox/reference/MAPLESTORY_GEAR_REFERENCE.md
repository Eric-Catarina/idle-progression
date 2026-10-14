# Referência: Equipamentos do MapleStory (jogo de origem)

> **ARQUIVO DE REFERÊNCIA BRUTO — NÃO faz parte do design do Progression Idle.**
> ⚠️ **NÃO deve ser carregado por IAs** salvo quando estivermos trabalhando em **Equipamentos / Potential / Star Force** (ver `01-Design/DESIGN-028 Equipamentos.md`).
> Fonte: *MapleStory* (Nexon) + comunidade (WSE Calculator). Texto informativo capturado do usuário.
> Objetivo: inspirar a **fidelidade** do nosso sistema de stats/Potentials (pedido: "praticamente idêntico ao MapleStory").

---

## 1. WSE — quais linhas "pegam" na arma

Armas + **Secondary** + **Emblem** formam o grupo **WSE**. Neles, linhas exclusivas são muito mais valiosas que linhas de status comuns (STR% etc.).

| Prioridade | Linha | Por quê |
| :--- | :--- | :--- |
| 1º | **Attack %** (ou Magic Attack %) | stat mais consistente; multiplica o Attack base, que é uma das maiores variáveis |
| 2º | **Boss Damage %** | ótimo contra chefes; soma no mesmo bloco de `Damage %` |
| 3º | **Ignore Defense % (IED)** | crucial no endgame; retorno **decrescente** (cálculo multiplicativo) |

- **Ordem geral:** Attack % > Boss Damage % > IED %.
- No início, **qualquer** dessas linhas é melhor que qualquer linha de status (STR/INT/DEX/LUK).
- **Status % (STR/DEX/INT/LUK):** muito menos eficazes **na arma** que na armadura/acessório → buscar `21% STR` etc. em **armadura/acessório**.
- **Rank do Potential** (Rare/Epic/Unique/Legendary) determina **quanto** cada linha dá.

---

## 2. Fórmula de dano (multiplicativa)

`Dano Final ≈ (Dano Base) × (Mult. de Stat) × (Mult. de Attack %) × (Mult. de Dano Total) × (Mult. de IED)`

1. **Attack %** (WSE): multiplicador **direto** sobre o Attack base. Funciona contra mobs **e** chefes → mais consistente.
2. **Dano Total (`Damage %` + `Boss Damage %`)**: as duas **somam no mesmo bloco** (aditivo). Ex.: 100% Damage + 50% Boss = **+150%** (não ×1.5 duas vezes). → **retorno decrescente**; por isso Attack % domina no endgame.
3. **IED**: **não** soma — é **multiplicativo** e reduz a defesa (PDR) do alvo pelo que **resta**. Pouco IED → ganho enorme; muito IED → ganho pequeno.

**Regra de ouro:** evitar acumular só um tipo de bônus — **equilibrar** os blocos.

---

## 3. Star Force

Progressão de atributos (STR/DEX/INT/LUK/HP…) com Mesos.

- **Até 15★:** custo relativamente baixo, risco gerenciável.
- **A partir de 16★:** começa a ganhar **Attack/Magic Attack** por estrela (escala com o **nível do item**).
- **A partir de 12★:** existe risco de o item ser **destruído** (exceto em níveis de proteção).
- **Após 15★:** falhas podem **derrubar** o nível da estrela.

**Por que 20 → 21★ é um marco:**
1. **Ganho massivo de ATT/MA** — a partir de 16★ cada estrela soma Attack que escala com o nível do item; o 20→21 é um dos maiores incrementos individuais fora de itens de endgame extremo. Multiplicado por todos os equipamentos, o ganho de *Final Damage* é enorme.
2. **"Settle" (ponto de ouro):** **21★** = item extremamente forte com custo acessível; **22★** = máximo de eficiência, mas custo desproporcional (duas sucessões seguidas com risco de destruição).
3. **Economia (Reboot):** chegar a 21★ num set completo destrava chefes de nível muito maior → acelera o farm de Mesos.

**Dica:** nunca tentar 21★+ sem **spares** e sem evento tipo *Shining Star Force* (chance aumentada) — o risco de perder o item é real.

---

## 4. Padrões observáveis (para inspirar o nosso design)

- Três **ranks/raridades** por linha de Potential (Rare/Epic/Unique/Legendary) → nós usamos **6** (escala de raridade própria).
- Linhas de **Attack %** existem quase só no WSE; **status %** vive em armadura/acessório.
- Blocos **aditivos** dentro do mesmo tipo (`Damage %` + `Boss Damage %`) e **multiplicativos** entre blocos.
- **IED** sempre multiplicativo e com retorno decrescente.
- Star Force: **custo**, **sucesso**, **queda de ★** e **destruição** — com **breakpoints** (15★, 21★, 22★).
