# setup.ps1 — Federated Memory Setup (Windows)
# Repositório: https://github.com/AndreAlmeidaDC/federated-memory
#
# O que este script faz:
#   1. Verifica dependências (git, python, node, npm)
#   2. Cria o vault template em $HOME\federated-memory
#   3. Inicializa repositório Git no vault
#   4. Instala o Hermes Agent
#   5. Instala o MCP server para Obsidian (filesystem)
#   6. Gera o settings.json para Claude Code
#   7. Exibe próximos passos
#
# Uso: .\setup.ps1 [-VaultDir "C:\caminho\vault"]

param(
    [string]$VaultDir = "$HOME\federated-memory"
)

$ErrorActionPreference = "Stop"

# ---------- helpers ----------
function Ok($msg)   { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "  [!]  $msg" -ForegroundColor Yellow }
function Fail($msg) { Write-Host "  [X]  $msg" -ForegroundColor Red; exit 1 }
function Step($msg) { Write-Host "`n-- $msg" -ForegroundColor Cyan }

$RepoUrl   = "https://github.com/AndreAlmeidaDC/federated-memory.git"
$HermesUrl = "https://github.com/NousResearch/hermes-agent.git"
$McpPackage = "@modelcontextprotocol/server-filesystem"

Write-Host "`nFederated Memory -- Setup" -ForegroundColor White
Write-Host "Vault destino: $VaultDir"
Write-Host "-------------------------------------"

# ---------- 1. dependências ----------
Step "Verificando dependencias"

function CheckCmd($cmd) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        Ok "$cmd encontrado"
    } else {
        Fail "$cmd nao encontrado. Instale antes de continuar."
    }
}

CheckCmd "git"
CheckCmd "python"
CheckCmd "pip"
CheckCmd "node"
CheckCmd "npm"

# ---------- 2. vault ----------
Step "Criando vault em $VaultDir"

if (Test-Path $VaultDir) {
    Warn "Pasta ja existe. Pulando criacao."
} else {
    New-Item -ItemType Directory -Path $VaultDir -Force | Out-Null

    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $TemplatePath = Join-Path $ScriptDir "template"

    if (Test-Path $TemplatePath) {
        Copy-Item -Path "$TemplatePath\*" -Destination $VaultDir -Recurse -Force
        Ok "Template copiado de $TemplatePath"
    } else {
        Warn "Pasta template nao encontrada localmente. Baixando do GitHub..."
        $TmpDir = Join-Path $env:TEMP "federated-memory-setup"
        git clone --depth 1 $RepoUrl "$TmpDir\repo" 2>$null
        Copy-Item -Path "$TmpDir\repo\template\*" -Destination $VaultDir -Recurse -Force
        Remove-Item $TmpDir -Recurse -Force
        Ok "Template baixado do repositorio"
    }
}

# ---------- 3. git no vault ----------
Step "Inicializando Git no vault"

if (Test-Path (Join-Path $VaultDir ".git")) {
    Warn "Repositorio Git ja existe. Pulando."
} else {
    git -C $VaultDir init -b main
    git -C $VaultDir add .
    git -C $VaultDir commit -m "chore: vault inicial do federated-memory"
    Ok "Repositorio Git inicializado"
}

# ---------- 4. hermes ----------
Step "Instalando Hermes Agent"

$HermesDir = Join-Path $HOME ".hermes-agent"

if (Test-Path $HermesDir) {
    Warn "Hermes ja instalado em $HermesDir. Pulando."
} else {
    git clone $HermesUrl $HermesDir
    Set-Location $HermesDir
    python -m venv .venv
    & "$HermesDir\.venv\Scripts\pip.exe" install -e . --quiet
    Set-Location $PSScriptRoot
    Ok "Hermes instalado em $HermesDir"
}

# AGENTS.md apontando para o vault
$AgentsFile = Join-Path $VaultDir "AGENTS.md"
if (-not (Test-Path $AgentsFile)) {
    @'
# AGENTS.md — lido automaticamente pelo Hermes

This is a federated memory base. Read the consumption protocol before doing anything:

  00-global/AGENT.md

Before responding to any task:
1. Identify the domain (writing, engineering, automation, etc).
2. Load the corresponding Context Pack from /30-context-packs/.
3. Never write to /00-global/ or /10-domains/ without explicit human approval.
4. New memory suggestions go to /50-inbox/suggested-memory.md.
'@ | Set-Content $AgentsFile -Encoding UTF8
    Ok "AGENTS.md criado no vault"
}

# ---------- 5. MCP server ----------
Step "Instalando MCP server (filesystem)"

$installed = npm list -g $McpPackage 2>$null
if ($installed -match $McpPackage) {
    Warn "MCP server ja instalado. Pulando."
} else {
    npm install -g $McpPackage --quiet
    Ok "MCP server instalado"
}

# ---------- 6. Claude Code settings ----------
Step "Configurando Claude Code"

$ClaudeDir    = Join-Path $HOME ".claude"
$SettingsFile = Join-Path $ClaudeDir "settings.json"
New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null

$VaultEscaped = $VaultDir -replace '\\', '\\'

if (Test-Path $SettingsFile) {
    Warn "settings.json ja existe. Nao sobrescrevendo."
    Warn "Adicione manualmente o bloco abaixo ao arquivo $SettingsFile :"
    Write-Host ""
    Write-Host @"
  "mcpServers": {
    "federated-memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "$VaultDir"]
    }
  }
"@
} else {
    @"
{
  "mcpServers": {
    "federated-memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "$VaultEscaped"]
    }
  }
}
"@ | Set-Content $SettingsFile -Encoding UTF8
    Ok "Claude Code configurado em $SettingsFile"
}

# ---------- 7. proximos passos ----------
Write-Host "`nSetup concluido." -ForegroundColor Green
Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor White
Write-Host ""
Write-Host "  1. Abra o Obsidian e aponte para: $VaultDir"
Write-Host "     (File > Open Vault > selecione a pasta)"
Write-Host ""
Write-Host "  2. Edite o contrato de memoria:"
Write-Host "     $VaultDir\00-global\AGENT.md"
Write-Host ""
Write-Host "  3. Para rodar o Hermes:"
Write-Host "     & `"$HermesDir\.venv\Scripts\activate.ps1`""
Write-Host "     Set-Location `"$VaultDir`"; hermes"
Write-Host ""
Write-Host "  4. Para verificar o MCP no Claude Code:"
Write-Host "     Abra o Claude Code e rode /mcp"
Write-Host "     O servidor 'federated-memory' deve aparecer como conectado."
Write-Host ""
Write-Host "  5. Leia o guia completo:"
Write-Host "     https://github.com/AndreAlmeidaDC/federated-memory"
Write-Host ""
