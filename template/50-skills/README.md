# 50-skills

Skills são procedimentos de execução reutilizáveis entre agentes.

## Três níveis

### /published/
Skills aprovadas, disponíveis para qualquer agente consumir.
Chegam aqui automaticamente (TTL) ou por aprovação humana.

### /proposed/
Skills propostas por agentes aguardando classificação e aprovação.
Equivalente ao /90-inbox/ mas específico para skills.

### /deprecated/
Skills antigas mantidas para histórico e rastreabilidade.
Nunca deletar — marcar como deprecated com referência à substituta.

## Protocolo de publicação

Antes de criar uma skill nova:
1. Leia o INDEX.md
2. Busque por tags relacionadas
3. Se já existir algo similar, adapte ou proponha melhoria
4. Se não existir, crie a proposta no /90-inbox/ com type: skill

## Metadados obrigatórios em cada skill

```
---
author_agent: [nome do agente que criou]
origin_project: [projeto de origem, se aplicável]
version: 1.0.0
status: published | proposed | deprecated
domain: [domínio principal]
sensitivity: public | internal | private
confidence: verified | hypothesis
risk: low | medium | high
created: YYYY-MM-DD
approved_by: [nome ou auto-promoted]
supersedes: [skill anterior, se aplicável]
tags: [lista de tags]
---
```

## Regras de promoção automática

- `verified` + `low` → TTL 7 dias → vai para /published/ automaticamente
- `verified` + `medium` → notifica humano → aprovação lazy
- `hypothesis` → fica em /proposed/ → humano decide quando quiser
- `high` risk → bloqueia → exige aprovação explícita

## Skills × Context Packs

A distinção importa. As duas pastas resolvem problemas diferentes:

| Aspecto | Context Pack (`/60-context-packs/`) | Skill (`/50-skills/`) |
|---|---|---|
| Pergunta que responde | "O que saber antes de executar?" | "Como executar esta tarefa específica?" |
| Natureza | Contexto **declarativo** | Procedimento **imperativo** |
| Conteúdo | Princípios, restrições, exemplos, referências | Passos numerados, triggers, validações |
| Quando carregar | Antes de raciocinar sobre o domínio | Quando a tarefa-alvo é reconhecida |

## Política de escrita

A pasta `/50-skills/` é **read-only para agentes**. Skills novas, alterações ou variantes entram via `/90-inbox/` como sugestão com `type: skill`, e só viram skill real depois do processo de classificação e aprovação.
