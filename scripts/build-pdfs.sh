#!/usr/bin/env bash
# build-pdfs.sh — gera PDFs do whitepaper e do guia via Chromium headless.
# Saída em releases/v1.0/ (ignorada pelo Git; os PDFs são distribuídos como
# assets da página de Releases do GitHub).

set -euo pipefail

OUT="${OUT_DIR:-releases/v1.0}"
mkdir -p "$OUT"

# Detecta um Chromium-like disponível
for bin in google-chrome chromium chromium-browser msedge "/c/Program Files/Google/Chrome/Application/chrome.exe" "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"; do
  if command -v "$bin" >/dev/null 2>&1 || [[ -x "$bin" ]]; then CHROME="$bin"; break; fi
done
[[ -n "${CHROME:-}" ]] || { echo "Chromium/Chrome/Edge não encontrado no PATH." >&2; exit 1; }

render() {
  local src="$1" out="$2"
  local url="file://$(cd "$(dirname "$src")" && pwd)/$(basename "$src")"
  "$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
            --print-to-pdf="$out" "$url" >/dev/null 2>&1
  echo "→ $out"
}

render "whitepaper/whitepaper-memoria-federada-ptbr.html" "$OUT/whitepaper-memoria-federada-ptbr-v1.0.pdf"
render "guia/memoria-federada-v2.html"                    "$OUT/guia-implementacao-v2.0.pdf"
echo "Pronto. Suba os PDFs como assets em https://github.com/AndreAlmeidaDC/federated-memory/releases"
