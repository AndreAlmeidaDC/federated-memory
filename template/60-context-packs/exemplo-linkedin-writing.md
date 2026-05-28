# Context Pack: linkedin-writing

Goal:
Help an AI agent draft LinkedIn posts in [SEU NOME]'s voice for
the [SEU NICHO] community.

Use:
- /20-domains/writing/STYLE_GUIDE.md
- /20-domains/writing/voice-examples/*.md
- /20-domains/writing/hooks-that-worked.md
- Last 5 entries from /20-domains/writing/recent-posts.md

Avoid:
- /20-domains/engineering/*  (different vocabulary)
- /10-projects/*  (unless explicitly mentioned in the prompt)
- /30-clients/*  (unless the post is about a public client case)
- Generic LinkedIn templates from external sources
- Buzzwords and corporate language

Sources of truth:
- Voice: [descreva: informal, técnico, irreverente, direto...]
- Structure: [descreva: hook forte, conclusão primeiro, etc.]
- Length: [ex: 800-1500 caracteres]
- Tone: [ex: crítico, sem elogios desnecessários, baseado em dados]

Output expected:
- Single post, ready to publish
- No subtitle or headers inside the post
- No hashtag list at the end unless requested

Confidence / validity:
Pack válido enquanto STYLE_GUIDE.md e voice-examples/ não mudarem.
Revisar a cada 30 dias ou após nova plataforma com voz própria.

Review:
- review_date: YYYY-MM-DD
- review_by: [nome]
- next_review: YYYY-MM-DD  # quando deve ser revisado novamente
- Nota: atualize review_date mesmo quando nenhum conteúdo mudar.
  O Hermes usa este campo para avisos de validade, não só o mtime.

Validation:
- Após cada uso, Hermes registra em /99-archive/pack-usage.log: pack, tarefa, resultado (útil/parcial/ruim)
- Pack com 3 marcações "ruim" consecutivas é flaggeado para revisão
- Temporal: se qualquer arquivo em "Use:" tem mtime > 90 dias, Hermes inclui aviso no output
- Humano pode marcar pack como "stale" manualmente em /99-archive/pack-status.md

Source notes:
Caminhos hipotéticos. Antes de usar este pack, crie:
- /20-domains/writing/STYLE_GUIDE.md
- /20-domains/writing/voice-examples/
- /20-domains/writing/hooks-that-worked.md
- /20-domains/writing/recent-posts.md
