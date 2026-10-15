---
id: CONTEXT-008
aliases:
  - CONTEXT-008
title: Escala Visual (Fibonacci / Proporção Áurea)
type: context-convention
scope: global
status: Active
version: 1.0.0
last_updated: 2026-10-13
dependencies:
  - "[[CONTEXT-000 Manifesto|CONTEXT-000]]"
tags:
  - context
  - convention
  - visual
  - proportions
---

# 📐 [CONTEXT-008] Escala Visual (Fibonacci / Proporção Áurea)

## 1. Propósito

Unificar as **proporções visuais** do jogo (UI, níveis, cartas, sprites, espaçamentos, durações) numa base harmônica: a **sequência de Fibonacci** e a **proporção áurea (φ ≈ 1.618)**. Objetivo: tudo parecer "coeso" sem esforço.

> **Escopo:** é uma convenção de **camada de render (visual)**. **Não** governa lógica/simulação — quando o gameplay exigir um valor específico, **o gameplay vence**.

## 2. A Escala (Fibonacci)

Use estes números para **tamanhos, espaçamentos, margens, raios e durações**:

```text
5 · 8 · 13 · 21 · 34 · 55 · 89 · 144 · 233 · 377 …
```

- **Espaçamento/margens/raios (px):** 5, 8, 13, 21, 34…
- **Tamanhos (px):** 13, 21, 34, 55, 89, 144…
- **Durações (ms):** 89, 144, 233, 377, 610…

## 3. Proporções Áureas

| Uso | Razão | Exemplo |
| :--- | :--- | :--- |
| Composição / blocos | **φ ≈ 1.618** | larguras 34/21, 55/34, 89/55 |
| Retângulo "áureo duplo" (widescreen) | **φ² ≈ 2.618** | **grade de nível 55×21** |
| Divisões de UI | φ em cascata | painel principal + lateral |

## 4. Aplicações no Projeto
- **Grade de nível:** padrão **55×21** (φ²), célula **21**.
- **UI:** espaçamentos/margens na escala Fibonacci; painéis com proporção φ.
- **Footer / HUD:** footer **89** px (F11), padding **8** px (F6), botões/ícones **34 · 55 · 89** ([[CONTEXT-010 UI de Jogo|CONTEXT-010]] §3b).
- **Cartas/ícones/sprites:** dimensões Fibonacci (ex: 21×34, 34×55, 55×89).
- **Animações:** durações em ms Fibonacci-ish (ex: 233ms de abertura de pacote).

## 5. Limites / Boas Práticas
- É **guia**, não dogma: se um valor "quebrar" o Fibonacci e ficar melhor, use-o.
- **Não** aplicar à simulação (dano, custos, curvas, probabilidades) — isso é domínio dos `DATA`.
- Prefira **números Fibonacci** a "φ puro" em medidas de pixel (são discretos e práticos).

## 6. Relacionado
- [[CONTEXT-000 Manifesto|CONTEXT-000]] — Manifesto mestre.
- [[CONTEXT-007 Raridades|CONTEXT-007]] — Visual/cor por raridade (usa esta escala para tamanhos/ui).
