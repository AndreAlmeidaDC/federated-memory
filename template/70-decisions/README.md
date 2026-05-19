# 70-decisions — Decisões

Resoluções tomadas: o que ficou decidido, quando e por quê. É o ponto único de verdade para resolver conflito de memória — o núcleo (Hermes) prioriza entradas com `status: approved` mais recentes e ignora as marcadas como `superseded`.

## Formato obrigatório (frontmatter)

```markdown
---
id: <slug-unico>
date: YYYY-MM-DD
status: approved | superseded | pending
supersedes: [<id-anterior-1>, <id-anterior-2>]
domain: <pasta-relevante>
owner: <quem-aprovou>
---

# Decisão: <titulo>

## Contexto
Por que essa decisão precisou ser tomada.

## Decisão
O que foi decidido, sem ambiguidade.

## Alternativas consideradas
- Opção A — descartada porque ...
- Opção B — descartada porque ...

## Consequências
- O que muda
- O que esta decisão fecha como fora de escopo

## Revisão
- Quando reavaliar (data ou gatilho)
```

## Regra de conflito

Quando duas decisões falam da mesma coisa:

1. Vence a mais recente com `status: approved`.
2. A anterior recebe `status: superseded` e o ID dela aparece em `supersedes` da nova.
3. Decisões com `status: superseded` permanecem no histórico (auditoria), mas o núcleo as ignora ao montar contexto.
4. Decisões sem `status` são tratadas como `pending` — o núcleo pergunta ao humano antes de usar.

Nunca infira a "vencedora" apenas pelo timestamp do arquivo: o status é obrigatório.

## Para implementações com busca semântica

Decisões podem ser indexadas externamente (DecisionNode, embeddings) — desde que a regra de status seja preservada e o arquivo Markdown continue sendo a fonte de verdade.
