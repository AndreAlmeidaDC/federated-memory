# setup.ps1 - Federated Memory Setup (Windows)
# Repositorio: https://github.com/AndreAlmeidaDC/federated-memory
#
# O que este script faz (apenas o piso recomendado):
#   1. Verifica dependencias (git, node, npm)
#   2. Copia o vault template para $HOME\federated-memory
#   3. Inicializa repositorio Git no vault (branch master) e faz o primeiro commit
#   4. Exibe proximos passos
#
# Este script NAO instala Hermes nem MCP. Na arquitetura v3 esses sao
# evolucao opcional, nao base. O piso e: vault Markdown + Git + contrato.
# Para somar Hermes ou MCP depois, veja o bloco "Evolucao opcional" do
# QUICKSTART.md.
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

$RepoUrl = "https://github.com/AndreAlmeidaDC/federated-memory.git"

Write-Host "`nFederated Memory -- Setup" -ForegroundColor White
Write-Host "Vault destino: $VaultDir"
Write-Host "Monta apenas o piso: vault + Git + contrato."
Write-Host "-------------------------------------"

# ---------- 1. dependencias ----------
Step "Verificando dependencias"

function CheckCmd($cmd) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        Ok "$cmd encontrado"
    } else {
        Fail "$cmd nao encontrado. Instale antes de continuar."
    }
}

CheckCmd "git"
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
Step "Inicializando Git no vault (branch master)"

if (Test-Path (Join-Path $VaultDir ".git")) {
    Warn "Repositorio Git ja existe. Pulando."
} else {
    git -C $VaultDir init -b master
    git -C $VaultDir add .
    git -C $VaultDir commit -m "chore: vault inicial do federated-memory"
    Ok "Repositorio Git inicializado na branch master"
}

# ---------- 4. proximos passos ----------
Write-Host "`nSetup concluido." -ForegroundColor Green
Write-Host ""
Write-Host "Voce tem o piso funcionando: vault + Git + contrato." -ForegroundColor White
Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor White
Write-Host ""
Write-Host "  1. Edite o contrato de memoria do seu contexto:"
Write-Host "     $VaultDir\00-global\AGENT.md"
Write-Host ""
Write-Host "  2. Crie seu primeiro Context Pack em:"
Write-Host "     $VaultDir\60-context-packs\"
Write-Host ""
Write-Host "  3. Abra um agente cliente (Claude Code, Cursor, etc.) na pasta do vault"
Write-Host "     e rode uma tarefa. So o piso ja funciona, sem Hermes e sem MCP."
Write-Host ""
Write-Host "  4. Conecte um repositorio remoto quando quiser sincronizar entre maquinas:"
Write-Host "     git -C `"$VaultDir`" remote add origin <URL_DO_SEU_REPO>"
Write-Host "     git -C `"$VaultDir`" push -u origin master"
Write-Host ""
Write-Host "  5. (Opcional) Editar com conforto visual: abra a pasta no Obsidian."
Write-Host "     (File > Open Vault > selecione $VaultDir)"
Write-Host ""
Write-Host "  6. (Opcional) Somar Hermes, MCP ou Graphiti: veja o bloco"
Write-Host "     'Evolucao opcional' do QUICKSTART.md. Nenhum deles e necessario"
Write-Host "     para o piso funcionar."
Write-Host ""
Write-Host "  Guia completo e whitepaper:"
Write-Host "     https://github.com/AndreAlmeidaDC/federated-memory"
Write-Host ""
