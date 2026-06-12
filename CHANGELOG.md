# Changelog

## v3.0.0
Reposicionamento arquitetural completo. Hermes sai do centro e vira agente cliente. Git assume versão e sincronização como espinha. Threat model em dois modos (cooperativo por contrato, adversarial por hardening de OS). Escada de maturidade com evolução sob dor. Seção 05 do whitepaper e 09b do guia reescritas. Degrau zero documentado na seção 07.

## v2.5.0
Memória de padrões recorrentes por ferramenta: escalate-patterns, tool-patterns/, protocolo 3 tiers (observed → auto_fix → root_cause_pending), seção 12e no guia; versões em inglês do whitepaper e do guia.

## v2.4.0
Pre-action log para auditoria de ações de alto risco; campo review_date e next_review em todos os artefatos; scripts promote-skills e update-index; whitepaper com mitigações documentadas para as 5 limitações conhecidas.

## v2.3.0
Mente de Colmeia: estrutura published/proposed/deprecated em 50-skills, protocolo de publicação via inbox, AGENT.md atualizado, seção 12d no guia, whitepaper atualizado.

## v2.1.0
Classificação automática confidence+risk+TTL; captura via hooks PostToolUse (capture-to-inbox); seção 06b multimodal/assets; seção 09c captura automática; princípio 5 reformulado de aprovação obrigatória para auditor de última instância.

## v2.0.1
Limitações conhecidas com 5 limitações e mitigações; progressão para Graphiti documentada; comparação honesta com Paperclip e Pi; tabela com coluna Compartilhamento entre agentes.

## v2.0.0
Hermes como núcleo ativo com 4 papéis: roteador, gerenciador de memória com feedback, controlador de escopo, policy engine declarativo. Nova estrutura de pastas numeradas. Seção 12b deployment remoto e 12c Harness Engineering.

## v1.0.0
Lançamento inicial: whitepaper, guia de implementação, template de vault com 11 pastas, adaptadores e scripts de setup.
