# AGENTS.md — Adaptador para OpenCode

Este arquivo segue a convenção `AGENTS.md` adotada nativamente pelo OpenCode a partir da v1.15.
Traduz o contrato neutro de [`../../00-global/AGENT.md`](../../00-global/AGENT.md) para o consumo do OpenCode.
Se houver conflito, `00-global/AGENT.md` prevalece.

> **Atenção:** OpenCode v1.15+ lê `AGENTS.md` nativamente. Quando `AGENTS.md` e `CLAUDE.md` coexistem na mesma pasta, **apenas `AGENTS.md` é lido**. Não duplique conteúdo em ambos.

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
- A regra vale em todos os modos do OpenCode (interativo, headless, auto). O nível de aprovação altera a UX, não a política.
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

O vault é a memória persistente. O contexto da sessão OpenCode é volátil.
Para retomar trabalho, consulte `10-projects/<projeto>/` e o Context Pack relevante.

## Critério de qualidade

Boa execução: leu o Context Pack, agiu no escopo, escreveu sugestão no inbox quando aprendeu algo novo.
Má execução: leu o vault inteiro, editou domínios sem permissão, gravou "memória" fora do inbox.
