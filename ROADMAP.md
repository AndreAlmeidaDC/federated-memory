# ROADMAP

Estado vivo do projeto. Itens entregues ficam aqui pra histórico. O `git log` é o changelog detalhado; este arquivo é o mapa.

Critério: só entra no ROADMAP o que tem chance real de acontecer. Wishlist sem dono vai pra issue, não pra cá.

Última revisão: 2026-06 — pós-reposicionamento v3.0

---

## Entregue

### Reposicionamento v3.0 (o pivô central)

- [x] Teste de campo (EXP-001) derrubou o Hermes como núcleo ativo: o `hermes.policy.yml`, os gatilhos semânticos e o papel de porteiro descritos na v2 não existem no Hermes real
- [x] Whitepaper e guia reescritos: memória passiva e soberana, Git como espinha, agentes como clientes intercambiáveis, nenhum núcleo
- [x] Seção 05 do whitepaper ("O Núcleo Ativo") e 09b do guia ("Os quatro papéis do Hermes") demolidas e substituídas
- [x] Threat model em dois modos declarados: cooperativo (contrato) e adversarial (hardening de OS)
- [x] Escada de maturidade: piso (vault + Git + contrato) → sync contínuo → MCP → Graphiti → hardening, sob dor
- [x] Degrau zero documentado: quando um arquivo de contrato simples (CLAUDE.md / AGENTS.md) já basta
- [x] Captura por hooks do próprio agente (`capture-to-inbox.mjs`) como caminho principal, agnóstico de agente
- [x] Versões PT e EN do whitepaper e do guia em v3.0
- [x] Release `v3.0` no GitHub com os 4 PDFs

### Conteúdo (histórico)

- [x] Whitepaper PT-BR v1.0 e EN
- [x] Guia de implementação PT-BR e EN
- [x] PDFs publicados como assets de release no GitHub

### Template de vault

- [x] Estrutura de 11 pastas (00-global ... 99-archive)
- [x] `AGENT.md` com governança proporcional ao risco (`verified`+`low` promove por TTL; hipótese e alto risco vão ao humano) e resolução de conflito (`approved`/`superseded`)
- [x] Inbox + log de revisão em `99-archive/`
- [x] `/70-decisions/` com README documentando o frontmatter obrigatório
- [x] Estrutura de mente de colmeia em `50-skills/` (published/proposed/deprecated + INDEX)
- [x] SESSION.lock + audit trail de sessões
- [x] Memória de padrões recorrentes por ferramenta (`tool-patterns/`, 3 tiers)

### Context Packs de exemplo (com campo `Validation`)

- [x] `exemplo-linkedin-writing.md`
- [x] `exemplo-code-review.md`
- [x] `exemplo-research.md`
- [x] `exemplo-planning.md`
- [x] `exemplo-bug-tracking.md`

### Adaptadores (11 agentes)

- [x] Claude Code, Cursor, Codex, Windsurf, OpenCode, Antigravity, Kimi Code, Grok Build, Pi, Command Code, MiMo Code

### Estrutura de evidências e governança

- [x] `hypotheses/`, `experiments/`, `cases/` com READMEs
- [x] `experiments/EXP-001-governanca-por-contrato.md`
- [x] `CHANGELOG.md`, `GOVERNANCE.md`
- [x] `docs/definitions.md`, `docs/references.md`
- [x] Templates `.github` (issue, PR)

### Scripts

- [x] `setup.sh` / `setup.ps1` — provisionamento do piso (vault + Git na branch master), sem Hermes nem MCP
- [x] `scripts/review-inbox.{sh,ps1}` — revisão do inbox com TTL e filtro por risco
- [x] `scripts/capture-to-inbox.mjs`, `pre-action-log.mjs`, `promote-skills.mjs`, `update-index.mjs`, `escalate-patterns.mjs`

---

## Próximo (prioridade alta)

- [ ] Validação do QUICKSTART v3 na máquina do André, do zero, antes de divulgar amplamente
- [ ] Validação independente do QUICKSTART v3 pelo Vini
- [ ] Migração do setup pessoal do André para Git no centro (sair de Obsidian Sync), publicada como primeiro case em `/cases/`
- [ ] Pelo menos um relato de implementação real de terceiro publicado em `/cases/`

## Próximo (prioridade média)

- [ ] Context Pack de exemplo: `exemplo-customer-support.md`
- [ ] Context Pack de exemplo: `exemplo-data-analysis.md`
- [ ] Exemplo de domínio real preenchido em `/template/20-domains/<exemplo>/` para mostrar como o vault parece em uso
- [ ] GitHub Action que valida estrutura do vault (presença de `AGENT.md`, formato de Context Packs)

## Backlog (sem data)

- [ ] Variante mínima do template em `/template-minimal/` (sem 10-projects, 30-clients, 99-archive) para quem só quer testar
- [ ] Comparativo lado a lado com Letta, MemGPT, Zep e Mem0 num arquivo único (`COMPARISON.md`)
- [ ] Suporte explícito a multi-vault físico
- [ ] Integração de referência com DecisionNode no sub-módulo de decisões
- [ ] Avaliar integração com Sinapse Vault (Michel) como camada de sessão

---

## Visão de longo prazo: quando o vault escalar

Conjunto de problemas que aparecem quando o vault tem centenas de decisões e o agente começa a ter dificuldade de achar contexto sem carregar tudo. Adicione quando sentir a dor, não antes.

- Graphiti (Zep) para memória temporal: decisões que substituem decisões, relações entre entidades, histórico de mudanças, consultas "o que mudou?". Sempre como índice derivado dos Markdown, nunca substituto da fonte
- Busca semântica local: FTS5 (SQLite) para texto + embeddings para busca vetorial
- Worker local que indexa o vault quando arquivos mudam; índice dentro do vault em `/99-archive/index/`, portável e versionável
- Harness avançado: toolset por domínio (restrição de ferramentas MCP por contexto), observabilidade (tokens por sessão, tempo de execução, taxa de sucesso de captura)

Esses itens são a camada de escala. Não confundir com o piso: quase todo mundo fica no piso (vault + Git + contrato) e nunca precisa disto.

---

## Fora de escopo

Itens propostos mas explicitamente rejeitados. Não reabrir sem motivo novo.

- **Backend hospedado como serviço.** Quebra o princípio de soberania do usuário.
- **Memória automática sem revisão.** Anti-pattern central do whitepaper. Promoção automática existe só para `verified` + `low` risco, com TTL; o resto passa por humano.
- **Adaptador único universal.** Cada agente tem convenções próprias; um adaptador genérico vira o pior denominador comum.
- **Embeddings/RAG no caminho crítico.** Opcional para busca, nunca substitui Markdown como fonte.
- **Núcleo ativo / policy engine no lado do agente.** Refutado empiricamente (EXP-001). Enforcement de escrita contra agente hostil não é função de nenhum componente do lado do agente; vem do sistema operacional. Reintroduzir um "núcleo que aplica política" é repetir o erro que a v3 corrigiu.

---

## Como contribuir com o roadmap

- Item novo: abra issue com label `roadmap-proposal` e proposta de em qual seção encaixaria
- Item entregue: PR que move o item para "Entregue" no mesmo commit da entrega
- Item que mudou de prioridade: PR justificando o motivo
