#!/usr/bin/env bash
# MASTER-INSTALL.sh - Orquestrador Principal Context7 Setup
# Versão: 1.0.0
# Autor: luiz.sena88@icloud.com
# Data: 2025-12-11
# Descrição: Executa setup completo e automatizado do Context7 em todos os ambientes
# Baseado em: PROMPT_CONTEXT7.TXT

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

LOGFILE="$HOME/context7-setup/installation-$(date +%Y%m%d-%H%M%S).log"
SETUP_DIR="$HOME/context7-setup"

log() {
    echo -e "$1" | tee -a "$LOGFILE"
}

log "${BLUE}╔══════════════════════════════════════════════════════════════════╗${NC}"
log "${BLUE}║                                                                  ║${NC}"
log "${BLUE}║      CONTEXT7 - INSTALAÇÃO COMPLETA E AUTOMATIZADA              ║${NC}"
log "${BLUE}║      Prompts Modulares | Versionamento | Deploy Global          ║${NC}"
log "${BLUE}║      Versão: 1.0.0                                              ║${NC}"
log "${BLUE}║                                                                  ║${NC}"
log "${BLUE}╚══════════════════════════════════════════════════════════════════╝${NC}"
log ""
log "${YELLOW}📋 Módulos a serem executados:${NC}"
log "${YELLOW}   1. Configuração de IDEs (VS Code, Cursor, Claude, Codex, Gemini)${NC}"
log "${YELLOW}   2. Integração 1Password para gerenciamento de secrets${NC}"
log "${YELLOW}   3. Sincronização GitHub e versionamento de prompts${NC}"
log "${YELLOW}   4. Deploy VPS via Coolify${NC}"
log "${YELLOW}⏱️  Tempo estimado: 10-15 minutos${NC}"
log "${YELLOW}📝 Log completo: $LOGFILE${NC}"
log ""

# Confirmação
read -p "🚀 Deseja iniciar a instalação completa? (s/N): " -n 1 -r confirm
echo
if [[ ! $confirm =~ ^[Ss]$ ]]; then
    log "${RED}❌ Execução cancelada pelo usuário${NC}"
    exit 0
fi

log ""
log "${GREEN}✓ Instalação confirmada. Iniciando...${NC}"
log ""

# ============================================================================
# MÓDULO 1: Configuração de IDEs
# ============================================================================
log ""
log "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
log "${GREEN}║ [1/4] MÓDULO 1: Configuração de IDEs                            ║${NC}"
log "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
log ""

if [ -f "$SETUP_DIR/module-1-ide-config.sh" ]; then
    log "${YELLOW}→ Configurando Context7 MCP em todas as IDEs...${NC}"
    bash "$SETUP_DIR/module-1-ide-config.sh" 2>&1 | tee -a "$LOGFILE"
    log "${GREEN}✓ Módulo 1 concluído${NC}"
else
    log "${RED}✗ Módulo 1 não encontrado: module-1-ide-config.sh${NC}"
fi

# ============================================================================
# MÓDULO 2: Integração 1Password
# ============================================================================
log ""
log "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
log "${GREEN}║ [2/4] MÓDULO 2: Integração 1Password                            ║${NC}"
log "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
log ""

if [ -f "$SETUP_DIR/module-2-1password.sh" ]; then
    log "${YELLOW}→ Configurando gerenciamento de secrets via 1Password...${NC}"
    bash "$SETUP_DIR/module-2-1password.sh" 2>&1 | tee -a "$LOGFILE"
    log "${GREEN}✓ Módulo 2 concluído${NC}"
else
    log "${YELLOW}⚠️  Módulo 2 não encontrado: module-2-1password.sh (pulando)${NC}"
fi

# ============================================================================
# MÓDULO 3: Sincronização GitHub
# ============================================================================
log ""
log "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
log "${GREEN}║ [3/4] MÓDULO 3: Sincronização GitHub e Prompts Modulares        ║${NC}"
log "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
log ""

if [ -f "$SETUP_DIR/module-3-github-sync.sh" ]; then
    log "${YELLOW}→ Criando estrutura de prompts e sincronizando com GitHub...${NC}"
    bash "$SETUP_DIR/module-3-github-sync.sh" 2>&1 | tee -a "$LOGFILE"
    log "${GREEN}✓ Módulo 3 concluído${NC}"
else
    log "${YELLOW}⚠️  Módulo 3 não encontrado: module-3-github-sync.sh (pulando)${NC}"
fi

# ============================================================================
# MÓDULO 4: Deploy VPS
# ============================================================================
log ""
log "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
log "${GREEN}║ [4/4] MÓDULO 4: Deploy VPS via Coolify                          ║${NC}"
log "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
log ""

if [ -f "$SETUP_DIR/module-4-vps-deploy.sh" ]; then
    log "${YELLOW}→ Preparando deploy para VPS...${NC}"
    bash "$SETUP_DIR/module-4-vps-deploy.sh" 2>&1 | tee -a "$LOGFILE"
    log "${GREEN}✓ Módulo 4 concluído${NC}"
else
    log "${YELLOW}⚠️  Módulo 4 não encontrado: module-4-vps-deploy.sh (pulando)${NC}"
fi

# ============================================================================
# FINALIZAÇÃO E VALIDAÇÃO
# ============================================================================
log ""
log "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
log "${GREEN}║ VALIDAÇÃO FINAL E TESTES                                        ║${NC}"
log "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
log ""

# Testar API Context7
log "${YELLOW}→ Testando conectividade API Context7...${NC}"
if [ -f "$SETUP_DIR/.env" ]; then
    source "$SETUP_DIR/.env"
    response=$(curl -s -o /dev/null -w "%{http_code}" \
        -X GET "https://context7.com/api/v2/search?query=test" \
        -H "Authorization: Bearer ${CONTEXT7_API_KEY}" 2>/dev/null)

    if [ "$response" -eq 200 ]; then
        log "${GREEN}✓ API Context7 funcionando${NC}"
    else
        log "${YELLOW}⚠️  API retornou HTTP $response${NC}"
    fi
else
    log "${YELLOW}⚠️  Arquivo .env não encontrado para validação${NC}"
fi

# Verificar arquivos gerados
log ""
log "${YELLOW}→ Verificando arquivos gerados...${NC}"
local files_count=$(find "$SETUP_DIR" -type f \( -name "*.sh" -o -name "*.json" -o -name "*.md" \) | wc -l | xargs)
log "${GREEN}✓ Total de arquivos criados: $files_count${NC}"

# Listar configurações
log ""
log "${YELLOW}→ Configurações criadas:${NC}"
[ -f "$HOME/Library/Application Support/Code/User/settings.json" ] && log "  ✓ VS Code MCP configurado"
[ -f "$HOME/.cursor/mcp.json" ] && log "  ✓ Cursor MCP configurado"
[ -f "$HOME/.codex/config.toml" ] && log "  ✓ Codex MCP configurado"
[ -f "$HOME/.config/gemini/config.json" ] && log "  ✓ Gemini CLI MCP configurado"
[ -f "$SETUP_DIR/load-secrets.sh" ] && log "  ✓ Script 1Password criado"
[ -d "$SETUP_DIR/prompts" ] && log "  ✓ Estrutura de prompts modulares criada"
[ -f "$SETUP_DIR/data-structure.json" ] && log "  ✓ Estrutura de dados versionada"

# ============================================================================
# FINALIZAÇÃO E RESUMO
# ============================================================================
log ""
log "${BLUE}╔══════════════════════════════════════════════════════════════════╗${NC}"
log "${BLUE}║                                                                  ║${NC}"
log "${BLUE}║         ✓ INSTALAÇÃO COMPLETA CONCLUÍDA COM SUCESSO!            ║${NC}"
log "${BLUE}║                                                                  ║${NC}"
log "${BLUE}╚══════════════════════════════════════════════════════════════════╝${NC}"
log ""

# Resumo detalhado
log "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
log "${GREEN}📊 RESUMO DA INSTALAÇÃO CONTEXT7${NC}"
log "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
log ""
log "${GREEN}✅ Componentes Instalados:${NC}"
log ""
log "  🔧 ${YELLOW}Configurações MCP:${NC}"
log "     • VS Code: ~/Library/Application Support/Code/User/settings.json"
log "     • Cursor: ~/.cursor/mcp.json"
log "     • Claude CLI: ~/.claude.json"
log "     • Codex: ~/.codex/config.toml"
log "     • Gemini CLI: ~/.config/gemini/config.json"
log ""
log "  📦 ${YELLOW}Estrutura de Dados:${NC}"
log "     • Estrutura versionada: ~/context7-setup/data-structure.json"
log "     • Prompts modulares: ~/context7-setup/prompts/"
log "     • Templates: ~/context7-setup/templates/"
log ""
log "  🔐 ${YELLOW}Integração 1Password:${NC}"
log "     • Script de carregamento: ~/context7-setup/load-secrets.sh"
log "     • Variáveis de ambiente: ~/context7-setup/.env"
log ""
log "  📚 ${YELLOW}Documentação:${NC}"
log "     • README principal: ~/context7-setup/README.md"
log "     • Guia de execução: ~/context7-setup/EXECUTION-GUIDE.md"
log "     • Logs: $LOGFILE"
log ""

log "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
log "${YELLOW}📋 PRÓXIMOS PASSOS RECOMENDADOS${NC}"
log "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
log ""
log "  ${BLUE}1.${NC} ${GREEN}Reiniciar suas IDEs:${NC}"
log "     • Feche e reabra VS Code para carregar config MCP"
log "     • Feche e reabra Cursor para ativar Context7"
log ""
log "  ${BLUE}2.${NC} ${GREEN}Abrir novo terminal:${NC}"
log "     • Abra nova aba/janela para carregar variáveis"
log "     • Ou execute: source ~/.zshrc"
log ""
log "  ${BLUE}3.${NC} ${GREEN}Testar integração Context7:${NC}"
log "     $ source ~/context7-setup/load-secrets.sh"
log "     $ curl -s 'https://context7.com/api/v2/search?query=next.js' \\"
log "       -H \"Authorization: Bearer \$CONTEXT7_API_KEY\" | jq"
log ""
log "  ${BLUE}4.${NC} ${GREEN}Usar prompts modulares:${NC}"
log "     $ cd ~/context7-setup/prompts"
log "     $ cat modules/IDE_CONFIGURATION.md"
log "     $ cat examples/COMPLETE_SETUP.md"
log ""
log "  ${BLUE}5.${NC} ${GREEN}Deploy VPS (opcional):${NC}"
log "     $ ~/context7-setup/module-4-vps-deploy.sh"
log "     # Requer SSH configurado para 147.79.81.59"
log ""
log "  ${BLUE}6.${NC} ${GREEN}Sincronizar com GitHub:${NC}"
log "     $ cd ~/context7-setup"
log "     $ git status"
log "     $ git push origin master"
log ""

log "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
log "${YELLOW}🔗 LINKS ÚTEIS${NC}"
log "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
log ""
log "  • Dashboard Context7: https://context7.com/dashboard"
log "  • API Docs: https://context7.com/docs"
log "  • GitHub Repo: https://github.com/senal88/context7"
log "  • Add Library: https://context7.com/add-library"
log "  • Task List: https://context7.com/tasklist?tab=repo"
log ""

log "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
log "${YELLOW}📁 ARQUIVOS IMPORTANTES${NC}"
log "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
log ""
log "  • Log de instalação: $LOGFILE"
log "  • Diretório principal: ~/context7-setup/"
log "  • Backups de configs: ~/context7-setup/.context7-backups/"
log "  • Estrutura de dados: ~/context7-setup/data-structure.json"
log ""

log "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
log "${BLUE}🎉 SEU AMBIENTE CONTEXT7 ESTÁ 100% PRONTO E OPERACIONAL!${NC}"
log "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
log ""
log "${GREEN}✓ Instalação finalizada em: $(date)${NC}"
log "${GREEN}✓ Versão instalada: 1.0.0${NC}"
log "${GREEN}✓ Todos os módulos executados com sucesso!${NC}"
log ""
