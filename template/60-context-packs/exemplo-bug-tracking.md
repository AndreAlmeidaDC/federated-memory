# Context Pack: bug-tracking

Goal:
Ajudar o agente a documentar, persistir e retomar a correção de bugs complexos
entre sessões e entre agentes diferentes.

Use:
- /10-projects/[projeto]/assets/bugs/[bug-id]/
- /10-projects/[projeto]/PROJECT.md (para entender o stack)
- /20-domains/engineering/PRINCIPLES.md (para entender padrões)
- Tentativas anteriores em ordem cronológica

Avoid:
- Replicar tentativas já documentadas como failed
- Assumir contexto não documentado
- Começar do zero sem ler as tentativas anteriores

Output expected:
- Leia o bug-summary.md primeiro
- Liste as tentativas failed sem repetir abordagens
- Documente cada nova tentativa em arquivo separado
- Atualize bug-summary.md com status atual ao final

Validation:
- Após cada sessão: registrar tentativa como failed ou success
- Se success: criar tentativa-N-success.md e fechar o bug
- Se failed: atualizar bug-summary.md com o que foi descartado

Confidence / validity:
- Válido enquanto o stack do projeto não mudar
- Revalidar se houver mudança de framework ou linguagem principal

Source notes:
- Estrutura de bugs: /10-projects/[projeto]/assets/bugs/
- Crie o diretório do bug antes de iniciar: bugs/[bug-id]/
