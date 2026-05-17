# Memória Federada: Por que Agentes de IA Não Devem Ser Donos do Contexto

> O problema de memória em agentes de IA não é falta de ferramentas.  
> É ausência de separação entre quem guarda, quem roteia e quem executa.  
> Memória federada resolve isso devolvendo o contexto a quem ele pertence: o usuário.

---

## O que é este repositório

Este repositório reúne dois artefatos complementares sobre arquitetura de memória para agentes de IA:

1. **Whitepaper** — argumento arquitetural, linguagem de paper técnico, sem passo a passo. Para quem quer entender o problema e a proposta antes de implementar.
2. **Guia de implementação** — passo a passo executável com comandos reais, templates e diagramas. Para quem quer construir.

Ambos partem da mesma tese: memória de agente acoplada ao agente é um anti-pattern. A solução é federada — separada por domínio, de propriedade do usuário, acessível por qualquer agente via contrato neutro.

---

## O problema

A maioria das implementações de memória para agentes cai em um destes padrões ruins:

| Anti-pattern | Consequência |
|---|---|
| Super cérebro único | Mistura contextos, contamina domínios |
| Contexto sempre ativo | Agente carrega memória inteira em todo prompt |
| Memória automática sem revisão | Hipótese vira fato permanente |
| Adaptador como fonte principal | Dependência de ferramenta específica |
| MCP/API sem escopo de permissões | Escrita irrestrita ao vault |

---

## A arquitetura

Memória federada separa três responsabilidades:

- **Quem guarda** — o vault do usuário (ex: Obsidian), estruturado por domínios isolados
- **Quem roteia** — o agente lê apenas o Context Pack relevante para a tarefa, não o vault inteiro
- **Quem executa** — o agente opera com contexto mínimo suficiente e sugere memória nova para aprovação humana

### Princípios que não mudam

1. **Soberania do usuário** — memória pertence ao usuário, não ao agente
2. **Isolamento por domínio** — domínios distintos não compartilham espaço semântico
3. **Contrato neutro** — `AGENT.md` descreve consumo para qualquer agente
4. **Contexto mínimo suficiente** — Context Packs, não dump do vault inteiro
5. **Aprovação humana** — nada vira memória permanente sem revisão

---

## Estrutura do repositório

```
/
├── whitepaper/
│   └── whitepaper-ptbr.html       # Argumento arquitetural completo
├── guia/
│   └── guia-implementacao-v2.html # Passo a passo executável com diagramas
├── template/
│   ├── 00-global/AGENT.md         # Contrato neutro para qualquer agente
│   ├── 10-domains/                # Domínios isolados (trabalho, pessoal, etc.)
│   ├── 20-projects/               # Projetos ativos com contexto próprio
│   ├── 30-context-packs/          # Pacotes de contexto por tarefa
│   │   └── exemplo-linkedin-writing.md
│   ├── 40-agent-adapters/         # Adaptadores por agente
│   │   └── claude/CLAUDE.md
│   └── 50-inbox/                  # Sugestões pendentes de aprovação humana
│       └── suggested-memory.md
└── README.md
```

O diretório `/template/` é um vault clonável. Copie, adapte os domínios para sua realidade e conecte ao agente de sua escolha via adaptador.

---

## Stack de referência

| Componente | Ferramenta |
|---|---|
| Vault | [Obsidian](https://obsidian.md) |
| Agente | [Hermes Agent](https://github.com/NousResearch/hermes-agent) (NousResearch) |
| Protocolo | [Model Context Protocol](https://modelcontextprotocol.io) |
| Memória estruturada (alternativa) | [Graphiti / Zep](https://help.getzep.com/graphiti/graphiti/overview) |
| Acesso ao vault via MCP | Obsidian Local REST API plugin ou filesystem direto |

A arquitetura é agnóstica de ferramenta. Obsidian pode ser substituído por qualquer sistema de arquivos estruturado. O agente pode ser Claude, GPT, Gemini ou local — o contrato é o `AGENT.md`.

---

## Por onde começar

1. Leia o [whitepaper](whitepaper/whitepaper-ptbr.html) para entender a tese
2. Leia o [guia de implementação](guia/guia-implementacao-v2.html) para montar o seu vault
3. Clone o `/template/` como ponto de partida
4. Adapte o `00-global/AGENT.md` para descrever seu contexto pessoal
5. Configure o adaptador do seu agente em `/40-agent-adapters/`

---

## Idiomas

- Português (este documento e os artefatos atuais)
- Inglês — em breve

---

## Autor

André Almeida — publicado como referência comunitária de acesso livre.
