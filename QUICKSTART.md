# QUICKSTART - Memória Federada para Agentes de IA

Do zero ao primeiro agente lendo memória federada, usando só o piso.
Tempo estimado: 20 a 40 minutos.

O piso é: vault Markdown + Git + contrato + um agente cliente. Não precisa
de Hermes nem de MCP para funcionar. Os dois são evolução opcional e estão
no fim deste documento, claramente marcados.

---

## Pré-requisitos

Antes de começar, confirme que você tem:

- **Git** instalado (`git --version`)
- **Node.js** v18+ instalado (`node --version`), para rodar o agente cliente
- **Um agente cliente** instalado: Claude Code, Cursor, Codex, Windsurf ou outro
- Uma chave de API de algum provider (Anthropic, OpenRouter, etc.)

Opcional, não necessário para o piso:

- **Obsidian** ([obsidian.md](https://obsidian.md)), se quiser editar o vault com conforto visual. O agente lê o filesystem direto, não depende do app.
- **Python** 3.11+, apenas se mais tarde você optar por Graphiti ou por rodar o Hermes.

---

## Etapa 1 - Criar o vault

```bash
# Cria a pasta do vault
mkdir federated-memory
cd federated-memory

# Cria a estrutura de pastas
mkdir -p 00-global \
         10-projects \
         20-domains \
         30-clients \
         40-workflows \
         50-skills \
         60-context-packs \
         70-decisions \
         80-agent-adapters/claude \
         90-inbox \
         99-archive
```

**Critério de conclusão:** rode `ls` e veja as 11 pastas criadas.

---

## Etapa 2 - Versionar com Git desde o início

Git é a espinha da arquitetura, não um passo posterior. Ele versiona e
sincroniza a memória. Inicialize agora, antes de qualquer conteúdo.

```bash
git init -b master
git add .
git commit -m "chore: estrutura inicial do vault federado"
```

Se você já tem um repositório remoto para o vault, conecte e suba:

```bash
git remote add origin <URL_DO_SEU_REPO>
git push -u origin master
```

O remoto é o que vai te dar sincronização entre máquinas mais adiante, sem
depender de sync proprietário. Se ainda não tem remoto, siga sem ele; o
versionamento local já está ativo.

**Critério de conclusão:** `git log` mostra o commit inicial.

---

## Etapa 3 - Criar o AGENT.md (o contrato)

Crie o arquivo `00-global/AGENT.md` com este conteúdo. Este é o contrato de
consumo. No modo cooperativo, que é o padrão, o agente respeita estas regras
porque o contrato pede, não porque algum componente as força. A seção
"Modos de governança", no fim deste documento, explica o limite disso.

```markdown
# AGENT.md

Purpose:
This repository contains the federated memory used by AI agents.
The memory is owned by the human user. Agents are interchangeable
clients, not owners. Git is the spine for versioning and sync.

Rules:
1. Do not load the entire memory base.
2. Start from the relevant Context Pack in /60-context-packs/.
3. If no Context Pack exists, ask which domain is relevant.
4. Permanent writes go only to /90-inbox/, in any execution mode
   (interactive, headless, scheduled). Everything else is read-only
   by contract.
5. Memory conflicts: the most recent entry with status: approved
   wins. Entries with status: superseded stay in history but are
   ignored at runtime.
6. When unsure, create a suggested memory entry in
   /90-inbox/suggested-memory.md instead of guessing.

Folders:
- 00-global, 10-projects, 20-domains, 30-clients, 40-workflows,
  50-skills, 60-context-packs, 70-decisions, 80-agent-adapters,
  90-inbox, 99-archive
```

**Critério de conclusão:** você consegue ler o arquivo e explicar cada regra.

---

## Etapa 4 - Criar o primeiro Context Pack

Crie o arquivo `60-context-packs/writing-style.md` (adapte para seu estilo):

```markdown
# Context Pack: writing-style

Goal:
Help an AI agent write content in my voice and style.

Use:
- /20-domains/writing/STYLE_GUIDE.md (crie depois)
- /20-domains/writing/voice-examples/ (crie depois)

Avoid:
- /20-domains/engineering/* (vocabulário diferente)
- /10-projects/* (a menos que mencionado explicitamente)
- Templates genéricos da internet
- Linguagem corporativa e jargão

Sources of truth:
- Voz: direta, sem suavização, sem elogios desnecessários
- Estrutura: conclusão primeiro, depois argumentos
- Tamanho: o mínimo necessário para ser claro

Output expected:
- Texto pronto para uso
- Sem subtítulos internos a menos que solicitado
- Sem hashtags no final

Confidence / validity:
- Revalidar a cada 90 dias ou quando o estilo mudar.

Validation:
- Após cada uso, registre em /99-archive/pack-usage.log:
  pack, tarefa, resultado (útil / parcial / ruim)
- 3 marcações "ruim" consecutivas = revisar o pack

Source notes:
- Crie /20-domains/writing/STYLE_GUIDE.md com exemplos reais
  do seu estilo antes de usar este pack.
```

**Critério de conclusão:** o arquivo existe e tem as seções Use, Avoid e Validation preenchidas.

---

## Etapa 5 - Criar o adaptador do seu agente

O adaptador é o arquivo que o agente lê automaticamente ao abrir a pasta.
Ele aponta para o contrato. Cada agente tem o seu nome de arquivo; o
exemplo abaixo é o Claude Code. Para outros agentes, troque o nome do
arquivo conforme a tabela no fim desta etapa, mantendo o conteúdo.

Crie `80-agent-adapters/claude/CLAUDE.md`:

```markdown
# CLAUDE.md

Read the shared memory contract at:
../../00-global/AGENT.md

Before starting any task:
1. Read the relevant Context Pack from /60-context-packs/
2. Do not load files outside the relevant domain
3. Write only to /90-inbox/ - never to other folders directly

If a new memory seems useful, write a suggestion to:
../../90-inbox/suggested-memory.md

Default Context Pack for writing tasks:
../../60-context-packs/writing-style.md
```

Para o agente funcionar lendo o contrato a partir da raiz do vault, copie
ou referencie esse adaptador na raiz com o nome que o seu agente espera:

| Agente | Arquivo na raiz do vault |
|---|---|
| Claude Code | `CLAUDE.md` |
| Cursor | `.cursorrules` |
| Codex, OpenCode, Antigravity, Kimi, Grok, MiMo Code | `AGENTS.md` |
| Windsurf | `.windsurfrules` |
| Pi | `AGENTS.md` (filesystem direto, sem MCP) |

O conteúdo é o mesmo do CLAUDE.md acima: leia `00-global/AGENT.md`, carregue
o Context Pack relevante, escreva só em `/90-inbox/`.

**Critério de conclusão:** abra o agente na pasta do vault e confirme que ele carrega o adaptador automaticamente.

---

## Etapa 6 - Rodar a primeira tarefa (só com o piso)

Este é o teste que prova que o caminho mínimo funciona. Sem Hermes, sem MCP.

Abra seu agente cliente na pasta do vault e faça uma pergunta que exige o
contrato:

```
Qual é o contrato de consumo de memória deste vault e em qual pasta você pode escrever?
```

O agente deve ler o adaptador e o `AGENT.md`, e responder que só pode
escrever em `/90-inbox/`, sem você ter explicado nada na conversa.

Depois, peça uma tarefa real de escrita e veja se ele puxa o Context Pack
`writing-style` em vez de carregar o vault inteiro.

**Critério de conclusão:** o agente cita as regras do contrato e usa o Context Pack correto, operando só com o piso.

Neste ponto você tem memória federada funcionando. As etapas seguintes são
opcionais e só fazem sentido sob uma dor concreta.

---

## Etapa 7 - Validar com dois agentes (opcional, recomendado)

Faça a mesma tarefa em dois agentes diferentes (ex: Claude Code e Cursor).
Verifique:

1. O resultado tem voz consistente entre os dois?
2. Ambos usaram o Context Pack correto?
3. Ambos depositaram sugestões em `/90-inbox/` em vez de escrever espalhado?

**Critério de conclusão:** as três respostas são "sim". Se alguma for "não",
o problema está no Context Pack ou no adaptador, não no agente. A
portabilidade entre agentes é a prova de que a memória não está acoplada a
nenhuma ferramenta.

Observação honesta: este teste mede cooperação, não enforcement. Que os dois
agentes tenham escrito só no inbox significa que cooperaram com o contrato
naquele teste, não que o sistema os impeça de escrever fora. Essa distinção
é o assunto da próxima seção.

---

## Modos de governança (leia antes de confiar no contrato)

A governança de escrita opera em dois modos declarados. Saber em qual você
está evita uma falsa sensação de segurança.

**Modo cooperativo (padrão).** A regra vive no contrato e na estrutura de
pastas. Leitura liberada em todo o vault; escrita permanente fora de
`/90-inbox/` é convertida em sugestão. O agente coopera porque o contrato
pede. Para uso solo, em time que confia nas suas ferramentas, e em CI
controlado, isto basta. A auditoria fica no histórico do Git: tudo que
entrou na memória é rastreável por commit.

**Modo adversarial.** Contra um agente que decida ignorar o contrato,
nenhum componente do lado do agente segura a escrita. Isto não é uma falha
da arquitetura; é um fato que ela declara. Enforcement real vem de baixo,
do sistema operacional: permissões de filesystem, container com a maior
parte do vault montada como read-only, hooks de pre/post tool call no nível
do shell. Nunca do próprio agente, e nunca de um "policy engine" embutido,
porque esse componente não existe.

Regra prática: comece no modo cooperativo. Só passe para hardening de OS
quando tiver uma ameaça real de agente hostil ou um requisito de
conformidade que exija a trava. Não pague o custo do modo adversarial sem a
dor que o justifique.

---

## Evolução opcional (só sob dor concreta)

Nada abaixo é necessário para o piso. Some um item de cada vez, quando uma
dor específica aparecer. Esta é a escada de maturidade.

### Hermes (um adaptador entre vários)

O Hermes é um agente de código completo, com memória própria. Na v3 ele é
um cliente como qualquer outro, não o núcleo. Use-o se já trabalha com ele,
não como passo obrigatório.

```bash
# Linux / macOS / WSL2
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

```powershell
# Windows
irm https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.ps1 | iex
```

Ressalva de soberania: a memória nativa do Hermes compete com o vault.
Trate-a como cache de sessão descartável. O vault é a fonte única de
verdade; conhecimento durável vai para `/90-inbox/`, nunca só para a
memória interna do Hermes.

### MCP (acesso, não controle)

MCP expõe o vault a um agente via servidor. É conveniência de acesso, não
governança.

```bash
npm install -g @modelcontextprotocol/server-filesystem
```

Configuração no Claude Code, em `.claude/settings.json` na pasta do projeto:

```json
{
  "mcpServers": {
    "federated-memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/caminho/para/federated-memory"]
    }
  }
}
```

Ressalva: o acesso via MCP é all-or-nothing. Ele não governa escrita; quem
tem acesso de escrita escreve em qualquer lugar. MCP é uma porta, não uma
trava. A governança continua sendo o contrato (modo cooperativo) ou o OS
(modo adversarial).

### Graphiti (índice derivado, opcional)

Se precisar de consultas temporais sobre a memória, Graphiti pode indexar o
conteúdo. Trate-o como índice derivado dos arquivos Markdown, gerado a
partir deles, nunca como substituto da fonte. Os Markdown versionados
continuam sendo a verdade; o grafo é uma camada de leitura por cima.
Comece pequeno antes de adotar.

---

## Troubleshooting

| Sintoma | Causa provável | Como resolver |
|---|---|---|
| Agente ignora o AGENT.md | Adaptador não aponta para o arquivo | Verifique se o adaptador referencia `../../00-global/AGENT.md` ou se a raiz tem o arquivo com o nome certo |
| Agente carrega o vault inteiro | Falta Context Pack ou regra 1 do contrato | Confirme a regra "do not load the entire memory base" e crie o pack do domínio |
| Context Pack não carrega | Caminho relativo errado | Use caminhos relativos à raiz do vault |
| Agente escreve fora do inbox | Regra de escrita ausente no adaptador, ou modo adversarial | Adicione a regra de escrita no adaptador. Se for agente hostil, isso é caso de hardening de OS, não de contrato |
| Sincronização entre máquinas não acontece | Falta remoto no Git | `git remote add origin <URL>` e `git push -u origin master` |
| MCP não conecta (se optou por MCP) | Caminho errado no config | Verifique o path absoluto do vault no settings.json |

---

## Próximos passos

Depois que o piso estiver validado:

1. **Criar domínios reais** em `/20-domains/` com vocabulário próprio
2. **Criar mais Context Packs** (code-review, research, planning)
3. **Revisar o /90-inbox/** periodicamente para promover sugestões a memória
4. **Conectar um remoto** se ainda não conectou, para sincronizar entre máquinas
5. **Avaliar a escada de maturidade** (Hermes, MCP, Graphiti, hardening) só sob dor concreta

Para o argumento por trás da arquitetura:
[whitepaper](https://raw.githack.com/AndreAlmeidaDC/federated-memory/master/whitepaper/whitepaper-ptbr.html)

Para o passo a passo completo com diagramas:
[guia de implementação](https://raw.githack.com/AndreAlmeidaDC/federated-memory/master/guia/guia-ptbr.html)

---

*Memória Federada para Agentes de IA · André Almeida · andrealmeidadc.com · v3.0*
