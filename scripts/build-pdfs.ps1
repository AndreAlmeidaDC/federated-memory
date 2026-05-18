# build-pdfs.ps1 — gera PDFs do whitepaper e do guia via Chromium headless.
# Saída em releases/v1.0/ (ignorada pelo Git; PDFs são distribuídos via GitHub Releases).

[CmdletBinding()]
param([string]$OutDir = "releases/v1.0")

$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$candidates = @(
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    "C:\Program Files\Microsoft\Edge\Application\msedge.exe",
    "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
)
$chrome = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $chrome) { throw "Chrome/Edge não encontrado." }

function Render($src, $out) {
    $url = "file:///" + ((Resolve-Path $src).Path -replace '\\','/')
    $abs = Join-Path (Resolve-Path $OutDir).Path $out
    & $chrome --headless=new --disable-gpu --no-pdf-header-footer "--print-to-pdf=$abs" $url | Out-Null
    Write-Host "→ $abs"
}

Render "whitepaper/whitepaper-memoria-federada-ptbr.html" "whitepaper-memoria-federada-ptbr-v1.0.pdf"
Render "guia/memoria-federada-v2.html"                    "guia-implementacao-v2.0.pdf"
Write-Host "Pronto. Suba os PDFs como assets em https://github.com/AndreAlmeidaDC/federated-memory/releases"
