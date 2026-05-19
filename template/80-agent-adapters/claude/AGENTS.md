# AGENTS.md — Política compartilhada (Claude)

Este arquivo segue a convenção `AGENTS.md` adotada pelo Codex CLI e por outros agentes.
Documenta a **política de escrita** do vault de forma neutra; o `CLAUDE.md` ao lado adiciona estilo e preferências específicas do Claude.

Se houver conflito entre este arquivo e o `00-global/AGENT.md`, o `AGENT.md` prevalece.

## Política de escrita (vale mesmo sem humano presente)

- **Leitura:** liberada em todo o vault.
- **Escrita permanente:** PROIBIDA fora de `/90-inbox/`.
- Em modo headless, agendado ou auto-edit, a regra continua valendo — escrita só vai para `/90-inbox/suggested-memory.md`.
- Qualquer pedido de escrita fora desse escopo deve gerar uma sugestão no inbox, **nunca uma edição direta**.

Quem aplica essa regra é o núcleo (Hermes ou equivalente) por meio do servidor MCP. O agente respeita a política como contrato — não como sugestão.

## Resolução de conflito de memória

- Vence a entrada mais recente com `status: approved`.
- Entradas com `status: superseded` ficam no histórico, são ignoradas em runtime.
- Sem status, perguntar ao humano. Não inferir pelo timestamp do arquivo.

Decisões formais vivem em `/70-decisions/` com frontmatter contendo `id`, `date`, `status`, `supersedes`.

## Permissões por pasta

| Pasta | Permissão para o agente |
|---|---|
| `00-global/` | read-only |
| `10-projects/` | read-only |
| `20-domains/` | read-only |
| `30-clients/` | read-only |
| `40-workflows/` | read-only |
| `50-skills/` | read-only |
| `60-context-packs/` | read-only |
| `70-decisions/` | read-only |
| `80-agent-adapters/` | read-only |
| `90-inbox/` | **read-write** (append-only preferencial) |
| `99-archive/` | read-only (só scripts gravam) |
