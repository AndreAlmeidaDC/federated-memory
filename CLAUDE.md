# CLAUDE.md — Contexto do Projeto: Memória Federada

## O que esse projeto é

André Almeida mantém dois artefatos sobre memória federada para agentes de IA, publicados como referência comunitária num repositório GitHub público:

1. **Whitepaper** — argumento arquitetural, paper técnico, sem passo a passo
2. **Guia de implementação** — passo a passo executável com comandos reais, templates e diagramas SVG

Além disso, o repositório distribui um **template clonável** de vault e adaptadores para múltiplos agentes.

---

## Estado atual

### Whitepaper

- `whitepaper/whitepaper-memoria-federada-ptbr.html` — **v2.0 completo**
- Inclui seção de limitações conhecidas (rollback, validade temporal, governança, escala)
- Inclui comparação honesta com Paperclip (orquestração complementar) e Pi (agente minimalista, caso de uso ideal)
- PDF distribuído via release v2.0.1 no GitHub

### Guia de implementação

- `guia/memoria-federada-v2.html` — **v2.0 com 20 seções + 06b (multimodal/assets) + 09c (captura automática via hooks)**
- Diagramas SVG inline (sem dependência de imagens externas)
- Hermes como **núcleo ativo** com 4 papéis: roteador, gerenciador de memória com feedback, controlador de escopo, policy engine declarativo
- Inclui seção 12b de **deployment remoto** (VPS, SSH tunnel, MCP via Caddy)
- Inclui Graphiti como camada temporal opcional (seção 13)
- PDF distribuído via release v2.0.1

### Template de vault (`/template/`)

11 pastas numeradas (00 a 99):

```
00-global/         AGENT.md — contrato neutro
10-projects/       projetos ativos
20-domains/        domínios isolados
30-clients/        contexto de clientes
40-workflows/      fluxos de trabalho
50-skills/         procedimentos de execução reutilizáveis (README + exemplo)
60-context-packs/  pacotes de contexto mínimo por tarefa
70-decisions/      decisões formais com status
80-agent-adapters/ adaptadores por agente
90-inbox/          único destino de escrita do agente
99-archive/        logs e arquivados
```

### Adaptadores (10 agentes em `/template/80-agent-adapters/`)

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

### Context Packs (`/template/60-context-packs/`)

5 packs prontos, todos com campo `Validation` para validade temporal:

- `exemplo-linkedin-writing.md`
- `exemplo-code-review.md`
- `exemplo-research.md`
- `exemplo-planning.md`
- `exemplo-bug-tracking.md`

### Documentos auxiliares

- `QUICKSTART.md` — ponto de entrada (30–60 min, 8 passos com critério de conclusão)
- `ROADMAP.md` — o que vem a seguir
- `CONTRIBUTING.md` — como contribuir
- `LICENSE` — CC BY 4.0

### Scripts

- `setup.sh` / `setup.ps1` — instala vault, Hermes, MCP server, gera settings.json
- `scripts/review-inbox.sh` / `.ps1` — ritual de revisão do inbox
- `scripts/build-pdfs.sh` / `.ps1` — gera PDFs do whitepaper e do guia via Chromium headless

### Releases publicadas

- **v2.0.1** (atual) — Limitações conhecidas + progressão Graphiti + comparação Paperclip/Pi
- v2.0.0 — Hermes núcleo ativo
- v1.0.0 — lançamento inicial

---

### Classificação automática (v2.0.2)

- `AGENT.md` agora exige `confidence` + `risk` em toda sugestão de inbox
- `verified + low` com TTL <=7 dias promove-se automaticamente para o domínio
- `hypothesis`, `high risk` e entradas sem classificação vão para revisão humana
- `verified + medium` fica no inbox como aprovação lazy
- Scripts `review-inbox.{sh,ps1}` aplicam essas regras antes da revisão interativa
- Whitepaper: princípio 5 reformulado de "aprovação humana obrigatória" para "humano como auditor de última instância"

## Backlog restante

- Versão em inglês do whitepaper (branch `wip/english`, após validação PT-BR)
- Validação real do QUICKSTART na máquina do André antes de divulgar amplamente
- Pack-usage logger no Hermes — implementação de referência do logging de uso
- GitHub Action para validar estrutura do vault (presença de `AGENT.md`, formato de Context Packs, etc.)
- Templates por área (escritor, dev, pesquisador) — perfis pré-configurados de domínios e packs
- Plugin Obsidian dedicado para Context Packs (criação assistida, validação de campos)
- Avaliar integração do ai-memory (github.com/akitaonrails/ai-memory) após estabilização — hoje em beta com dependência Docker

---

## Decisões tomadas (não reabrir sem motivo)

**Formato:** Whitepaper separado do guia de implementação. Whitepaper fala de princípios, guia fala de comandos.

**Idioma:** Português primeiro, inglês depois. As duas versões existirão.

**Título do whitepaper:** "Memória Federada: Por que Agentes de IA Não Devem Ser Donos do Contexto"

**Tese central:** O problema de memória em agentes de IA não é falta de ferramentas. É ausência de separação entre quem guarda, quem roteia e quem executa. Memória federada resolve isso devolvendo o contexto a quem ele pertence: o usuário.

**Stack de referência:** Obsidian + Hermes Agent (NousResearch) + MCP server para Obsidian + Context Packs.

**Posicionamento do DecisionNode:** convergência independente que valida a arquitetura. Citado no whitepaper e no guia. Não integrado como backend.

**Posicionamento do Paperclip:** camada complementar (orquestração entre agentes), não concorrente.

**Posicionamento do Pi:** agente minimalista sem memória própria — caso de uso ideal para memória federada.

---

## Princípios que não mudam

1. Soberania do usuário — memória pertence ao usuário, não ao agente
2. Isolamento por domínio — domínios distintos não compartilham espaço semântico
3. Contrato neutro — `AGENT.md` descreve consumo para qualquer agente
4. Contexto mínimo suficiente — Context Packs, não dump do vault inteiro
5. Aprovação humana — nada vira memória permanente sem revisão

---

## Anti-patterns identificados (não repetir)

- Super cérebro único — mistura tudo, contamina tudo
- Contexto sempre ativo — agente carrega memória inteira
- Memória automática sem revisão — hipótese vira fato
- Adaptador como fonte principal — prende a uma ferramenta
- MCP/API sem escopo de permissões — escrita restrita a `/90-inbox/`

---

## Tom e estilo

**Whitepaper:** linguagem de paper técnico, sem comandos de terminal, argumentativo, comparações honestas incluindo onde a proposta perde. Sem elogios desnecessários à própria arquitetura.

**Guia:** direto, executável, cada passo tem critério de conclusão objetivo. Sem passos vagos.

**André como autor:** não suavizar realidade, não fazer elogios desnecessários, ser parceiro crítico.

---

## Referências do projeto

- Hermes Agent: https://github.com/NousResearch/hermes-agent
- DecisionNode: https://github.com/decisionnode/DecisionNode
- Model Context Protocol: https://modelcontextprotocol.io
- Graphiti (Zep): https://help.getzep.com/graphiti/graphiti/overview
- Paperclip: https://paperclip.ing
- Pi: https://pi.dev
- Claude Code Memory: https://docs.claude.com/en/docs/claude-code/memory
