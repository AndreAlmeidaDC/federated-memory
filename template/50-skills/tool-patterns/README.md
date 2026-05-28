# 50-skills/tool-patterns

Ledger de padrões recorrentes por ferramenta ou biblioteca.
Separado do contexto de projeto — o que o agente aprende sobre o Brandcraft
num projeto vale para todos os outros, sem contaminar memória de cliente.

## Por que aqui e não em /published/?

Skills em `/published/` são procedimentos reutilizáveis (como fazer X).
Tool patterns são incidentes rastreados por ferramenta (o que essa ferramenta faz de errado e como resolver).
São dois contratos diferentes.

## Protocolo de 3 tiers

| Tier | Ocorrência | Status | O que acontece |
|---|---|---|---|
| 1 | 1ª vez | `observed` | Agente registra sintoma no inbox com `type: tool_pattern` |
| 2 | 2ª vez | `auto_fix` | Agente aplica fix documentado automaticamente, sem perguntar |
| 3 | 3ª+ vez | `root_cause_pending` | Trigger para análise de causa raiz definitiva na fonte |

## Metadados obrigatórios em cada arquivo

```
---
tool: [nome da ferramenta ou biblioteca]
symptom: [descrição objetiva do problema]
occurrences: [número de ocorrências registradas]
status: observed | auto_fix | root_cause_pending | resolved
confidence: verified | hypothesis
risk: low | medium | high
first_seen: YYYY-MM-DD
last_seen: YYYY-MM-DD
author_agent: [agente que criou]
fix: [solução documentada, ou "pendente"]
root_cause: [causa raiz quando identificada, ou null]
---
```

## Convenção de nomes

Um arquivo por ferramenta: `{tool-slug}.md`
Exemplos: `brandcraft.md`, `puppeteer.md`, `obsidian-mcp.md`

## Como criar um novo padrão

1. Escreva no inbox com `type: tool_pattern`, `tool: [nome]`, `symptom: [descrição]`
2. Execute `node scripts/escalate-patterns.mjs`
3. O script cria ou atualiza o arquivo em `tool-patterns/` com status e escalada automáticos

## Como consumir

Antes de criar qualquer workaround para uma ferramenta externa:
1. Verifique se existe `tool-patterns/{tool}.md`
2. Se `status: auto_fix` → aplique o fix documentado sem perguntar
3. Se não existir → registre no inbox para iniciar o rastreamento

## Política de escrita

Esta pasta é **read-only para agentes em runtime**.
Atualizações só via `scripts/escalate-patterns.mjs` ou aprovação humana explícita.
