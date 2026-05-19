# Adaptador Cursor

## Como instalar

Copie `.cursorrules` para a raiz do vault (mesmo nível de `00-global/`):

```bash
cp template/80-agent-adapters/cursor/.cursorrules /caminho/do/vault/.cursorrules
```

O Cursor lê esse arquivo automaticamente ao abrir o workspace.

## Alternativa: Project Rules (Cursor 0.45+)

Se você usa a versão nova de Project Rules, mova o conteúdo para `.cursor/rules/federated-memory.mdc` com frontmatter:

```yaml
---
description: Contrato de memória federada
globs: ["**/*.md"]
alwaysApply: true
---
```

E cole o conteúdo de `.cursorrules` abaixo.

## MCP

Se você expõe o vault via MCP server (filesystem ou Obsidian Local REST API), configure-o em **Settings → MCP** no Cursor com escrita restrita a `90-inbox/`.
