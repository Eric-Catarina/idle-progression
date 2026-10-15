---
id: SYSTEM-006
aliases:
  - SYSTEM-006
title: Dados Imutáveis & Carregamento
type: tech-spec
status: Draft
moscow: Should
moscow_note: O carregamento em si é Must; as otimizações (arrays planos, binário, ECS) são Should — não fazer antes de medir.
implements: "[[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]]"
dependencies:
  - "[[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]]"
  - "[[CONTEXT-014 Addons & Ferramentas|CONTEXT-014]]"
  - "[[DATA-006 Level Layout|DATA-006]]"
---

# [SYSTEM-006] Dados Imutáveis & Carregamento

## 1. Responsabilidade & Escopo
- Define **como os dados imutáveis** do jogo (níveis, tabelas de odds/curvas) são **carregados** e **representados em memória**.
- Origem: `game/data/**` — **gerado** do vault por `tools/export-data.mjs` ([[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]] §6).
- **Não** define as *regras* (essas vivem em `DESIGN`/`DATA`).

## 2. A pergunta: existe "Blob" no Godot?
**Não.** O `BlobAssetReference<T>` da Unity (DOTS) existe porque DOTS usa **structs unmanaged** em memória contígua serializada na cena. No Godot:
- **GDScript não tem structs unmanaged** — o modelo é objetos/Variants (com GC e "boxing").
- O Godot é uma engine de **scene tree/objetos**, não *data-oriented*. **Não há ECS nem Blob nativos.**
- Um Blob de verdade exigiria **GDExtension (C++/Rust)** → conflita com o alvo **web + Android** e com "preferir GDScript" ([[CONTEXT-014 Addons & Ferramentas|CONTEXT-014]] §1).

## 3. O que o Godot **tem** (e basta)
| Recurso | O que é | Uso nosso |
| :--- | :--- | :--- |
| **Packed arrays** (`PackedInt32Array`, `PackedFloat32Array`, `PackedVector2Array`…) | Buffer **contíguo** tipado — o "array plano" de verdade | **Grade do nível** (índice `y*cols + x`) |
| **`PackedByteArray`** | Blob **binário cru** | Buffer pré-compilado (gancho) |
| `var_to_bytes` / `bytes_to_var` · `StreamPeerBuffer` | (De)serialização binária | Save state / cache binário |
| **`Resource`** (`.tres`/`.res`) | Dado carregável, com **cache** por caminho | Configs imutáveis (gancho) |
| `ResourceLoader.load_threaded_request/get` | Carrega **em thread** (não trava o frame) | Nível grande / boot |
| `ResourceLoader.CACHE_MODE_REUSE` | Mesmo caminho → **mesma instância** | Compartilhar dado imutável |
| `Dictionary`/`Array` **tipados** (4.4+) | Coleções tipadas | Tabelas pequenas (odds, curvas) |
| `WorkerThreadPool` | Paralelismo para preparar dados | Conversão JSON → packed |

## 4. Por que **não** precisamos de ECS/Blob (agora)
1. **Volume pequeno:** o maior nível é `55×45 = 2.475` ints; as tabelas têm **dezenas** de linhas. Cabe folgado.
2. **Leitura rara:** carrega **uma vez** no boot e em eventos (troca de nível) — **não** por frame.
3. **O custo do idle não é varrer dados:** é **matemática escalar** (BigNumber/catch-up), não *cache miss*.
4. **Complexidade ≠ benefício:** ECS muda o paradigma de todo o `sim/` — caro, sem ganho medido.

## 5. O plano (o que fazer de fato)
- **`DataDB`** (autoload, [[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]]): carrega `data/levels/*.json` + `data/tables/*.json` **uma vez** no boot.
- **Grade → `PackedInt32Array` plano:** `grid[y*cols + x]`. Sem `Array[Array[int]]` (elimina indireção e 1 array por linha).
- **Tabelas → `Dictionary` pequeno** (ex.: `data-015.json` de pets).
- **Imutabilidade por contrato:** o `DataDB` expõe **leitura**; quem precisa mutar **duplica** (`duplicate()`). Nunca mutar o dado carregado ([[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]] §6).
- **Zero alocação por frame:** buffers reusados; sem `new` no `_process`.
- **Gancho:** no build, **pré-compilar** os JSONs em **`.res`/binário** (`bytes_to_var`) → boot mais rápido que parsear texto.

## 6. Pontos de Extensão & Escalabilidade (Should Futuro)
- **ECS (se hordas/summons explodirem):** **Godex** (GDScript, 1.4k★) — única opção **GDScript puro** (compatível com web). Flecs exige **GDExtension** (C++) → evitar pelo alvo web.
- **Blob binário:** `PackedByteArray` + `StreamPeerBuffer` para um buffer cru pré-compilado (colisão estática do nível, tabelas).
- **Structs unmanaged (C++/Rust):** só se o alvo **web** for revisto.
- **Regra:** só adotar após **medir** (Profiler) — não por estética.

## 7. Decisão
- **Nada de ECS/Blob no protótipo.** Carregar via `DataDB` + **arrays planos** + dicionários tipados resolve.
- O caminho de crescimento (`Godex`, blob binário) fica **documentado como seam**, não implementado ([[CONTEXT-001 MoSCoW|CONTEXT-001]] §6).

## 8. Relacionados
- Estrutura/integridade: [[CONTEXT-012 Estrutura do Projeto Godot|CONTEXT-012]] · Addons: [[CONTEXT-014 Addons & Ferramentas|CONTEXT-014]].
- Layout/tiles: [[DATA-006 Level Layout|DATA-006]] · Escala numérica: [[CONTEXT-004 Notacao Numerica|CONTEXT-004]].
