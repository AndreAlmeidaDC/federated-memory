# 60-context-packs — Pacotes de Contexto

Um Context Pack é a unidade mínima de contexto para uma tarefa específica.
Ele não copia o vault — aponta, resume e limita.

## Por que usar Context Packs

Sem Context Packs, o agente leria o vault inteiro (lento, caro, impreciso) ou
adivinharia o que é relevante (perigoso). O Context Pack define exatamente:
o que usar, o que evitar, o formato esperado.

## Como criar um Context Pack

Copie o template abaixo e preencha para cada tarefa recorrente que você delega a agentes.

```markdown
# Context Pack: [nome-da-tarefa]

Goal:
[O que o agente deve fazer — uma frase clara]

Use:
- [caminho para nota ou pasta relevante em /10-projects/, /20-domains/, /70-decisions/...]

Avoid:
- [o que não carregar — seja específico]
- /70-decisions/ com status: superseded

Sources of truth:
- [regra ou referência que define qualidade]
- Em conflito, a decisão approved mais recente em /70-decisions/ prevalece

Output expected:
- [formato, tamanho, restrições]

Confidence / validity:
[critério temporal: até quando vale, gatilho de revisão]

Validation:
- Uso registrado em /99-archive/pack-usage.log (útil/parcial/ruim)
- 3 marcações "ruim" consecutivas flagga o pack para revisão
- Temporal: se algum arquivo em "Use:" tem mtime > 90 dias, incluir aviso no output
- Humano pode marcar como "stale" em /99-archive/pack-status.md

O registro de uso e o aviso temporal podem ser automatizados via hook do agente cliente (ex: PostToolUse rodando um script do vault). No piso, sem hook, valem como rotina manual de revisão.

Source notes:
[liste os arquivos hipotéticos que o usuário precisa criar antes de usar este pack]
```

## Exemplos incluídos

- `exemplo-linkedin-writing.md` — posts no LinkedIn com voz própria
- `exemplo-code-review.md` — crítica técnica de PR priorizada
- `exemplo-research.md` — síntese estruturada com hierarquia de fontes
- `exemplo-planning.md` — plano executável com fases, riscos e critério de falha

## Regra de expiração

Todo Context Pack deve ter campo `Confidence / validity` (critério temporal explícito)
e `Validation` (loop de feedback). Contexto desatualizado é pior que ausência de contexto.
O aviso de validade temporal pode ser automatizado via hook do agente que inspeciona o
`mtime` dos arquivos, de modo que ninguém use contexto velho sem ser avisado. Sem hook,
o aviso depende da rotina manual de revisão.

