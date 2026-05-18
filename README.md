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

## Status do projeto

| Componente | Status |
|---|---|
| Whitepaper (PT-BR) | ✅ Publicado — v1.0 |
| Guia de implementação | ✅ Publicado — v2.0 com seção de deployment remoto |
| Template de vault clonável | ✅ Disponível em `/template/` |
| Script de setup (Linux/macOS) | ✅ `setup.sh` |
| Script de setup (Windows) | ✅ `setup.ps1` |
| Adaptador Claude Code | ✅ Disponível |
| Adaptador Cursor | ✅ Disponível |
| Adaptador Codex | ✅ Disponível |
| Adaptador Windsurf | ✅ Disponível |
| Adaptador Antigravity | ⏳ Aceita contribuição |
| Context Packs de exemplo | ✅ 4 disponíveis (linkedin-writing, code-review, research, planning) |
| Context Packs adicionais | ⏳ Aceita contribuição |

Veja [CONTRIBUTING.md](CONTRIBUTING.md) para como contribuir e [ROADMAP.md](ROADMAP.md) para o que vem a seguir.

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
│   └── whitepaper-memoria-federada-ptbr.html
├── guia/
│   └── memoria-federada-v2.html
├── template/
│   ├── 00-global/AGENT.md
│   ├── 10-domains/
│   ├── 20-projects/
│   ├── 30-context-packs/
│   │   ├── exemplo-linkedin-writing.md
│   │   ├── exemplo-code-review.md
│   │   ├── exemplo-research.md
│   │   └── exemplo-planning.md
│   ├── 40-agent-adapters/
│   │   └── claude/CLAUDE.md
│   └── 50-inbox/suggested-memory.md
├── setup.sh
├── setup.ps1
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

O diretório `/template/` é um vault clonável. Copie, adapte os domínios para sua realidade e conecte ao agente de sua escolha via adaptador.

---

## Como visualizar os documentos

Os artefatos são arquivos HTML estilizados. Como o GitHub mostra apenas o código-fonte de HTML, use os links abaixo via **raw.githack.com**, que renderiza o HTML diretamente no navegador:

- 📄 [Whitepaper (PT-BR)](https://raw.githack.com/AndreAlmeidaDC/federated-memory/master/whitepaper/whitepaper-memoria-federada-ptbr.html)
- 📘 [Guia de implementação](https://raw.githack.com/AndreAlmeidaDC/federated-memory/master/guia/memoria-federada-v2.html)

Alternativa local: clone o repositório e abra os arquivos `.html` direto no navegador.

```bash
git clone https://github.com/AndreAlmeidaDC/federated-memory.git
cd federated-memory
# Abra qualquer .html no seu navegador
```

### Versões em PDF

Para leitura offline, impressão ou anotação, os artefatos também estão disponíveis em PDF como assets da [página de releases do GitHub](https://github.com/AndreAlmeidaDC/federated-memory/releases):

- `whitepaper-memoria-federada-ptbr-v1.0.pdf`
- `guia-implementacao-v2.0.pdf`

Os PDFs são gerados a partir dos HTML via Chromium headless. Para regenerar localmente, veja `scripts/build-pdfs.sh` ou `scripts/build-pdfs.ps1`.

---

## Setup rápido

Para montar um vault funcional em poucos minutos, use o script de setup. Ele faz:

1. Verifica dependências (`git`, `python`, `node`, `npm`)
2. Cria o vault em `~/federated-memory` a partir do `/template/`
3. Inicializa Git no vault
4. Clona e instala o Hermes Agent em `~/.hermes-agent`
5. Instala o MCP server filesystem via npm
6. Gera o `settings.json` do Claude Code apontando para o vault
7. Mostra próximos passos

### Linux / macOS

```bash
git clone https://github.com/AndreAlmeidaDC/federated-memory.git
cd federated-memory
bash setup.sh

# Ou com caminho customizado:
bash setup.sh /outro/caminho/para/vault
```

### Windows (PowerShell)

```powershell
git clone https://github.com/AndreAlmeidaDC/federated-memory.git
cd federated-memory
.\setup.ps1

# Ou com caminho customizado:
.\setup.ps1 -VaultDir "D:\meu-vault"
```

Os scripts são idempotentes: rodam várias vezes sem quebrar nada já instalado.

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

1. Leia o [whitepaper](https://raw.githack.com/AndreAlmeidaDC/federated-memory/master/whitepaper/whitepaper-memoria-federada-ptbr.html) para entender a tese
2. Leia o [guia de implementação](https://raw.githack.com/AndreAlmeidaDC/federated-memory/master/guia/memoria-federada-v2.html) para montar o seu vault
3. Rode `setup.sh` ou `setup.ps1` para criar o vault automaticamente
4. Adapte o `00-global/AGENT.md` para descrever seu contexto pessoal
5. Configure o adaptador do seu agente em `/40-agent-adapters/`

---

## Contribuindo

Veja [CONTRIBUTING.md](CONTRIBUTING.md). Contribuições mais valiosas: novos Context Packs e adaptadores para outros agentes.

---

## Licença

[CC BY 4.0](LICENSE) — uso livre com atribuição.

---

## Autor

André Almeida — publicado como referência comunitária de acesso livre.
