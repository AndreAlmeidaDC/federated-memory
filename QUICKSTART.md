# QUICKSTART — Memória Federada para Agentes de IA

Do zero ao primeiro agente com memória federada funcionando.  
Tempo estimado: 30 a 60 minutos.

---

## Pré-requisitos

Antes de começar, confirme que você tem:

- **Node.js** v18+ instalado (`node --version`)
- **Python** 3.11+ instalado (`python --version`)
- **Git** instalado (`git --version`)
- **Obsidian** instalado ([obsidian.md](https://obsidian.md))
- **Claude Code** ou outro agente MCP instalado
- Uma chave de API de algum provider (Anthropic, OpenRouter, etc.)

---

## Etapa 1 — Criar o vault

```bash
# Cria a pasta do vault
mkdir federated-memory
cd federated-memory

# Cria a estrutura de pastas
mkdir -p 00-global \
         10-projects \
         20-domains \
         30-clients \
         40-workflows \
         50-skills \
         60-context-packs \
         70-decisions \
         80-agent-adapters/claude \
         80-agent-adapters/cursor \
         80-agent-adapters/codex \
         80-agent-adapters/windsurf \
         90-inbox \
         99-archive

# Inicializa o repositório Git
git init
git add .
git commit -m "init: estrutura do vault federado"
```

**Critério de conclusão:** rode `ls` e veja as 11 pastas criadas.

---

## Etapa 2 — Criar o AGENT.md

Crie o arquivo `00-global/AGENT.md` com este conteúdo:

```markdown
# AGENT.md

Purpose:
This repository contains the federated memory used by AI agents.
The memory is owned by the human user. Agents are consumers,
not owners.

Rules:
1. Do not load the entire memory base.
2. Start from the relevant Context Pack in /60-context-packs/.
3. If no Context Pack exists, ask which domain is relevant.
4. Permanent writes are forbidden outside /90-inbox/ in any
   execution mode (interactive, headless, scheduled).
5. Memory conflicts: the most recent entry with status: approved
   wins. Entries with status: superseded stay in history but are
   ignored at runtime.
6. When unsure, create a suggested memory entry in
   /90-inbox/suggested-memory.md instead of guessing.

Folders:
- 00-global, 10-projects, 20-domains, 30-clients, 40-workflows,
  50-skills, 60-context-packs, 70-decisions, 80-agent-adapters,
  90-inbox, 99-archive
```

**Critério de conclusão:** você consegue ler o arquivo e explicar cada regra.

---

## Etapa 3 — Criar o primeiro Context Pack

Crie o arquivo `60-context-packs/writing-style.md` com este conteúdo (adapte para seu estilo):

```markdown
# Context Pack: writing-style

Goal:
Help an AI agent write content in my voice and style.

Use:
- /20-domains/writing/STYLE_GUIDE.md (crie depois)
- /20-domains/writing/voice-examples/ (crie depois)

Avoid:
- /20-domains/engineering/* (vocabulário diferente)
- /10-projects/* (a menos que mencionado explicitamente)
- Templates genéricos da internet
- Linguagem corporativa e jargão

Sources of truth:
- Voz: direta, sem suavização, sem elogios desnecessários
- Estrutura: conclusão primeiro, depois argumentos
- Tamanho: o mínimo necessário para ser claro

Output expected:
- Texto pronto para uso
- Sem subtítulos internos a menos que solicitado
- Sem hashtags no final

Confidence / validity:
- Revalidar a cada 90 dias ou quando o estilo mudar.

Validation:
- Após cada uso, registre em /99-archive/pack-usage.log:
  pack, tarefa, resultado (útil / parcial / ruim)
- 3 marcações "ruim" consecutivas = revisar o pack

Source notes:
- Crie /20-domains/writing/STYLE_GUIDE.md com exemplos reais
  do seu estilo antes de usar este pack.
```

**Critério de conclusão:** o arquivo existe e tem as seções Use, Avoid e Validation preenchidas.

---

## Etapa 4 — Criar o adaptador para Claude Code

Crie `80-agent-adapters/claude/CLAUDE.md`:

```markdown
# CLAUDE.md

Read the shared memory protocol at:
../../00-global/AGENT.md

Before starting any task:
1. Read the relevant Context Pack from /60-context-packs/
2. Do not load files outside the relevant domain
3. Do not write anywhere except /90-inbox/

If a new memory seems useful, write a suggestion to:
../../90-inbox/suggested-memory.md

Default Context Pack for writing tasks:
../../60-context-packs/writing-style.md
```

Crie também `80-agent-adapters/claude/AGENTS.md` (para o Hermes):

```markdown
# AGENTS.md

This is a federated memory base. Read the consumption protocol
before doing anything:

  ../../00-global/AGENT.md

Before responding to any task:
1. Identify the domain (writing, engineering, clients, etc.)
2. Load the corresponding Context Pack from /60-context-packs/
3. Write only to /90-inbox/ — never to other folders directly
4. Suggest memory updates; never apply them permanently alone
```

**Critério de conclusão:** abra o Claude Code na pasta do vault e confirme que ele carrega o CLAUDE.md automaticamente.

---

## Etapa 5 — Instalar o Hermes

**Linux / macOS / WSL2:**

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
source ~/.bashrc   # ou source ~/.zshrc
```

**Windows (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1 | iex
```

Após a instalação, configure o provider:

```bash
hermes model
```

Siga o wizard interativo. Escolha seu provider (Anthropic, OpenRouter, etc.) e insira a chave de API.

**Verificar se funcionou:**

```bash
hermes doctor
hermes
```

Se o Hermes responder normalmente, a instalação está correta.

**Critério de conclusão:** `hermes doctor` sem erros e uma conversa normal funcionando.

---

## Etapa 6 — Conectar o Hermes ao vault

Na raiz do vault, crie o `AGENTS.md` principal:

```markdown
# AGENTS.md

This is a federated memory base.

Before doing anything, read:
  00-global/AGENT.md

Rules:
- Read: allowed anywhere in the vault
- Write: ONLY to /90-inbox/suggested-memory.md
- Never modify 00-global/, 20-domains/, or 70-decisions/ directly
- Always load a Context Pack from /60-context-packs/ before tasks
```

Rode o Hermes a partir da pasta do vault:

```bash
cd /caminho/para/federated-memory
hermes
```

Teste com uma pergunta que exige contexto:

```
Qual é o contrato de consumo de memória deste vault?
```

O Hermes deve ler o `AGENTS.md` e responder com base nas regras.

**Critério de conclusão:** Hermes responde citando as regras do AGENT.md sem você ter explicado nada na conversa.

---

## Etapa 7 — Configurar o MCP server para Obsidian

Abra o vault no Obsidian. Depois instale o MCP server:

```bash
npm install -g obsidian-mcp-server
```

**Claude Desktop** — adicione em `~/.claude/claude_desktop_config.json` (Mac/Linux) ou `%APPDATA%\Claude\claude_desktop_config.json` (Windows):

```json
{
  "mcpServers": {
    "federated-memory": {
      "command": "node",
      "args": [
        "/caminho/para/node_modules/obsidian-mcp-server/build/index.js",
        "/caminho/para/federated-memory"
      ]
    }
  }
}
```

**Claude Code** — adicione em `.claude/settings.json` na pasta do projeto:

```json
{
  "mcpServers": {
    "federated-memory": {
      "command": "node",
      "args": [
        "/caminho/para/node_modules/obsidian-mcp-server/build/index.js",
        "/caminho/para/federated-memory"
      ]
    }
  }
}
```

Reinicie o cliente. Teste:

```
Liste os arquivos do vault.
```

O agente deve listar as pastas do `federated-memory` via MCP.

**Critério de conclusão:** agente lista arquivos do vault sem você apontar o caminho manualmente.

---

## Etapa 8 — Validar com dois agentes

Faça a mesma tarefa em Claude Code e em outro agente (Cursor, Windsurf).

Verifique três coisas:

1. O resultado tem voz consistente entre os dois?
2. Nenhum dos dois escreveu fora de `/90-inbox/`?
3. Ambos usaram o Context Pack correto?

**Critério de conclusão:** as três respostas são "sim".  
Se alguma for "não", o problema está no Context Pack ou no adaptador — não no agente.

---

## Troubleshooting

| Sintoma | Causa provável | Como resolver |
|---|---|---|
| Hermes não carrega AGENTS.md | Não está rodando na pasta certa | `cd /caminho/para/vault && hermes` |
| MCP server não conecta | Caminho errado no config | Verifique o path absoluto do vault |
| Agente ignora AGENT.md | Adaptador não aponta para o arquivo | Verifique se CLAUDE.md referencia `../../00-global/AGENT.md` |
| Agente escreve fora do inbox | Regra ausente no adaptador | Adicione a regra de escrita no CLAUDE.md e AGENTS.md |
| Context Pack não carrega | Caminho relativo errado | Use caminhos relativos à raiz do vault |
| `hermes doctor` com erros | Config incompleta | Rode `hermes setup` novamente |

---

## Próximos passos

Depois que tudo estiver funcionando:

1. **Criar domínios reais** em `/20-domains/` com vocabulário próprio
2. **Criar mais Context Packs** (code-review, research, planning)
3. **Usar o script review-inbox** semanalmente para processar sugestões
4. **Versionar o vault no Git** para rollback de memória
5. **Configurar deployment remoto** via VPS se precisar de acesso multi-máquina

Para o guia completo com todos os detalhes arquiteturais:  
`/guia/guia-implementacao-v2.html`

Para o argumento por trás da arquitetura:  
`/whitepaper/whitepaper-ptbr.html`

---

*Memória Federada para Agentes de IA · André Almeida · andrealmeidadc.com*
