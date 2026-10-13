---
id: DESIGN-015
aliases:
  - DESIGN-015
title: "A Constelação (Mapa Estelar)"
type: system-design
subtype: mechanic
status: Draft
moscow: Should
moscow_note: Mecânica transversal do Mundo 1; tecido conjuntivo da progressão, mas o core loop valida sem ela.
dependencies:
  - "[[DESIGN-003]]"
  - "[[DESIGN-005]]"
  - "[[DESIGN-013]]"
  - "[[DESIGN-014]]"
data_spec: "[[DATA-004]]"
---

# [DESIGN-015] A Constelação (Mapa Estelar)

> 🗄️ **ARQUIVADO (não usar no jogo atual).** Ideia de signos/constelação guardada para o futuro — a Mecânica Transversal #3 do Mundo 1 virou **Cartas & Pacotinhos**.

> **Mecânica Transversal #3 do [[DESIGN-003]] (Mundo 1).**
> Referências (ver `99-Inbox/reference/STAR_MECHANICS_REFERENCE.md`): **Grim Dawn** (mapa de constelações + afinidade), **ESO** (ramos), **Skyrim** (UI de estrelas + signos).

## 0. Prioridade MoSCoW
- **Categoria:** Should
- **Justificativa:** É o "tecido conjuntivo" que amplifica todas as outras alças, mas o core loop valida sem ela (F2).
- Ver [[CONTEXT-001]].

## 1. Visão & Propósito
A terceira alça de progressão do Mundo 1: você ganha **Pontos Estelares (PE)** e **acende nós** num mapa de constelações. Cada constelação pertence a um **ramo** — **Combate, Fortuna, Produção, Mobilidade** — e, ao ser **completada**, concede um **Poder de Constelação**. É o sistema que **conversa com todo o resto**: classes, Selos, Osíris e a meta espacial de mapas.

## 2. Como Funcionam
- **Pontos Estelares (PE):** ganhos por **nível**, por **Grande Reinício** ([[DESIGN-014]]) e por **conquistas**.
- **Nós:** custam PE e concedem bônus pequenos e cumulativos.
- **Afinidade:** cada nó gera **afinidade** de um tipo; constelações exigem afinidade mínima (modelo Grim Dawn) → força escolhas de build.
- **Completar constelação:** concede um **Poder** (efeito forte e temático).
- **Respec:** refundir PE — grátis fora de combate (proposta); a definir.
- **Signos (opcional):** um **Signo ativo** escolhido por vez (modelo Skyrim), respecável; dá um bônus grande com leve trade-off.

## 3. Os 4 Ramos

| Ramo | Conversa com | Foco |
| :--- | :--- | :--- |
| **Combate** | Classes (Bossing/Mobbing/Suporte) | dano, crítico, área, suporte |
| **Fortuna** | Selos ([[DESIGN-013]]) | drop rate, fragmentos, raridade |
| **Produção** | Osíris ([[DESIGN-014]]) | cristais/s, custo, offline |
| **Mobilidade** | Meta espacial ([[DESIGN-006]]) | movimento, alcance vertical/horizontal, dash |

## 4. Constelações (exemplo)

| Ramo | Constelação | Nós (bônus) | Poder ao completar |
| :--- | :--- | :--- | :--- |
| Combate | **A Fera** | +dano, +área | +% de dano em **AoE** (Mobbing) |
| Combate | **O Caçador** | +crítico, +precisão | +% de dano em **alvo único/Boss** (Bossing) |
| Fortuna | **A Moeda** | +drop rate | +% de **drop** geral |
| Fortuna | **A Colheita** | +fragmentos/selos | +% de chance de **Fragmento Raro** |
| Produção | **A Forja** | +cristais/s | +% de **geração de Cristais** |
| Produção | **O Relojoeiro** | +offline | +% de **ganhos offline** |
| Mobilidade | **O Vento** | +velocidade | +% de **velocidade de movimento** |
| Mobilidade | **A Escalada** | +alcance vertical | +dano/alcance em **mapas verticais** |

> Valores em [[DATA-004]]. As constelações são o mapa que liga cada sistema do jogo a um eixo de progressão.

## 5. Contrato Funcional (I/O)
- **Gatilho:** ganhar PE (level-up / Grande Reinício / conquista).
- **Ação:** acender nó → `PE -= cost`; somar bônus de afinidade.
- **Completar constelação:** aplicar **Poder**; marcar constelação como concluída.
- **Respec:** devolver PE; recalcular bônus.

## 6. Casos de Borda
- PE insuficiente (nó bloqueado); afinidade insuficiente (constelação bloqueada).
- Respec durante o combate (a definir: bloqueado).
- Overflows de bônus (BigNumber).
- Offline: PE por nível do **catch-up** creditado uma vez.

## 7. UI/UX e Feedback
- **Mapa de estrelas interligadas**; nós apagados ↔ acesos; linhas de constelação brilham ao completar.
- Tooltip mostrando o **Poder** e a **afinidade** necessária.

## 8. Ganchos para o Futuro
- Novas constelações por **mundo** (Should/Could).
- **Signos** sazonais / rotativos.
- Amarração com os **Selos** e o **Osíris**: três eixos permanentes no Mundo 1.

## 9. Relacionados
- Mundo: [[DESIGN-003]] · Classes: [[DESIGN-005]] · Selos: [[DESIGN-013]] · Osíris: [[DESIGN-014]] · Mapas: [[DESIGN-006]] · Curvas: [[DATA-004]].
