#!/usr/bin/env node
/**
 * escalate-patterns.mjs — processa entradas type:tool_pattern no inbox,
 * mantém ledger em /50-skills/tool-patterns/ e aplica escalada de 3 tiers:
 *
 *   1ª ocorrência → status: observed
 *   2ª ocorrência → status: auto_fix
 *   3ª+ ocorrência → status: root_cause_pending  (trigger para análise humana)
 *
 * Scoped por ferramenta, não por projeto. O que o agente aprende sobre
 * uma biblioteca num projeto vale para todos os outros.
 */

import fs from 'fs';
import path from 'path';

const BASE        = path.join(process.cwd(), 'template');
const INBOX       = path.join(BASE, '90-inbox', 'suggested-memory.md');
const PATTERNS    = path.join(BASE, '50-skills', 'tool-patterns');
const REVIEW_LOG  = path.join(BASE, '99-archive', 'review-log.md');

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function parseFrontmatter(content) {
  const match = content.match(/^---\n([\s\S]*?)\n---/);
  if (!match) return {};
  const result = {};
  for (const line of match[1].split('\n')) {
    const [key, ...rest] = line.split(':');
    if (key && rest.length) result[key.trim()] = rest.join(':').trim();
  }
  return result;
}

function statusFor(n) {
  if (n <= 1) return 'observed';
  if (n === 2) return 'auto_fix';
  return 'root_cause_pending';
}

function toolSlug(name) {
  return name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
}

function parseInboxPatterns(inboxText) {
  // Split on YAML frontmatter blocks that have type: tool_pattern
  const blocks = inboxText.split(/(?=^---$)/m);
  const entries = [];
  for (const block of blocks) {
    if (!block.trim().startsWith('---')) continue;
    const fm = parseFrontmatter(block);
    if (fm.type === 'tool_pattern' && fm.tool) entries.push({ fm, raw: block });
  }
  return entries;
}

function buildPatternFile({ tool, symptom, fix, risk, source, firstSeen, occurrences }) {
  const status = statusFor(occurrences);
  const today  = new Date().toISOString().split('T')[0];
  const lines  = [
    '---',
    `tool: ${tool}`,
    `symptom: ${symptom}`,
    `occurrences: ${occurrences}`,
    `status: ${status}`,
    `confidence: verified`,
    `risk: ${risk || 'low'}`,
    `first_seen: ${firstSeen}`,
    `last_seen: ${today}`,
    `author_agent: ${source || 'unknown'}`,
    `fix: ${fix || 'pendente — documente na 2ª ocorrência'}`,
    `root_cause: ${occurrences >= 3 ? 'PENDENTE — análise requerida' : 'null'}`,
    '---',
    '',
    `# Padrão: ${tool}`,
    '',
    '## Sintoma',
    '',
    symptom,
    '',
    '## Fix conhecido',
    '',
    fix || '_Não documentado ainda. Atualize ao resolver._',
    '',
    '## Causa raiz',
    '',
    occurrences >= 3
      ? '**⚠️ ANÁLISE REQUERIDA** — 3ª+ ocorrência atingida. Investigue a origem do problema na ferramenta ou configuração.'
      : '_Pendente. Será exigida na 3ª ocorrência._',
    '',
    '## Histórico',
    '',
    `| Campo | Valor |`,
    `|---|---|`,
    `| Ocorrências | ${occurrences} |`,
    `| Status | ${status} |`,
    `| Primeira vez | ${firstSeen} |`,
    `| Última vez | ${today} |`,
    '',
  ];
  return lines.join('\n');
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

function main() {
  if (!fs.existsSync(PATTERNS)) fs.mkdirSync(PATTERNS, { recursive: true });

  if (!fs.existsSync(INBOX)) {
    console.log('Inbox not found — nothing to process.');
    return;
  }

  const inboxText = fs.readFileSync(INBOX, 'utf8');
  const entries   = parseInboxPatterns(inboxText);

  if (entries.length === 0) {
    console.log('No tool_pattern entries in inbox.');
    return;
  }

  const today    = new Date().toISOString().split('T')[0];
  let   updated  = 0;
  const escalated = [];

  for (const { fm } of entries) {
    const slug      = toolSlug(fm.tool);
    const toolFile  = path.join(PATTERNS, `${slug}.md`);
    const symptom   = fm.symptom || 'não especificado';
    const fix       = fm.fix     || '';
    const risk      = fm.risk    || 'low';
    const source    = fm.source  || 'unknown';

    let occurrences = 1;
    let firstSeen   = today;

    if (fs.existsSync(toolFile)) {
      const existing   = fs.readFileSync(toolFile, 'utf8');
      const existingFm = parseFrontmatter(existing);
      occurrences      = (parseInt(existingFm.occurrences || '0', 10)) + 1;
      firstSeen        = existingFm.first_seen || today;
    }

    const status  = statusFor(occurrences);
    const content = buildPatternFile({ tool: fm.tool, symptom, fix, risk, source, firstSeen, occurrences });

    fs.writeFileSync(toolFile, content, 'utf8');

    // Append to review log
    const logEntry = [
      '',
      `## ${today} — tool-pattern: ${fm.tool}`,
      `- slug: ${slug}`,
      `- occurrences: ${occurrences}`,
      `- status: ${status}`,
      `- symptom: ${symptom}`,
      fix ? `- fix: ${fix}` : null,
      '',
    ].filter(l => l !== null).join('\n');
    fs.appendFileSync(REVIEW_LOG, logEntry, 'utf8');

    const icon = occurrences >= 3 ? '⚠️ ' : occurrences === 2 ? '✓  ' : '   ';
    console.log(`${icon}[${status}] ${fm.tool} — ${occurrences} ocorrência(s) → ${slug}.md`);

    if (occurrences >= 3) escalated.push(fm.tool);
    updated++;
  }

  console.log(`\nDone. ${updated} pattern(s) updated.`);

  if (escalated.length > 0) {
    console.log('\n⚠️  Root cause analysis required for:');
    for (const t of escalated) {
      console.log(`   → template/50-skills/tool-patterns/${toolSlug(t)}.md`);
    }
    console.log('\n   Adicione o campo root_cause no arquivo e mude status para resolved.');
  }
}

main();
