# Context Pack: planning

Goal:
Transformar um objetivo em plano executável com fases, marcos, riscos e
critérios de sucesso. Sem plano genérico, sem otimismo descalibrado, sem
ignorar o que já foi decidido.

Use:
- /10-projects/<projeto>/PROJECT.md
- /10-projects/<projeto>/constraints.md  (prazos, orçamento, equipe, técnico)
- /10-projects/<projeto>/risks.md  (riscos já mapeados)
- /10-projects/<projeto>/dependencies.md  (dependências externas)
- /70-decisions/ (decisões com status: approved relacionadas a este projeto)
- /20-domains/strategy/PRINCIPLES.md  (se existir domínio de estratégia)

Avoid:
- Outros projetos em /10-projects/  (cada projeto é um plano, não misturar)
- /70-decisions/ com status: superseded
- Templates de plano da internet ("OKR genérico", "framework X")
- Otimismo sem análise de risco ("vamos entregar em 2 sprints")
- Reabrir decisões já approved ("e se a gente trocar o banco?" — não, já foi decidido)
- Marcos vagos ("Q3: melhorar produto")
- Plano sem dono por fase

Sources of truth:
- O contexto do projeto: PROJECT.md
- O que já foi decidido: /70-decisions/ (apenas approved, ignorar superseded)
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
Plano válido enquanto PROJECT.md, decisões approved relevantes e constraints.md não mudarem.
Revisar marcos a cada conclusão de fase. Re-planejar quando: (a) uma
premissa cair, (b) uma dependência crítica atrasar mais de 20%, (c) uma
decisão prévia for revertida (status: superseded). Não estender prazo sem revisar premissa.

Review:
- review_date: YYYY-MM-DD
- review_by: [nome]
- next_review: YYYY-MM-DD  # quando deve ser revisado novamente
- Nota: atualize review_date mesmo quando nenhum conteúdo mudar.
  O Hermes usa este campo para avisos de validade, não só o mtime.

Validation:
- Após cada uso, Hermes registra em /99-archive/pack-usage.log: pack, tarefa, resultado (útil/parcial/ruim)
- Pack com 3 marcações "ruim" consecutivas é flaggeado para revisão
- Temporal: se qualquer arquivo em "Use:" tem mtime > 90 dias, Hermes inclui aviso no output
- Humano pode marcar pack como "stale" manualmente em /99-archive/pack-status.md

Source notes:
Caminhos hipotéticos. Antes de usar este pack, crie por projeto:
- /10-projects/<projeto>/PROJECT.md
- /10-projects/<projeto>/constraints.md
- /10-projects/<projeto>/risks.md
- /10-projects/<projeto>/dependencies.md
- /70-decisions/ (decisões approved relevantes ao projeto)

Sem PROJECT.md o agente faz plano genérico. Sem decisões approved ele reabre
discussões já fechadas. Sem constraints.md ele promete o impossível. Os
três são o mínimo; risks.md e dependencies.md elevam a qualidade.
