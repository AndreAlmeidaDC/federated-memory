# Contribuindo

Contribuições são bem-vindas. Este documento é curto de propósito.

## Antes de qualquer coisa

Leia o whitepaper e o guia. Mudanças que vão contra os cinco princípios (soberania do usuário, isolamento por domínio, contrato neutro, contexto mínimo, aprovação humana) não serão aceitas.

## Contribuir com um novo Context Pack

Context Packs são a peça mais útil que a comunidade pode contribuir. Cada pack resolve uma tarefa específica.

1. Abra uma issue usando o template "Context Pack Suggestion"
2. Se a sugestão fizer sentido, abra um PR adicionando o arquivo em `template/30-context-packs/`
3. Use o formato do `exemplo-linkedin-writing.md` como referência
4. Inclua os cinco campos: Goal, Use, Avoid, Sources of truth, Output expected, Confidence

Packs aceitos são exemplos genéricos que outras pessoas podem adaptar. Packs muito específicos a um indivíduo ou empresa devem ficar no vault pessoal, não aqui.

## Adicionar um adaptador para outro agente

Cada agente tem sua convenção de arquivo de contexto. Para adicionar suporte a Cursor, Windsurf, Codex, Gemini ou outro:

1. Crie uma subpasta em `template/40-agent-adapters/[nome-do-agente]/`
2. Adicione o arquivo no formato que o agente espera (ex: `cursor/.cursorrules`, `codex/codex.md`)
3. O adaptador deve apenas apontar para `00-global/AGENT.md`, não substituí-lo
4. Atualize `template/40-agent-adapters/README.md` listando o novo adaptador

## Propor mudanças no whitepaper ou no guia

O whitepaper e o guia são opinativos. Mudanças estruturais (nova seção, mudança de tese) exigem discussão em issue antes do PR. Correções de erro, typo, link quebrado ou exemplo desatualizado podem vir direto como PR.

Para mudanças no HTML:
- Mantenha o tom (direto, sem suavizar, sem elogios à própria arquitetura)
- Mantenha o estilo visual existente
- Não adicione dependências externas além das fontes do Google Fonts já usadas

## Pull requests

- Um PR por mudança lógica. Não misture refactor visual com nova feature
- Título no formato `tipo(escopo): descrição` (ex: `feat(template): adaptador para Cursor`)
- Descreva o "por quê", não só o "o quê"
- Se o PR tem mais de 300 linhas, considere quebrar em PRs menores

## Conduta

Este é um projeto técnico. Discussão honesta é esperada. Não há espaço para:

- Elogio vazio ("ótimo projeto!", "amei a ideia") sem conteúdo técnico
- Suavização de problemas reais ("talvez não seja ideal" quando algo está errado)
- Promoção de produtos comerciais sem discussão arquitetural

Crítica direta é bem-vinda. Crítica pessoal não.

## Dúvidas

Abra uma issue com a tag `question`. Respostas vão para o próprio thread — assim outras pessoas com a mesma dúvida encontram.
