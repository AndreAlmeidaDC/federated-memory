# Context Pack: code-review

Goal:
Revisar código ou um Pull Request e devolver crítica técnica fundamentada,
no padrão arquitetural do projeto. Sem opinião solta, sem suavização.

Use:
- /20-domains/engineering/PRINCIPLES.md
- /20-domains/engineering/stack-conventions.md
- /20-domains/engineering/review-checklist.md
- /70-decisions/ (decisões com domain: engineering e status: approved)
- O diff completo do PR ou o trecho de código fornecido

Avoid:
- /20-domains/writing/*  (estilo de outro domínio, não se aplica)
- /20-domains/product/*  (decisões de produto não justificam código ruim)
- /70-decisions/ com status: superseded
- Opiniões de estilo sem respaldo em PRINCIPLES.md ou stack-conventions.md
- Sugestões fora do escopo do PR ("e já que estamos aqui, refatora X")
- Padrões genéricos da internet quando há decisão arquitetural registrada
- Elogios ao autor ou ao código antes/depois da crítica

Sources of truth:
- Princípios de engenharia: PRINCIPLES.md
- Padrões da stack (linguagem, framework, libs): stack-conventions.md
- Decisões arquiteturais: /70-decisions/ (apenas approved)
- Checklist objetivo: review-checklist.md
- Em conflito entre fontes, a decisão approved mais recente em /70-decisions/ prevalece

Output expected:
Lista priorizada de problemas no formato:

```
## Crítico
- [arquivo:linha] — Problema. Por quê (referência ao princípio/decisão). Sugestão de correção.

## Médio
- ...

## Baixo / Estilo
- ...
```

- Cada item: localização exata, justificativa técnica (não "acho que"), correção concreta
- Se o PR estiver bom, dizer isso em uma linha — não inventar problemas para preencher
- Itens fora do escopo do PR ficam em uma seção separada "Fora do escopo (sugestão para PR futuro)"

Confidence / validity:
Pack válido enquanto PRINCIPLES.md e stack-conventions.md não mudarem.
Revalidar a cada release maior da stack (linguagem ou framework principal)
ou a cada nova decisão approved em /70-decisions/ que altere padrão de revisão.
Recomendado: revisão a cada 6 meses mesmo sem mudanças explícitas.

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
Os caminhos acima são hipotéticos. Antes de usar este pack, crie:
- /20-domains/engineering/PRINCIPLES.md
- /20-domains/engineering/stack-conventions.md
- /20-domains/engineering/review-checklist.md
- /70-decisions/ (primeira decisão approved relevante)

Sem esses arquivos, o agente não tem fonte de verdade — vai cair no anti-pattern
de "padrões genéricos da internet" que este pack explicitamente proíbe.
