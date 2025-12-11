#!/bin/bash
# =============================================================================
# DEVCONTAINER SETUP SCRIPT - MCP CENTRAL
# Executa automaticamente após criação do container
# =============================================================================

set -e

echo "╔══════════════════════════════════════════════════════════╗"
echo "║       MCP Central DevContainer Setup                    ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# ==========================
# 1. ENVIRONMENT VALIDATION
# ==========================
echo "📋 [1/8] Validando ambiente..."

if [ ! -f "$HOME/.ssh/id_ed25519" ] && [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "⚠️  SSH keys não encontradas - configure antes de usar Git"
fi

# ==========================
# 2. GIT CONFIGURATION
# ==========================
echo "🔧 [2/8] Configurando Git..."

if [ -z "$(git config --global user.name)" ]; then
    git config --global user.name "Luiz Fernando Moreira Sena"
fi

if [ -z "$(git config --global user.email)" ]; then
    git config --global user.email "luizfernandomoreirasena@gmail.com"
fi

git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.editor "code --wait"
git config --global credential.helper store

echo "✅ Git configurado"

# ==========================
# 3. SUBMODULE INITIALIZATION
# ==========================
echo "📦 [3/8] Inicializando submodules..."

if [ -f ".gitmodules" ]; then
    git submodule update --init --recursive
    echo "✅ Submodules inicializados"
else
    echo "⚠️  Nenhum submodule encontrado"
fi

# ==========================
# 4. CONTEXT7 PACKAGE SETUP
# ==========================
echo "🔨 [4/8] Configurando packages Context7..."

if [ -d "packages/context7" ]; then
    cd packages/context7

    if [ -f "package.json" ]; then
        echo "   Installing dependencies..."
        pnpm install --frozen-lockfile || pnpm install

        echo "   Building packages..."
        pnpm build || echo "⚠️  Build failed - dependencies may be missing"
    fi

    cd ../..
    echo "✅ Context7 packages configurados"
else
    echo "⚠️  Diretório packages/context7 não encontrado"
fi

# ==========================
# 5. INSTALL GLOBAL TOOLS
# ==========================
echo "🛠️  [5/8] Instalando ferramentas globais..."

npm install -g \
    typescript \
    ts-node \
    tsx \
    @changesets/cli \
    vitest \
    prettier \
    eslint \
    2>/dev/null || echo "⚠️  Algumas ferramentas podem ter falhas"

echo "✅ Ferramentas instaladas"

# ==========================
# 6. ENVIRONMENT FILES
# ==========================
echo "🔐 [6/8] Configurando variáveis de ambiente..."

if [ ! -f ".env" ]; then
    cat > .env << 'EOF'
# Context7 Configuration
CONTEXT7_API_KEY=ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032
CONTEXT7_MCP_URL=https://mcp.context7.com/mcp
CONTEXT7_API_URL=https://context7.com/api/v2

# GitHub Configuration
GITHUB_USERNAME=senal88
GITHUB_EMAIL=luizfernandomoreirasena@gmail.com

# VPS Configuration
VPS_HOST=147.79.81.59
VPS_USER=admin
VPS_DOMAIN=senamfo.com.br

# Node Environment
NODE_ENV=development
EOF
    echo "✅ Arquivo .env criado"
else
    echo "✅ Arquivo .env já existe"
fi

# ==========================
# 7. WORKSPACE VALIDATION
# ==========================
echo "🔍 [7/8] Validando workspace..."

ERRORS=0

# Check critical directories
for dir in "packages" "prompts" "templates"; do
    if [ ! -d "$dir" ]; then
        echo "   ⚠️  Diretório '$dir' não encontrado"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check critical files
for file in "data-structure.json" "MASTER-INSTALL.sh"; do
    if [ ! -f "$file" ]; then
        echo "   ⚠️  Arquivo '$file' não encontrado"
        ERRORS=$((ERRORS + 1))
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo "✅ Workspace válido"
else
    echo "⚠️  Workspace com $ERRORS problemas"
fi

# ==========================
# 8. WELCOME MESSAGE
# ==========================
echo "🎉 [8/8] Setup concluído!"
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║           🚀 MCP Central está pronto!                   ║"
echo "╠══════════════════════════════════════════════════════════╣"
echo "║                                                          ║"
echo "║  📦 Context7 packages:  packages/context7/              ║"
echo "║  🎯 Prompts modulares:  prompts/                        ║"
echo "║  📝 Templates:          templates/                      ║"
echo "║  🔧 Scripts:            module-*.sh                     ║"
echo "║                                                          ║"
echo "║  COMANDOS ÚTEIS:                                        ║"
echo "║  • source load-secrets.sh    - Carregar secrets        ║"
echo "║  • ./MASTER-INSTALL.sh       - Instalação completa     ║"
echo "║  • cd packages/context7      - Acessar Context7        ║"
echo "║  • pnpm build                - Build packages          ║"
echo "║  • pnpm test                 - Executar testes         ║"
echo "║                                                          ║"
echo "║  📚 Documentação:                                       ║"
echo "║  • EXECUTION-GUIDE-COMPLETE.md                         ║"
echo "║  • DEPLOYMENT-FINAL-REPORT.md                          ║"
echo "║  • README.md                                            ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Create welcome script in user's home
cat > $HOME/.welcome.sh << 'WELCOME'
#!/bin/bash
echo ""
echo "🎯 MCP Central Development Environment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 Workspace: /workspaces/mcp-central"
echo "🔧 Node: $(node --version)"
echo "📦 pnpm: $(pnpm --version)"
echo ""
WELCOME

chmod +x $HOME/.welcome.sh

# Add to .zshrc if exists
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q ".welcome.sh" "$HOME/.zshrc"; then
        echo "" >> $HOME/.zshrc
        echo "# MCP Central Welcome" >> $HOME/.zshrc
        echo "[[ -f \$HOME/.welcome.sh ]] && source \$HOME/.welcome.sh" >> $HOME/.zshrc
    fi
fi

echo "✨ DevContainer pronto para uso!"
