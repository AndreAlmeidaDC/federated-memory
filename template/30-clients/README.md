# 30-clients — Clientes

Cada cliente é uma subpasta isolada. Notas sobre relacionamento, contexto comercial, restrições contratuais, decisões específicas do cliente.

## Quando promover a vault físico separado

Conteúdo de cliente é o caso mais comum de isolamento forte. Considere mover a pasta para um vault Obsidian separado quando:

- O cliente exige isolamento contratual (NDA, LGPD/GDPR com escopo restrito)
- Você precisa compartilhar leitura com pessoas externas sem expor o resto
- A sincronização precisa rodar em outra conta/serviço

Enquanto não houver essa necessidade, mantenha como pasta neste vault.

## Estrutura sugerida por cliente

```
30-clients/
├── <cliente>/
│   ├── CONTEXT.md         # quem é, o que faz, histórico de relacionamento
│   ├── decisions/         # decisões específicas, vinculadas ao 70-decisions/
│   ├── deliverables/      # entregas e materiais por projeto
│   └── notes/             # reuniões, follow-ups, observações
```
