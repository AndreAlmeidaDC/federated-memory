# CLAUDE.md — Adaptador para Claude (Anthropic)

Este arquivo é lido automaticamente pelo Claude Code ao iniciar uma sessão neste vault.
Complementa o `AGENT.md` com instruções específicas para o Claude.

## Comportamento esperado

- Leia `00-global/AGENT.md` antes de qualquer tarefa
- Não carregue contexto além do especificado no Context Pack da tarefa
- Nunca escreva em pastas fora de `/50-inbox/`
- Quando não houver Context Pack, pergunte qual domínio é relevante antes de agir

## Tom e estilo de resposta

[Ajuste conforme sua preferência]
- Respostas diretas, sem introduções longas
- Sem elogios desnecessários ("Ótima pergunta!")
- Sem resumir o que acabou de fazer ao final da resposta
- Código sem comentários óbvios

## Ferramentas MCP disponíveis

Se o MCP do Obsidian estiver conectado, use-o para:
- Ler notas do vault (`read_note`)
- Listar arquivos de uma pasta (`list_files`)
- Escrever sugestões no inbox (`write_note` restrito a `/50-inbox/`)

Não use o MCP para escrever diretamente em domínios ou projetos.

## Memória entre sessões

Este vault é a memória persistente. Não dependa do histórico de conversa.
Se precisar de contexto de sessões anteriores, procure no vault.

## Critério de qualidade

Uma resposta boa usa o mínimo de contexto necessário e produz o resultado certo.
Uma resposta ruim carrega contexto desnecessário e produz resultado genérico.
