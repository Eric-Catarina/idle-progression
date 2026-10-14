---
id: DATA-006
aliases:
  - DATA-006
title: "Level Layout (Schema & Níveis)"
type: data-spec
status: Draft
moscow: Should
system: "[[DESIGN-004 Nivel 1-1|DESIGN-004]]"
dependencies:
  - "[[DESIGN-004 Nivel 1-1|DESIGN-004]]"
  - "[[DESIGN-017 Interactables & Hub|DESIGN-017]]"
---

# [DATA-006] Level Layout (Schema & Níveis)

> Schema do JSON exportado pelo **editor de nível** (`tools/level-editor.html`). Os níveis brutos ficam em `03-Data/levels/`.

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
| 2 | Plataforma one-way |
| 3 | Parede/Sólido |
| 4 | Portal Entrada |
| 5 | Portal Saída |
| 6 | Spawn Jogador |

## 2. Níveis
| Arquivo | Nível | Papel |
| :--- | :--- | :--- |
| `levels/level-1-1.json` | **1-1** | **Hub** (NPCs/estações) |

## 3. Nível 1-1 (Hub) — resumo
- **Dimensões:** 55 × 21.
- **Spawn:** `(2, 19)`. **Portal Saída:** `(53, 19)`. *(Hub não tem Portal Entrada — é o ponto inicial.)*
- **Interactables:** `osiris` `(15,8)` · `cartas` `(39,8)` · `selos` `(27,13)`.
- **Piso:** linha 20 inteira (Plataforma) + plataformas internas.

## 4. Relacionados
- [[DESIGN-017 Interactables & Hub|DESIGN-017]] — interactables & hub.
- [[DESIGN-004 Nivel 1-1|DESIGN-004]] — design do nível.
