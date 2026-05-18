# AGENTS.md — Adaptador para OpenAI Codex / Codex CLI

Este arquivo segue a convenção `AGENTS.md` usada pelo Codex CLI e por outros agentes da OpenAI.
Traduz o contrato neutro de `00-global/AGENT.md` para as convenções do Codex.
Se houver conflito, `00-global/AGENT.md` prevalece.

## Contrato do vault

Este workspace é um vault de memória federada, não um repositório de código:

- `00-global/AGENT.md` — contrato neutro (leia primeiro)
- `10-domains/` — domínios isolados (read-only para o agente)
- `20-projects/` — projetos ativos (read-only para o agente)
- `30-context-packs/` — pacotes de contexto mínimo por tarefa (read-only)
- `40-agent-adapters/` — adaptadores por agente
- `50-inbox/suggested-memory.md` — única pasta gravável pelo agente
- `90-archive/` — log de decisões de revisão

## Comportamento esperado

- Antes de agir, leia `00-global/AGENT.md`
- Se o usuário citar um Context Pack, leia apenas esse arquivo e o domínio que ele referencia
- Se não houver Context Pack, pergunte qual domínio é relevante antes de assumir
- Toda informação nova que valha a pena lembrar entra como sugestão em `50-inbox/suggested-memory.md`, no formato definido pelo próprio inbox
- Nunca edite arquivos em `00-global/`, `10-domains/`, `20-projects/`, `30-context-packs/` sem confirmação explícita do usuário

## Restrições de escrita

| Pasta | Permissão para o agente |
|---|---|
| `00-global/` | read-only |
| `10-domains/` | read-only |
| `20-projects/` | read-only |
| `30-context-packs/` | read-only |
| `40-agent-adapters/` | read-only |
| `50-inbox/` | **read-write** (append-only preferencial) |
| `90-archive/` | read-only (só o script de revisão grava) |

## Modo de execução (Codex CLI)

- Em `suggest` mode: proponha diffs, nunca aplique direto fora de `50-inbox/`
- Em `auto-edit`/`full-auto`: a regra acima continua valendo — o agente respeita o escopo mesmo com aprovação automática habilitada
- Se o usuário pedir algo que exija escrita em pasta read-only, responda com a sugestão formatada para o inbox e explique por quê

## Tom e estilo de resposta

- Respostas diretas, sem introduções longas
- Sem elogios desnecessários
- Sem resumir o que acabou de fazer
- Código sem comentários óbvios

## Memória entre sessões

O vault é a memória persistente. O contexto da sessão Codex é volátil.
Para retomar trabalho, consulte `20-projects/<projeto>/` e o Context Pack relevante.

## Critério de qualidade

Boa execução: leu o Context Pack, agiu no escopo, escreveu sugestão no inbox quando aprendeu algo novo.
Má execução: leu o vault inteiro, editou domínios sem permissão, gravou "memória" fora do inbox.
