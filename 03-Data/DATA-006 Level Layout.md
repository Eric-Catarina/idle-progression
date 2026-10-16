---
id: DATA-006
aliases:
  - DATA-006
title: "Level Layout (Schema & Níveis)"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-004 Level1_0|DESIGN-004]]"
dependencies:
  - "[[DESIGN-004 Level1_0|DESIGN-004]]"
  - "[[DESIGN-017 Interactables & Hub|DESIGN-017]]"
---

# [DATA-006] Level Layout (Schema & Níveis)

> Schema do JSON exportado pelo **editor de nível** (`tools/level-editor.html`). Os níveis brutos ficam em `03-Data/levels/`.
> **Convenção de nome do nível:** `Level<world>_<level>` (ex.: `Level1_0`, `Level1_2`) para fases normais, e **`Level<world>_Boss<N>`** para **fases de chefe** (ex.: `Level1_Boss1`).

## 1. Schema do Nível (JSON)
| Campo | Tipo | Descrição |
| :--- | :--- | :--- |
| `name` | string | nome do nível |
| `cols` / `rows` | int | dimensões da grade (padrão **55 × 21**, φ²) |
| `cellSize` | int | tamanho da célula em px (só visual, padrão 21) |
| `legend` | obj | mapa `id` → nome do tile |
| `grid` | int[][] | matriz `rows × cols` de ids de tile |
| `interactables` | `{x,y,slot}[]` | camada de entidades (NPCs/estações) |

### Legend de tiles (atual)
| id | Tile |
| :--- | :--- |
| 0 | Vazio |
| 1 | Plataforma |
| 2 | Portal Intrafase (amarelo) |
| 3 | Parede/Sólido |
| 4 | Portal Entrada |
| 5 | Portal Saída |
| 6 | Spawn Jogador |
| 7 | **Spawn Chefe** |

> **Tile `7` (Spawn Chefe):** marca **onde o chefe fica** na fase de chefe ([[DESIGN-041 Level1_Boss1|DESIGN-041]]). É um **ponto**, não uma plataforma — o chefe **não se move**.
> ⚠️ **Pendência:** adicionar a paleta do tile `7` no `tools/level-editor.html`.

> **Plataformas (id 1):** todas são **one-way** — atravessa de **baixo→cima** sempre, e de **cima→baixo** se quiser; **exceto a última linha (piso), que é sólida**. Ver [[DESIGN-023 Plataformas & Portais|DESIGN-023]].
> **Portal Intrafase (id 2):** teleporta para outro ponto da **mesma fase** (par em ordem de leitura).

### Ancoragem vertical do nível (footer)
- O nível é **ancorado pelo piso**: a **superfície da última linha** fica em **`F + P`** px acima do fundo da tela (`F` = footer 89, `P` = padding 8) — [[CONTEXT-010 UI de Jogo|CONTEXT-010]] §3b.
- Consequência: mapas **baixos** (21 linhas) encostam o piso acima do footer; mapas **verticais** (ex.: `Level1_4` 25×45) sobem e a **câmera** acompanha, com o **limite inferior** no topo do footer.
- Nenhum tile pode ser **desenhado/colidido abaixo** do topo do footer.

## 2. Níveis
| Arquivo                 | Nível   | Papel                   |
| :---------------------- | :------ | :---------------------- |
| `levels/Level1_0.json` | **Level1_0** | **Hub** (NPCs/estações) |
| `levels/Level1_1.json` | **Level1_1** | Raízes/solo — **Lesma** |
| `levels/Level1_2.json` | **Level1_2** | Mata baixa — **Cogumelo** + NPC `selos` |
| `levels/Level1_3.json` | **Level1_3** | Mata média — **Vespão** + NPC `osiris` |
| `levels/Level1_4.json` | **Level1_4** | **Escalada no tronco** (vertical 25×45) — **Esquilo** + NPC `cartas` |
| `levels/Level1_5.json` | **Level1_5** | **Copa** — **Coruja** + chefe **Vorax** + Livro dos Contratos |
| `levels/Level1_Boss1.json` | **Level1_Boss1** | **Fase de chefe** — arena do **Vorax** ([[DESIGN-041 Level1_Boss1\|DESIGN-041]]) |

## 3. Level1_0 (Hub) — resumo
- **Dimensões:** 55 × 21.
- **Spawn:** `(2, 19)`. **Portal Saída:** `(53, 19)`. *(Hub não tem Portal Entrada — é o ponto inicial.)*
- **Interactables:** `osiris` `(15,8)` · `cartas` `(39,8)` · `selos` `(27,13)`.
- **Piso:** linha 20 inteira (Plataforma) + plataformas internas.

### Level1_1
- Spawn `(2,19)` · Portal Entrada `(1,19)` · Portal Saída `(53,19)`.

### Level1_2
- Spawn `(2,19)` · Portal Entrada `(1,19)` · Portal Saída `(53,19)` · NPC `selos` `(27,14)`.

### Level1_3
- 35×21 · Spawn `(2,19)` · Entrada `(1,19)` · Saída `(33,19)` · NPC `osiris` `(17,11)`.

### Level1_4
- 25×45 · **vertical** · Spawn `(2,43)` · Entrada `(1,43)` · Saída `(23,3)`.
- **Portal Intrafase:** `(12,2)` ↔ `(16,43)` (par).
- **Interactable:** `cartas` `(8,2)` — libera a UI de Cartas ([[DESIGN-016 Cartas|DESIGN-016]]).

### Level1_5
- 50×21 · **3 andares** · Spawn `(2,19)` · Entrada `(1,19)` · Saída `(48,19)`.
- **Portal Intrafase:** `(1,3)` ↔ `(44,19)` (par).
- **Fecha o Mundo 1** → libera o Mundo 2.

## 4. Relacionados
- [[DESIGN-017 Interactables & Hub|DESIGN-017]] — interactables & hub.
- [[DESIGN-004 Level1_0|DESIGN-004]] — design do nível.
