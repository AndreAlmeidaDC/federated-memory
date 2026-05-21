# /50-skills/ — Procedimentos de Execução Reutilizáveis

Skills são **procedimentos de execução** reutilizáveis. Elas descrevem *como* fazer uma tarefa específica, passo a passo, com restrições explícitas.

## Skills × Context Packs

A distinção importa. As duas pastas resolvem problemas diferentes:

| Aspecto | Context Pack (`/60-context-packs/`) | Skill (`/50-skills/`) |
|---|---|---|
| Pergunta que responde | "O que saber antes de executar?" | "Como executar esta tarefa específica?" |
| Natureza | Contexto **declarativo** | Procedimento **imperativo** |
| Conteúdo | Princípios, restrições, exemplos, referências | Passos numerados, triggers, validações |
| Quando carregar | Antes de raciocinar sobre o domínio | Quando a tarefa-alvo é reconhecida |

Em prática: o Context Pack carrega princípios do domínio (ex: "como o André escreve no LinkedIn — voz, anti-patterns, exemplos"). A Skill executa um procedimento que *consome* esse contexto (ex: "criar-post-linkedin: passos 1 a 8 com restrições").

Skills podem (e geralmente devem) apontar para Context Packs no primeiro passo. O contexto entra como leitura prévia; a skill ordena a execução.

## Como qualquer agente consome

Qualquer agente conectado ao vault via MCP — Claude, Codex, Grok Build, OpenCode, Kimi, Antigravity, Cursor, Windsurf — consegue ler uma skill como instrução. Não há formato proprietário: cada skill é um Markdown legível por humanos e por modelos.

O fluxo típico:

1. Usuário aciona um trigger (ex: "cria um post sobre X no LinkedIn")
2. Agente identifica a skill correspondente em `/50-skills/`
3. Agente lê a skill, executa cada passo na ordem, respeita as restrições
4. Se um passo aponta para um Context Pack, o agente carrega esse pack antes de continuar

## Formato sugerido

Cada skill deve ter:

- **Trigger** — em que situação ela é acionada
- **Passos** — lista numerada, ações concretas e verificáveis
- **Restrições** — o que *não* fazer, com a regra explícita
- **Critério de conclusão** (opcional) — como saber que a skill foi executada bem

Veja `skill-criar-post-linkedin.md` como exemplo de referência.

## Política de escrita

A pasta `/50-skills/` é **read-only para agentes**. Skills novas, alterações ou variantes entram via `/90-inbox/suggested-memory.md` como sugestão, e só viram skill real depois de revisão humana.
