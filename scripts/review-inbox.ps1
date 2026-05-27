# review-inbox.ps1 — ritual semanal de revisão do inbox de memória federada.
# Processa cada sugestão de /90-inbox/suggested-memory.md interativamente:
#   a = aprovar (anexa ao destino e remove do inbox)
#   e = editar (abre $env:EDITOR e volta a perguntar)
#   r = rejeitar (remove do inbox)
#   d = adiar  (mantém no inbox)
#   q = sair    (mantém o que sobrar)
# Decisões são registradas em /99-archive/review-log.md.

[CmdletBinding()]
param(
    [string]$VaultPath = $(if ($env:VAULT_PATH) { $env:VAULT_PATH } else { Join-Path (Get-Location) 'template' })
)

$ErrorActionPreference = 'Stop'
$inbox = Join-Path $VaultPath '90-inbox/suggested-memory.md'
$log   = Join-Path $VaultPath '99-archive/review-log.md'
$marker = '<!-- Entradas pendentes abaixo desta linha -->'
$editor = if ($env:EDITOR) { $env:EDITOR } else { 'notepad' }

if (-not (Test-Path $inbox)) { throw "Inbox não encontrado: $inbox" }
$logDir = Split-Path $log -Parent
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
if (-not (Test-Path $log)) {
    "# 99-archive — Log de revisões do inbox`n`n<!-- Entradas abaixo desta linha -->`n" | Set-Content -Path $log -Encoding UTF8
}

$raw = Get-Content -Raw -Path $inbox -Encoding UTF8
$markerIdx = $raw.IndexOf($marker)
if ($markerIdx -lt 0) { throw "Marcador não encontrado no inbox: $marker" }
$header = $raw.Substring(0, $markerIdx + $marker.Length)
$body   = $raw.Substring($markerIdx + $marker.Length).TrimStart("`r","`n")

if ([string]::IsNullOrWhiteSpace($body)) {
    Write-Host "Nada no inbox. Tudo já revisado."
    exit 0
}

# Split em entries por linha "## "
$entries = New-Object System.Collections.Generic.List[string]
$buf = New-Object System.Text.StringBuilder
foreach ($line in ($body -split "`r?`n")) {
    if ($line -match '^## ' -and $buf.Length -gt 0) {
        $entries.Add($buf.ToString().TrimEnd()) | Out-Null
        [void]$buf.Clear()
    }
    [void]$buf.AppendLine($line)
}
if ($buf.Length -gt 0) {
    $t = $buf.ToString().TrimEnd()
    if ($t) { $entries.Add($t) | Out-Null }
}

function Get-Field($text, $name) {
    $m = [regex]::Match($text, "(?m)^\*\*$([regex]::Escape($name)):\*\*\s*(.+)$")
    if ($m.Success) { return $m.Groups[1].Value.Trim() } else { return '' }
}
function Get-Title($text) {
    $m = [regex]::Match($text, "(?m)^##\s+(.+)$")
    if ($m.Success) { return $m.Groups[1].Value.Trim() } else { return '' }
}
function Write-Log($decision, $dest, $sug, $dom) {
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm'
    $line = "- $ts — **$decision** — $($dom -as [string]) — ``$($dest -as [string])`` — $($sug -as [string])"
    Add-Content -Path $log -Value $line -Encoding UTF8
}

function Get-FrontmatterField($text, $name) {
    $m = [regex]::Match($text, "(?m)^$([regex]::Escape($name)):\s*(.+)$")
    if ($m.Success) { return $m.Groups[1].Value.Trim() } else { return '' }
}

# Pré-pass: classificação automática por confidence/risk/ttl
$autoKept   = New-Object System.Collections.Generic.List[string]   # vão para revisão humana
$silentKept = New-Object System.Collections.Generic.List[string]   # mantidos no inbox sem apresentar
foreach ($entry in $entries) {
    $conf = Get-FrontmatterField $entry 'confidence'
    $risk = Get-FrontmatterField $entry 'risk'
    $ttl  = Get-FrontmatterField $entry 'ttl_days'
    $dom  = Get-FrontmatterField $entry 'domain'
    if (-not $conf -or -not $risk) { $autoKept.Add($entry) | Out-Null; continue }
    if ($risk -eq 'high') { $autoKept.Add($entry) | Out-Null; continue }
    if ($conf -eq 'hypothesis') { $autoKept.Add($entry) | Out-Null; continue }
    if ($conf -eq 'verified' -and $risk -eq 'low' -and $ttl -and [int]$ttl -le 7) {
        $domSafe = if ($dom) { $dom } else { 'uncategorized' }
        $relPath = "20-domains/$domSafe/auto-promoted.md"
        $target = Join-Path $VaultPath $relPath
        $td = Split-Path $target -Parent
        if (-not (Test-Path $td)) { New-Item -ItemType Directory -Path $td -Force | Out-Null }
        if (-not (Test-Path $target)) { New-Item -ItemType File -Path $target -Force | Out-Null }
        Add-Content -Path $target -Value ("`n" + $entry) -Encoding UTF8
        Write-Log 'auto_promoted' $relPath '' $dom
        continue
    }
    if ($conf -eq 'verified' -and $risk -eq 'medium') {
        $silentKept.Add($entry) | Out-Null
        Write-Log 'pending_lazy' '90-inbox/suggested-memory.md' '' $dom
        continue
    }
    $autoKept.Add($entry) | Out-Null
}
$entries = $autoKept

$kept = New-Object System.Collections.Generic.List[string]
$total = $entries.Count
$idx = 0
$quit = $false

foreach ($entry in $entries) {
    $idx++
    if ($quit) { $kept.Add($entry) | Out-Null; continue }
    $dest = Get-Field $entry 'Destino sugerido'
    $sug  = Get-Field $entry 'Sugestão'
    $dom  = Get-Title $entry

    Write-Host ""
    Write-Host "──────── [$idx/$total] ────────"
    Write-Host $entry
    Write-Host "────────────────────────────"

    while ($true) {
        $ans = (Read-Host "[a]provar  [e]ditar  [r]ejeitar  [d]eferir  [q]uit").ToLower()
        switch ($ans) {
            'a' {
                if (-not $dest) { $dest = Read-Host "Destino vazio. Caminho relativo ao vault" }
                $target = Join-Path $VaultPath $dest
                $td = Split-Path $target -Parent
                if (-not (Test-Path $td)) { New-Item -ItemType Directory -Path $td -Force | Out-Null }
                if (-not (Test-Path $target)) { New-Item -ItemType File -Path $target -Force | Out-Null }
                Add-Content -Path $target -Value ("`n" + $entry) -Encoding UTF8
                Write-Log 'human_approved' $dest $sug $dom
                Write-Host "→ anexado em $dest"
                break
            }
            'e' {
                $tmp = [System.IO.Path]::GetTempFileName() + '.md'
                Set-Content -Path $tmp -Value $entry -Encoding UTF8
                Start-Process -FilePath $editor -ArgumentList $tmp -Wait
                $entry = Get-Content -Raw -Path $tmp -Encoding UTF8
                Remove-Item $tmp -Force
                $dest = Get-Field $entry 'Destino sugerido'
                $sug  = Get-Field $entry 'Sugestão'
                $dom  = Get-Title $entry
                Write-Host "(editado — escolha de novo)"
            }
            'r' { Write-Log 'human_rejected' $dest $sug $dom; Write-Host "→ rejeitado"; break }
            'd' { $kept.Add($entry) | Out-Null; Write-Log 'human_deferred' $dest $sug $dom; Write-Host "→ adiado"; break }
            'q' { $kept.Add($entry) | Out-Null; $quit = $true; break }
            default { Write-Host "Opção inválida." }
        }
        if ($ans -in 'a','r','d','q') { break }
    }
}

$out = $header + "`n`n"
$finalKept = New-Object System.Collections.Generic.List[string]
foreach ($e in $silentKept) { $finalKept.Add($e) | Out-Null }
foreach ($e in $kept) { $finalKept.Add($e) | Out-Null }
if ($finalKept.Count -gt 0) { $out += (($finalKept -join "`n`n") + "`n") }
Set-Content -Path $inbox -Value $out -Encoding UTF8

Write-Host ""
Write-Host "Revisão concluída. Log: $log"
