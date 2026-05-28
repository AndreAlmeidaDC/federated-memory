#!/usr/bin/env node
/**
 * promote-skills.mjs — processa /50-skills/proposed/ e promove skills
 * que atendem as regras de TTL automático para /50-skills/published/
 */

import fs from 'fs';
import path from 'path';
import { execSync } from 'child_process';

const BASE = path.join(process.cwd(), 'template', '50-skills');
const PROPOSED = path.join(BASE, 'proposed');
const PUBLISHED = path.join(BASE, 'published');
const REVIEW_LOG = path.join(process.cwd(), 'template', '99-archive', 'review-log.md');

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

function daysSince(dateStr) {
  const created = new Date(dateStr);
  if (isNaN(created)) return null;
  return Math.floor((Date.now() - created.getTime()) / 86400000);
}

function appendReviewLog(entry) {
  fs.appendFileSync(REVIEW_LOG, entry + '\n', 'utf8');
}

function main() {
  if (!fs.existsSync(PROPOSED)) { console.log('No proposed/ directory found.'); return; }

  const files = fs.readdirSync(PROPOSED).filter(f => f.endsWith('.md'));
  let promoted = 0;

  for (const file of files) {
    const srcPath = path.join(PROPOSED, file);
    const content = fs.readFileSync(srcPath, 'utf8');
    const fm = parseFrontmatter(content);

    const confidence = fm.confidence?.toLowerCase();
    const risk = fm.risk?.toLowerCase();
    const ttlDays = parseInt(fm.ttl_days || '7', 10);
    const age = daysSince(fm.created);
    const now = new Date().toISOString().split('T')[0];

    if (risk === 'high') {
      console.log(`[SKIP] ${file} — high risk, requires explicit approval`);
      continue;
    }
    if (confidence === 'hypothesis') {
      console.log(`[SKIP] ${file} — hypothesis, awaiting human decision`);
      continue;
    }
    if (confidence === 'verified' && risk === 'medium') {
      console.log(`[PENDING_LAZY] ${file} — verified+medium, awaiting lazy approval`);
      appendReviewLog(`\n## ${now} — ${file}\n- type: pending_lazy\n- from: proposed\n- reason: verified+medium awaiting human\n`);
      continue;
    }
    if (confidence === 'verified' && risk === 'low') {
      if (age === null || age < ttlDays) {
        console.log(`[WAIT] ${file} — only ${age ?? '?'} days old, TTL is ${ttlDays}`);
        continue;
      }
      const destPath = path.join(PUBLISHED, file);
      fs.renameSync(srcPath, destPath);
      console.log(`[PROMOTED] ${file} → published/`);
      appendReviewLog(`\n## ${now} — ${file}\n- type: auto_promoted\n- from: proposed\n- to: published\n- age_days: ${age}\n- ttl_days: ${ttlDays}\n`);
      promoted++;
    }
  }

  console.log(`\nDone. ${promoted} skill(s) promoted.`);
  if (promoted > 0) {
    try { execSync('node scripts/update-index.mjs', { stdio: 'inherit' }); }
    catch { console.warn('update-index.mjs not found or failed — run manually.'); }
  }
}

main();
