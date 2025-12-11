#!/bin/bash

# Script para integração com 1Password e gestão segura de secrets

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║        CONTEXT7 - INTEGRAÇÃO 1PASSWORD                ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"

# Verificar se op CLI está instalado
if ! command -v op &> /dev/null; then
    echo -e "${RED}✗ 1Password CLI não encontrado!${NC}"
    echo "Instale com: brew install --cask 1password-cli"
    exit 1
fi

# Verificar autenticação
if ! op account list &> /dev/null; then
    echo -e "${YELLOW}⚠ Não autenticado no 1Password${NC}"
    echo "Execute: eval \$(op signin)"
    exit 1
fi

echo -e "${GREEN}✓ 1Password CLI autenticado${NC}\n"

# Função para criar item no 1Password
create_context7_item() {
    local vault=$1
    local item_name="Context7_MCP"

    echo -e "${YELLOW}→ Criando item no vault: $vault${NC}"

    # Verificar se item já existe
    if op item get "$item_name" --vault "$vault" &> /dev/null; then
        echo -e "${YELLOW}⚠ Item já existe. Deseja atualizar? (s/n)${NC}"
        read -r response
        if [[ "$response" != "s" ]]; then
            return
        fi

        # Atualizar item existente
        op item edit "$item_name" --vault "$vault" \
            "CONTEXT7_API_KEY[password]=ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032" \
            "CONTEXT7_API_URL[text]=https://context7.com/api/v2" \
            "CONTEXT7_MCP_URL[text]=https://mcp.context7.com/mcp" \
            "CONTEXT7_DASHBOARD[text]=https://context7.com/dashboard"

        echo -e "${GREEN}✓ Item atualizado em $vault${NC}"
    else
        # Criar novo item
        op item create \
            --category=password \
            --vault="$vault" \
            --title="$item_name" \
            "CONTEXT7_API_KEY[password]=ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032" \
            "CONTEXT7_API_URL[text]=https://context7.com/api/v2" \
            "CONTEXT7_MCP_URL[text]=https://mcp.context7.com/mcp" \
            "CONTEXT7_DASHBOARD[text]=https://context7.com/dashboard" \
            "notes=Configuração MCP para Context7 - IDEs e CLIs"

        echo -e "${GREEN}✓ Item criado em $vault${NC}"
    fi
}

# Menu interativo
echo "Selecione o vault para armazenar as credenciais Context7:"
echo ""
echo "1) 1p_macos (recomendado para uso local)"
echo "2) 1p_azure (para integrações cloud)"
echo "3) 1p_vps (para uso no servidor)"
echo "4) Personal"
echo "5) Todos os vaults"
echo ""
read -p "Escolha (1-5): " choice

case $choice in
    1)
        create_context7_item "1p_macos"
        ;;
    2)
        create_context7_item "1p_azure"
        ;;
    3)
        create_context7_item "1p_vps"
        ;;
    4)
        create_context7_item "Personal"
        ;;
    5)
        create_context7_item "1p_macos"
        create_context7_item "1p_azure"
        create_context7_item "1p_vps"
        create_context7_item "Personal"
        ;;
    *)
        echo -e "${RED}Opção inválida${NC}"
        exit 1
        ;;
esac

# Criar script de recuperação segura
echo -e "\n${GREEN}Gerando script de recuperação...${NC}"

cat > "$HOME/context7-setup/load-from-1password.sh" << 'EOF'
#!/bin/bash

# Script para carregar Context7 API Key do 1Password

VAULT="${1:-1p_macos}"
ITEM="Context7_MCP"

# Verificar autenticação
if ! op account list &> /dev/null; then
    echo "Erro: Não autenticado no 1Password"
    echo "Execute: eval $(op signin)"
    exit 1
fi

# Recuperar API Key
API_KEY=$(op item get "$ITEM" --vault "$VAULT" --fields label=CONTEXT7_API_KEY 2>/dev/null)

if [ -z "$API_KEY" ]; then
    echo "Erro: Não foi possível recuperar a API Key"
    exit 1
fi

# Exportar variáveis
export CONTEXT7_API_KEY="$API_KEY"
export CONTEXT7_API_URL="https://context7.com/api/v2"
export CONTEXT7_MCP_URL="https://mcp.context7.com/mcp"

echo "✓ Credenciais Context7 carregadas do 1Password"
echo "  Vault: $VAULT"
echo "  API Key: ${API_KEY:0:10}..."

# Testar conexão
echo ""
echo "Testando conexão..."
response=$(curl -s -w "%{http_code}" -o /dev/null \
    -X GET "https://context7.com/api/v2/search?query=test" \
    -H "Authorization: Bearer $CONTEXT7_API_KEY")

if [ "$response" = "200" ]; then
    echo "✓ API respondendo corretamente"
else
    echo "✗ Erro na conexão (HTTP $response)"
fi
EOF

chmod +x "$HOME/context7-setup/load-from-1password.sh"
echo -e "${GREEN}✓ Script criado: ~/context7-setup/load-from-1password.sh${NC}"

# Atualizar .zshrc para usar 1Password
echo -e "\n${GREEN}Atualizando .zshrc para carregar do 1Password...${NC}"

if ! grep -q "load-from-1password.sh" "$HOME/.zshrc" 2>/dev/null; then
    cat >> "$HOME/.zshrc" << 'EOF'

# ====== CONTEXT7 - 1PASSWORD INTEGRATION ======
# Carregar credenciais do 1Password ao iniciar shell
if command -v op &> /dev/null; then
    if [ -f "$HOME/context7-setup/load-from-1password.sh" ]; then
        source <(bash "$HOME/context7-setup/load-from-1password.sh" 1p_macos 2>/dev/null || echo "")
    fi
fi
# ==============================================
EOF
    echo -e "${GREEN}✓ .zshrc atualizado${NC}"
else
    echo -e "${YELLOW}⚠ .zshrc já contém integração 1Password${NC}"
fi

# Criar função helper para rotação de chaves
cat > "$HOME/context7-setup/rotate-api-key.sh" << 'EOF'
#!/bin/bash

# Script para rotacionar API Key do Context7

set -e

echo "=== ROTAÇÃO DE API KEY CONTEXT7 ==="
echo ""
echo "Este script irá:"
echo "1. Atualizar a chave no 1Password"
echo "2. Atualizar todas as configurações locais"
echo "3. Testar a nova chave"
echo ""

read -p "Digite a NOVA API Key: " new_key

if [ -z "$new_key" ]; then
    echo "Erro: API Key não pode ser vazia"
    exit 1
fi

# Atualizar 1Password
echo ""
echo "Atualizando 1Password..."
for vault in "1p_macos" "1p_azure" "1p_vps" "Personal"; do
    if op item get "Context7_MCP" --vault "$vault" &> /dev/null; then
        op item edit "Context7_MCP" --vault "$vault" \
            "CONTEXT7_API_KEY[password]=$new_key"
        echo "✓ Atualizado: $vault"
    fi
done

# Atualizar configurações locais
echo ""
echo "Atualizando configurações locais..."

# VS Code
VSCODE_CONFIG="$HOME/Library/Application Support/Code/User/settings.json"
if [ -f "$VSCODE_CONFIG" ]; then
    sed -i '' "s/ctx7sk-[^\"]*/$new_key/g" "$VSCODE_CONFIG"
    echo "✓ VS Code atualizado"
fi

# Cursor
CURSOR_CONFIG="$HOME/.config/cursor/config.json"
if [ -f "$CURSOR_CONFIG" ]; then
    sed -i '' "s/ctx7sk-[^\"]*/$new_key/g" "$CURSOR_CONFIG"
    echo "✓ Cursor atualizado"
fi

# Claude
CLAUDE_CONFIG="$HOME/.claude.json"
if [ -f "$CLAUDE_CONFIG" ]; then
    sed -i '' "s/ctx7sk-[^\"]*/$new_key/g" "$CLAUDE_CONFIG"
    echo "✓ Claude Code atualizado"
fi

# .zshrc
if grep -q "CONTEXT7_API_KEY=" "$HOME/.zshrc"; then
    sed -i '' "s/ctx7sk-[^\"]*/$(echo $new_key | sed 's/[\/&]/\\&/g')/g" "$HOME/.zshrc"
    echo "✓ .zshrc atualizado"
fi

# Testar nova chave
echo ""
echo "Testando nova API Key..."
response=$(curl -s -w "%{http_code}" -o /dev/null \
    -X GET "https://context7.com/api/v2/search?query=test" \
    -H "Authorization: Bearer $new_key")

if [ "$response" = "200" ]; then
    echo "✓ Nova API Key funcionando corretamente!"
    echo ""
    echo "Rotação concluída com sucesso!"
    echo "Reinicie suas IDEs para aplicar as mudanças."
else
    echo "✗ Erro ao testar nova chave (HTTP $response)"
    echo "Verifique se a chave está correta"
    exit 1
fi
EOF

chmod +x "$HOME/context7-setup/rotate-api-key.sh"
echo -e "${GREEN}✓ Script de rotação criado: ~/context7-setup/rotate-api-key.sh${NC}"

# Resumo
echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     INTEGRAÇÃO 1PASSWORD CONCLUÍDA!                  ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}📋 Recursos disponíveis:${NC}"
echo ""
echo -e "1. ${GREEN}Carregar credenciais do 1Password:${NC}"
echo -e "   source ~/context7-setup/load-from-1password.sh [vault]"
echo ""
echo -e "2. ${GREEN}Rotacionar API Key:${NC}"
echo -e "   ~/context7-setup/rotate-api-key.sh"
echo ""
echo -e "3. ${GREEN}Verificar item no 1Password:${NC}"
echo -e "   op item get Context7_MCP --vault 1p_macos"
echo ""
echo -e "${GREEN}✨ Suas credenciais estão seguras no 1Password!${NC}"
echo ""
