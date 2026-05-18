# 20-domains — Domínios de Conhecimento

Cada subpasta é um domínio isolado. Domínios não compartilham contexto entre si — vocabulário, tom e fontes são diferentes por design.

## Como criar um domínio

1. Crie uma subpasta com nome descritivo: `writing/`, `engineering/`, `learning/`, `personal/`
2. Dentro de cada domínio, crie as notas que fazem sentido para aquele contexto
3. Domínios diferentes têm vocabulário, tom e fontes diferentes — mantenha separados

## Estrutura sugerida por domínio

```
20-domains/
└── writing/
    ├── STYLE_GUIDE.md        ← voz, tom, regras do domínio
    ├── voice-examples/       ← exemplos reais de output aprovado
    ├── hooks-that-worked.md  ← padrões que funcionaram
    └── recent-posts.md       ← histórico recente
```

## Exemplos de domínios comuns

- `writing/` — produção de conteúdo, voz, estilo
- `engineering/` — princípios técnicos, padrões de código (decisões formais vão em `70-decisions/`)
- `research/` — notas de pesquisa, metodologia, fontes validadas
- `learning/` — notas de estudo, resumos, conceitos em construção
- `personal/` — preferências pessoais, rotina, metas

## Quando promover a vault físico

Domínios geralmente vivem juntos no mesmo vault. Considere mover para um vault físico separado quando:

- O domínio tem requisitos de sincronização diferentes (ex.: só Local, enquanto o resto vai pra Obsidian Sync)
- Você precisa compartilhar leitura desse domínio sem expor o resto do vault

## Regra de ouro

Se você hesitou em qual domínio colocar uma nota, ela provavelmente pertence a um domínio novo — ou não pertence ao vault ainda. Não force encaixe.
