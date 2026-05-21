# AGENTS.md — Adaptador para Grok Build (xAI)

Este arquivo segue a convenção `AGENTS.md` adotada nativamente pelo Grok Build (xAI),
lançado em beta em maio de 2026. Grok Build lê `AGENTS.md` junto com plugins, hooks,
skills e MCP servers — este arquivo é o ponto de entrada para o contrato de contexto.
Traduz o contrato neutro de [`../../00-global/AGENT.md`](../../00-global/AGENT.md) para o consumo do Grok Build.
Se houver conflito, `00-global/AGENT.md` prevalece.

## Contrato do vault

Este workspace é um vault de memória federada, não um repositório de código:

- `00-global/AGENT.md` — contrato neutro (leia primeiro)
- `10-projects/` — projetos ativos (read-only)
- `20-domains/` — domínios isolados (read-only)
- `30-clients/` — contexto de clientes (read-only)
- `40-workflows/` — fluxos de trabalho (read-only)
- `50-skills/` — capacidades reutilizáveis (read-only)
- `60-context-packs/` — pacotes de contexto mínimo por tarefa (read-only)
- `70-decisions/` — decisões formais com status (read-only)
- `80-agent-adapters/` — adaptadores por agente (read-only)
- `90-inbox/suggested-memory.md` — único destino de escrita do agente
- `99-archive/` — logs e arquivados

## Política de escrita (vale em qualquer modo)

- **Leitura:** liberada em todo o vault
- **Escrita permanente:** PROIBIDA fora de `/90-inbox/`
- A regra vale em todos os modos do Grok Build (interativo, agent, autonomous), em hooks, skills e plugins. O nível de aprovação altera a UX, não a política.
- MCP servers conectados ao vault devem operar com escopo de escrita restrito a `/90-inbox/`.
- Qualquer pedido que exija escrita em pasta read-only deve virar sugestão para o inbox, com explicação.

## Comportamento esperado

- Antes de agir, leia `../../00-global/AGENT.md`
- Se o usuário citar um Context Pack, leia apenas esse arquivo e os caminhos listados em `Use:`
- Se não houver Context Pack, pergunte qual domínio é relevante antes de assumir
- Toda informação nova que valha a pena lembrar entra como sugestão em `90-inbox/suggested-memory.md`

## Resolução de conflito de memória

- Vence a entrada mais recente com `status: approved`
- `status: superseded` é ignorado em runtime
- Sem status, perguntar ao humano — não inferir pelo timestamp

## Tom e estilo de resposta

- Respostas diretas, sem introduções longas
- Sem elogios desnecessários
- Sem resumir o que acabou de fazer
- Código sem comentários óbvios

## Memória entre sessões

O vault é a memória persistente. O contexto da sessão Grok Build é volátil.
Para retomar trabalho, consulte `10-projects/<projeto>/` e o Context Pack relevante.

## Critério de qualidade

Boa execução: leu o Context Pack, agiu no escopo, escreveu sugestão no inbox quando aprendeu algo novo.
Má execução: leu o vault inteiro, editou domínios sem permissão, gravou "memória" fora do inbox.
