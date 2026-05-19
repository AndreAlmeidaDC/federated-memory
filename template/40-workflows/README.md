# 40-workflows — Fluxos de trabalho

Procedimentos repetíveis: como você faz X. Diferente de `50-skills/` (que descreve capacidade) e de `70-decisions/` (que registra resolução).

Cada workflow é um arquivo Markdown com passos, critérios de conclusão e gatilhos.

## Formato sugerido

```markdown
# Workflow: <nome>

Gatilho:
- Quando este fluxo deve ser executado

Passos:
1. ...
2. ...

Critério de conclusão:
- O que precisa ser verdade para o workflow ser considerado feito

Owner:
- Quem revisa este workflow quando ele falha

Última revisão: YYYY-MM-DD
```

## Exemplos de workflow

- `release-process.md`
- `incident-response.md`
- `weekly-inbox-review.md`
- `client-onboarding.md`

Workflows que mudam toda semana não são workflows — são notas de projeto. Promova para `10-projects/`.
