#!/usr/bin/env node
/**
 * update-index.mjs — regenera template/50-skills/INDEX.md
 * a partir dos arquivos em published/
 */

import fs from 'fs';
import path from 'path';

const BASE = path.join(process.cwd(), 'template', '50-skills');
const PUBLISHED = path.join(BASE, 'published');
const INDEX_FILE = path.join(BASE, 'INDEX.md');

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

function parseTags(raw) {
  if (!raw) return [];
  return raw.replace(/[\[\]]/g, '').split(',').map(t => t.trim()).filter(Boolean);
}

function main() {
  if (!fs.existsSync(PUBLISHED)) {
    console.log('No published/ directory found.'); return;
  }

  const files = fs.readdirSync(PUBLISHED).filter(f => f.endsWith('.md') && f !== '.gitkeep');
  const skills = [];

  for (const file of files) {
    const content = fs.readFileSync(path.join(PUBLISHED, file), 'utf8');
    const fm = parseFrontmatter(content);
    const title = content.match(/^#\s+(.+)/m)?.[1] || file.replace('.md', '');
    skills.push({
      file,
      title,
      domain: fm.domain || 'uncategorized',
      author_agent: fm.author_agent || 'unknown',
      version: fm.version || '1.0.0',
      tags: parseTags(fm.tags),
    });
  }

  const byDomain = {};
  const byAgent = {};
  for (const s of skills) {
    (byDomain[s.domain] = byDomain[s.domain] || []).push(s);
    (byAgent[s.author_agent] = byAgent[s.author_agent] || []).push(s);
  }

  const now = new Date().toISOString().split('T')[0];
  const lines = [
    '# Skills Index',
    '',
    'Índice navegável de skills publicadas por agente.',
    'Consulte este índice antes de criar uma nova skill para evitar duplicação.',
    '',
    '## Como usar',
    '1. Busque por tag ou domínio antes de criar uma skill nova',
    '2. Se encontrar algo similar, adapte ou proponha melhoria',
    '3. Para publicar uma skill, escreva proposta em /90-inbox/ com type: skill',
    '',
    '## Skills por domínio',
    '',
  ];

  for (const [domain, list] of Object.entries(byDomain).sort()) {
    lines.push(`### ${domain}`);
    for (const s of list) {
      const tags = s.tags.length ? ` · \`${s.tags.join('` `')}\`` : '';
      lines.push(`- **${s.title}** (v${s.version}) — \`${s.file}\`${tags}`);
    }
    lines.push('');
  }

  lines.push('## Skills por agente', '');
  for (const [agent, list] of Object.entries(byAgent).sort()) {
    lines.push(`### ${agent}`);
    for (const s of list) lines.push(`- **${s.title}** · domínio: ${s.domain}`);
    lines.push('');
  }

  lines.push('---', `Última atualização: ${now}`, `Total de skills publicadas: ${skills.length}`, '');

  fs.writeFileSync(INDEX_FILE, lines.join('\n'), 'utf8');
  console.log(`INDEX.md regenerado — ${skills.length} skill(s) publicada(s).`);
}

main();
