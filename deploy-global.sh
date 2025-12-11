#!/bin/bash

# Context7 Setup - Instalação Automatizada Completa
# Este script configura o Context7 MCP em todas as IDEs e ferramentas

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   CONTEXT7 - INSTALAÇÃO AUTOMATIZADA GLOBAL          ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"

# Diretório de configurações
SETUP_DIR="$HOME/context7-setup"
CONFIG_BACKUP_DIR="$HOME/context7-setup/backups-$(date +%Y%m%d-%H%M%S)"

# Criar diretório de backup
mkdir -p "$CONFIG_BACKUP_DIR"

# Função para backup seguro
backup_config() {
    local file=$1
    if [ -f "$file" ]; then
        echo -e "${YELLOW}→ Backup: $file${NC}"
        cp "$file" "$CONFIG_BACKUP_DIR/$(basename $file).bak"
    fi
}

# Função para verificar e criar diretório
ensure_dir() {
    local dir=$1
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo -e "${GREEN}✓ Criado: $dir${NC}"
    fi
}

# 1. CONFIGURAÇÃO VS CODE
echo -e "\n${GREEN}[1/7] Configurando VS Code...${NC}"
VSCODE_CONFIG="$HOME/Library/Application Support/Code/User/settings.json"
VSCODE_DIR="$(dirname "$VSCODE_CONFIG")"
ensure_dir "$VSCODE_DIR"
backup_config "$VSCODE_CONFIG"

# Merge com configurações existentes
if [ -f "$VSCODE_CONFIG" ]; then
    # Adicionar config MCP ao settings existente
    python3 -c "
import json
import sys

try:
    with open('$VSCODE_CONFIG', 'r') as f:
        settings = json.load(f)
except:
    settings = {}

# Adicionar configuração Context7
settings['mcp'] = {
    'servers': {
        'context7': {
            'type': 'http',
            'url': 'https://mcp.context7.com/mcp',
            'headers': {
                'CONTEXT7_API_KEY': 'ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032'
            }
        }
    }
}

with open('$VSCODE_CONFIG', 'w') as f:
    json.dump(settings, f, indent=2)

print('✓ VS Code configurado')
" || echo -e "${RED}✗ Erro ao configurar VS Code${NC}"
else
    cp "$SETUP_DIR/vscode-settings.json" "$VSCODE_CONFIG"
    echo -e "${GREEN}✓ VS Code configurado (novo arquivo)${NC}"
fi

# 2. CONFIGURAÇÃO CURSOR
echo -e "\n${GREEN}[2/7] Configurando Cursor...${NC}"
CURSOR_CONFIG="$HOME/.config/cursor/config.json"
ensure_dir "$(dirname "$CURSOR_CONFIG")"
backup_config "$CURSOR_CONFIG"
cp "$SETUP_DIR/cursor-config.json" "$CURSOR_CONFIG"
echo -e "${GREEN}✓ Cursor configurado${NC}"

# 3. CONFIGURAÇÃO CLAUDE CODE
echo -e "\n${GREEN}[3/7] Configurando Claude Code...${NC}"
CLAUDE_CONFIG="$HOME/.claude.json"
backup_config "$CLAUDE_CONFIG"

# Merge com config existente do Claude
if [ -f "$CLAUDE_CONFIG" ]; then
    python3 -c "
import json

try:
    with open('$CLAUDE_CONFIG', 'r') as f:
        config = json.load(f)
except:
    config = {}

# Adicionar servidor Context7
if 'mcp' not in config:
    config['mcp'] = {'servers': {}}
elif 'servers' not in config['mcp']:
    config['mcp']['servers'] = {}

config['mcp']['servers']['context7'] = {
    'command': 'npx',
    'args': ['-y', '@upstash/context7-mcp'],
    'env': {
        'CONTEXT7_API_KEY': 'ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032'
    }
}

with open('$CLAUDE_CONFIG', 'w') as f:
    json.dump(config, f, indent=2)

print('✓ Claude Code configurado')
" || echo -e "${RED}✗ Erro ao configurar Claude Code${NC}"
else
    cp "$SETUP_DIR/claude-mcp-config.json" "$CLAUDE_CONFIG"
    echo -e "${GREEN}✓ Claude Code configurado (novo arquivo)${NC}"
fi

# 4. CONFIGURAÇÃO GEMINI CLI (se instalado)
echo -e "\n${GREEN}[4/7] Configurando Gemini CLI...${NC}"
if command -v gemini &> /dev/null; then
    GEMINI_CONFIG="$HOME/.gemini/config.json"
    ensure_dir "$(dirname "$GEMINI_CONFIG")"
    backup_config "$GEMINI_CONFIG"
    cp "$SETUP_DIR/gemini-cli-config.json" "$GEMINI_CONFIG"
    echo -e "${GREEN}✓ Gemini CLI configurado${NC}"
else
    echo -e "${YELLOW}⚠ Gemini CLI não encontrado - pulando${NC}"
fi

# 5. VARIÁVEIS DE AMBIENTE
echo -e "\n${GREEN}[5/7] Configurando variáveis de ambiente...${NC}"
ZSHRC="$HOME/.zshrc"
backup_config "$ZSHRC"

# Adicionar ao .zshrc se não existir
if ! grep -q "CONTEXT7_API_KEY" "$ZSHRC" 2>/dev/null; then
    cat >> "$ZSHRC" << 'EOF'

# ====== CONTEXT7 CONFIGURATION ======
export CONTEXT7_API_KEY="ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032"
export CONTEXT7_API_URL="https://context7.com/api/v2"
export CONTEXT7_MCP_URL="https://mcp.context7.com/mcp"

# Context7 aliases
alias ctx7-search='curl -X GET "$CONTEXT7_API_URL/search?query=$1" -H "Authorization: Bearer $CONTEXT7_API_KEY"'
alias ctx7-docs='curl -X GET "$CONTEXT7_API_URL/docs/code/$1" -H "Authorization: Bearer $CONTEXT7_API_KEY"'
alias claude-ctx7='cat $1 | claude --mcp-server context7'
# ====================================
EOF
    echo -e "${GREEN}✓ Variáveis adicionadas ao .zshrc${NC}"
else
    echo -e "${YELLOW}⚠ Variáveis já existem no .zshrc${NC}"
fi

# 6. CRIAR SCRIPT DE TESTE
echo -e "\n${GREEN}[6/7] Criando script de validação...${NC}"
cat > "$HOME/context7-setup/test-integration.sh" << 'EOF'
#!/bin/bash

echo "=== TESTE DE INTEGRAÇÃO CONTEXT7 ==="
echo ""

# Teste 1: API Key
echo "1. Testando API..."
response=$(curl -s -w "\n%{http_code}" -X GET "https://context7.com/api/v2/search?query=react" \
  -H "Authorization: Bearer ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032")
http_code=$(echo "$response" | tail -n 1)

if [ "$http_code" = "200" ]; then
    echo "✓ API respondendo corretamente"
else
    echo "✗ Erro na API (HTTP $http_code)"
fi

# Teste 2: Claude MCP
echo ""
echo "2. Verificando Claude MCP..."
if [ -f "$HOME/.claude.json" ]; then
    if grep -q "context7" "$HOME/.claude.json"; then
        echo "✓ Claude MCP configurado"
    else
        echo "✗ Context7 não encontrado no Claude"
    fi
else
    echo "✗ Arquivo .claude.json não encontrado"
fi

# Teste 3: VS Code
echo ""
echo "3. Verificando VS Code..."
VSCODE_CONFIG="$HOME/Library/Application Support/Code/User/settings.json"
if [ -f "$VSCODE_CONFIG" ]; then
    if grep -q "context7" "$VSCODE_CONFIG"; then
        echo "✓ VS Code configurado"
    else
        echo "✗ Context7 não encontrado no VS Code"
    fi
else
    echo "✗ VS Code settings não encontrado"
fi

# Teste 4: Cursor
echo ""
echo "4. Verificando Cursor..."
if [ -f "$HOME/.config/cursor/config.json" ]; then
    if grep -q "context7" "$HOME/.config/cursor/config.json"; then
        echo "✓ Cursor configurado"
    else
        echo "✗ Context7 não encontrado no Cursor"
    fi
else
    echo "✗ Cursor config não encontrado"
fi

# Teste 5: Variáveis de ambiente
echo ""
echo "5. Verificando variáveis de ambiente..."
source "$HOME/.zshrc"
if [ ! -z "$CONTEXT7_API_KEY" ]; then
    echo "✓ CONTEXT7_API_KEY definida"
else
    echo "✗ CONTEXT7_API_KEY não encontrada"
fi

echo ""
echo "=== FIM DOS TESTES ==="
EOF

chmod +x "$HOME/context7-setup/test-integration.sh"
echo -e "${GREEN}✓ Script de teste criado: ~/context7-setup/test-integration.sh${NC}"

# 7. DOCUMENTAÇÃO
echo -e "\n${GREEN}[7/7] Gerando documentação...${NC}"
cat > "$HOME/context7-setup/README.md" << 'EOF'
# Context7 - Configuração Global

Instalação automatizada concluída com sucesso!

## 📁 Estrutura de Arquivos

```
~/context7-setup/
├── vscode-settings.json      → Configuração VS Code
├── cursor-config.json         → Configuração Cursor
├── claude-mcp-config.json     → Configuração Claude Code
├── gemini-cli-config.json     → Configuração Gemini CLI
├── codex-config.toml          → Configuração Codex
├── test-integration.sh        → Script de validação
├── deploy-global.sh           → Este script
└── backups-*/                 → Backups das configs anteriores
```

## 🔧 Ferramentas Configuradas

- ✅ VS Code (MCP Server)
- ✅ Cursor IDE
- ✅ Claude Code CLI
- ✅ Variáveis de ambiente (.zshrc)
- ⚙️  Gemini CLI (se instalado)

## 🚀 Como Usar

### No VS Code
1. Reinicie o VS Code
2. A integração Context7 estará ativa automaticamente
3. Use Ctrl+Shift+P → "MCP: Connect to Context7"

### No Cursor
1. Reinicie o Cursor
2. As sugestões contextuais estarão ativas

### No Claude Code
```bash
# No terminal
claude

# No prompt do Claude
> /mcp
# Você verá context7 na lista de servidores
```

### Linha de Comando
```bash
# Buscar documentação
ctx7-search "next.js"

# Obter código específico
ctx7-docs "vercel/next.js"

# Usar Claude com Context7
claude-ctx7 meu-arquivo.txt
```

## 🧪 Validação

Execute o script de teste:
```bash
~/context7-setup/test-integration.sh
```

## 🔑 API Key

A chave está configurada em:
- Variáveis de ambiente: `$CONTEXT7_API_KEY`
- Configs de IDE: embutida nos arquivos JSON
- 1Password: Vault `1p_macos` (recomendado para rotação)

## 🌐 Endpoints

- **API**: https://context7.com/api/v2
- **MCP**: https://mcp.context7.com/mcp
- **Dashboard**: https://context7.com/dashboard

## 📊 Próximos Passos

1. ✅ Testar integração: `~/context7-setup/test-integration.sh`
2. 📦 Deploy no VPS: `ssh admin@147.79.81.59` e executar script
3. 🔄 Sync GitHub: Push configs para `senal88/context7`
4. 🤖 Integrar com Hugging Face Pro para datasets

## 🆘 Troubleshooting

**Claude MCP não conecta:**
```bash
claude --debug
# Verifique logs em: ~/Library/Caches/claude-cli-nodejs/
```

**VS Code não reconhece MCP:**
- Verifique extensão MCP instalada
- Reinicie completamente o VS Code

**API retorna 401:**
- Verifique se a API key está correta
- Teste: `curl -H "Authorization: Bearer $CONTEXT7_API_KEY" https://context7.com/api/v2/search?query=test`

## 📞 Recursos

- Docs: https://context7.com/docs
- GitHub: https://github.com/senal88/context7
- Status: https://context7.com/tasklist
EOF

echo -e "${GREEN}✓ Documentação gerada: ~/context7-setup/README.md${NC}"

# FINALIZAÇÃO
echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║            INSTALAÇÃO CONCLUÍDA COM SUCESSO!          ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}📋 Próximas ações recomendadas:${NC}"
echo ""
echo -e "1. ${GREEN}Recarregue o terminal:${NC}"
echo -e "   source ~/.zshrc"
echo ""
echo -e "2. ${GREEN}Execute os testes:${NC}"
echo -e "   ~/context7-setup/test-integration.sh"
echo ""
echo -e "3. ${GREEN}Reinicie suas IDEs:${NC}"
echo -e "   - VS Code"
echo -e "   - Cursor"
echo ""
echo -e "4. ${GREEN}Teste o Claude Code:${NC}"
echo -e "   claude"
echo -e "   > /mcp"
echo ""
echo -e "5. ${GREEN}Leia a documentação:${NC}"
echo -e "   cat ~/context7-setup/README.md"
echo ""
echo -e "${GREEN}✨ Backups salvos em:${NC} $CONFIG_BACKUP_DIR"
echo ""
