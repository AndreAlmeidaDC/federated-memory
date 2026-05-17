# Context Pack: linkedin-writing

Goal:
Help an AI agent draft LinkedIn posts in [SEU NOME]'s voice for
the [SEU NICHO] community.

Use:
- /10-domains/writing/STYLE_GUIDE.md
- /10-domains/writing/voice-examples/*.md
- /10-domains/writing/hooks-that-worked.md
- Last 5 entries from /10-domains/writing/recent-posts.md

Avoid:
- /10-domains/engineering/*  (different vocabulary)
- /20-projects/*  (unless explicitly mentioned in the prompt)
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

Confidence: valid until [DATA] or until STYLE_GUIDE.md is updated
