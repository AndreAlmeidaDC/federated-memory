# Context Pack: research

Goal:
Conduzir investigação exploratória sobre um tópico delimitado e devolver
síntese estruturada: o que está estabelecido, o que ainda é hipótese, o
que ficou em aberto. Sem conclusão precoce, sem fonte não verificada.

Use:
- /10-domains/research/notes/<tópico>.md  (notas próprias prévias, se houver)
- /10-domains/research/sources-allowlist.md  (fontes já validadas)
- /10-domains/research/open-questions.md
- /10-domains/research/methodology.md
- Fontes externas explicitamente fornecidas no prompt (com URL e data de acesso)

Avoid:
- /10-domains/engineering/*  (vocabulário e critérios diferentes)
- /10-domains/writing/*  (este pack não é para gerar post, é para gerar síntese)
- Conclusões antes de listar evidência ("provavelmente X é causado por Y")
- Especulação sobre causas quando só há correlação
- Fontes não listadas em sources-allowlist.md sem marcá-las como "não verificada"
- LLM-generated content tratado como fonte primária
- Resumos genéricos da Wikipedia/Medium sem checar fonte original

Sources of truth:
- Fontes confiáveis previamente validadas: sources-allowlist.md
- Notas próprias com data e contexto: notes/<tópico>.md
- Perguntas que motivaram a investigação: open-questions.md
- Como se faz pesquisa neste vault: methodology.md
- Hierarquia: fonte primária > revisão peer-reviewed > análise técnica > opinião especialista > blog > LLM

Output expected:
Síntese no formato:

```
## Fatos verificados
- Afirmação. [fonte:trecho, acessado em DATA]

## Hipóteses sustentadas por evidência parcial
- Afirmação. [evidência limitada, lacuna]

## Lacunas identificadas
- O que não foi possível confirmar e por quê

## Perguntas para próxima rodada
- Pergunta específica, com fonte sugerida quando possível
```

- Nada na seção "Fatos verificados" sem fonte explícita e citável
- Se a evidência for fraca, vai para "Hipóteses", não para "Fatos"
- Lacunas explícitas são parte do entregável, não falha do entregável

Confidence / validity:
Pack válido enquanto methodology.md e sources-allowlist.md não mudarem.
Cada síntese gerada tem validade própria: fatos sobre tópicos em evolução
rápida (regulatório, ML, mercado) re-validar em 3 meses; tópicos estáveis
(história, fundamentos teóricos) em 12 meses. Marcar a validade no
próprio output.

Source notes:
Caminhos hipotéticos. Antes de usar este pack, crie:
- /10-domains/research/notes/
- /10-domains/research/sources-allowlist.md
- /10-domains/research/open-questions.md
- /10-domains/research/methodology.md

Sem methodology.md o agente improvisa critério; sem sources-allowlist.md
ele puxa qualquer link da web e trata como verdade. Os dois são pré-requisito.
