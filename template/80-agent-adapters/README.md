# 40-agent-adapters — Adaptadores por Agente

Cada subpasta é um adaptador para um agente específico.
O adaptador traduz o contrato neutro do `AGENT.md` para as convenções do agente.

## Estrutura

```
40-agent-adapters/
├── claude/
│   └── CLAUDE.md          ← lido automaticamente pelo Claude Code
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
3. Inclua: comportamento esperado, tom, ferramentas disponíveis, restrições

## O adaptador não substitui o AGENT.md

O `AGENT.md` é o contrato. O adaptador é a tradução.
Se houver conflito, o `AGENT.md` prevalece.

## Incluídos

- `claude/CLAUDE.md` — Claude Code (Anthropic), lido automaticamente
- `cursor/.cursorrules` — Cursor; copiar para a raiz do vault
- `codex/AGENTS.md` — OpenAI Codex CLI; copiar para a raiz do vault
- `windsurf/.windsurfrules` — Windsurf / Cascade (Codeium); copiar para a raiz do vault
