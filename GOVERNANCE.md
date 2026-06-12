# Governança

Este documento descreve como conteúdo vira memória neste projeto. Não existe um segundo sistema de status: a governança usa os mesmos campos confidence e risk definidos no AGENT.md do template.

## Princípio

Governança proporcional ao risco. O humano é auditor de última instância, não gargalo de captura.

## Fluxo

Todo conteúdo novo capturado por agente entra em 90-inbox como sugestão. A classificação usa dois eixos: confidence (hypothesis, verified) e risk (low, high). Verified com low risk promove automaticamente, com TTL e review_date. Hypothesis ou high risk aguardam decisão humana. Conteúdo promovido carrega autoria, data e origem. Decisões formais vivem em 70-decisions com status approved ou superseded; em conflito, vence a entrada mais recente com status approved.

## Threat model

O fluxo acima opera no modo cooperativo: assume agentes que seguem o contrato. Foi validado empiricamente que esse fluxo é contrato, não enforcement (ver experiments/EXP-001). Quem precisa de garantia contra agente adversarial deve aplicar hardening de sistema operacional: container com vault montado read-only exceto 90-inbox, ou usuário de sistema separado sem escrita nas pastas protegidas.

## Hipóteses e experimentos

Afirmações não validadas dos documentos são rastreadas em hypotheses/. Testes ficam em experiments/. Relatos de uso real ficam em cases/. Hipótese refutada gera correção obrigatória nos documentos.
