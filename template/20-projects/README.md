# 20-projects — Projetos Ativos

Cada subpasta é um projeto com contexto próprio, prazo e objetivo definido.
Diferente dos domínios, projetos têm começo, meio e fim.

## Como criar um projeto

1. Crie uma subpasta com o nome do projeto: `federated-memory/`, `site-redesign/`
2. Crie um `PROJECT.md` na raiz do projeto com o contexto essencial
3. Arquive o projeto quando concluído (mova para `_archived/`)

## Estrutura sugerida por projeto

```
20-projects/
└── nome-do-projeto/
    ├── PROJECT.md        ← contexto, objetivo, prazo, stakeholders
    ├── decisions/        ← decisões tomadas e motivos
    ├── notes/            ← notas de reunião, pesquisa, rascunhos
    └── _archived/        ← versões antigas, descartados
```

## Template de PROJECT.md

```markdown
# [Nome do Projeto]

**Objetivo:** [uma frase]
**Prazo:** [data ou milestone]
**Status:** em andamento / pausado / concluído

## Contexto
[O que é, por que existe, quem está envolvido]

## Decisões tomadas
[Liste decisões importantes já fechadas — não reabrir sem motivo]

## Próximos passos
[O que falta fazer]

## O que não fazer
[Restrições, anti-patterns identificados, caminhos descartados]
```
