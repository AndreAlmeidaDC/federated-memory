# ROADMAP

Estado vivo do projeto. Itens entregues ficam aqui pra histórico, não migram pra "changelog" — o `git log` já é o changelog.

Critério: só entra no ROADMAP o que tem chance real de acontecer. Wishlist sem dono vai pra issue, não pra cá.

Última revisão: 2026-05-18

---

## Entregue

### Conteúdo
- [x] Whitepaper PT-BR v1.0 (`whitepaper/whitepaper-memoria-federada-ptbr.html`)
- [x] Guia de implementação v2.0 com seção de deployment remoto (`guia/memoria-federada-v2.html`)
- [x] PDFs do whitepaper e do guia publicados na release `v1.0.0`

### Template de vault
- [x] Estrutura clonável em `/template/` (00-global, 10-domains, 20-projects, 30-context-packs, 40-agent-adapters, 50-inbox, 90-archive)
- [x] `AGENT.md` neutro como contrato
- [x] Inbox + log de revisão em `90-archive/review-log.md`

### Context Packs de exemplo
- [x] `exemplo-linkedin-writing.md`
- [x] `exemplo-code-review.md`
- [x] `exemplo-research.md`
- [x] `exemplo-planning.md`

### Adaptadores
- [x] Claude Code (`claude/CLAUDE.md`)
- [x] Cursor (`cursor/.cursorrules` + variante Project Rules)
- [x] OpenAI Codex CLI (`codex/AGENTS.md`)
- [x] Windsurf / Cascade (`windsurf/.windsurfrules`)

### Scripts
- [x] `setup.sh` / `setup.ps1` — provisionamento idempotente do vault
- [x] `scripts/review-inbox.sh` / `.ps1` — ritual semanal de revisão do inbox
- [x] `scripts/build-pdfs.sh` / `.ps1` — geração dos PDFs via Chromium headless

---

## Próximo (prioridade alta)

- [ ] Validação da v1.0 PT-BR com leitores externos (alvo: 3 revisões qualificadas)
- [ ] Lançamento da versão em inglês do whitepaper (branch `wip/english`, ver issue #4)
- [ ] Pelo menos um relato de implementação real publicado como case (`/cases/`)

## Próximo (prioridade média)

- [ ] Adaptador Antigravity
- [ ] Context Pack de exemplo: `exemplo-customer-support.md`
- [ ] Context Pack de exemplo: `exemplo-data-analysis.md`
- [ ] Exemplo de domínio real preenchido em `/template/10-domains/<exemplo>/` para mostrar como o vault parece em uso
- [ ] Workflow do GitHub Actions que regenera PDFs e anexa em cada nova release

## Backlog (sem data)

- [ ] Tradução do guia de implementação para inglês (após validação do whitepaper EN)
- [ ] Variante mínima do template em `/template-minimal/` (sem 20-projects, sem 90-archive) para quem só quer testar
- [ ] Comparativo lado a lado com Letta, MemGPT, Zep e Mem0 num arquivo único (`COMPARISON.md`)
- [ ] Suporte explícito a multi-vault (vários vaults compondo memória de um agente)
- [ ] Integração de referência com DecisionNode no sub-módulo de decisões

---

## Fora de escopo

Itens propostos mas explicitamente rejeitados. Não reabrir sem motivo novo.

- **Backend hospedado como serviço.** Quebra o princípio de soberania do usuário.
- **Memória automática sem revisão.** Anti-pattern central do whitepaper.
- **Adaptador único universal.** Cada agente tem convenções próprias; um adaptador-genérico vira o pior denominador comum.
- **Embeddings/RAG no caminho crítico.** Opcional para busca, nunca substitui Markdown como fonte.

---

## Como contribuir com o roadmap

- Item novo: abra issue com label `roadmap-proposal` e proposta de em qual seção encaixaria
- Item entregue: PR que move o item para "Entregue" no mesmo commit da entrega
- Item que mudou de prioridade: PR justificando o motivo
