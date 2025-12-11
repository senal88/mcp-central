#!/usr/bin/env bash
# Módulo 2: Integração com 1Password para gerenciamento de secrets
# Versão: 1.0.0
# Autor: luiz.sena88@icloud.com
# Data: 2025-12-11

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Vaults do 1Password
VAULT_AZURE="zfdghptbnbxjilasq7e2tb3rxi"
VAULT_MACOS="gkpsbgizlks2zknwzqpppnb2ze"
VAULT_VPS="oa3tidekmeu26nxiier2qbi7v4"
VAULT_PERSONAL="7bgov3zmccio5fxc5v7irhy5k4"

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

# Verificar instalação do 1Password CLI
check_op_cli() {
    if ! command -v op &> /dev/null; then
        log_error "1Password CLI não encontrado"
        log_info "Instale com: brew install --cask 1password-cli"
        exit 1
    fi

    log_success "1Password CLI encontrado: $(op --version)"
}

# Verificar autenticação
check_op_auth() {
    if ! op vault list &> /dev/null; then
        log_error "Não autenticado no 1Password"
        log_info "Execute: eval \$(op signin)"
        exit 1
    fi

    log_success "Autenticado no 1Password"
}

# Criar item no 1Password se não existir
create_or_update_item() {
    local vault=$1
    local item_name=$2
    local field_name=$3
    local field_value=$4
    local item_category=${5:-"Secure Note"}

    log_info "Criando/atualizando item '$item_name' no vault..."

    # Verificar se item existe
    if op item get "$item_name" --vault "$vault" &> /dev/null; then
        log_info "Item '$item_name' já existe, atualizando..."
        op item edit "$item_name" \
            --vault "$vault" \
            "$field_name=$field_value" &> /dev/null || {
            log_warning "Não foi possível atualizar, tentando recriar..."
            op item delete "$item_name" --vault "$vault" &> /dev/null || true
            op item create \
                --category "$item_category" \
                --title "$item_name" \
                --vault "$vault" \
                "$field_name=$field_value" &> /dev/null
        }
    else
        log_info "Criando novo item '$item_name'..."
        op item create \
            --category "$item_category" \
            --title "$item_name" \
            --vault "$vault" \
            "$field_name=$field_value" &> /dev/null
    fi

    log_success "Item '$item_name' configurado com sucesso"
}

# Recuperar valor do 1Password
get_secret() {
    local vault=$1
    local item_name=$2
    local field_name=$3

    local value=$(op item get "$item_name" \
        --vault "$vault" \
        --fields "$field_name" 2>/dev/null || echo "")

    if [ -z "$value" ]; then
        log_warning "Não foi possível recuperar '$field_name' de '$item_name'"
        return 1
    fi

    echo "$value"
}

# Configurar credenciais do Context7 no 1Password
setup_context7_credentials() {
    log_info "Configurando credenciais Context7 no 1Password..."

    local api_key="ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032"
    local mcp_url="https://mcp.context7.com/mcp"
    local api_url="https://context7.com/api/v2"

    # Salvar no vault macOS
    create_or_update_item \
        "$VAULT_MACOS" \
        "Context7_API" \
        "api_key" \
        "$api_key" \
        "API Credential"

    create_or_update_item \
        "$VAULT_MACOS" \
        "Context7_Config" \
        "mcp_url" \
        "$mcp_url" \
        "Secure Note"

    create_or_update_item \
        "$VAULT_MACOS" \
        "Context7_Config" \
        "api_url" \
        "$api_url" \
        "Secure Note"

    log_success "Credenciais Context7 salvas no 1Password"
}

# Configurar credenciais VPS no 1Password
setup_vps_credentials() {
    log_info "Configurando credenciais VPS no 1Password..."

    create_or_update_item \
        "$VAULT_VPS" \
        "Hostinger_VPS" \
        "ip_address" \
        "147.79.81.59" \
        "Server"

    create_or_update_item \
        "$VAULT_VPS" \
        "Hostinger_VPS" \
        "ssh_port" \
        "22" \
        "Server"

    create_or_update_item \
        "$VAULT_VPS" \
        "Hostinger_VPS" \
        "domain" \
        "senamfo.com.br" \
        "Server"

    create_or_update_item \
        "$VAULT_VPS" \
        "Hostinger_VPS" \
        "username" \
        "admin" \
        "Server"

    log_success "Credenciais VPS salvas no 1Password"
}

# Configurar credenciais GitHub no 1Password
setup_github_credentials() {
    log_info "Configurando credenciais GitHub no 1Password..."

    create_or_update_item \
        "$VAULT_PERSONAL" \
        "GitHub_senal88" \
        "username" \
        "senal88" \
        "Login"

    create_or_update_item \
        "$VAULT_PERSONAL" \
        "GitHub_senal88" \
        "email" \
        "luizfernandomoreirasena@gmail.com" \
        "Login"

    create_or_update_item \
        "$VAULT_PERSONAL" \
        "GitHub_senal88" \
        "repository" \
        "https://github.com/senal88/context7" \
        "Login"

    log_success "Credenciais GitHub salvas no 1Password"
}

# Exportar variáveis de ambiente do 1Password
export_env_vars() {
    log_info "Exportando variáveis de ambiente do 1Password..."

    local context7_api_key=$(get_secret "$VAULT_MACOS" "Context7_API" "api_key" || echo "")

    if [ -n "$context7_api_key" ]; then
        export CONTEXT7_API_KEY="$context7_api_key"
        log_success "CONTEXT7_API_KEY exportada"
    fi

    # Criar arquivo .env local
    local env_file="$HOME/context7-setup/.env"
    cat > "$env_file" << EOF
# Context7 Configuration
# Gerado automaticamente em $(date)
CONTEXT7_API_KEY=$context7_api_key
CONTEXT7_MCP_URL=https://mcp.context7.com/mcp
CONTEXT7_API_URL=https://context7.com/api/v2

# 1Password Vaults
OP_VAULT_AZURE=$VAULT_AZURE
OP_VAULT_MACOS=$VAULT_MACOS
OP_VAULT_VPS=$VAULT_VPS
OP_VAULT_PERSONAL=$VAULT_PERSONAL

# VPS Configuration
VPS_IP=147.79.81.59
VPS_PORT=22
VPS_USER=admin
VPS_DOMAIN=senamfo.com.br

# GitHub Configuration
GITHUB_USER=senal88
GITHUB_EMAIL=luizfernandomoreirasena@gmail.com
GITHUB_REPO=https://github.com/senal88/context7
EOF

    chmod 600 "$env_file"
    log_success "Arquivo .env criado: $env_file"
}

# Gerar script de integração
generate_integration_script() {
    log_info "Gerando script de integração 1Password..."

    local script_file="$HOME/context7-setup/load-secrets.sh"

    cat > "$script_file" << 'EOF'
#!/usr/bin/env bash
# Script para carregar secrets do 1Password
# Uso: source load-secrets.sh

VAULT_MACOS="gkpsbgizlks2zknwzqpppnb2ze"

if ! command -v op &> /dev/null; then
    echo "❌ 1Password CLI não instalado"
    return 1
fi

if ! op vault list &> /dev/null; then
    echo "❌ Não autenticado no 1Password. Execute: eval \$(op signin)"
    return 1
fi

# Carregar Context7 API Key
export CONTEXT7_API_KEY=$(op item get "Context7_API" --vault "$VAULT_MACOS" --fields "api_key" 2>/dev/null)

if [ -n "$CONTEXT7_API_KEY" ]; then
    echo "✅ CONTEXT7_API_KEY carregada do 1Password"
else
    echo "⚠️  Não foi possível carregar CONTEXT7_API_KEY"
fi

# Carregar outras variáveis de ambiente
export CONTEXT7_MCP_URL="https://mcp.context7.com/mcp"
export CONTEXT7_API_URL="https://context7.com/api/v2"

echo "✅ Variáveis de ambiente carregadas"
EOF

    chmod +x "$script_file"
    log_success "Script de integração criado: $script_file"
}

# Testar integração
test_integration() {
    log_info "Testando integração 1Password..."

    local api_key=$(get_secret "$VAULT_MACOS" "Context7_API" "api_key" || echo "")

    if [ -z "$api_key" ]; then
        log_error "Falha ao recuperar API key do 1Password"
        return 1
    fi

    # Testar API Context7
    local response=$(curl -s -o /dev/null -w "%{http_code}" \
        -X GET "https://context7.com/api/v2/search?query=test" \
        -H "Authorization: Bearer ${api_key}")

    if [ "$response" -eq 200 ]; then
        log_success "API Context7 validada com secret do 1Password"
    else
        log_error "Falha na validação da API (HTTP $response)"
        return 1
    fi
}

# Função principal
main() {
    log_info "=== Configurando integração 1Password para Context7 ==="

    check_op_cli
    check_op_auth

    setup_context7_credentials
    setup_vps_credentials
    setup_github_credentials

    export_env_vars
    generate_integration_script

    test_integration

    log_success "=== Integração 1Password configurada com sucesso! ==="
    log_info "Para carregar secrets: source ~/context7-setup/load-secrets.sh"
}

main "$@"
