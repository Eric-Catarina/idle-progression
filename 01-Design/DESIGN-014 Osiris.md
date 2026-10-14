---
id: DESIGN-014
aliases:
  - DESIGN-014
title: "Osíris (Golem dos Cristais)"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Mecânica transversal do Mundo 1; enterprise idle com prestígio próprio, mas o core loop valida sem ela.
dependencies:
  - "[[DESIGN-003 Mundo 1|DESIGN-003]]"
  - "[[DESIGN-013 Selos|DESIGN-013]]"
data_spec: "[[DATA-003 Osiris Curvas|DATA-003]]"
---

# [DESIGN-014] Osíris (Golem dos Cristais)

> **Mecânica Transversal #2 do [[DESIGN-003 Mundo 1|DESIGN-003]] (Mundo 1).**
> Modelo: *enterprise* idle de **Orion/penas** (Idleon) reescrito para o Golem. Inspiração do confronto: **Muto** (Chu-Chu Island, *MapleStory*).

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** Progressão permanente com prestígio próprio; enriquece muito, mas o core loop valida sem ela (F2).
- Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].

## 1. Visão & Propósito
**Osíris**, um deus caído, é restaurado por fragmentos e passa a **produzir Cristais**. Você investe os Cristais em melhorias; no prestígio, ele enfrenta **Vorax** — volta destruído, mas traz um **Megacristal** permanente (que resiste ao prestígio; **5 no total**). *(Lore propositalmente leve.)*

## 2. Loop Principal
```text
Golem produz Cristais (idle)
        │
        ▼
Comprar melhorias (Geração, Multiplicador, Barateador…)
        │
        ▼
Reinício de Cristal (reset barato)  ──► multiplicador 3^(resets+1)
        │
        ▼  (limiar alto)
O Grande Reinício (prestígio) = CONFRONTO DIVINO
        ├─ Golem volta DESTRUÍDO (reset quase total)
        └─ +1 MEGACRISTAL (permanente)  ← 5 no total
```

## 3. Contrato Funcional (I/O)
- **Tick:** `crystals += generation × dt` (offline via Catch-up analítico).
- **Comprar melhoria:** `crystals -= cost(L)` → `L++`.
- **Reinício de Cristal:** reseta upgrades/cristais → `multiplier = 3^(resets+1)`.
- **O Grande Reinício:** reseta quase tudo → `megacrystals.add(1)` (permanente).

## 4. A Empresa de Cristais (árvore de melhorias)

| Melhoria | Desbloqueio (Cristais) | Efeito |
| :--- | :--- | :--- |
| **Geração de Cristal** | 100 | Gera `{1 por nível}` cristal/s |
| **Bônus do Golem** | 1 K | Bônus permanente no jogo real (rotativo — §5); **nunca reseta** |
| **Multiplicador de Cristal** | 2.5 K | `+{5 por nível}%` de geração |
| **Barateador de Cristal** | 30 K | Melhorias ficam `%` mais baratas |
| **Reinício de Cristal** | 750 K | Reseta upgrades/cristais → gera `{3^(resets+1)}×` Cristais |
| **Produção de Super Cristal** | 10 M | `+{5 por nível}` cristais/s |
| **Cristais Brilhantes** | 250 M | Chance rara de **Cristal Brilhante**; cada um `+{1 por nível}%` geração |
| **Super Barateador** | 5 B | Melhorias `{20 por nível}%` mais baratas |
| **O Grande Reinício** | 100 B | Reset quase total → **+1 Megacristal** permanente |

> **Impulso de Essência:** gastar **Essência** ([[DESIGN-035 Essencia|DESIGN-035]]) ativa um **acelerador temporário** de geração (`gen × mult` por `T`) — o sink de essência do Osíris ([[DATA-012 Essencia Custos|DATA-012]] §2.3).

## 5. Bônus do Golem (rotativo)
Cada nível concede **um** bônus, na ordem, ciclando (modelo Orion):

| Ordem | Bônus por nível |
| :--- | :--- |
| 1 | +5% Class XP |
| 2 | +10 Dano Base |
| 3 | +2% Dano Total |
| 4 | +4% Skill XP |
| 5 | +1% Drop Rate |
| 6 | +2 Todos os Stats |

## 6. O Grande Reinício (Prestígio / Confronto Divino)
- **Gatilho:** cristais acumulados ≥ limiar do confronto ([[DATA-003 Osiris Curvas|DATA-003]]).
- **Resultado:** reseta geração/melhorias (mantém **Megacristais** e **Bônus do Golem**).
- **Recompensa:** **+1 Megacristal** (na ordem — §7).
- **Narrativa:** Osíris enfrenta **Vorax** (adversário recorrente) e volta em pedaços, com o Megacristal.
- **Escalação:** o limiar cresce a cada confronto (5 no total); **Vorax é sempre o mesmo**.

## 7. Os 5 Megacristais (permanentes, resistem ao prestígio)
| # | Megacristal | Efeito |
| :--- | :--- | :--- |
| 1 | **Cristal Primordial** | `×10` em **toda** a geração de Cristais (multiplicativo) |
| 2 | **Cristal Gêmeo** | Dobra os **Bônus do Golem** |
| 3 | **Cristal Divino** | Bônus do Golem passam a **5×** |
| 4 | **Cristal do Artífice** | Custo da **Geração de Cristal** sobe 25% mais devagar |
| 5 | **Cristal Fractal** | Bônus do Golem passam a **6×**; +0,5× por Grande Reinício adicional |

> Tema adaptado do "Megafeather" do Idleon. Nomes são proposta — trocáveis para condizer com a lore final.

## 8. Casos de Borda
- Overflow de cristais (BigNumber).
- Comprar no limiar exato do confronto (guardar para o próximo ciclo).
- Offline longo: explosão de cristais → **Catch-up** analítico (não simular tick a tick).
- Reinício de Cristal vs Grande Reinício (o barato não dá Megacristal).

## 9. UI/UX e Feedback
- Estatuária do Golem que **se recompõe** por estágio; a "fábrica" de cristais pulsa.
- Confronto: cutscene curta; retorna destruído + Megacristal.

## 10. Ganchos para o Futuro
- Pós-5 Megacristais: escala infinita (Should/Could).
- Amarração com os **Selos** ([[DESIGN-013 Selos|DESIGN-013]]): dois eixos permanentes do Mundo 1.

## 11. Relacionados
- Mundo: [[DESIGN-003 Mundo 1|DESIGN-003]] · Selos: [[DESIGN-013 Selos|DESIGN-013]] · Curvas: [[DATA-003 Osiris Curvas|DATA-003]].
