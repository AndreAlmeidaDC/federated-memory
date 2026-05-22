# AGENTS.md — Adaptador para Pi (pi.dev)

Este arquivo segue a convenção `AGENTS.md` lida automaticamente pelo Pi de três lugares,
nesta ordem de prioridade:

1. `~/.pi/agent/` (global, vale para todas as execuções do usuário)
2. Diretórios pai do projeto (ancestrais do CWD)
3. Diretório atual

Quando você roda o Pi dentro deste vault (ou de qualquer subpasta dele), este
`AGENTS.md` é carregado automaticamente por estar em um diretório pai — sem
configuração adicional.

Traduz o contrato neutro de [`../../00-global/AGENT.md`](../../00-global/AGENT.md) para o consumo do Pi.
Se houver conflito, `00-global/AGENT.md` prevalece.

## Nota sobre integração: Pi não tem MCP nativo

Pi é minimalista por design — quatro ferramentas (`read`, `write`, `edit`, `bash`),
mais de quinze providers de modelo, e **nenhum MCP server embutido**. A integração
com o vault federado acontece por **leitura direta via filesystem**, não por MCP:

- Você roda o Pi dentro do vault. O `AGENTS.md` do diretório pai é detectado e lido automaticamente.
- O Pi acessa os arquivos do vault como qualquer outro arquivo local — via `read` e `edit`.
- **Não tente configurar um MCP server para o vault no Pi**: não é o caminho idiomático e duplica a ponte que o filesystem já oferece.
- A segurança da política de escrita continua valendo: o Pi obedece a regra `/90-inbox/` deste arquivo, sem necessidade de scope de permissão externo.

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

- **Leitura:** liberada em todo o vault — use `read`/`edit` livremente para arquivos read-only quando precisar consultar.
- **Escrita permanente:** PROIBIDA fora de `/90-inbox/`. A ferramenta `write` só pode produzir arquivo final em `/90-inbox/`. `edit` não pode alterar conteúdo em pastas read-only.
- A regra vale em todos os modos do Pi (interativo, headless, com qualquer provider).
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

O vault é a memória persistente. O contexto da sessão Pi é volátil (mesmo com compaction automático próprio do Pi, ele não substitui memória persistente).
Para retomar trabalho, consulte `10-projects/<projeto>/` e o Context Pack relevante.

## Critério de qualidade

Boa execução: leu o Context Pack, agiu no escopo, escreveu sugestão no inbox quando aprendeu algo novo.
Má execução: leu o vault inteiro, editou domínios sem permissão, gravou "memória" fora do inbox, tentou configurar MCP server para algo que o filesystem direto já resolve.
