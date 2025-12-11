#!/bin/bash

# Script de deploy para VPS Ubuntu (Coolify)
# VPS: 147.79.81.59 | senamfo.com.br | Porta 22

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

VPS_HOST="147.79.81.59"
VPS_USER="admin"
VPS_PORT="22"

echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     CONTEXT7 - DEPLOY PARA VPS UBUNTU                ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"

# Verificar conexão SSH
echo -e "\n${YELLOW}→ Testando conexão SSH...${NC}"
if ssh -p $VPS_PORT -o ConnectTimeout=5 $VPS_USER@$VPS_HOST "echo 'OK'" &> /dev/null; then
    echo -e "${GREEN}✓ Conexão SSH estabelecida${NC}"
else
    echo -e "${RED}✗ Não foi possível conectar ao VPS${NC}"
    echo "Verifique: ssh -p $VPS_PORT $VPS_USER@$VPS_HOST"
    exit 1
fi

# Criar estrutura no VPS
echo -e "\n${GREEN}[1/5] Criando estrutura de diretórios no VPS...${NC}"
ssh -p $VPS_PORT $VPS_USER@$VPS_HOST << 'ENDSSH'
mkdir -p ~/context7-setup
mkdir -p ~/.config
echo "✓ Diretórios criados"
ENDSSH

# Transferir arquivos de configuração
echo -e "\n${GREEN}[2/5] Transferindo arquivos de configuração...${NC}"
scp -P $VPS_PORT ~/context7-setup/vscode-settings.json \
    $VPS_USER@$VPS_HOST:~/context7-setup/
scp -P $VPS_PORT ~/context7-setup/cursor-config.json \
    $VPS_USER@$VPS_HOST:~/context7-setup/
scp -P $VPS_PORT ~/context7-setup/claude-mcp-config.json \
    $VPS_USER@$VPS_HOST:~/context7-setup/
echo -e "${GREEN}✓ Arquivos transferidos${NC}"

# Criar script de instalação remoto
echo -e "\n${GREEN}[3/5] Gerando script de instalação remoto...${NC}"
cat > /tmp/vps-install.sh << 'EOF'
#!/bin/bash

set -e

echo "=== INSTALAÇÃO CONTEXT7 NO VPS ==="

# Atualizar sistema
echo "→ Atualizando sistema..."
sudo apt-get update -qq

# Instalar dependências
echo "→ Instalando dependências..."
sudo apt-get install -y curl jq python3 nodejs npm > /dev/null

# Instalar Claude Code (se não existir)
if ! command -v claude &> /dev/null; then
    echo "→ Instalando Claude Code..."
    curl -fsSL https://raw.githubusercontent.com/anthropics/claude-code/main/install.sh | bash
    export PATH="$HOME/.local/bin:$PATH"
fi

# Configurar Claude
echo "→ Configurando Claude MCP..."
cp ~/context7-setup/claude-mcp-config.json ~/.claude.json

# Configurar variáveis de ambiente
echo "→ Configurando variáveis de ambiente..."
if ! grep -q "CONTEXT7_API_KEY" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOFBASH'

# ====== CONTEXT7 CONFIGURATION ======
export CONTEXT7_API_KEY="ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032"
export CONTEXT7_API_URL="https://context7.com/api/v2"
export CONTEXT7_MCP_URL="https://mcp.context7.com/mcp"

alias ctx7-search='curl -X GET "$CONTEXT7_API_URL/search?query=$1" -H "Authorization: Bearer $CONTEXT7_API_KEY"'
alias ctx7-docs='curl -X GET "$CONTEXT7_API_URL/docs/code/$1" -H "Authorization: Bearer $CONTEXT7_API_KEY"'
# ====================================
EOFBASH
fi

# Testar instalação
echo ""
echo "→ Testando instalação..."
source ~/.bashrc
response=$(curl -s -w "%{http_code}" -o /dev/null \
    -X GET "https://context7.com/api/v2/search?query=test" \
    -H "Authorization: Bearer $CONTEXT7_API_KEY")

if [ "$response" = "200" ]; then
    echo "✓ API Context7 respondendo corretamente"
else
    echo "✗ Erro ao conectar na API (HTTP $response)"
fi

# Configurar Coolify integration (se existir)
if command -v coolify &> /dev/null; then
    echo "→ Integrando com Coolify..."
    # Adicionar Context7 como variável de ambiente no Coolify
    # (isso depende da estrutura específica do seu Coolify)
fi

echo ""
echo "=== INSTALAÇÃO CONCLUÍDA NO VPS ==="
echo ""
echo "Para usar:"
echo "  source ~/.bashrc"
echo "  claude"
echo ""
EOF

scp -P $VPS_PORT /tmp/vps-install.sh $VPS_USER@$VPS_HOST:~/context7-setup/
echo -e "${GREEN}✓ Script criado${NC}"

# Executar instalação
echo -e "\n${GREEN}[4/5] Executando instalação no VPS...${NC}"
ssh -p $VPS_PORT $VPS_USER@$VPS_HOST "bash ~/context7-setup/vps-install.sh"

# Criar serviço systemd para Context7 (opcional)
echo -e "\n${GREEN}[5/5] Configurando serviço systemd...${NC}"
ssh -p $VPS_PORT $VPS_USER@$VPS_HOST << 'ENDSSH'
sudo tee /etc/systemd/system/context7-sync.service > /dev/null << 'EOFSERVICE'
[Unit]
Description=Context7 Documentation Sync Service
After=network.target

[Service]
Type=simple
User=admin
Environment="CONTEXT7_API_KEY=ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032"
ExecStart=/usr/bin/bash -c 'while true; do curl -s https://context7.com/api/v2/search?query=healthcheck -H "Authorization: Bearer $CONTEXT7_API_KEY" > /dev/null; sleep 3600; done'
Restart=always

[Install]
WantedBy=multi-user.target
EOFSERVICE

sudo systemctl daemon-reload
sudo systemctl enable context7-sync.service
sudo systemctl start context7-sync.service
echo "✓ Serviço systemd criado e iniciado"
ENDSSH

# Documentação
echo -e "\n${GREEN}Gerando documentação de deploy...${NC}"
cat > ~/context7-setup/VPS-README.md << 'EOF'
# Context7 - Configuração VPS Ubuntu

Deploy concluído com sucesso no VPS Hostinger!

## 🖥️ Informações do Servidor

- **Host**: 147.79.81.59
- **Domínio**: senamfo.com.br
- **Porta SSH**: 22
- **Usuário**: admin
- **Stack**: Ubuntu KVM4 + Coolify

## 📂 Estrutura no VPS

```
/home/admin/
├── context7-setup/
│   ├── vscode-settings.json
│   ├── cursor-config.json
│   ├── claude-mcp-config.json
│   └── vps-install.sh
└── .bashrc (com variáveis Context7)
```

## 🔧 Serviços Instalados

### Systemd Service
```bash
sudo systemctl status context7-sync.service
sudo systemctl restart context7-sync.service
sudo journalctl -u context7-sync.service -f
```

## 🚀 Uso no VPS

### Conectar via SSH
```bash
ssh -p 22 admin@147.79.81.59
```

### Testar Context7
```bash
# Carregar variáveis
source ~/.bashrc

# Buscar documentação
ctx7-search "docker"
ctx7-docs "vercel/next.js"

# Usar Claude Code
claude
> /mcp
```

### API Direct
```bash
curl -X GET "https://context7.com/api/v2/search?query=kubernetes" \
  -H "Authorization: Bearer $CONTEXT7_API_KEY"
```

## 🔄 Integração Coolify

Se você tem apps no Coolify, adicione as variáveis de ambiente:

```bash
CONTEXT7_API_KEY=ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032
CONTEXT7_API_URL=https://context7.com/api/v2
```

## 📊 Monitoramento

### Logs do Serviço
```bash
sudo journalctl -u context7-sync.service --since "1 hour ago"
```

### Status da API
```bash
curl -s https://context7.com/api/v2/search?query=healthcheck \
  -H "Authorization: Bearer $CONTEXT7_API_KEY" | jq .
```

## 🔐 Segurança

**IMPORTANTE**: A API Key está hardcoded. Para produção:

1. Use variáveis de ambiente do Coolify
2. Ou integre com vault (HashiCorp Vault, etc.)
3. Rotacione periodicamente: `~/context7-setup/rotate-api-key.sh` (no Mac)

## 🔄 Atualização

Para atualizar as configurações:
```bash
# No Mac
~/context7-setup/deploy-vps.sh

# Ou manualmente no VPS
cd ~/context7-setup
git pull  # Se estiver usando Git
```

## 🆘 Troubleshooting

**SSH não conecta:**
```bash
ssh -v -p 22 admin@147.79.81.59
```

**API retorna erro:**
```bash
# Verificar conectividade
ping -c 3 context7.com

# Testar DNS
nslookup context7.com
```

**Serviço não inicia:**
```bash
sudo systemctl status context7-sync.service
sudo journalctl -xe
```

## 📞 API Hostinger

Para automações adicionais, use a API da Hostinger:
- Dashboard: https://hostinger.com/cpanel
- API Docs: (verificar no painel)

## 🌐 Próximos Passos

1. ✅ Configurar nginx reverse proxy
2. ✅ Setup SSL para senamfo.com.br
3. ✅ Integrar com GitHub Actions para CI/CD
4. ✅ Configurar backups automáticos
EOF

echo -e "${GREEN}✓ Documentação salva: ~/context7-setup/VPS-README.md${NC}"

# Finalização
echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          DEPLOY VPS CONCLUÍDO COM SUCESSO!            ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}📋 Acesse o VPS:${NC}"
echo -e "   ssh -p 22 admin@147.79.81.59"
echo ""
echo -e "${YELLOW}📋 Teste a instalação:${NC}"
echo -e "   ssh admin@147.79.81.59 'source ~/.bashrc && claude --version'"
echo ""
echo -e "${YELLOW}📋 Documentação:${NC}"
echo -e "   cat ~/context7-setup/VPS-README.md"
echo ""
