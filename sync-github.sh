#!/bin/bash

# Script para sincronizar com GitHub e preparar versionamento de prompts

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_URL="https://github.com/senal88/context7.git"
REPO_DIR="$HOME/context7-github"
GITHUB_USER="senal88"
GITHUB_EMAIL="luizfernandomoreirasena@gmail.com"

echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      CONTEXT7 - SINCRONIZAÇÃO GITHUB                  ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"

# Verificar Git
if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ Git não encontrado!${NC}"
    exit 1
fi

# Configurar Git
echo -e "\n${GREEN}[1/6] Configurando Git...${NC}"
git config --global user.name "$GITHUB_USER"
git config --global user.email "$GITHUB_EMAIL"
echo -e "${GREEN}✓ Git configurado${NC}"

# Clonar ou atualizar repositório
echo -e "\n${GREEN}[2/6] Sincronizando repositório...${NC}"
if [ -d "$REPO_DIR" ]; then
    echo -e "${YELLOW}→ Repositório já existe, atualizando...${NC}"
    cd "$REPO_DIR"
    git pull origin master
else
    echo -e "${YELLOW}→ Clonando repositório...${NC}"
    git clone "$REPO_URL" "$REPO_DIR"
    cd "$REPO_DIR"
fi
echo -e "${GREEN}✓ Repositório sincronizado${NC}"

# Criar estrutura de diretórios para prompts modulares
echo -e "\n${GREEN}[3/6] Criando estrutura de prompts modulares...${NC}"
mkdir -p "$REPO_DIR/prompts/modules"
mkdir -p "$REPO_DIR/prompts/templates"
mkdir -p "$REPO_DIR/prompts/examples"
mkdir -p "$REPO_DIR/configs/ide"
mkdir -p "$REPO_DIR/configs/cli"
mkdir -p "$REPO_DIR/scripts"
mkdir -p "$REPO_DIR/docs"
echo -e "${GREEN}✓ Estrutura criada${NC}"

# Copiar arquivos de configuração
echo -e "\n${GREEN}[4/6] Copiando configurações...${NC}"
cp ~/context7-setup/*.json "$REPO_DIR/configs/ide/" 2>/dev/null || true
cp ~/context7-setup/*.toml "$REPO_DIR/configs/ide/" 2>/dev/null || true
cp ~/context7-setup/*.sh "$REPO_DIR/scripts/" 2>/dev/null || true
cp ~/context7-setup/*.md "$REPO_DIR/docs/" 2>/dev/null || true
echo -e "${GREEN}✓ Arquivos copiados${NC}"

# Criar arquivo de prompts modulares baseado no PROMPT_CONTEXT7.TXT
echo -e "\n${GREEN}[5/6] Gerando prompts modulares versionados...${NC}"

# Módulo 1: Setup Base
cat > "$REPO_DIR/prompts/modules/01-setup-base.md" << 'EOF'
# Módulo 1: Setup Base Context7

## Objetivo
Configurar ambiente base com credenciais e URLs

## Variáveis
```bash
CONTEXT7_API_KEY="ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032"
CONTEXT7_API_URL="https://context7.com/api/v2"
CONTEXT7_MCP_URL="https://mcp.context7.com/mcp"
CONTEXT7_DASHBOARD="https://context7.com/dashboard"
```

## Predecessores
- Nenhum (módulo inicial)

## Sucessores
- 02-ide-integration
- 03-1password-setup

## Validação
```bash
curl -X GET "$CONTEXT7_API_URL/search?query=test" \
  -H "Authorization: Bearer $CONTEXT7_API_KEY"
```
EOF

# Módulo 2: Integração IDEs
cat > "$REPO_DIR/prompts/modules/02-ide-integration.md" << 'EOF'
# Módulo 2: Integração IDEs

## Objetivo
Configurar Context7 em todas as IDEs

## Predecessores
- 01-setup-base

## IDEs Suportadas
1. VS Code
2. Cursor 2.1
3. Antigravity (futuro)

## Configurações

### VS Code
```json
{
  "mcp": {
    "servers": {
      "context7": {
        "type": "http",
        "url": "https://mcp.context7.com/mcp",
        "headers": {
          "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
        }
      }
    }
  }
}
```

### Cursor
```json
{
  "mcpServers": {
    "context7": {
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    }
  }
}
```

## Validação
- Reiniciar IDEs
- Verificar status MCP
- Testar busca de documentação

## Sucessores
- 04-cli-setup
EOF

# Módulo 3: 1Password
cat > "$REPO_DIR/prompts/modules/03-1password-setup.md" << 'EOF'
# Módulo 3: Integração 1Password

## Objetivo
Armazenar credenciais de forma segura

## Predecessores
- 01-setup-base

## Vaults Disponíveis
- 1p_azure (zfdghptbnbxjilasq7e2tb3rxi)
- 1p_macos (gkpsbgizlks2zknwzqpppnb2ze)
- 1p_vps (oa3tidekmeu26nxiier2qbi7v4)
- Personal (7bgov3zmccio5fxc5v7irhy5k4)

## Setup
```bash
op item create \
  --category=password \
  --vault="1p_macos" \
  --title="Context7_MCP" \
  "CONTEXT7_API_KEY[password]=${CONTEXT7_API_KEY}"
```

## Recuperação
```bash
export CONTEXT7_API_KEY=$(op item get Context7_MCP --vault 1p_macos --fields label=CONTEXT7_API_KEY)
```

## Sucessores
- 05-environment-vars
EOF

# Módulo 4: CLI Setup
cat > "$REPO_DIR/prompts/modules/04-cli-setup.md" << 'EOF'
# Módulo 4: Setup CLI

## Objetivo
Configurar CLIs e terminais

## Predecessores
- 01-setup-base
- 02-ide-integration

## CLIs Suportadas
1. Claude Code 2.0.61
2. Gemini CLI 3.0
3. Bash/Zsh

## Configuração Claude Code
```json
{
  "mcp": {
    "servers": {
      "context7": {
        "command": "npx",
        "args": ["-y", "@upstash/context7-mcp"],
        "env": {
          "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
        }
      }
    }
  }
}
```

## Aliases
```bash
alias ctx7-search='curl -X GET "$CONTEXT7_API_URL/search?query=$1" -H "Authorization: Bearer $CONTEXT7_API_KEY"'
alias ctx7-docs='curl -X GET "$CONTEXT7_API_URL/docs/code/$1" -H "Authorization: Bearer $CONTEXT7_API_KEY"'
```

## Validação
```bash
claude
> /mcp
# Verificar "context7" conectado
```

## Sucessores
- 06-vps-deploy
EOF

# Módulo 5: Variáveis de Ambiente
cat > "$REPO_DIR/prompts/modules/05-environment-vars.md" << 'EOF'
# Módulo 5: Variáveis de Ambiente

## Objetivo
Configurar variáveis globais no sistema

## Predecessores
- 03-1password-setup

## Arquivo: ~/.zshrc
```bash
# ====== CONTEXT7 CONFIGURATION ======
export CONTEXT7_API_KEY="ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032"
export CONTEXT7_API_URL="https://context7.com/api/v2"
export CONTEXT7_MCP_URL="https://mcp.context7.com/mcp"
export CONTEXT7_DASHBOARD="https://context7.com/dashboard"
# ====================================
```

## Segurança
Para produção, use 1Password:
```bash
source <(bash ~/context7-setup/load-from-1password.sh 1p_macos)
```

## Validação
```bash
source ~/.zshrc
echo $CONTEXT7_API_KEY | cut -c1-10
```

## Sucessores
- 04-cli-setup
- 06-vps-deploy
EOF

# Módulo 6: Deploy VPS
cat > "$REPO_DIR/prompts/modules/06-vps-deploy.md" << 'EOF'
# Módulo 6: Deploy VPS Ubuntu

## Objetivo
Implantar Context7 no servidor remoto

## Predecessores
- 01-setup-base
- 04-cli-setup
- 05-environment-vars

## Informações VPS
- **Host**: 147.79.81.59
- **Domínio**: senamfo.com.br
- **Usuário**: admin
- **Porta SSH**: 22
- **Stack**: Ubuntu KVM4 + Coolify

## Deploy
```bash
~/context7-setup/deploy-vps.sh
```

## Pós-Deploy
```bash
ssh admin@147.79.81.59
source ~/.bashrc
claude --version
ctx7-search "docker"
```

## Validação
```bash
# No VPS
sudo systemctl status context7-sync.service
curl -s https://context7.com/api/v2/search?query=healthcheck \
  -H "Authorization: Bearer $CONTEXT7_API_KEY"
```

## Sucessores
- Nenhum (módulo final)
EOF

# Criar template completo
cat > "$REPO_DIR/prompts/templates/full-setup-template.md" << 'EOF'
# Context7 - Template de Setup Completo

Este template executa todos os módulos em ordem.

## Ordem de Execução
1. [Setup Base](../modules/01-setup-base.md)
2. [Integração IDEs](../modules/02-ide-integration.md)
3. [1Password](../modules/03-1password-setup.md)
4. [CLI Setup](../modules/04-cli-setup.md)
5. [Variáveis de Ambiente](../modules/05-environment-vars.md)
6. [Deploy VPS](../modules/06-vps-deploy.md)

## Execução Automatizada
```bash
cd ~/context7-setup
./deploy-global.sh          # Local
./setup-1password.sh        # Segurança
./deploy-vps.sh             # Remoto
./test-integration.sh       # Validação
```

## Checklist
- [ ] API Key validada
- [ ] IDEs configuradas (VS Code, Cursor)
- [ ] 1Password integrado
- [ ] CLIs funcionando (Claude, etc.)
- [ ] Variáveis carregadas
- [ ] VPS deployado
- [ ] Testes passaram

## Versionamento
- **v1.0**: Setup inicial
- **v1.1**: Integração 1Password
- **v1.2**: Deploy VPS
- **v1.3**: Prompts modulares
EOF

# Criar exemplo de uso
cat > "$REPO_DIR/prompts/examples/uso-basico.md" << 'EOF'
# Exemplo: Uso Básico do Context7

## Cenário
Buscar documentação atualizada sobre Next.js SSR

## Pré-requisitos
- Módulo 01 completo
- API Key configurada

## Código
```bash
# Via curl
curl -X GET "https://context7.com/api/v2/docs/code/vercel/next.js?type=txt&topic=ssr&page=1" \
  -H "Authorization: Bearer $CONTEXT7_API_KEY"

# Via alias
ctx7-docs "vercel/next.js"

# Via Claude Code
claude
> Use Context7 para buscar exemplos de SSR em Next.js 15
```

## Resultado Esperado
- Snippets de código atualizados
- Links para fontes oficiais
- Scores de confiança e benchmark
EOF

echo -e "${GREEN}✓ Prompts modulares criados${NC}"

# Criar README principal
cat > "$REPO_DIR/README.md" << 'EOF'
# Context7 MCP - Repositório Oficial

![Context7](https://img.shields.io/badge/Context7-MCP-blue)
![Status](https://img.shields.io/badge/status-active-green)

Documentação e configurações oficiais para integração do Context7 MCP.

## 📁 Estrutura

```
context7/
├── prompts/
│   ├── modules/           → Prompts modulares versionados
│   ├── templates/         → Templates completos
│   └── examples/          → Exemplos de uso
├── configs/
│   ├── ide/              → Configs VS Code, Cursor, etc.
│   └── cli/              → Configs Claude, Gemini, etc.
├── scripts/              → Scripts de automação
└── docs/                 → Documentação adicional
```

## 🚀 Quick Start

```bash
# Clone
git clone https://github.com/senal88/context7.git
cd context7

# Execute setup
./scripts/deploy-global.sh
```

## 📚 Documentação

- [Setup Base](prompts/modules/01-setup-base.md)
- [Integração IDEs](prompts/modules/02-ide-integration.md)
- [1Password](prompts/modules/03-1password-setup.md)
- [CLI Setup](prompts/modules/04-cli-setup.md)
- [Deploy VPS](prompts/modules/06-vps-deploy.md)

## 🔗 Links

- **Dashboard**: https://context7.com/dashboard
- **API Docs**: https://context7.com/docs
- **MCP Server**: https://mcp.context7.com/mcp

## 🤝 Contribuindo

Este é um repositório privado para uso pessoal.

## 📄 Licença

Privado © 2025
EOF

# Commit e push
echo -e "\n${GREEN}[6/6] Commitando mudanças...${NC}"
cd "$REPO_DIR"
git add .
git commit -m "feat: Adicionar prompts modulares versionados e configurações completas

- Estrutura modular de prompts (6 módulos)
- Configurações para IDEs (VS Code, Cursor)
- Scripts de deploy (local, VPS, 1Password)
- Templates e exemplos de uso
- Documentação completa

Predecessores validados em cada módulo.
Pronto para deploy automatizado."

echo -e "${YELLOW}→ Fazendo push para GitHub...${NC}"
git push origin master

echo -e "${GREEN}✓ Sincronização completa!${NC}"

# Resumo
echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     SINCRONIZAÇÃO GITHUB CONCLUÍDA!                   ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}📦 Repositório:${NC} https://github.com/$GITHUB_USER/context7"
echo ""
echo -e "${YELLOW}📂 Local:${NC} $REPO_DIR"
echo ""
echo -e "${YELLOW}📋 Estrutura criada:${NC}"
echo -e "   - 6 módulos de prompts"
echo -e "   - Templates completos"
echo -e "   - Exemplos de uso"
echo -e "   - Scripts de automação"
echo ""
