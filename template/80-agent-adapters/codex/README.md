# Adaptador Codex (OpenAI)

Compatível com o Codex CLI (`codex`) e demais agentes da OpenAI que respeitam a convenção `AGENTS.md`.

## Como instalar

Copie `AGENTS.md` para a raiz do vault:

```bash
cp template/80-agent-adapters/codex/AGENTS.md /caminho/do/vault/AGENTS.md
```

O Codex CLI procura `AGENTS.md` na raiz do workspace ao iniciar uma sessão.

## Modo de aprovação

Recomendado rodar o Codex CLI em `suggest` mode quando operar sobre o vault:

```bash
codex --approval-mode suggest
```

O adaptador instrui o agente a respeitar o escopo mesmo em `full-auto`, mas `suggest` é a opção mais segura para memória federada — toda mudança fora de `90-inbox/` passa por você.

## MCP

Se você usa MCP server para expor o vault, configure-o no `~/.codex/config.toml` com escrita restrita a `90-inbox/`.
