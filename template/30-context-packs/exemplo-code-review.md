# Context Pack: code-review

Goal:
Revisar código ou um Pull Request e devolver crítica técnica fundamentada,
no padrão arquitetural do projeto. Sem opinião solta, sem suavização.

Use:
- /10-domains/engineering/PRINCIPLES.md
- /10-domains/engineering/stack-conventions.md
- /10-domains/engineering/architectural-decisions/*.md
- /10-domains/engineering/review-checklist.md
- O diff completo do PR ou o trecho de código fornecido

Avoid:
- /10-domains/writing/*  (estilo de outro domínio, não se aplica)
- /10-domains/product/*  (decisões de produto não justificam código ruim)
- Opiniões de estilo sem respaldo em PRINCIPLES.md ou stack-conventions.md
- Sugestões fora do escopo do PR ("e já que estamos aqui, refatora X")
- Padrões genéricos da internet quando há decisão arquitetural registrada
- Elogios ao autor ou ao código antes/depois da crítica

Sources of truth:
- Princípios de engenharia: PRINCIPLES.md
- Padrões da stack (linguagem, framework, libs): stack-conventions.md
- Decisões registradas (ADRs): architectural-decisions/
- Checklist objetivo: review-checklist.md
- Em caso de conflito entre fontes, o ADR mais recente prevalece

Output expected:
Lista priorizada de problemas no formato:

```
## Crítico
- [arquivo:linha] — Problema. Por quê (referência ao princípio/ADR). Sugestão de correção.

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
ou a cada novo ADR que altere padrão de revisão. Recomendado: revisão a
cada 6 meses mesmo sem mudanças explícitas.

Source notes:
Os caminhos acima são hipotéticos. Antes de usar este pack, crie:
- /10-domains/engineering/PRINCIPLES.md
- /10-domains/engineering/stack-conventions.md
- /10-domains/engineering/architectural-decisions/
- /10-domains/engineering/review-checklist.md

Sem esses arquivos, o agente não tem fonte de verdade — vai cair no anti-pattern
de "padrões genéricos da internet" que este pack explicitamente proíbe.
