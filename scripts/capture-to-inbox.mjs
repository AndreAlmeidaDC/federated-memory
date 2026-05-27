#!/usr/bin/env node
// capture-to-inbox.mjs — hook PostToolUse do Claude Code.
// Lê o evento JSON do stdin, identifica padrões via regex grosseiro e
// anexa uma sugestão classificada em /90-inbox/suggested-memory.md.
// Sem dependências externas — apenas Node.js built-in.

import { readFileSync, appendFileSync, existsSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';

const VAULT = process.env.VAULT_PATH || join(process.cwd(), 'template');
const INBOX = join(VAULT, '90-inbox', 'suggested-memory.md');

const PATTERNS = [
  { type: 'decisão',     re: /\b(decidi|decidimos|resolved to|decision:)\b/i, confidence: 'verified',   risk: 'medium' },
  { type: 'preferência', re: /\b(prefiro|prefere|I prefer|preference:)\b/i,   confidence: 'preference', risk: 'low'    },
  { type: 'bug',         re: /\b(resolvido|fixed|bug resolved|solved)\b/i,    confidence: 'verified',   risk: 'low'    },
];

let raw = '';
try { raw = readFileSync(0, 'utf8'); } catch { process.exit(0); }
if (!raw.trim()) process.exit(0);

let blob = raw;
try { blob = JSON.stringify(JSON.parse(raw)); } catch { /* texto cru */ }

const hit = PATTERNS.find(p => p.re.test(blob));
if (!hit) process.exit(0);

const snippet = (blob.match(hit.re)?.input || '').slice(0, 400).replace(/\s+/g, ' ').trim();
const today = new Date().toISOString().slice(0, 10);
const ttl = hit.risk === 'low' && hit.confidence === 'verified' ? 7 : '';

const entry = [
  '',
  '## ' + today + ' — auto-capture (' + hit.type + ')',
  '---',
  'source: claude-code-hook',
  'date: ' + today,
  'domain: uncategorized',
  'type: ' + (hit.type === 'decisão' ? 'decision' : hit.type === 'preferência' ? 'preference' : 'fact'),
  'confidence: ' + hit.confidence,
  'risk: ' + hit.risk,
  ttl ? 'ttl_days: ' + ttl : null,
  '---',
  '**Sugestão:** padrão "' + hit.type + '" detectado automaticamente.',
  '**Fonte:** ' + snippet,
  '**Destino sugerido:** [revisar]',
  '',
].filter(l => l !== null).join('\n');

if (!existsSync(dirname(INBOX))) mkdirSync(dirname(INBOX), { recursive: true });
if (!existsSync(INBOX)) appendFileSync(INBOX, '# 90-inbox/suggested-memory.md\n\n<!-- Entradas pendentes abaixo desta linha -->\n');
appendFileSync(INBOX, entry);
