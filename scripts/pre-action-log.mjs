#!/usr/bin/env node
/**
 * pre-action-log.mjs — PreToolUse hook para Claude Code
 * Detecta ações de alto risco e registra em /99-archive/pre-action-log.md
 * antes da execução. Não bloqueia. Só audita.
 */

import fs from 'fs';
import path from 'path';
import readline from 'readline';

const HIGH_RISK_PATTERNS = [
  /\bdelete\b/i, /\bdrop\b/i, /\btruncate\b/i, /\bformat\b/i,
  /\brm\b/, /\boverwrite\b/i, /\bsend\b/i, /\bdeploy\b/i,
  /\bpush\s+--force\b/i, /\bforce.push\b/i,
];

const LOG_FILE = path.join(process.cwd(), 'template', '99-archive', 'pre-action-log.md');
const LOCK_FILE = path.join(process.cwd(), 'template', '10-projects', 'SESSION.lock');

function isHighRisk(input) {
  const text = JSON.stringify(input || '');
  return HIGH_RISK_PATTERNS.some(p => p.test(text));
}

function readSessionId() {
  try {
    const content = fs.readFileSync(LOCK_FILE, 'utf8');
    const match = content.match(/session_id:\s*([^\n]+)/);
    return match ? match[1].trim() : 'unknown';
  } catch { return 'no-lock'; }
}

function formatEntry(data) {
  const now = new Date().toISOString();
  const sessionId = readSessionId();
  const toolName = data?.tool_name || data?.tool || 'unknown';
  const toolInput = data?.tool_input || data?.input || {};
  const target = toolInput?.file_path || toolInput?.command || toolInput?.path || JSON.stringify(toolInput).slice(0, 120);
  const agent = data?.agent || process.env.CLAUDE_AGENT_NAME || 'claude-code';

  return [
    '',
    '---',
    `date: ${now}`,
    `agent: ${agent}`,
    `session_id: ${sessionId}`,
    `action: ${toolName}`,
    `target: ${target}`,
    `context_pack_active: ${process.env.ACTIVE_CONTEXT_PACK || 'unknown'}`,
    `risk: high`,
    '---',
    '',
  ].join('\n');
}

async function main() {
  const rl = readline.createInterface({ input: process.stdin });
  let raw = '';
  for await (const line of rl) raw += line;

  let data = {};
  try { data = JSON.parse(raw); } catch { process.exit(0); }

  if (!isHighRisk(data)) process.exit(0);

  const entry = formatEntry(data);

  try {
    fs.appendFileSync(LOG_FILE, entry, 'utf8');
  } catch {
    // Se o arquivo não existe ainda, não bloquear a ação
  }

  process.exit(0);
}

main();
