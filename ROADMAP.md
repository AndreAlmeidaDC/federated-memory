# ROADMAP

Estado vivo do projeto. Itens entregues ficam aqui pra histórico, não migram pra "changelog" — o `git log` já é o changelog.

Critério: só entra no ROADMAP o que tem chance real de acontecer. Wishlist sem dono vai pra issue, não pra cá.

Última revisão: 2026-05-18 — pós-reescrita Hermes-core v2.0

---

## Entregue

### Conteúdo
- [x] Whitepaper PT-BR v1.0 — primeiro lançamento
- [x] Whitepaper PT-BR **v2.0** — Hermes como núcleo ativo, três gaps fechados, validade temporal automática, comparação com sistemas centralizadores/Life OS
- [x] Guia de implementação v2.0 (estrutura inicial)
- [x] Guia de implementação **v2.0 (reescrita)** — Hermes-core, seção "Os quatro papéis do Hermes", nova estrutura de pastas, conceito "Vault único"
- [x] PDFs do whitepaper e do guia publicados na release `v1.0.0` (PDFs da v2 entrarão em `v2.0.0`)

### Template de vault
- [x] Estrutura inicial em `/template/` (6 pastas)
- [x] **Reestruturação para 11 pastas** (00-global, 10-projects, 20-domains, 30-clients, 40-workflows, 50-skills, 60-context-packs, 70-decisions, 80-agent-adapters, 90-inbox, 99-archive)
- [x] `AGENT.md` v2.0 com regra de resolução de conflito (`approved`/`superseded`)
- [x] Inbox + log de revisão em `99-archive/review-log.md`
- [x] Diretório `/70-decisions/` com README documentando o frontmatter obrigatório

### Context Packs de exemplo (com campo `Validation`)
- [x] `exemplo-linkedin-writing.md`
- [x] `exemplo-code-review.md`
- [x] `exemplo-research.md`
- [x] `exemplo-planning.md`

### Adaptadores (com política de escrita unificada)
- [x] Claude Code (`claude/CLAUDE.md` + `claude/AGENTS.md` cross-tool)
- [x] Cursor (`cursor/.cursorrules` + variante Project Rules)
- [x] OpenAI Codex CLI (`codex/AGENTS.md`)
- [x] Windsurf / Cascade (`windsurf/.windsurfrules`)

### Scripts
- [x] `setup.sh` / `setup.ps1` — provisionamento idempotente do vault
- [x] `scripts/review-inbox.sh` / `.ps1` — ritual semanal de revisão do inbox
- [x] `scripts/build-pdfs.sh` / `.ps1` — geração dos PDFs via Chromium headless

### Reescrita Hermes-core (v2.0)
- [x] Hermes promovido a núcleo ativo com quatro papéis: roteador, gerenciador de memória com feedback, controlador de escopo, policy engine declarativo
- [x] Gap 1 fechado: campo `Validation:` em todos os Context Packs
- [x] Gap 2 fechado: regra explícita `approved`/`superseded` em `/70-decisions/` e no AGENT.md
- [x] Gap 3 fechado: política de escrita aplicada pelo núcleo em qualquer modo (interativo, headless, agendado), restrita a `/90-inbox/`
- [x] Diferencial: validade temporal automática por inspeção de `mtime`

---

## Próximo (prioridade alta)

- [ ] Validação da v2.0 PT-BR com leitores externos (alvo: 3 revisões qualificadas)
- [ ] Release `v2.0.0` no GitHub com PDFs regenerados do whitepaper e do guia v2
- [ ] Lançamento da versão em inglês do whitepaper (branch `wip/english`, ver issue #4 — depende da validação PT-BR estabilizar)
- [ ] Pelo menos um relato de implementação real publicado como case (`/cases/`)
- [ ] Pack-usage logger no Hermes (referência de implementação concreta do papel 2 do núcleo)

## Próximo (prioridade média)

- [ ] Adaptador Antigravity (com política de escrita unificada)
- [ ] Context Pack de exemplo: `exemplo-customer-support.md`
- [ ] Context Pack de exemplo: `exemplo-data-analysis.md`
- [ ] Exemplo de domínio real preenchido em `/template/20-domains/<exemplo>/` para mostrar como o vault parece em uso
- [ ] Workflow do GitHub Actions que regenera PDFs e anexa em cada nova release

## Backlog (sem data)

- [ ] Tradução do guia de implementação para inglês (após validação do whitepaper EN)
- [ ] Variante mínima do template em `/template-minimal/` (sem 10-projects, sem 30-clients, sem 99-archive) para quem só quer testar
- [ ] Comparativo lado a lado com Letta, MemGPT, Zep e Mem0 num arquivo único (`COMPARISON.md`)
- [ ] Suporte explícito a multi-vault físico (vários vaults compondo memória de um agente)
- [ ] Integração de referência com DecisionNode no sub-módulo de decisões
- [ ] Exemplo concreto de `hermes.policy.yml` configurável por projeto

---

## Visão de longo prazo

### v3.0 — Quando o vault escalar

- Graphiti (Zep) para memória temporal: decisões que substituem decisões, relações entre entidades, histórico de mudanças, consultas "o que mudou?"
- Busca semântica local: FTS5 (SQLite) para busca por texto + embeddings para busca semântica vetorial
- Worker local que indexa o vault automaticamente quando arquivos mudam
- O índice fica dentro do vault em `/99-archive/index/` — portável e versionável
- Inspiração técnica: padrão de 3 camadas do claude-mem (`search → timeline → get_observations`) com economia de tokens

**Harness Engineering avançado:**
- Toolset por domínio: restrição de ferramentas MCP por contexto de trabalho — agente em `/30-clients/` acessa só ferramentas de cliente; agente em `/20-domains/engineering/` acessa só ferramentas de código
- Observabilidade completa: tokens por sessão, tempo de execução, ferramentas mais usadas, taxa de sucesso de captura de memória
- Inspiração: padrão de worker service do claude-mem com métricas por sessão

> v3.0 não é uma data. É um conjunto de problemas que aparecem quando o vault tem centenas de decisões e o agente começa a ter dificuldade de encontrar contexto relevante sem carregar tudo. Adicione quando sentir essa dor.

---

## Fora de escopo

Itens propostos mas explicitamente rejeitados. Não reabrir sem motivo novo.

- **Backend hospedado como serviço.** Quebra o princípio de soberania do usuário.
- **Memória automática sem revisão.** Anti-pattern central do whitepaper.
- **Adaptador único universal.** Cada agente tem convenções próprias; um adaptador-genérico vira o pior denominador comum.
- **Embeddings/RAG no caminho crítico.** Opcional para busca, nunca substitui Markdown como fonte.
- **Núcleo ativo opcional.** Sem ele, os três gaps reabrem; a arquitetura vira pasta organizada.

---

## Como contribuir com o roadmap

- Item novo: abra issue com label `roadmap-proposal` e proposta de em qual seção encaixaria
- Item entregue: PR que move o item para "Entregue" no mesmo commit da entrega
- Item que mudou de prioridade: PR justificando o motivo
