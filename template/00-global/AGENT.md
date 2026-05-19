---
contract: agent-memory
version: 2.0
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
| `00-global/` | Contrato neutro, instruções gerais, este arquivo |
| `10-projects/` | Projetos ativos com contexto próprio e prazo |
| `20-domains/` | Domínios de conhecimento estáveis (engenharia, escrita, pesquisa...) |
| `30-clients/` | Clientes e contexto comercial — candidato a vault físico separado |
| `40-workflows/` | Procedimentos repetíveis (como fazer X) |
| `50-skills/` | Capacidades reutilizáveis (técnicas, padrões aplicáveis) |
| `60-context-packs/` | Pacotes de contexto por tarefa — use estes para carregar contexto |
| `70-decisions/` | Decisões formais com status `approved` / `superseded` |
| `80-agent-adapters/` | Instruções específicas por agente (Claude, Cursor, Codex, Windsurf, Hermes...) |
| `90-inbox/` | Sugestões de memória pendentes de revisão humana |
| `99-archive/` | Logs, packs obsoletos, arquivos arquivados |

## Regras de acesso

- **Leitura:** liberada em todo o vault
- **Escrita permanente:** restrita a `/90-inbox/` — nunca escreva diretamente em outras pastas, em nenhum modo de execução (interativo, headless, agendado)
- **Memória permanente:** só existe após revisão e aprovação humana explícita

Essas regras são aplicadas pelo núcleo (Hermes ou equivalente), não delegadas ao agente. Se você se ver tentado a escrever fora de `/90-inbox/`, isso é um bug — pare e gere uma sugestão de inbox.

## Resolução de conflito de memória

Quando duas notas afirmam coisas conflitantes:

- **Vence** a entrada mais recente com `status: approved` no frontmatter (ou em um bloco DECISION explícito)
- Entradas com `status: superseded` permanecem no histórico para auditoria mas são **ignoradas em runtime**
- **Nunca infira o vencedor pelo timestamp do arquivo sozinho** — o `status` é obrigatório
- Em ausência de `status`, trate como `pending`: pergunte ao humano em vez de chutar
- Decisões formais vivem em `/70-decisions/` no formato documentado lá

O núcleo aplica essa regra ao montar o contexto. O agente recebe a versão vencedora, não o conflito.

## Como carregar contexto para uma tarefa

1. Identifique o domínio, projeto ou cliente relevante
2. Leia o Context Pack correspondente em `/60-context-packs/`
3. Siga as instruções de `Use:`, `Avoid:` e `Sources of truth:` do pack
4. Não carregue mais contexto do que o pack especifica

## O que fazer quando não encontrar contexto

Se não houver Context Pack para a tarefa:

- Use apenas o que estiver explicitamente no prompt do usuário
- Não invente contexto a partir de outras notas do vault
- Se identificar algo que deveria virar memória, escreva uma sugestão em `/90-inbox/`

## Sugestão de memória

Quando identificar algo que merece ser memorizado permanentemente, escreva em
`/90-inbox/suggested-memory.md` usando este formato:

```
## [DATA] — [DOMÍNIO]
**Sugestão:** [o que você quer registrar]
**Fonte:** [de onde veio essa informação]
**Confiança:** [alta / média / baixa]
**Destino sugerido:** [caminho da nota onde deveria ir]
```

Nunca escreva isso diretamente nas pastas de domínio. O humano revisa e decide via ritual semanal (`scripts/review-inbox.{sh,ps1}`).
