# Context Pack: planning

Goal:
Transformar um objetivo em plano executável com fases, marcos, riscos e
critérios de sucesso. Sem plano genérico, sem otimismo descalibrado, sem
ignorar o que já foi decidido.

Use:
- /20-projects/<projeto>/CONTEXT.md
- /20-projects/<projeto>/DECISIONS.md  (decisões prévias que restringem o plano)
- /20-projects/<projeto>/constraints.md  (prazos, orçamento, equipe, técnico)
- /20-projects/<projeto>/risks.md  (riscos já mapeados)
- /10-domains/strategy/PRINCIPLES.md  (se existir domínio de estratégia)
- Dependências externas listadas em /20-projects/<projeto>/dependencies.md

Avoid:
- Outros projetos em /20-projects/  (cada projeto é um plano, não misturar)
- Templates de plano da internet ("OKR genérico", "framework X")
- Otimismo sem análise de risco ("vamos entregar em 2 sprints")
- Ignorar DECISIONS.md ("e se a gente trocar o banco?" — não, já foi decidido)
- Marcos vagos ("Q3: melhorar produto")
- Plano sem dono por fase

Sources of truth:
- O contexto do projeto: CONTEXT.md
- O que já foi decidido e não está em discussão: DECISIONS.md
- O que limita o plano: constraints.md
- O que pode dar errado: risks.md
- Em conflito entre desejo e restrição, a restrição vence — o plano se ajusta

Output expected:
Plano no formato:

```
## Objetivo
[uma frase, sem ambiguidade]

## Premissas
- O que estou assumindo como verdadeiro (e por quê)

## Fases
### Fase 1 — [nome]
- Marco: [resultado observável, com data]
- Entregáveis concretos
- Dono
- Dependências (internas e externas)

### Fase 2 — ...

## Riscos e mitigação
| Risco | Probabilidade | Impacto | Mitigação | Dono |

## Dependências críticas
- Externas (fora do controle do time)
- Internas (entre fases)

## Critérios de sucesso
- Métricas observáveis, não sentimento
- Critério de falha explícito (quando matar o plano)
```

- Cada fase tem marco com data e dono
- Riscos sem mitigação não são riscos, são desejos
- Critério de sucesso precisa ser mensurável e ter critério de falha-parceira

Confidence / validity:
Plano válido enquanto CONTEXT.md, DECISIONS.md e constraints.md não mudarem.
Revisar marcos a cada conclusão de fase. Re-planejar quando: (a) uma
premissa cair, (b) uma dependência crítica atrasar mais de 20%, (c) uma
decisão prévia for revertida. Não estender prazo sem revisar premissa.

Source notes:
Caminhos hipotéticos. Antes de usar este pack, crie por projeto:
- /20-projects/<projeto>/CONTEXT.md
- /20-projects/<projeto>/DECISIONS.md
- /20-projects/<projeto>/constraints.md
- /20-projects/<projeto>/risks.md
- /20-projects/<projeto>/dependencies.md

Sem CONTEXT.md o agente faz plano genérico. Sem DECISIONS.md ele reabre
discussões já fechadas. Sem constraints.md ele promete o impossível. Os
três são o mínimo; risks.md e dependencies.md elevam a qualidade.
