# AGENTS.md — Adaptador para MiMo Code

MiMo Code é um agente de código terminal-native da Xiaomi, fork do OpenCode.
Herda do OpenCode o suporte ao contrato via `AGENTS.md` no diretório de trabalho.
Traduz o contrato neutro de [`../../00-global/AGENT.md`](../../00-global/AGENT.md) para o consumo do MiMo Code.
Se houver conflito, `00-global/AGENT.md` prevalece.

> **Verificação na primeira configuração:** confirme que o MiMo Code carrega `AGENTS.md` automaticamente. Se não carregar, aponte o arquivo na configuração do projeto em `.mimocode/mimocode.json`.

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
- Qualquer pedido que exija escrita em pasta read-only deve virar sugestão para o inbox, com explicação.

## Aviso importante: memória nativa do MiMo Code

O MiMo Code tem sistema próprio de memória persistente (MEMORY.md, checkpoints, notes e destilação automática via dream/distill). Essa memória durável **compete com o vault federado**: acumula decisões e conhecimento de projeto fora do ciclo de revisão, sem auditoria Git e sem portabilidade.

**Regra ao usar com memória federada: o vault é a única fonte de verdade.**

- Trate a memória nativa como cache de sessão descartável.
- Conhecimento durável vai para `90-inbox` via sugestão, nunca apenas para a MEMORY.md.
- Verifique em `.mimocode/mimocode.json` as opções de comportamento de checkpoint e memória e reduza a persistência durável ao mínimo que a configuração permitir.
- A parte de memória de sessão (checkpoint e notes) é inofensiva e pode ficar ativa.

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

## Critério de qualidade

Boa execução: leu o Context Pack, agiu no escopo, escreveu sugestão no inbox quando aprendeu algo novo.
Má execução: leu o vault inteiro, editou domínios sem permissão, gravou conhecimento durável apenas na MEMORY.md nativa.
