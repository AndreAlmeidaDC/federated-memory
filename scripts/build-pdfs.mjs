import path from 'path';
import { pathToFileURL } from 'url';

let puppeteer;
try {
  puppeteer = (await import('puppeteer')).default;
} catch {
  console.error('puppeteer não encontrado. Rode `npm install puppeteer` na raiz do projeto antes de gerar os PDFs.');
  process.exit(1);
}

const out = process.argv[2] || 'releases/v2.1.0';
const jobs = [
  ['whitepaper/whitepaper-memoria-federada-ptbr.html', `${out}/whitepaper-memoria-federada-ptbr-v2.1.0.pdf`],
  ['guia/memoria-federada-v2.html',                    `${out}/guia-implementacao-v2.1.0.pdf`],
];

const browser = await puppeteer.launch({ headless: 'new' });
for (const [src, dst] of jobs) {
  const page = await browser.newPage();
  const url = pathToFileURL(path.resolve(src)).href;
  await page.goto(url, { waitUntil: 'networkidle0', timeout: 60000 });
  await page.emulateMediaType('print');
  await page.pdf({
    path: dst,
    format: 'A4',
    printBackground: true,
    margin: { top: '15mm', bottom: '15mm', left: '15mm', right: '15mm' },
  });
  console.log(`→ ${dst}`);
  await page.close();
}
await browser.close();
