# 80-agent-adapters — Adaptadores por Agente

Cada subpasta é um adaptador para um agente específico.
O adaptador traduz o contrato neutro do `AGENT.md` para as convenções do agente.

## Estrutura

```
80-agent-adapters/
├── claude/
│   ├── CLAUDE.md          ← lido automaticamente pelo Claude Code
│   └── AGENTS.md          ← política de escrita neutra (cross-tool)
├── cursor/
│   └── .cursorrules       ← copiar para a raiz do vault
├── codex/
│   └── AGENTS.md          ← copiar para a raiz do vault
└── windsurf/
    └── .windsurfrules     ← copiar para a raiz do vault
```

## Como criar um adaptador

1. Crie uma subpasta com o nome do agente
2. Escreva as instruções no formato que o agente espera
3. Inclua: política de escrita, regra de conflito, comportamento esperado, tom, ferramentas, restrições

Todo adaptador novo deve reafirmar a **política de escrita** (escrita permanente só em `/90-inbox/`, em qualquer modo de execução) e a **regra de resolução de conflito** (vence `status: approved` mais recente; `superseded` ignorado em runtime).

## O adaptador não substitui o AGENT.md

O `AGENT.md` é o contrato. O adaptador é a tradução.
Se houver conflito, o `AGENT.md` prevalece.

## Incluídos

- `claude/CLAUDE.md` + `claude/AGENTS.md` — Claude Code (Anthropic), lido automaticamente; AGENTS.md formaliza a política para reuso por outros agentes
- `cursor/.cursorrules` — Cursor; copiar para a raiz do vault
- `codex/AGENTS.md` — OpenAI Codex CLI; copiar para a raiz do vault
- `windsurf/.windsurfrules` — Windsurf / Cascade (Codeium); copiar para a raiz do vault
