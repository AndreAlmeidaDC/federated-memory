# CLAUDE.md — Contexto do Projeto: Memória Federada

## O que é esse projeto

André Almeida está criando dois artefatos sobre memória federada para agentes de IA:

1. **Whitepaper** — argumento arquitetural, ~10 páginas, linguagem de paper técnico, sem passo a passo
2. **Guia de implementação** — passo a passo executável com comandos reais, templates e diagramas SVG

Ambos serão publicados num repositório GitHub público como referência comunitária.

---

## Estado atual

### Artefatos prontos (gerados no Claude.ai)

| Arquivo | Status | Descrição |
|---|---|---|
| `whitepaper-memoria-federada-ptbr.html` | ✅ Rascunho v1 | Whitepaper em português, 7 seções |
| `memoria-federada-v2.html` | ✅ Rascunho v2 | Guia de implementação com diagramas SVG |

### O que ainda falta

- [ ] Revisão do whitepaper pelo André
- [ ] Versão em inglês do whitepaper
- [ ] Refinamento do guia de implementação
- [ ] Estrutura do repositório GitHub montada
- [ ] Template de vault clonável (`/template/` com pastas e arquivos de exemplo)
- [ ] README.md do repositório
- [ ] Script de setup inicial (bash ou PowerShell)

---

## Decisões tomadas (não reabrir sem motivo)

**Formato:** Whitepaper separado do guia de implementação. Whitepaper fala de princípios, guia fala de comandos.

**Idioma:** Português primeiro, inglês depois. As duas versões existirão.

**Título do whitepaper:** "Memória Federada: Por que Agentes de IA Não Devem Ser Donos do Contexto"

**Tese central:** O problema de memória em agentes de IA não é falta de ferramentas. É ausência de separação entre quem guarda, quem roteia e quem executa. Memória federada resolve isso devolvendo o contexto a quem ele pertence: o usuário.

**Stack de referência:** Obsidian + Hermes Agent (NousResearch) + MCP server para Obsidian + Context Packs

**Posicionamento do DecisionNode:** Citado como convergência independente que valida a arquitetura. Aparece na seção de comparação do whitepaper e nas seções 13 e 17 do guia. Não é integrado como backend — risco de dependência em projeto ainda pequeno.

**Estrutura do repositório decidida:**
```
/
├── whitepaper/
│   ├── whitepaper-ptbr.html
├── guia/
│   └── guia-implementacao-v2.html
├── template/
│   ├── 00-global/AGENT.md
│   ├── 10-domains/
│   ├── 20-projects/
│   ├── 30-context-packs/exemplo-linkedin-writing.md
│   ├── 40-agent-adapters/claude/CLAUDE.md
│   └── 50-inbox/suggested-memory.md
└── README.md
```

---

## Princípios que não mudam

1. Soberania do usuário — memória pertence ao usuário, não ao agente
2. Isolamento por domínio — domínios distintos não compartilham espaço semântico
3. Contrato neutro — AGENT.md descreve consumo para qualquer agente
4. Contexto mínimo suficiente — Context Packs, não dump do vault inteiro
5. Aprovação humana — nada vira memória permanente sem revisão

---

## Anti-patterns identificados (não repetir)

- Super cérebro único — mistura tudo, contamina tudo
- Contexto sempre ativo — agente carrega memória inteira
- Memória automática sem revisão — hipótese vira fato
- Adaptador como fonte principal — prende a uma ferramenta
- MCP/API sem escopo de permissões — escrita restrita a /50-inbox/

---

## Tom e estilo

**Whitepaper:** linguagem de paper técnico, sem comandos de terminal, argumentativo, cita comparações honestas incluindo onde a proposta perde para outras abordagens. Sem elogios desnecessários à própria arquitetura.

**Guia:** direto, executável, cada passo tem critério de conclusão objetivo. Sem passos vagos como "configure o Hermes" sem instrução concreta.

**André como autor:** não suavizar realidade, não fazer elogios desnecessários, ser parceiro crítico.

---

## Próximos passos sugeridos (em ordem)

1. André revisa o whitepaper e o guia e dá feedback
2. Ajustes com base no feedback
3. Montar a estrutura do repositório com os arquivos reais
4. Escrever o README.md
5. Criar o template de vault clonável
6. Traduzir whitepaper para inglês

---

## Referências do projeto

- Hermes Agent: https://github.com/NousResearch/hermes-agent
- DecisionNode: https://github.com/decisionnode/DecisionNode
- Model Context Protocol: https://modelcontextprotocol.io
- Graphiti (Zep): https://help.getzep.com/graphiti/graphiti/overview
- Obsidian MCP: buscar implementações via Local REST API plugin ou filesystem direto
- Claude Code Memory: https://docs.claude.com/en/docs/claude-code/memory
