# 30-context-packs — Pacotes de Contexto

Um Context Pack é a unidade mínima de contexto para uma tarefa específica.
Ele não copia o vault — aponta, resume e limita.

## Por que usar Context Packs

Sem Context Packs, o agente leria o vault inteiro (lento, caro, impreciso) ou
adivinharia o que é relevante (perigoso). O Context Pack define exatamente:
o que usar, o que evitar, o formato esperado.

## Como criar um Context Pack

Copie o template abaixo e preencha para cada tarefa recorrente que você delega a agentes.

```markdown
# Context Pack: [nome-da-tarefa]

Goal:
[O que o agente deve fazer — uma frase clara]

Use:
- [caminho para nota ou pasta relevante]
- [outro caminho]

Avoid:
- [o que não carregar — seja específico]

Sources of truth:
- [regra ou referência que define qualidade]

Output expected:
- [formato, tamanho, restrições]

Confidence: valid until [DATA] or until [condição de expiração]
```

## Exemplos incluídos

- `exemplo-linkedin-writing.md` — posts no LinkedIn com voz própria

## Regra de expiração

Todo Context Pack deve ter uma data de validade ou condição de revisão.
Contexto desatualizado é pior que ausência de contexto.
