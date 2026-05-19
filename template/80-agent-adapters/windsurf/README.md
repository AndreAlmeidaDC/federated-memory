# Adaptador Windsurf (Codeium)

## Como instalar

Copie `.windsurfrules` para a raiz do vault:

```bash
cp template/80-agent-adapters/windsurf/.windsurfrules /caminho/do/vault/.windsurfrules
```

O Cascade lê o arquivo automaticamente ao abrir o workspace.

## Global rules

Se preferir aplicar as regras a todos os workspaces, cole o conteúdo em **Windsurf Settings → Cascade → Memories & Rules → Global rules**. Para escopo só do vault, mantenha em `.windsurfrules` local.

## Cascade Memories

O Windsurf oferece memórias internas do Cascade. Desligue ou mantenha vazias quando trabalhar sobre o vault — elas competem com o `90-inbox/` e violam o princípio de soberania do usuário.

## MCP

Windsurf suporta MCP servers via Settings → MCP. Configure o servidor de filesystem ou Obsidian Local REST API com escrita restrita a `90-inbox/`.
