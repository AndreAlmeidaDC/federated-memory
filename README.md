# Memória Federada: Por que Agentes de IA Não Devem Ser Donos do Contexto

> O problema de memória em agentes de IA não é falta de ferramentas.
> É ausência de separação entre quem guarda o contexto e quem o executa.
> Memória federada resolve isso devolvendo o contexto a quem ele pertence: o usuário, com Git como espinha de versão e auditoria.

---

## O que é este repositório

Este repositório reúne dois artefatos complementares sobre arquitetura de memória para agentes de IA:

1. **Whitepaper** - argumento arquitetural, linguagem de paper técnico, sem passo a passo. Para quem quer entender o problema e a proposta antes de implementar.
2. **Guia de implementação** - passo a passo executável com comandos reais, templates e diagramas. Para quem quer construir.

Ambos partem da mesma tese: memória de agente acoplada ao agente é um anti-pattern. A solução é federada: separada por domínio, de propriedade do usuário, versionada em Git, acessível por qualquer agente via contrato neutro.

---

## Status do projeto

| Componente | Status |
|---|---|
| Whitepaper (PT-BR) | Publicado, v3.0 (memória passiva, Git como espinha, agente como cliente, dois modos de governança) |
| Whitepaper (EN) | Publicado, v3.0 |
| Guia de implementação (PT-BR) | Publicado, v3.0 |
| Guia de implementação (EN) | Publicado, v3.0 |
| Template de vault clonável | Disponível em `/template/` (11 pastas) |
| QUICKSTART | Publicado, v3.0 (piso primeiro: vault + Git + contrato + agente) |
| Script de setup (Linux/macOS) | `setup.sh` (monta o piso) |
| Script de setup (Windows) | `setup.ps1` (monta o piso) |
| Adaptadores de agente | 11 disponíveis em `/template/80-agent-adapters/` |
| Context Packs de exemplo | 5 disponíveis com campo `Validation` |
| PDFs (PT e EN) | Disponíveis como assets da release v3.0 |

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
| MCP/API tratado como governança | Acesso confundido com controle de escrita |

---

## A arquitetura

Memória federada separa duas responsabilidades que as ferramentas misturam:

- **Quem guarda** - o vault do usuário: arquivos Markdown versionados em Git, estruturados por domínios isolados. Passivo e soberano. Não depende de nenhuma ferramenta para existir.
- **Quem executa** - o agente, que é um cliente intercambiável. Ele puxa o Context Pack relevante para a tarefa, guiado pelo contrato, opera com contexto mínimo suficiente e deposita memória nova como sugestão para revisão.

Não há um terceiro componente ativo no meio. O que a v2 deste projeto chamou de "roteador" ou "núcleo ativo" não existe como descrito: a leitura é o próprio agente puxando o que precisa a partir de arquivos estáticos versionados, guiado pelo contrato. Não é um porteiro central que medeia chamadas.

### Princípios que não mudam

1. **Soberania do usuário** - memória pertence ao usuário, não ao agente
2. **Isolamento por domínio** - domínios distintos não compartilham espaço semântico
3. **Contrato neutro** - `AGENT.md` descreve consumo para qualquer agente
4. **Contexto mínimo suficiente** - Context Packs, não dump do vault inteiro
5. **Git como espinha** - versionamento e sincronização vêm do Git, não de um sync proprietário
6. **Revisão antes de promover** - sugestões vão para `/90-inbox/`; promoção a memória durável é decisão, não automatismo

### Governança em dois modos declarados

A governança de escrita não é mágica nem está embutida em nenhum agente. Ela opera em dois modos, e o projeto declara os dois com honestidade:

- **Modo cooperativo (padrão).** A regra vive no contrato e na estrutura de pastas: leitura liberada, escrita permanente fora de `/90-inbox/` convertida em sugestão. O agente coopera porque o contrato pede. Serve do uso solo ao multi-máquina técnico e ao CI controlado, já com auditoria via histórico do Git.
- **Modo adversarial.** Contra um agente que decida ignorar o contrato, nenhum componente do lado do agente segura a escrita. O enforcement vem de baixo: isolamento de sistema operacional, permissões de filesystem, container com read-only, hooks de shell. Nunca do próprio agente.

Esta distinção foi exposta por teste de campo, não deduzida no papel. Confundir cooperação observada com enforcement é o erro que a v3 corrige.

### A escada de maturidade

A arquitetura cresce por degraus, sob dor, não por padrão:

- **Piso recomendado:** vault Markdown + Git + governança por contrato. Serve do uso solo local ao multi-máquina técnico, já com auditoria embutida.
- **Sob dor de tempo real ou usuário não técnico:** somar sincronização contínua (Obsidian Sync, Syncthing) por cima, mantendo o Git para versão.
- **Sob dor de acesso programático:** somar MCP como porta de acesso, lembrando que MCP não governa escrita.
- **Sob dor de consulta temporal:** somar Graphiti como índice derivado dos Markdown, nunca como substituto da fonte.
- **Sob ameaça de agente hostil ou exigência de conformidade:** hardening de OS.

Quase todo mundo fica no piso. O resto é evolução, não requisito.

---

## Estrutura do repositório

```
/
├── whitepaper/
│   ├── whitepaper-ptbr.html
│   └── whitepaper-en.html
├── guia/
│   ├── guia-ptbr.html
│   └── guia-en.html
├── template/
│   ├── 00-global/         AGENT.md (contrato do agente), RULES.md (regras globais)
│   ├── 10-projects/
│   ├── 20-domains/
│   ├── 30-clients/
│   ├── 40-workflows/
│   ├── 50-skills/
│   ├── 60-context-packs/  5 exemplos com campo Validation
│   ├── 70-decisions/
│   ├── 80-agent-adapters/ 11 adaptadores (claude, cursor, codex, windsurf, opencode, antigravity, kimi, grok, pi, commandcode, mimocode)
│   ├── 90-inbox/          suggested-memory.md (sugestões pendentes de revisão)
│   └── 99-archive/
├── setup.sh
├── setup.ps1
├── QUICKSTART.md
├── ROADMAP.md
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

> **Vault único, separação lógica por pastas.** A estrutura padrão é um único vault com pastas segmentadas. Múltiplos vaults físicos só quando precisar de isolamento real (dados de cliente, sincronização separada, compartilhamento seletivo). Detalhes no guia.

O diretório `/template/` é um vault clonável. Copie, adapte os domínios para sua realidade e conecte ao agente de sua escolha via adaptador.

---

## Como visualizar os documentos

Os artefatos são arquivos HTML estilizados. Como o GitHub mostra apenas o código-fonte de HTML, use os links abaixo via **raw.githack.com**, que renderiza o HTML diretamente no navegador:

### Português

- [Whitepaper (PT-BR)](https://raw.githack.com/AndreAlmeidaDC/federated-memory/master/whitepaper/whitepaper-ptbr.html)
- [Guia de implementação (PT-BR)](https://raw.githack.com/AndreAlmeidaDC/federated-memory/master/guia/guia-ptbr.html)

### English

- [Whitepaper (EN)](https://raw.githack.com/AndreAlmeidaDC/federated-memory/master/whitepaper/whitepaper-en.html)
- [Implementation Guide (EN)](https://raw.githack.com/AndreAlmeidaDC/federated-memory/master/guia/guia-en.html)

Alternativa local: clone o repositório e abra os arquivos `.html` direto no navegador.

```bash
git clone https://github.com/AndreAlmeidaDC/federated-memory.git
cd federated-memory
# Abra qualquer .html no seu navegador
```

### Versões em PDF

Para leitura offline, impressão ou anotação, os artefatos também estão disponíveis em PDF como assets da [página de releases do GitHub](https://github.com/AndreAlmeidaDC/federated-memory/releases), na release v3.0:

- Whitepaper PT-BR e EN
- Guia de implementação PT-BR e EN

---

## Setup rápido

Para montar o piso em poucos minutos, use o script de setup. Ele faz só o
essencial:

1. Verifica dependências (`git`, `node`, `npm`)
2. Copia o vault a partir do `/template/`
3. Inicializa Git no vault na branch `master` e faz o primeiro commit
4. Mostra próximos passos

O script **não** instala Hermes nem MCP. Esses são evolução opcional, não
base. Para somá-los, veja o bloco "Evolução opcional" do
[QUICKSTART.md](QUICKSTART.md).

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

Os scripts são idempotentes: rodam várias vezes sem quebrar nada já criado.

Prefere entender cada passo em vez de automatizar? Siga o
[QUICKSTART.md](QUICKSTART.md) manualmente.

---

## Stack de referência

A arquitetura é agnóstica de ferramenta. A tabela abaixo é uma referência,
não uma obrigação. Só o piso é necessário.

| Camada | Papel | Ferramenta de referência |
|---|---|---|
| Memória (piso) | Guardar, versionar, sincronizar, auditar | Arquivos Markdown + [Git](https://git-scm.com) |
| Agente (piso) | Executar como cliente intercambiável | Claude Code, Cursor, Codex, Windsurf, ou outro |
| Edição (opcional) | Editar o vault com conforto visual | [Obsidian](https://obsidian.md) |
| Acesso programático (opcional) | Expor o vault a um agente | [MCP](https://modelcontextprotocol.io) (acesso, não governança) |
| Consulta temporal (opcional) | Indexar a memória por tempo | [Graphiti / Zep](https://help.getzep.com/graphiti/graphiti/overview), como índice derivado |

O agente pode ser Claude, GPT, Gemini ou local. O contrato é o `AGENT.md`.
Nenhum agente é o núcleo; o Hermes, quando usado, é um cliente entre vários.

---

## Por onde começar

**Primeiro passo para implementar agora:**

[QUICKSTART.md](QUICKSTART.md) - do zero ao primeiro agente lendo memória federada, usando só o piso. Sem Hermes e sem MCP. Tempo: 20 a 40 minutos. Critério de conclusão em cada passo.

**Se preferir mais contexto antes de implementar:**

1. Leia o [whitepaper](https://raw.githack.com/AndreAlmeidaDC/federated-memory/master/whitepaper/whitepaper-ptbr.html) para entender a tese
2. Leia o [guia de implementação](https://raw.githack.com/AndreAlmeidaDC/federated-memory/master/guia/guia-ptbr.html) para ver a arquitetura em detalhe
3. Volte ao [QUICKSTART.md](QUICKSTART.md) e execute as etapas

**Setup automático:**

- Rode `setup.sh` (Linux/macOS) ou `setup.ps1` (Windows) para montar o piso
- Adapte o `00-global/AGENT.md` para seu contexto pessoal
- Configure o adaptador do seu agente em `/80-agent-adapters/`

---

## Contribuindo

Veja [CONTRIBUTING.md](CONTRIBUTING.md). Contribuições mais valiosas: novos Context Packs e adaptadores para outros agentes.

---

## Licença

[CC BY 4.0](LICENSE) - uso livre com atribuição.

---

## Autor

André Almeida - publicado como referência comunitária de acesso livre.
