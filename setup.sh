#!/usr/bin/env bash
# setup.sh - Federated Memory Setup (Linux / macOS)
# Repositorio: https://github.com/AndreAlmeidaDC/federated-memory
#
# O que este script faz (apenas o piso recomendado):
#   1. Verifica dependencias (git, node, npm)
#   2. Copia o vault template para ~/federated-memory
#   3. Inicializa repositorio Git no vault (branch master) e faz o primeiro commit
#   4. Exibe proximos passos
#
# Este script NAO instala Hermes nem MCP. Na arquitetura v3 esses sao
# evolucao opcional, nao base. O piso e: vault Markdown + Git + contrato.
# Para somar Hermes ou MCP depois, veja o bloco "Evolucao opcional" do
# QUICKSTART.md.
#
# Uso: bash setup.sh [CAMINHO_DO_VAULT]

set -e

# ---------- cores ----------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

ok()   { echo -e "${GREEN}OK${NC} $1"; }
warn() { echo -e "${YELLOW}! ${NC} $1"; }
fail() { echo -e "${RED}X ${NC} $1"; exit 1; }
step() { echo -e "\n${BOLD}${CYAN}-- $1${NC}"; }

# ---------- configuracoes ----------
VAULT_DIR="${1:-$HOME/federated-memory}"
REPO_URL="https://github.com/AndreAlmeidaDC/federated-memory.git"

echo -e "\n${BOLD}Federated Memory - Setup${NC}"
echo    "Vault destino: $VAULT_DIR"
echo    "Monta apenas o piso: vault + Git + contrato."
echo    "-------------------------------------"

# ---------- 1. dependencias ----------
step "Verificando dependencias"

check_cmd() {
    if command -v "$1" &>/dev/null; then
        ok "$1 encontrado ($(command -v $1))"
    else
        fail "$1 nao encontrado. Instale antes de continuar."
    fi
}

check_cmd git
check_cmd node
check_cmd npm

# ---------- 2. vault ----------
step "Criando vault em $VAULT_DIR"

if [ -d "$VAULT_DIR" ]; then
    warn "Pasta ja existe. Pulando criacao."
else
    mkdir -p "$VAULT_DIR"

    # copia o template do repositorio clonado localmente
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -d "$SCRIPT_DIR/template" ]; then
        cp -r "$SCRIPT_DIR/template/." "$VAULT_DIR/"
        ok "Template copiado de $SCRIPT_DIR/template"
    else
        warn "Pasta template nao encontrada localmente. Baixando do GitHub..."
        TMP=$(mktemp -d)
        git clone --depth 1 "$REPO_URL" "$TMP/repo" 2>/dev/null
        cp -r "$TMP/repo/template/." "$VAULT_DIR/"
        rm -rf "$TMP"
        ok "Template baixado do repositorio"
    fi
fi

# ---------- 3. git no vault ----------
step "Inicializando Git no vault (branch master)"

if [ -d "$VAULT_DIR/.git" ]; then
    warn "Repositorio Git ja existe. Pulando."
else
    git -C "$VAULT_DIR" init -b master
    git -C "$VAULT_DIR" add .
    git -C "$VAULT_DIR" commit -m "chore: vault inicial do federated-memory"
    ok "Repositorio Git inicializado na branch master"
fi

# ---------- 4. proximos passos ----------
echo -e "\n${BOLD}${GREEN}Setup concluido.${NC}\n"
echo -e "${BOLD}Voce tem o piso funcionando: vault + Git + contrato.${NC}"
echo ""
echo -e "${BOLD}Proximos passos:${NC}"
echo ""
echo "  1. Edite o contrato de memoria do seu contexto:"
echo "     $VAULT_DIR/00-global/AGENT.md"
echo ""
echo "  2. Crie seu primeiro Context Pack em:"
echo "     $VAULT_DIR/60-context-packs/"
echo ""
echo "  3. Abra um agente cliente (Claude Code, Cursor, etc.) na pasta do vault"
echo "     e rode uma tarefa. So o piso ja funciona, sem Hermes e sem MCP."
echo ""
echo "  4. Conecte um repositorio remoto quando quiser sincronizar entre maquinas:"
echo "     git -C \"$VAULT_DIR\" remote add origin <URL_DO_SEU_REPO>"
echo "     git -C \"$VAULT_DIR\" push -u origin master"
echo ""
echo "  5. (Opcional) Editar com conforto visual: abra a pasta no Obsidian."
echo "     (File > Open Vault > selecione $VAULT_DIR)"
echo ""
echo "  6. (Opcional) Somar Hermes, MCP ou Graphiti: veja o bloco"
echo "     'Evolucao opcional' do QUICKSTART.md. Nenhum deles e necessario"
echo "     para o piso funcionar."
echo ""
echo "  Guia completo e whitepaper:"
echo "     https://github.com/AndreAlmeidaDC/federated-memory"
echo ""
