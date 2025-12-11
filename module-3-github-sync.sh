#!/usr/bin/env bash
# Módulo 3: Sincronização com GitHub e versionamento de prompts
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

# Configurações GitHub
GITHUB_USER="senal88"
GITHUB_EMAIL="luizfernandomoreirasena@gmail.com"
GITHUB_REPO="https://github.com/senal88/context7"
GITHUB_BRANCH="master"

# Diretórios
REPO_DIR="$HOME/context7-setup/repo"
PROMPTS_DIR="$HOME/context7-setup/prompts"
TEMPLATES_DIR="$HOME/context7-setup/templates"

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

# Configurar Git
configure_git() {
    log_info "Configurando Git..."

    git config --global user.name "Luiz Sena"
    git config --global user.email "$GITHUB_EMAIL"
    git config --global init.defaultBranch main

    log_success "Git configurado"
}

# Clonar ou atualizar repositório
clone_or_update_repo() {
    log_info "Clonando/atualizando repositório GitHub..."

    if [ -d "$REPO_DIR/.git" ]; then
        log_info "Repositório já existe, atualizando..."
        cd "$REPO_DIR"
        git fetch origin
        git pull origin "$GITHUB_BRANCH" || log_warning "Conflitos detectados, merge manual necessário"
    else
        log_info "Clonando repositório..."
        mkdir -p "$(dirname "$REPO_DIR")"
        git clone "$GITHUB_REPO" "$REPO_DIR"
        cd "$REPO_DIR"
        git checkout "$GITHUB_BRANCH" 2>/dev/null || git checkout -b "$GITHUB_BRANCH"
    fi

    log_success "Repositório pronto: $REPO_DIR"
}

# Criar estrutura de diretórios para prompts modulares
create_prompt_structure() {
    log_info "Criando estrutura de prompts modulares..."

    mkdir -p "$PROMPTS_DIR"/{core,modules,examples,templates}
    mkdir -p "$TEMPLATES_DIR"/{ide,api,deployment}

    # Criar README para prompts
    cat > "$PROMPTS_DIR/README.md" << 'EOF'
# Context7 Prompts Modulares

Estrutura de prompts versionados e modulares para Context7.

## Estrutura

- `core/` - Prompts fundamentais e configurações base
- `modules/` - Módulos reutilizáveis de prompts
- `examples/` - Exemplos de uso e casos práticos
- `templates/` - Templates prontos para uso

## Versionamento

Todos os prompts seguem versionamento semântico (MAJOR.MINOR.PATCH).

## Uso

1. Selecione o prompt adequado em `modules/`
2. Customize conforme necessário
3. Execute com seu assistente IA preferido
4. Contribua melhorias via PR

EOF

    log_success "Estrutura de prompts criada"
}

# Criar prompts modulares
create_modular_prompts() {
    log_info "Criando prompts modulares..."

    # Prompt Core: Configuração base
    cat > "$PROMPTS_DIR/core/BASE_CONFIG.md" << 'EOF'
# Context7 - Configuração Base
Versão: 1.0.0

## Objetivo
Configurar Context7 MCP em todos os ambientes de desenvolvimento.

## Contexto
- API Key: {{CONTEXT7_API_KEY}}
- MCP URL: https://mcp.context7.com/mcp
- API URL: https://context7.com/api/v2

## Ambientes Suportados
- VS Code
- Cursor
- Claude CLI
- Codex
- Gemini CLI

## Pré-requisitos
- 1Password CLI instalado
- Git configurado
- Permissões de escrita nos diretórios de config
EOF

    # Módulo: IDE Configuration
    cat > "$PROMPTS_DIR/modules/IDE_CONFIGURATION.md" << 'EOF'
# Módulo: Configuração de IDEs
Versão: 1.0.0

## Descrição
Configura Context7 MCP em todas as IDEs suportadas.

## Entradas
- CONTEXT7_API_KEY
- Caminhos de configuração das IDEs

## Saídas
- Arquivos de configuração atualizados
- Backups das configurações anteriores
- Relatório de validação

## Dependências
- Módulo: BASE_CONFIG
- Ferramenta: jq (para JSON)
EOF

    # Módulo: 1Password Integration
    cat > "$PROMPTS_DIR/modules/ONEPASSWORD_INTEGRATION.md" << 'EOF'
# Módulo: Integração 1Password
Versão: 1.0.0

## Descrição
Gerencia secrets de forma segura usando 1Password CLI.

## Entradas
- Vault IDs
- Item names
- Field names

## Saídas
- Secrets recuperados com segurança
- Variáveis de ambiente exportadas
- Script de carregamento automático

## Dependências
- 1Password CLI (op)
- Autenticação ativa no 1Password
EOF

    # Módulo: API Integration
    cat > "$PROMPTS_DIR/modules/API_INTEGRATION.md" << 'EOF'
# Módulo: Integração API Context7
Versão: 1.0.0

## Descrição
Integra com a API do Context7 para buscar documentação e exemplos.

## Endpoints Principais

### Search
```bash
GET https://context7.com/api/v2/search?query={query}
Header: Authorization: Bearer {API_KEY}
```

### Code Documentation
```bash
GET https://context7.com/api/v2/docs/code/{org}/{project}?type=json&topic={topic}
Header: Authorization: Bearer {API_KEY}
```

### Info Documentation
```bash
GET https://context7.com/api/v2/docs/info/{org}/{project}?type=txt
Header: Authorization: Bearer {API_KEY}
```

## Exemplos de Uso

### Buscar Next.js
```bash
curl -X GET "https://context7.com/api/v2/search?query=next.js" \
  -H "Authorization: Bearer $CONTEXT7_API_KEY"
```
EOF

    # Exemplo completo
    cat > "$PROMPTS_DIR/examples/COMPLETE_SETUP.md" << 'EOF'
# Exemplo: Setup Completo Context7
Versão: 1.0.0

## Objetivo
Demonstrar setup completo do Context7 em todos os ambientes.

## Passos

1. **Validar Ambiente**
   - Verificar 1Password CLI
   - Testar conectividade API
   - Validar permissões

2. **Configurar IDEs**
   - VS Code
   - Cursor
   - Outras IDEs

3. **Integrar Secrets**
   - Salvar credenciais no 1Password
   - Gerar script de carregamento
   - Testar recuperação

4. **Sincronizar GitHub**
   - Clonar/atualizar repositório
   - Versionar configurações
   - Commit e push

5. **Deploy VPS**
   - Configurar SSH
   - Deploy via Coolify
   - Validar acesso remoto

## Resultado Esperado
- Todas IDEs configuradas
- Secrets gerenciados com segurança
- Repositório sincronizado
- VPS operacional
EOF

    log_success "Prompts modulares criados"
}

# Criar templates de configuração
create_config_templates() {
    log_info "Criando templates de configuração..."

    # Template VS Code
    cat > "$TEMPLATES_DIR/ide/vscode-settings.json" << 'EOF'
{
  "mcp": {
    "servers": {
      "context7": {
        "type": "http",
        "url": "https://mcp.context7.com/mcp",
        "headers": {
          "CONTEXT7_API_KEY": "{{CONTEXT7_API_KEY}}"
        }
      }
    }
  }
}
EOF

    # Template Cursor
    cat > "$TEMPLATES_DIR/ide/cursor-mcp.json" << 'EOF'
{
  "mcpServers": {
    "context7": {
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "{{CONTEXT7_API_KEY}}"
      }
    }
  }
}
EOF

    # Template API Usage
    cat > "$TEMPLATES_DIR/api/api-examples.sh" << 'EOF'
#!/usr/bin/env bash
# Exemplos de uso da API Context7

API_KEY="${CONTEXT7_API_KEY}"
API_URL="https://context7.com/api/v2"

# Buscar biblioteca
search_library() {
    local query=$1
    curl -s -X GET "${API_URL}/search?query=${query}" \
        -H "Authorization: Bearer ${API_KEY}" | jq
}

# Obter documentação de código
get_code_docs() {
    local org=$1
    local project=$2
    local topic=${3:-""}

    curl -s -X GET "${API_URL}/docs/code/${org}/${project}?type=json&topic=${topic}" \
        -H "Authorization: Bearer ${API_KEY}" | jq
}

# Exemplos
search_library "next.js"
get_code_docs "vercel" "next.js" "ssr"
EOF

    chmod +x "$TEMPLATES_DIR/api/api-examples.sh"

    log_success "Templates criados"
}

# Versionar e comitar alterações
commit_and_push() {
    log_info "Versionando e enviando para GitHub..."

    cd "$HOME/context7-setup"

    # Inicializar git se necessário
    if [ ! -d ".git" ]; then
        git init
        git remote add origin "$GITHUB_REPO" 2>/dev/null || true
    fi

    # Adicionar arquivos
    git add -A

    # Criar commit
    local commit_msg="feat: setup completo Context7 - $(date +%Y-%m-%d)"
    git commit -m "$commit_msg" || log_warning "Nada para comitar"

    # Push (se houver remote configurado)
    if git remote get-url origin &> /dev/null; then
        log_info "Enviando para GitHub..."
        git push -u origin "$GITHUB_BRANCH" 2>/dev/null || \
            log_warning "Push falhou - verifique autenticação GitHub"
    else
        log_warning "Remote não configurado - push manual necessário"
    fi

    log_success "Alterações versionadas"
}

# Gerar documentação
generate_documentation() {
    log_info "Gerando documentação..."

    cat > "$HOME/context7-setup/README.md" << 'EOF'
# Context7 Setup Completo

Setup automatizado do Context7 MCP para todos os ambientes de desenvolvimento.

## 📋 Pré-requisitos

- macOS (Apple Silicon)
- 1Password CLI instalado
- Git configurado
- Acesso à API Context7

## 🚀 Instalação Rápida

```bash
# Executar setup completo
./MASTER-INSTALL.sh
```

## 📦 Componentes

### Módulos
1. **IDE Configuration** - Configura todas as IDEs
2. **1Password Integration** - Gerenciamento seguro de secrets
3. **GitHub Sync** - Sincronização e versionamento
4. **VPS Deployment** - Deploy no servidor remoto

### Estrutura de Arquivos
```
context7-setup/
├── module-1-ide-config.sh      # Configuração IDEs
├── module-2-1password.sh       # Integração 1Password
├── module-3-github-sync.sh     # Sincronização GitHub
├── module-4-vps-deploy.sh      # Deploy VPS
├── MASTER-INSTALL.sh           # Orquestrador principal
├── data-structure.json         # Estrutura de dados
├── prompts/                    # Prompts modulares
│   ├── core/                   # Prompts base
│   ├── modules/                # Módulos reutilizáveis
│   ├── examples/               # Exemplos práticos
│   └── templates/              # Templates prontos
└── templates/                  # Templates de configuração
    ├── ide/                    # Configs IDEs
    ├── api/                    # Exemplos API
    └── deployment/             # Scripts deployment
```

## 🔧 Uso

### Carregar Secrets do 1Password
```bash
source load-secrets.sh
```

### Configurar IDEs Individualmente
```bash
./module-1-ide-config.sh
```

### Sincronizar com GitHub
```bash
./module-3-github-sync.sh
```

## 📚 Documentação

- [Prompts Modulares](prompts/README.md)
- [API Context7](https://context7.com/docs)
- [1Password CLI](https://developer.1password.com/docs/cli)

## 🔐 Segurança

Todos os secrets são gerenciados via 1Password CLI. Nunca comite API keys ou credenciais.

## 📝 Versionamento

Este projeto segue [Semantic Versioning](https://semver.org/).

Versão atual: **1.0.0**

## 👤 Autor

Luiz Sena <luiz.sena88@icloud.com>

## 📄 Licença

MIT
EOF

    log_success "Documentação gerada"
}

# Função principal
main() {
    log_info "=== Configurando sincronização GitHub e prompts modulares ==="

    configure_git
    clone_or_update_repo
    create_prompt_structure
    create_modular_prompts
    create_config_templates
    generate_documentation
    commit_and_push

    log_success "=== Sincronização GitHub configurada! ==="
    log_info "Repositório: $REPO_DIR"
    log_info "Prompts: $PROMPTS_DIR"
}

main "$@"
