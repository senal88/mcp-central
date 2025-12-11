#!/usr/bin/env bash
# Módulo 4: Deploy no VPS via Coolify
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

# Configurações VPS
VPS_IP="147.79.81.59"
VPS_PORT="22"
VPS_USER="admin"
VPS_DOMAIN="senamfo.com.br"

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

# Verificar conectividade SSH
check_ssh_connection() {
    log_info "Verificando conectividade SSH com VPS..."

    if timeout 10 ssh -o BatchMode=yes -o ConnectTimeout=5 \
        -p "$VPS_PORT" "${VPS_USER}@${VPS_IP}" exit 2>/dev/null; then
        log_success "Conexão SSH estabelecida com sucesso"
        return 0
    else
        log_error "Não foi possível conectar via SSH"
        log_info "Configure autenticação SSH: ssh-copy-id -p ${VPS_PORT} ${VPS_USER}@${VPS_IP}"
        return 1
    fi
}

# Configurar SSH key
setup_ssh_key() {
    log_info "Configurando chave SSH..."

    local ssh_key="$HOME/.ssh/id_ed25519"

    if [ ! -f "$ssh_key" ]; then
        log_info "Gerando nova chave SSH..."
        ssh-keygen -t ed25519 -f "$ssh_key" -N "" -C "luiz.sena88@icloud.com"
        log_success "Chave SSH gerada"
    else
        log_info "Chave SSH já existe"
    fi

    # Copiar para VPS
    log_info "Copiando chave pública para VPS..."
    log_info "Execute manualmente: ssh-copy-id -p ${VPS_PORT} ${VPS_USER}@${VPS_IP}"
}

# Preparar scripts de deploy
prepare_deploy_scripts() {
    log_info "Preparando scripts de deploy..."

    local deploy_dir="$HOME/context7-setup/deployment"
    mkdir -p "$deploy_dir"

    # Script de instalação remota
    cat > "$deploy_dir/remote-install.sh" << 'EOF'
#!/usr/bin/env bash
# Script de instalação remota no VPS
set -euo pipefail

echo "=== Instalando Context7 no VPS ==="

# Atualizar sistema
echo "[1/6] Atualizando sistema..."
sudo apt-get update -qq
sudo apt-get upgrade -y -qq

# Instalar dependências
echo "[2/6] Instalando dependências..."
sudo apt-get install -y -qq curl git jq docker.io docker-compose

# Instalar Node.js (para MCP)
echo "[3/6] Instalando Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Configurar Docker
echo "[4/6] Configurando Docker..."
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Instalar Coolify (se não estiver instalado)
echo "[5/6] Verificando Coolify..."
if ! command -v coolify &> /dev/null; then
    echo "Instalando Coolify..."
    curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
else
    echo "Coolify já instalado"
fi

# Criar diretório para Context7
echo "[6/6] Criando estrutura de diretórios..."
mkdir -p ~/context7-setup
mkdir -p ~/context7-setup/configs
mkdir -p ~/context7-setup/logs

echo "✅ Instalação base concluída!"
EOF

    # Script de configuração Context7
    cat > "$deploy_dir/configure-context7.sh" << 'EOF'
#!/usr/bin/env bash
# Configurar Context7 no VPS
set -euo pipefail

CONTEXT7_API_KEY="${1:-}"

if [ -z "$CONTEXT7_API_KEY" ]; then
    echo "❌ Erro: API Key não fornecida"
    echo "Uso: $0 <CONTEXT7_API_KEY>"
    exit 1
fi

echo "=== Configurando Context7 no VPS ==="

# Criar arquivo de configuração
cat > ~/context7-setup/configs/context7.env << ENVEOF
CONTEXT7_API_KEY=${CONTEXT7_API_KEY}
CONTEXT7_MCP_URL=https://mcp.context7.com/mcp
CONTEXT7_API_URL=https://context7.com/api/v2
ENVEOF

chmod 600 ~/context7-setup/configs/context7.env

# Criar serviço systemd para MCP server
sudo tee /etc/systemd/system/context7-mcp.service > /dev/null << SERVICEEOF
[Unit]
Description=Context7 MCP Server
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME/context7-setup
EnvironmentFile=$HOME/context7-setup/configs/context7.env
ExecStart=/usr/bin/node $HOME/context7-setup/mcp-server.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICEEOF

# Recarregar systemd
sudo systemctl daemon-reload

echo "✅ Context7 configurado!"
echo "Para iniciar: sudo systemctl start context7-mcp"
EOF

    # Script de teste
    cat > "$deploy_dir/test-deployment.sh" << 'EOF'
#!/usr/bin/env bash
# Testar deployment no VPS
set -euo pipefail

echo "=== Testando Context7 no VPS ==="

# Source environment
source ~/context7-setup/configs/context7.env

# Testar API
echo "[1/3] Testando API Context7..."
response=$(curl -s -o /dev/null -w "%{http_code}" \
    -X GET "${CONTEXT7_API_URL}/search?query=test" \
    -H "Authorization: Bearer ${CONTEXT7_API_KEY}")

if [ "$response" -eq 200 ]; then
    echo "✅ API Context7 funcionando"
else
    echo "❌ API falhou (HTTP $response)"
    exit 1
fi

# Verificar serviço
echo "[2/3] Verificando serviço MCP..."
if systemctl is-active --quiet context7-mcp; then
    echo "✅ Serviço MCP ativo"
else
    echo "⚠️  Serviço MCP não está ativo"
fi

# Verificar Docker
echo "[3/3] Verificando Docker..."
if docker ps &> /dev/null; then
    echo "✅ Docker funcionando"
else
    echo "❌ Docker não está funcionando"
fi

echo ""
echo "=== Resumo do Deployment ==="
echo "Hostname: $(hostname)"
echo "IP: $(hostname -I | awk '{print $1}')"
echo "Uptime: $(uptime -p)"
echo "Docker containers: $(docker ps -q | wc -l)"
EOF

    chmod +x "$deploy_dir"/*.sh

    log_success "Scripts de deploy preparados em: $deploy_dir"
}

# Executar deploy remoto
execute_remote_deploy() {
    log_info "Executando deploy remoto..."

    local deploy_dir="$HOME/context7-setup/deployment"

    # Carregar API key do 1Password
    local api_key=""
    if command -v op &> /dev/null && op vault list &> /dev/null 2>&1; then
        api_key=$(op item get "Context7_API" \
            --vault "gkpsbgizlks2zknwzqpppnb2ze" \
            --fields "api_key" 2>/dev/null || echo "")
    fi

    if [ -z "$api_key" ]; then
        api_key="ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032"
        log_warning "Usando API key padrão (não recuperada do 1Password)"
    fi

    # Copiar scripts para VPS
    log_info "Copiando scripts para VPS..."
    scp -P "$VPS_PORT" \
        "$deploy_dir"/*.sh \
        "${VPS_USER}@${VPS_IP}:~/context7-setup/" 2>/dev/null || {
        log_error "Falha ao copiar scripts. Verifique conexão SSH."
        return 1
    }

    # Executar instalação remota
    log_info "Executando instalação remota..."
    ssh -p "$VPS_PORT" "${VPS_USER}@${VPS_IP}" \
        "bash ~/context7-setup/remote-install.sh" || {
        log_error "Falha na instalação remota"
        return 1
    }

    # Configurar Context7
    log_info "Configurando Context7 remotamente..."
    ssh -p "$VPS_PORT" "${VPS_USER}@${VPS_IP}" \
        "bash ~/context7-setup/configure-context7.sh '$api_key'" || {
        log_error "Falha na configuração Context7"
        return 1
    }

    # Executar testes
    log_info "Executando testes..."
    ssh -p "$VPS_PORT" "${VPS_USER}@${VPS_IP}" \
        "bash ~/context7-setup/test-deployment.sh" || {
        log_warning "Alguns testes falharam"
    }

    log_success "Deploy remoto concluído!"
}

# Configurar Coolify
configure_coolify() {
    log_info "Configurando integração Coolify..."

    cat > "$HOME/context7-setup/deployment/coolify-compose.yml" << 'EOF'
version: '3.8'

services:
  context7-mcp:
    image: node:20-alpine
    container_name: context7-mcp
    restart: unless-stopped
    environment:
      - CONTEXT7_API_KEY=${CONTEXT7_API_KEY}
      - CONTEXT7_MCP_URL=https://mcp.context7.com/mcp
      - CONTEXT7_API_URL=https://context7.com/api/v2
    volumes:
      - ./mcp-server.js:/app/server.js
      - ./configs:/app/configs
    working_dir: /app
    command: node server.js
    ports:
      - "3000:3000"
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    labels:
      - "coolify.managed=true"
      - "coolify.name=context7-mcp"
EOF

    log_success "Configuração Coolify criada"
}

# Gerar relatório de deploy
generate_deploy_report() {
    log_info "Gerando relatório de deploy..."

    local report_file="$HOME/context7-setup/deployment-vps-report-$(date +%Y%m%d_%H%M%S).txt"

    cat > "$report_file" << EOF
===========================================
RELATÓRIO DE DEPLOY VPS - CONTEXT7
===========================================
Data: $(date)
Versão: 1.0.0

CONFIGURAÇÃO VPS:
-----------------
IP: $VPS_IP
Porta SSH: $VPS_PORT
Usuário: $VPS_USER
Domínio: $VPS_DOMAIN
Orquestrador: Coolify

STATUS:
-------
EOF

    if check_ssh_connection &>/dev/null; then
        echo "✓ Conexão SSH: OK" >> "$report_file"
    else
        echo "✗ Conexão SSH: FALHA" >> "$report_file"
    fi

    cat >> "$report_file" << EOF

ARQUIVOS GERADOS:
-----------------
$(ls -lh ~/context7-setup/deployment/*.sh 2>/dev/null | awk '{print $9}' || echo "Nenhum")

PRÓXIMOS PASSOS:
---------------
1. Configurar autenticação SSH: ssh-copy-id -p ${VPS_PORT} ${VPS_USER}@${VPS_IP}
2. Executar deploy: ./module-4-vps-deploy.sh
3. Verificar serviços: ssh ${VPS_USER}@${VPS_IP} "systemctl status context7-mcp"
4. Configurar Coolify: Importar docker-compose.yml no dashboard

===========================================
EOF

    log_success "Relatório gerado: $report_file"
    cat "$report_file"
}

# Função principal
main() {
    log_info "=== Configurando deploy VPS via Coolify ==="

    setup_ssh_key
    prepare_deploy_scripts
    configure_coolify

    if check_ssh_connection; then
        read -p "Executar deploy remoto agora? (s/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            execute_remote_deploy
        else
            log_info "Deploy remoto pulado. Execute manualmente quando pronto."
        fi
    else
        log_warning "Configuração SSH necessária antes do deploy"
    fi

    generate_deploy_report

    log_success "=== Configuração VPS concluída! ==="
}

main "$@"
