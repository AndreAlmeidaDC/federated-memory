---
contract: agent-memory
version: 1.0
owner: "[SEU NOME]"
last-reviewed: "[DATA]"
---

# AGENT.md — Contrato de Memória

Este arquivo é o ponto de entrada para qualquer agente que acesse este vault.
Leia antes de qualquer outra coisa. Não assuma nada que não esteja aqui.

## Quem sou

[Escreva 2-3 frases sobre você: papel profissional, área de atuação, contexto geral.
Exemplo: Sou um engenheiro de software focado em sistemas distribuídos, trabalhando
remotamente no Brasil. Escrevo sobre tecnologia e construo ferramentas para times pequenos.]

## Como este vault está organizado

| Pasta | Conteúdo |
|---|---|
| `10-domains/` | Domínios de conhecimento estáveis (trabalho, escrita, aprendizado...) |
| `20-projects/` | Projetos ativos com contexto próprio e prazo |
| `30-context-packs/` | Pacotes de contexto por tarefa — use estes para carregar contexto |
| `40-agent-adapters/` | Instruções específicas por agente (Claude, GPT, Hermes...) |
| `50-inbox/` | Sugestões de memória pendentes de revisão humana |

## Regras de acesso

- **Leitura:** qualquer pasta é permitida
- **Escrita:** restrita a `/50-inbox/` — nunca escreva diretamente em outras pastas
- **Memória permanente:** só existe após revisão e aprovação humana explícita

## Como carregar contexto para uma tarefa

1. Identifique o domínio ou projeto relevante
2. Leia o Context Pack correspondente em `/30-context-packs/`
3. Siga as instruções de `Usar`, `Evitar` e `Fontes` do pack
4. Não carregue mais contexto do que o pack especifica

## O que fazer quando não encontrar contexto

Se não houver Context Pack para a tarefa:
- Use apenas o que estiver explicitamente no prompt do usuário
- Não invente contexto a partir de outras notas do vault
- Se identificar algo que deveria virar memória, escreva uma sugestão em `/50-inbox/`

## Sugestão de memória

Quando identificar algo que merece ser memorizado permanentemente, escreva em
`/50-inbox/suggested-memory.md` usando este formato:

```
## [DATA] — [DOMÍNIO]
**Sugestão:** [o que você quer registrar]
**Fonte:** [de onde veio essa informação]
**Confiança:** [alta / média / baixa]
```

Nunca escreva isso diretamente nas pastas de domínio. O humano revisa e decide.
