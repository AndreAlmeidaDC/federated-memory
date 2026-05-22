# AGENTS.md — Adaptador para Command Code (commandcode.ai)

Este arquivo segue a convenção `AGENTS.md` adotada pelo Command Code,
lida automaticamente de dois lugares:

1. `./AGENTS.md` na raiz do projeto
2. `./.commandcode/AGENTS.md` (alternativo, quando você prefere manter a raiz limpa)

Traduz o contrato neutro de [`../../00-global/AGENT.md`](../../00-global/AGENT.md) para o consumo do Command Code.
Se houver conflito, `00-global/AGENT.md` prevalece.

## Nota sobre integração: taste e skills nativas do Command Code

Command Code traz dois sistemas próprios que **complementam** a memória federada
sem substituí-la:

- **Taste** — aprende com aceitações e rejeições automaticamente. É memória implícita de preferência, derivada de comportamento do usuário em runtime, mantida pela ferramenta.
- **Skills nativas** — biblioteca interna de procedimentos do próprio Command Code, evoluída pela equipe da ferramenta.

A relação com este vault:

- **Taste é da ferramenta, contexto é do usuário.** Taste reflete preferências aprendidas dentro do Command Code; não substitui o `AGENT.md`, os Context Packs ou as decisões com status. Quando taste e contrato divergem, o contrato vence — taste é heurística, não política.
- **Skills curadas humanas vivem em `/50-skills/`.** As skills nativas são automáticas; as skills do vault são deliberadas. Você pode (e deve) referenciar a pasta `/50-skills/` deste vault dentro do Command Code para que as skills curadas pelo humano sejam carregadas além das nativas. As duas camadas coexistem: skill nativa resolve o caso geral; skill do vault impõe a forma específica do usuário.
- **Não mover preferências de taste para o vault automaticamente.** Se uma preferência aprendida por taste merece virar regra duradoura, ela passa por `/90-inbox/suggested-memory.md` para revisão humana antes de virar memória governada.

## Contrato do vault

Este workspace é um vault de memória federada, não um repositório de código:

- `00-global/AGENT.md` — contrato neutro (leia primeiro)
- `10-projects/` — projetos ativos (read-only)
- `20-domains/` — domínios isolados (read-only)
- `30-clients/` — contexto de clientes (read-only)
- `40-workflows/` — fluxos de trabalho (read-only)
- `50-skills/` — capacidades reutilizáveis curadas (read-only; referenciar daqui no Command Code)
- `60-context-packs/` — pacotes de contexto mínimo por tarefa (read-only)
- `70-decisions/` — decisões formais com status (read-only)
- `80-agent-adapters/` — adaptadores por agente (read-only)
- `90-inbox/suggested-memory.md` — único destino de escrita do agente
- `99-archive/` — logs e arquivados

## Política de escrita (vale em qualquer modo)

- **Leitura:** liberada em todo o vault
- **Escrita permanente:** PROIBIDA fora de `/90-inbox/`
- A regra vale em todos os modos do Command Code (interativo, autônomo, com taste ativo ou não). O nível de aprovação altera a UX, não a política.
- Qualquer pedido que exija escrita em pasta read-only deve virar sugestão para o inbox, com explicação.

## Comportamento esperado

- Antes de agir, leia `../../00-global/AGENT.md`
- Se o usuário citar um Context Pack, leia apenas esse arquivo e os caminhos listados em `Use:`
- Se não houver Context Pack, pergunte qual domínio é relevante antes de assumir
- Toda informação nova que valha a pena lembrar entra como sugestão em `90-inbox/suggested-memory.md`
- Skills curadas em `/50-skills/` têm precedência sobre skills nativas equivalentes do Command Code

## Resolução de conflito de memória

- Vence a entrada mais recente com `status: approved`
- `status: superseded` é ignorado em runtime
- Sem status, perguntar ao humano — não inferir pelo timestamp
- Em conflito entre taste e regra do vault, vence o vault

## Tom e estilo de resposta

- Respostas diretas, sem introduções longas
- Sem elogios desnecessários
- Sem resumir o que acabou de fazer
- Código sem comentários óbvios

## Memória entre sessões

O vault é a memória persistente. Taste é volátil em termos de governança — não auditável, não versionável, não portável entre máquinas.
Para retomar trabalho, consulte `10-projects/<projeto>/` e o Context Pack relevante.

## Critério de qualidade

Boa execução: leu o Context Pack, agiu no escopo, respeitou skill curada quando havia, escreveu sugestão no inbox quando aprendeu algo novo.
Má execução: deixou taste sobrescrever decisão com `status: approved`, ignorou skill de `/50-skills/`, gravou "memória" fora do inbox.
