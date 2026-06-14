# CLAUDE.md — Contexto do Projeto: Memória Federada

## O que esse projeto é

André Almeida mantém dois artefatos sobre memória federada para agentes de IA, publicados como referência comunitária num repositório GitHub público:

1. **Whitepaper** — argumento arquitetural, paper técnico, sem passo a passo
2. **Guia de implementação** — passo a passo executável com comandos reais, templates e diagramas SVG

Além disso, o repositório distribui um **template clonável** de vault e adaptadores para múltiplos agentes.

---

## Tese central (v3)

O problema de memória em agentes de IA não é falta de ferramentas. É ausência de separação entre **quem guarda** o contexto e **quem o executa**. Memória federada resolve isso devolvendo o contexto a quem ele pertence: o usuário. A memória é passiva, soberana, versionada em Git. Os agentes são clientes intercambiáveis. Não existe um terceiro componente ativo no meio.

**Importante para quem edita este repo:** a v2 deste projeto descreveu o Hermes como "núcleo ativo" com quatro papéis (roteador, gerenciador de memória, controlador de escopo, policy engine declarativo). Esse desenho foi refutado por teste de campo e pela documentação oficial do Hermes: o `hermes.policy.yml` e os gatilhos semânticos descritos na v2 não existem. O Hermes é um agente de código completo, com memória própria, não um porteiro. A v3 corrigiu isso. Ao editar qualquer documento, **nunca reintroduza a linguagem de núcleo ativo, roteador central ou policy engine como capacidade real.** Onde esses termos aparecem nos HTMLs, é sempre na refutação histórica, e deve permanecer só nesse contexto.

---

## Estado atual (v3.0)

### Whitepaper

- `whitepaper/whitepaper-ptbr.html` — v3.0 (PT-BR)
- `whitepaper/whitepaper-en.html` — v3.0 (EN)
- Seção 05 reescrita: "O Agente como Cliente" (a antiga "O Núcleo Ativo" foi demolida)
- Governança em dois modos declarados: cooperativo (contrato) e adversarial (hardening de OS)
- Escada de maturidade: piso (vault + Git + contrato) → sync contínuo → MCP → Graphiti → hardening, sempre sob dor
- Degrau zero na seção 07: quando um arquivo de contrato simples (CLAUDE.md / AGENTS.md) já basta
- Governança proporcional ao risco: `verified` + `low` promove por TTL; hipóteses e alto risco exigem decisão humana
- Mapeamento ACE: agente cliente (Generator), captura/classificação confidence-risk + review (Reflector), promoção por TTL (Curator). "ACE com governança proporcional ao risco"

### Guia de implementação

- `guia/guia-ptbr.html` — v3.0 (PT-BR)
- `guia/guia-en.html` — v3.0 (EN)
- Diagramas SVG inline (sem dependência de imagens externas)
- Seção 09b "Os quatro papéis do Hermes" demolida; substituída pela memória passiva e agente como cliente
- Captura automática por hooks do próprio agente (PostToolUse rodando `scripts/capture-to-inbox.mjs`) como caminho principal, agnóstico de agente
- Seção de deployment remoto com Git no centro (sincroniza e versiona); Obsidian Sync citado só como contraste (não versiona, amarra a vendor)
- Harness real: shell hooks + approvals + permissões; enforcement forte é OS/container. Sem triggers semânticos inventados
- Graphiti como índice derivado dos Markdown, não substituto da fonte

### Template de vault (`/template/`)

11 pastas numeradas (00 a 99):

```
00-global/         AGENT.md — contrato neutro (governança risk-proportional, mente de colmeia)
10-projects/       projetos ativos (+ SESSION.lock.example)
20-domains/        domínios isolados
30-clients/        contexto de clientes
40-workflows/      fluxos de trabalho
50-skills/         skills reutilizáveis (published/ proposed/ deprecated/ + INDEX.md)
60-context-packs/  pacotes de contexto mínimo por tarefa
70-decisions/      decisões formais com status approved/superseded
80-agent-adapters/ adaptadores por agente
90-inbox/          único destino de escrita do agente
99-archive/        logs e arquivados (+ session-log.md)
```

### Adaptadores (11 agentes em `/template/80-agent-adapters/`)

| Agente | Arquivo |
|---|---|
| Claude Code | `claude/CLAUDE.md` + `claude/AGENTS.md` |
| Cursor | `cursor/.cursorrules` |
| Codex | `codex/AGENTS.md` |
| Windsurf | `windsurf/.windsurfrules` |
| OpenCode | `opencode/AGENTS.md` (nativo v1.15+) |
| Antigravity | `antigravity/AGENTS.md` (Google, beta 2026-05-19) |
| Kimi Code CLI | `kimi/AGENTS.md` (MoonshotAI v1.44) |
| Grok Build | `grok/AGENTS.md` (xAI, beta maio/2026) |
| Pi | `pi/AGENTS.md` (pi.dev, filesystem direto sem MCP) |
| Command Code | `commandcode/AGENTS.md` (commandcode.ai, taste + skills nativas) |
| MiMo Code | `mimocode/AGENTS.md` (Xiaomi, fork do OpenCode, AGENTS.md nativo) |

Nenhum desses agentes é o núcleo. Quando o Hermes é usado, é um cliente entre vários.

### Context Packs (`/template/60-context-packs/`)

5 packs prontos, todos com campo `Validation` para validade temporal:

- `exemplo-linkedin-writing.md`
- `exemplo-code-review.md`
- `exemplo-research.md`
- `exemplo-planning.md`
- `exemplo-bug-tracking.md`

### Documentos auxiliares

- `QUICKSTART.md` — ponto de entrada v3 (piso primeiro: vault + Git + contrato + agente, sem Hermes e sem MCP)
- `CHANGELOG.md` — histórico de versões (v3.0.0 no topo)
- `GOVERNANCE.md` — fluxo, threat model, rastreamento de hipóteses
- `ROADMAP.md` — o que vem a seguir
- `CONTRIBUTING.md` — como contribuir
- `docs/definitions.md` — glossário com âncoras da indústria
- `docs/references.md` — fontes primárias
- `LICENSE` — CC BY 4.0

### Estrutura de evidências

- `hypotheses/` — afirmações ainda não validadas empiricamente
- `experiments/` — testes; `EXP-001-governanca-por-contrato.md` registra o teste de campo que derrubou o núcleo ativo
- `cases/` — relatos de implementação real

### Scripts

- `setup.sh` / `setup.ps1` — provisionamento do piso (vault + Git na branch master + primeiro commit). Não instala Hermes nem MCP
- `scripts/review-inbox.sh` / `.ps1` — ritual de revisão do inbox, com TTL automático e filtro por risco (verified+low promove auto, verified+medium fica como pending_lazy, hypothesis/high/sem classificação vão para humano)
- `scripts/capture-to-inbox.mjs` — hook PostToolUse que detecta decisões/preferências/bugs via regex e anexa sugestões classificadas no inbox
- `scripts/pre-action-log.mjs` — hook PreToolUse que detecta ações de alto risco e registra em `template/99-archive/pre-action-log.md`. Não bloqueia, só audita
- `scripts/promote-skills.mjs` — processa `template/50-skills/proposed/`, aplica confidence+risk+TTL, move verified+low para `published/` quando TTL venceu
- `scripts/update-index.mjs` — regenera `template/50-skills/INDEX.md` a partir de `published/`
- `scripts/escalate-patterns.mjs` — processa `type: tool_pattern` no inbox, mantém ledger em `50-skills/tool-patterns/`, escalada 3 tiers: observed → auto_fix → root_cause_pending
- `template/.claude/hooks.json` — configuração de hooks: PreToolUse (pre-action-log) + PostToolUse (capture-to-inbox)

> A geração de PDF não usa script no repo. Os PDFs são gerados via WeasyPrint, fora do repositório, e distribuídos como assets da release no GitHub.

### Releases

Tags reais no repositório: `v1.0.0`, `v2.0.0`, `v2.0.1`, `v2.1.0`, `v2.3.0`, `v2.4.0`, `v3.0`. A release **v3.0** é a atual e traz os 4 PDFs (whitepaper e guia, PT e EN). As tags v2.x são histórico; o conteúdo v2 foi reposicionado pela v3.

---

## Backlog restante

- Validação real do QUICKSTART v3 na máquina do André antes de divulgar amplamente
- Vini valida o QUICKSTART v3 quando a documentação estiver finalizada
- Pelo menos um relato de implementação real publicado em `/cases/`
- Migração do setup pessoal do André para Git no centro (tirar Obsidian Sync), que vira o primeiro caso testado do caminho recomendado
- GitHub Action para validar estrutura do vault (presença de `AGENT.md`, formato de Context Packs)
- Avaliar integração com Sinapse Vault do Michel como camada de sessão
- Quando o vault escalar: Graphiti + FTS5 + busca semântica + worker local de indexação

---

## Decisões tomadas (não reabrir sem motivo)

**Formato:** Whitepaper separado do guia. Whitepaper fala de princípios, guia fala de comandos.

**Idioma:** Português e inglês, as duas versões existem.

**Título do whitepaper:** "Memória Federada: Por que Agentes de IA Não Devem Ser Donos do Contexto"

**Tese central (v3):** separação entre quem guarda e quem executa; memória passiva e soberana; Git como espinha; agentes como clientes intercambiáveis; sem núcleo ativo.

**Governança:** dois modos declarados (cooperativo por contrato, adversarial por hardening de OS) e promoção proporcional ao risco.

**Stack de referência:** vault Markdown + Git (piso). Obsidian, MCP e Graphiti são camadas opcionais sob dor. Hermes é um adaptador entre vários, não o núcleo.

**Posicionamento do DecisionNode:** convergência independente que valida a arquitetura. Citado, não integrado como backend.

**Posicionamento do Paperclip:** camada complementar (orquestração entre agentes), não concorrente.

**Posicionamento do Pi:** agente minimalista sem memória própria, caso de uso ideal para memória federada.

---

## Princípios que não mudam

1. Soberania do usuário — memória pertence ao usuário, não ao agente
2. Isolamento por domínio — domínios distintos não compartilham espaço semântico
3. Contrato neutro — `AGENT.md` descreve consumo para qualquer agente
4. Contexto mínimo suficiente — Context Packs, não dump do vault inteiro
5. Git como espinha — versionamento e sincronização vêm do Git
6. Revisão proporcional ao risco — `verified` + `low` promove por TTL; hipóteses e alto risco exigem decisão humana. O humano é filtro de qualidade, não gargalo de captura

---

## Anti-patterns identificados (não repetir)

- Super cérebro único — mistura tudo, contamina tudo
- Contexto sempre ativo — agente carrega memória inteira
- Memória automática sem revisão — hipótese vira fato
- Adaptador como fonte principal — prende a uma ferramenta
- MCP/API tratado como governança — acesso confundido com controle de escrita
- Núcleo ativo / orquestrador cedo demais — componente central que ninguém entende; começar com leitura direta, adicionar orquestração só quando doer

---

## Tom e estilo

**Whitepaper:** linguagem de paper técnico, sem comandos de terminal, argumentativo, comparações honestas incluindo onde a proposta perde. Sem elogios à própria arquitetura.

**Guia:** direto, executável, cada passo tem critério de conclusão objetivo. Sem passos vagos.

**André como autor:** não suavizar realidade, não fazer elogios desnecessários, ser parceiro crítico. Sem travessões nos textos em PT-BR.

---

## Referências do projeto

- Hermes Agent: https://github.com/NousResearch/hermes-agent
- DecisionNode: https://github.com/decisionnode/DecisionNode
- Model Context Protocol: https://modelcontextprotocol.io
- Graphiti (Zep): https://help.getzep.com/graphiti/graphiti/overview
- Paperclip: https://paperclip.ing
- Pi: https://pi.dev
- Claude Code Memory: https://docs.claude.com/en/docs/claude-code/memory
- ACE (Agentic Context Engineering): arXiv 2510.04618
