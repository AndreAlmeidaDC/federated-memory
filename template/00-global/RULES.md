# Global Rules

Regras transversais a todos os projetos. Carregadas pelo agente em toda sessão junto com AGENT.md.
Para sobrescrever uma regra em projeto específico, registre um override em 70-decisions/ do projeto com os campos obrigatórios.

---

## Company Rules

- stack: [ex: TypeScript, nunca MongoDB]
- padrão de testes: [ex: TDD obrigatório]
- segurança: [ex: nunca commitar secrets, usar variáveis de ambiente]

## Dev Rules

- commits: [ex: inglês, imperativo, máximo 72 caracteres]
- PR: [ex: nunca maior que 400 linhas]
- revisão: [ex: auto-review antes de abrir PR]

---

Edite as regras acima para refletir os padrões reais da sua empresa e do seu fluxo de trabalho.
Mantenha este arquivo curto e estável. Regras voláteis pertencem ao projeto, não aqui.
