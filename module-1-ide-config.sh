#!/usr/bin/env bash
# Módulo 1: Configuração completa do Context7 MCP para todas as IDEs
# Versão: 1.0.0
# Autor: luiz.sena88@icloud.com
# Data: 2025-12-11

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variáveis de ambiente
CONTEXT7_API_KEY="${CONTEXT7_API_KEY:-ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032}"
MCP_URL="https://mcp.context7.com/mcp"
API_URL="https://context7.com/api/v2"

# Diretórios de configuração
VSCODE_MCP_CONFIG="$HOME/Library/Application Support/Code/User/mcp.json"
CURSOR_CONFIG="$HOME/.cursor/mcp.json"
CLAUDE_CONFIG="$HOME/.claude.json"
CODEX_CONFIG="$HOME/.codex/config.toml"
GEMINI_CONFIG="$HOME/.config/gemini/config.json"

# Diretório de backup
BACKUP_DIR="$HOME/.context7-backups/$(date +%Y%m%d_%H%M%S)"

# Funções auxiliares
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Função para criar backup
create_backup() {
    local file=$1
    if [ -f "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        cp "$file" "$BACKUP_DIR/$(basename "$file").backup"
        log_info "Backup criado: $BACKUP_DIR/$(basename "$file").backup"
    fi
}

# Função para validar API Context7
validate_context7_api() {
    log_info "Validando conexão com API Context7..."
    local response=$(curl -s -o /dev/null -w "%{http_code}" \
        -X GET "${API_URL}/search?query=test" \
        -H "Authorization: Bearer ${CONTEXT7_API_KEY}")

    if [ "$response" -eq 200 ]; then
        log_success "API Context7 validada com sucesso"
        return 0
    else
        log_error "Falha na validação da API Context7 (HTTP $response)"
        return 1
    fi
}

# Função para configurar VS Code
configure_vscode() {
    log_info "Configurando Context7 MCP para VS Code..."

    create_backup "$VSCODE_MCP_CONFIG"

    local vscode_dir="$(dirname "$VSCODE_MCP_CONFIG")"
    mkdir -p "$vscode_dir"

    # Criar ou atualizar configuração MCP dedicada
    if [ -f "$VSCODE_MCP_CONFIG" ]; then
        # Merge com configuração existente
        local temp_file=$(mktemp)
        jq --arg api_key "$CONTEXT7_API_KEY" \
           --arg mcp_url "$MCP_URL" \
           '.servers.context7 = {
               "type": "http",
               "url": $mcp_url,
               "headers": {
                   "CONTEXT7_API_KEY": $api_key
               }
           }' "$VSCODE_MCP_CONFIG" > "$temp_file" 2>/dev/null || \
        jq --arg api_key "$CONTEXT7_API_KEY" \
           --arg mcp_url "$MCP_URL" \
           '. + {
               "servers": {
                   "context7": {
                       "type": "http",
                       "url": $mcp_url,
                       "headers": {
                           "CONTEXT7_API_KEY": $api_key
                       }
                   }
               }
           }' "$VSCODE_MCP_CONFIG" > "$temp_file"

        mv "$temp_file" "$VSCODE_MCP_CONFIG"
    else
        # Criar nova configuração MCP dedicada
        cat > "$VSCODE_MCP_CONFIG" << EOF
{
  "servers": {
    "context7": {
      "type": "http",
      "url": "${MCP_URL}",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    }
  }
}
EOF
    fi

    log_success "VS Code MCP configurado com sucesso"
}

# Função para configurar Cursor
configure_cursor() {
    log_info "Configurando Context7 MCP para Cursor..."

    create_backup "$CURSOR_CONFIG"

    local cursor_dir="$(dirname "$CURSOR_CONFIG")"
    mkdir -p "$cursor_dir"

    cat > "$CURSOR_CONFIG" << EOF
{
  "mcpServers": {
    "context7": {
      "url": "${MCP_URL}",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    }
  }
}
EOF

    log_success "Cursor configurado com sucesso"
}

# Função para configurar Claude CLI
configure_claude() {
    log_info "Configurando Context7 MCP para Claude CLI..."

    create_backup "$CLAUDE_CONFIG"

    # Executar comando claude mcp add
    if command -v claude &> /dev/null; then
        claude mcp add --transport http context7 "${MCP_URL}" \
            --header "CONTEXT7_API_KEY: ${CONTEXT7_API_KEY}" 2>/dev/null || \
        log_warning "Claude CLI não configurado via comando (pode já existir)"

        log_success "Claude CLI configurado com sucesso"
    else
        log_warning "Claude CLI não encontrado, pulando configuração"
    fi
}

# Função para configurar Codex
configure_codex() {
    log_info "Configurando Context7 MCP para Codex..."

    create_backup "$CODEX_CONFIG"

    local codex_dir="$(dirname "$CODEX_CONFIG")"
    mkdir -p "$codex_dir"

    # Verificar se já existe seção mcp_servers
    if [ -f "$CODEX_CONFIG" ] && grep -q "\[mcp_servers.context7\]" "$CODEX_CONFIG"; then
        log_warning "Configuração Context7 já existe no Codex, atualizando..."
        sed -i.bak '/\[mcp_servers.context7\]/,/^$/d' "$CODEX_CONFIG"
    fi

    cat >> "$CODEX_CONFIG" << EOF

[mcp_servers.context7]
url = "${MCP_URL}"
http_headers = { "CONTEXT7_API_KEY" = "${CONTEXT7_API_KEY}" }
EOF

    log_success "Codex configurado com sucesso"
}

# Função para configurar Gemini CLI
configure_gemini() {
    log_info "Configurando Context7 MCP para Gemini CLI..."

    create_backup "$GEMINI_CONFIG"

    local gemini_dir="$(dirname "$GEMINI_CONFIG")"
    mkdir -p "$gemini_dir"

    cat > "$GEMINI_CONFIG" << EOF
{
  "mcpServers": {
    "context7": {
      "httpUrl": "${MCP_URL}",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}",
        "Accept": "application/json, text/event-stream"
      }
    }
  }
}
EOF

    log_success "Gemini CLI configurado com sucesso"
}

# Função para gerar relatório
generate_report() {
    local report_file="$HOME/context7-setup/deployment-report-$(date +%Y%m%d_%H%M%S).txt"

    cat > "$report_file" << EOF
===========================================
RELATÓRIO DE CONFIGURAÇÃO CONTEXT7 MCP
===========================================
Data: $(date)
Versão: 1.0.0

AMBIENTES CONFIGURADOS:
-----------------------
EOF

    [ -f "$VSCODE_MCP_CONFIG" ] && echo "✓ VS Code MCP: $VSCODE_MCP_CONFIG" >> "$report_file" || echo "✗ VS Code MCP: Não configurado" >> "$report_file"
    [ -f "$CURSOR_CONFIG" ] && echo "✓ Cursor: $CURSOR_CONFIG" >> "$report_file" || echo "✗ Cursor: Não configurado" >> "$report_file"
    [ -f "$CLAUDE_CONFIG" ] && echo "✓ Claude CLI: $CLAUDE_CONFIG" >> "$report_file" || echo "✗ Claude CLI: Não configurado" >> "$report_file"
    [ -f "$CODEX_CONFIG" ] && echo "✓ Codex: $CODEX_CONFIG" >> "$report_file" || echo "✗ Codex: Não configurado" >> "$report_file"
    [ -f "$GEMINI_CONFIG" ] && echo "✓ Gemini CLI: $GEMINI_CONFIG" >> "$report_file" || echo "✗ Gemini CLI: Não configurado" >> "$report_file"

    cat >> "$report_file" << EOF

CREDENCIAIS:
-----------
API Key: ${CONTEXT7_API_KEY:0:20}...
MCP URL: ${MCP_URL}
API URL: ${API_URL}

BACKUPS:
--------
Localização: ${BACKUP_DIR}

===========================================
EOF

    log_success "Relatório gerado: $report_file"
    cat "$report_file"
}

# Função principal
main() {
    log_info "=== Iniciando configuração Context7 MCP para todas as IDEs ==="

    # Validar API
    if ! validate_context7_api; then
        log_error "Validação da API falhou. Abortando."
        exit 1
    fi

    # Configurar cada IDE
    configure_vscode
    configure_cursor
    configure_claude
    configure_codex
    configure_gemini

    # Gerar relatório
    generate_report

    log_success "=== Configuração concluída com sucesso! ==="
    log_info "Reinicie suas IDEs para aplicar as alterações"
}

# Executar
main "$@"
