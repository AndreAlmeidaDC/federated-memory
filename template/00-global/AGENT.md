---
contract: agent-memory
version: 2.0
owner: "[SEU NOME]"
last-reviewed: "[DATA]"
---

# AGENT.md — Contrato de Memória

Este arquivo é o ponto de entrada para qualquer agente que acesse este vault.
Leia antes de qualquer outra coisa. Não assuma nada que não esteja aqui.

## Quem sou

[Escreva 2-3 frases sobre você: papel profissional, área de atuação, contexto geral.
Exemplo: Sou um engenheiro de software focado em sistemas distribuídos, trabalhando
remotamente no Brasil. Escrevo sobre tecnologia e construo ferramentas para times pequenos.]

## Como este vault está organizado

| Pasta | Conteúdo |
|---|---|
| `00-global/` | Contrato neutro, instruções gerais, este arquivo |
| `10-projects/` | Projetos ativos com contexto próprio e prazo |
| `20-domains/` | Domínios de conhecimento estáveis (engenharia, escrita, pesquisa...) |
| `30-clients/` | Clientes e contexto comercial — candidato a vault físico separado |
| `40-workflows/` | Procedimentos repetíveis (como fazer X) |
| `50-skills/` | Capacidades reutilizáveis (técnicas, padrões aplicáveis) |
| `60-context-packs/` | Pacotes de contexto por tarefa — use estes para carregar contexto |
| `70-decisions/` | Decisões formais com status `approved` / `superseded` |
| `80-agent-adapters/` | Instruções específicas por agente (Claude, Cursor, Codex, Windsurf, Hermes...) |
| `90-inbox/` | Sugestões de memória pendentes de revisão humana |
| `99-archive/` | Logs, packs obsoletos, arquivos arquivados |

## Regras de acesso

- **Leitura:** liberada em todo o vault
- **Escrita permanente:** restrita a `/90-inbox/` — nunca escreva diretamente em outras pastas, em nenhum modo de execução (interativo, headless, agendado)
- **Memória permanente:** só existe após revisão e aprovação humana explícita

Essas regras são aplicadas pelo núcleo (Hermes ou equivalente), não delegadas ao agente. Se você se ver tentado a escrever fora de `/90-inbox/`, isso é um bug — pare e gere uma sugestão de inbox.

## Resolução de conflito de memória

Quando duas notas afirmam coisas conflitantes:

- **Vence** a entrada mais recente com `status: approved` no frontmatter (ou em um bloco DECISION explícito)
- Entradas com `status: superseded` permanecem no histórico para auditoria mas são **ignoradas em runtime**
- **Nunca infira o vencedor pelo timestamp do arquivo sozinho** — o `status` é obrigatório
- Em ausência de `status`, trate como `pending`: pergunte ao humano em vez de chutar
- Decisões formais vivem em `/70-decisions/` no formato documentado lá

O núcleo aplica essa regra ao montar o contexto. O agente recebe a versão vencedora, não o conflito.

## Como carregar contexto para uma tarefa

1. Identifique o domínio, projeto ou cliente relevante
2. Leia o Context Pack correspondente em `/60-context-packs/`
3. Siga as instruções de `Use:`, `Avoid:` e `Sources of truth:` do pack
4. Não carregue mais contexto do que o pack especifica

## O que fazer quando não encontrar contexto

Se não houver Context Pack para a tarefa:

- Use apenas o que estiver explicitamente no prompt do usuário
- Não invente contexto a partir de outras notas do vault
- Se identificar algo que deveria virar memória, escreva uma sugestão em `/90-inbox/`

## Sugestão de memória

Quando identificar algo que merece ser memorizado permanentemente, escreva em
`/90-inbox/suggested-memory.md` usando este formato:

```
## [DATA] — [DOMÍNIO]
**Sugestão:** [o que você quer registrar]
**Fonte:** [de onde veio essa informação]
**Confiança:** [alta / média / baixa]
**Destino sugerido:** [caminho da nota onde deveria ir]
```

Nunca escreva isso diretamente nas pastas de domínio. O humano revisa e decide via ritual semanal (`scripts/review-inbox.{sh,ps1}`).

## Validade temporal explícita

O campo `review_date` é obrigatório em Context Packs e Decisions.
Ele representa a última vez que um humano revisou o conteúdo —
independente de ter alterado algo.

O Hermes verifica dois critérios antes de entregar um pack:
1. `mtime` do arquivo > 90 dias → aviso automático
2. `next_review` < hoje → aviso automático

Se ambos estiverem dentro do prazo, o pack é entregue sem aviso.
Se qualquer um venceu, o pack é entregue com aviso de revisão pendente.

## Classificação obrigatória antes de gravar no inbox

Antes de sugerir qualquer memória, classifique obrigatoriamente:

- `confidence`: `verified` | `hypothesis` | `preference` | `deprecated`
- `risk`: `low` | `medium` | `high`

Regras de promoção automática:

- `verified` + `low` → TTL 7 dias → vira permanente sem aprovação
- `verified` + `medium` → notifica humano → aprovação lazy
- `hypothesis` → fica no inbox → humano decide quando quiser
- `deprecated` → substitui entrada anterior + arquiva a antiga
- `high` risk (qualquer confidence) → bloqueia → exige aprovação

Formato obrigatório no inbox:

```
---
source: [agente ou sessão]
date: YYYY-MM-DD
domain: [domínio alvo]
type: fact | decision | preference | workflow | risk
confidence: verified | hypothesis | preference | deprecated
risk: low | medium | high
ttl_days: 7  # só para verified + low
supersedes: [id da entrada anterior, se aplicável]
---
[conteúdo da memória]
```

## Lock de projeto (SESSION.lock)

Antes de iniciar qualquer trabalho em um projeto:

1. Verifique se existe `/10-projects/[projeto]/SESSION.lock`
2. Se existir, calcule se o lock ainda é válido:
   - `(started + ttl_minutes) > agora` → lock válido, avise o usuário e pergunte se continua
   - `(started + ttl_minutes) <= agora` → lock expirado, pode sobrescrever
3. Se não existir ou estiver expirado, crie o `SESSION.lock` com seus dados:
   - `agent`: seu nome de agente
   - `machine`: hostname da máquina atual
   - `user`: identificador do usuário atual
   - `started`: timestamp atual em ISO 8601
   - `ttl_minutes`: 60 (padrão)
   - `task`: descrição curta do que vai fazer
   - `session_id`: string aleatória de 8 caracteres
4. Ao finalizar a sessão, delete o `SESSION.lock`
5. Registre a sessão em `/99-archive/session-log.md`:

```
## [YYYY-MM-DD] [agent] em [machine]
- session_id: [id]
- user: [user]
- started: [timestamp]
- finished: [timestamp]
- task: [descrição]
- project: [projeto]
```

O arquivo de exemplo do lock fica em `/10-projects/SESSION.lock.example`.
Locks reais não são versionados (ver `.gitignore`).

## Mente de colmeia: compartilhamento de conhecimento entre agentes

Cada agente mantém sua memória privada. Conhecimento reutilizável
pode ser publicado na área compartilhada para outros agentes consumirem.

### Antes de criar uma skill, playbook ou template:
1. Leia `/50-skills/INDEX.md`
2. Se encontrar algo similar, reutilize, adapte ou proponha melhoria
3. Não crie duplicatas — prefira fork ou nova versão com `supersedes`

### Para publicar conhecimento novo:
1. Crie a proposta em `/90-inbox/` com `type: skill` (ou `playbook`, `template`, `pattern`)
2. Preencha todos os metadados obrigatórios incluindo `confidence` e `risk`
3. O sistema processa automaticamente baseado em `confidence` + `risk`:
   - `verified` + `low` → published em 7 dias
   - `verified` + `medium` → aguarda aprovação lazy
   - `hypothesis` → aguarda decisão humana
   - `high` risk → exige aprovação explícita

### O que pode ser publicado na área compartilhada:
- Skills (procedimentos de execução)
- Playbooks (sequências de passos para tarefas complexas)
- Templates (estruturas reutilizáveis)
- Padrões de arquitetura
- Decisões técnicas compartilhadas
- Lessons learned
- Critérios de validação
- Padrões de prompt

### O que NUNCA fazer:
- Escrever diretamente na memória privada de outro agente
- Publicar conhecimento sem metadados completos
- Criar skill duplicada sem verificar o `INDEX.md` primeiro
- Marcar como `verified` sem ter testado em uso real

## Memória de padrões recorrentes por ferramenta

Problemas repetidos com a mesma ferramenta ou biblioteca são rastreados em
`/50-skills/tool-patterns/`, separados do contexto de projeto e de cliente.
O que o agente aprende sobre o Brandcraft num projeto vale para todos os outros.

### Protocolo de 3 tiers

| Tier | Ocorrência | Status | Ação |
|---|---|---|---|
| 1 | 1ª vez | `observed` | Registre no inbox com `type: tool_pattern` |
| 2 | 2ª vez | `auto_fix` | Aplique o fix documentado automaticamente, sem perguntar |
| 3 | 3ª+ vez | `root_cause_pending` | Execute `escalate-patterns.mjs` e inicie análise de causa raiz |

### Antes de criar qualquer workaround para uma ferramenta externa:
1. Verifique se existe `/50-skills/tool-patterns/{tool}.md`
2. Se `status: auto_fix` → aplique o fix documentado sem intervenção humana
3. Se não existir → registre no inbox para iniciar o rastreamento

### Formato obrigatório no inbox para tool_pattern:

```
---
source: [agente ou sessão]
date: YYYY-MM-DD
type: tool_pattern
tool: [nome da ferramenta ou biblioteca]
symptom: [descrição objetiva do problema]
fix: [solução encontrada, se já conhecida]
confidence: verified
risk: low | medium | high
---
[contexto adicional se necessário]
```

### O que NÃO fazer:
- Criar workarounds silenciosos sem registrar o padrão
- Confundir `tool_pattern` com `fact` ou `preference` — são tipos distintos
- Misturar padrões de ferramentas com contexto de projeto ou cliente
