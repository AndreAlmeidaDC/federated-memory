#!/usr/bin/env bash
# setup.sh — Federated Memory Setup (Linux / macOS)
# Repositório: https://github.com/AndreAlmeidaDC/federated-memory
#
# O que este script faz:
#   1. Verifica dependências (git, python3, node, npm)
#   2. Clona o vault template para ~/federated-memory
#   3. Inicializa repositório Git no vault
#   4. Instala o Hermes Agent
#   5. Instala o MCP server para Obsidian (filesystem)
#   6. Gera o settings.json para Claude Code
#   7. Exibe próximos passos
#
# Uso: bash setup.sh [--vault-dir CAMINHO]

set -e

# ---------- cores ----------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

ok()   { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; exit 1; }
step() { echo -e "\n${BOLD}${CYAN}── $1${NC}"; }

# ---------- configurações ----------
VAULT_DIR="${1:-$HOME/federated-memory}"
REPO_URL="https://github.com/AndreAlmeidaDC/federated-memory.git"
HERMES_URL="https://github.com/NousResearch/hermes-agent.git"
MCP_PACKAGE="@modelcontextprotocol/server-filesystem"

echo -e "\n${BOLD}Federated Memory — Setup${NC}"
echo    "Vault destino: $VAULT_DIR"
echo    "─────────────────────────────────────"

# ---------- 1. dependências ----------
step "Verificando dependências"

check_cmd() {
    if command -v "$1" &>/dev/null; then
        ok "$1 encontrado ($(command -v $1))"
    else
        fail "$1 não encontrado. Instale antes de continuar."
    fi
}

check_cmd git
check_cmd python3
check_cmd pip3
check_cmd node
check_cmd npm

# ---------- 2. vault ----------
step "Criando vault em $VAULT_DIR"

if [ -d "$VAULT_DIR" ]; then
    warn "Pasta já existe. Pulando criação."
else
    mkdir -p "$VAULT_DIR"

    # copia o template do repositório clonado localmente
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -d "$SCRIPT_DIR/template" ]; then
        cp -r "$SCRIPT_DIR/template/." "$VAULT_DIR/"
        ok "Template copiado de $SCRIPT_DIR/template"
    else
        warn "Pasta template não encontrada localmente. Baixando do GitHub..."
        TMP=$(mktemp -d)
        git clone --depth 1 "$REPO_URL" "$TMP/repo" 2>/dev/null
        cp -r "$TMP/repo/template/." "$VAULT_DIR/"
        rm -rf "$TMP"
        ok "Template baixado do repositório"
    fi
fi

# ---------- 3. git no vault ----------
step "Inicializando Git no vault"

if [ -d "$VAULT_DIR/.git" ]; then
    warn "Repositório Git já existe. Pulando."
else
    git -C "$VAULT_DIR" init -b main
    git -C "$VAULT_DIR" add .
    git -C "$VAULT_DIR" commit -m "chore: vault inicial do federated-memory"
    ok "Repositório Git inicializado"
fi

# ---------- 4. hermes ----------
step "Instalando Hermes Agent"

HERMES_DIR="$HOME/.hermes-agent"

if [ -d "$HERMES_DIR" ]; then
    warn "Hermes já instalado em $HERMES_DIR. Pulando."
else
    git clone "$HERMES_URL" "$HERMES_DIR"
    cd "$HERMES_DIR"
    python3 -m venv .venv
    source .venv/bin/activate
    pip3 install -e . --quiet
    deactivate
    cd - > /dev/null
    ok "Hermes instalado em $HERMES_DIR"
fi

# AGENTS.md apontando para o vault
AGENTS_FILE="$VAULT_DIR/AGENTS.md"
if [ ! -f "$AGENTS_FILE" ]; then
cat > "$AGENTS_FILE" <<'AGENTSEOF'
# AGENTS.md — lido automaticamente pelo Hermes

This is a federated memory base. Read the consumption protocol before doing anything:

  00-global/AGENT.md

Before responding to any task:
1. Identify the domain (writing, engineering, automation, etc).
2. Load the corresponding Context Pack from /30-context-packs/.
3. Never write to /00-global/ or /10-domains/ without explicit human approval.
4. New memory suggestions go to /50-inbox/suggested-memory.md.
AGENTSEOF
    ok "AGENTS.md criado no vault"
fi

# ---------- 5. MCP server ----------
step "Instalando MCP server (filesystem)"

if npm list -g "$MCP_PACKAGE" &>/dev/null 2>&1; then
    warn "MCP server já instalado. Pulando."
else
    npm install -g "$MCP_PACKAGE" --quiet
    ok "MCP server instalado"
fi

# ---------- 6. Claude Code settings ----------
step "Configurando Claude Code"

CLAUDE_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
mkdir -p "$CLAUDE_DIR"

if [ -f "$SETTINGS_FILE" ]; then
    warn "settings.json já existe. Não sobrescrevendo."
    warn "Adicione manualmente o bloco mcpServers abaixo:"
    echo ""
    cat <<SETTINGSEOF
  "mcpServers": {
    "federated-memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "$VAULT_DIR"]
    }
  }
SETTINGSEOF
else
    cat > "$SETTINGS_FILE" <<SETTINGSEOF
{
  "mcpServers": {
    "federated-memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "$VAULT_DIR"]
    }
  }
}
SETTINGSEOF
    ok "Claude Code configurado em $SETTINGS_FILE"
fi

# ---------- 7. próximos passos ----------
echo -e "\n${BOLD}${GREEN}Setup concluído.${NC}\n"
echo -e "${BOLD}Próximos passos:${NC}"
echo ""
echo "  1. Abra o Obsidian e aponte para: $VAULT_DIR"
echo "     (File > Open Vault > selecione a pasta)"
echo ""
echo "  2. Edite o contrato de memória:"
echo "     $VAULT_DIR/00-global/AGENT.md"
echo ""
echo "  3. Para rodar o Hermes:"
echo "     source $HERMES_DIR/.venv/bin/activate"
echo "     cd $VAULT_DIR && hermes"
echo ""
echo "  4. Para verificar o MCP no Claude Code:"
echo "     Abra o Claude Code e rode /mcp"
echo "     O servidor 'federated-memory' deve aparecer como conectado."
echo ""
echo "  5. Leia o guia completo:"
echo "     https://github.com/AndreAlmeidaDC/federated-memory"
echo ""
