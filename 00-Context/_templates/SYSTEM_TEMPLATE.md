---
id: SYSTEM-XXX
aliases:
  - SYSTEM-XXX
title: Nome do Módulo Técnico
type: tech-spec
status: Draft | Approved | Done
moscow: Must | Should | Could | Wont
moscow_note: Herda a prioridade do DESIGN que implementa, salvo exceção justificada.
implements: "[[DESIGN-XXX]]"
dependencies: []
---

# [SYSTEM-XXX] Nome do Módulo Técnico

## 1. Responsabilidade & Escopo
- O que este componente de software gerencia.

## 2. Padrões de Projeto & Algoritmos
- Padrão arquitetural (ex: State Pattern, Event Bus, ECS, A* NavGraph).

## 3. Contratos de Dados & Interfaces (TypeScript)
```typescript
// Interfaces estritas de entrada, saída e estado
```

## 4. Fluxo de Execução no Game Loop
- Passo a passo de processamento dentro do ciclo de tick / FixedUpdate.

## 5. Pontos de Extensão & Escalabilidade (Should Futuro)
- Seams, interfaces plugáveis ou eventos que permitem adicionar features `Should`/`Could` futuras sem refatoração estrutural.
- **Não** implementar a feature futura — apenas expor o ponto de extensão. Ver [[CONTEXT-001 MoSCoW|CONTEXT-001]].
