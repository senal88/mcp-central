# 🐳 DevContainer - MCP Central

DevContainer completo para desenvolvimento do MCP Central com Context7.

## 🎯 Features

### Ambiente Base
- **Node.js 20 LTS** - Runtime JavaScript/TypeScript
- **pnpm** - Gerenciador de pacotes rápido
- **TypeScript** - Suporte completo a TS
- **Zsh + Oh My Zsh** - Shell aprimorada

### Ferramentas Incluídas
- ✅ GitHub CLI (`gh`)
- ✅ Docker in Docker
- ✅ Git LFS
- ✅ PostgreSQL Client
- ✅ Redis Tools
- ✅ jq/yq - Processamento JSON/YAML
- ✅ Build essentials

### Extensões VS Code
- GitHub Copilot + Chat
- ESLint + Prettier
- GitLens
- Docker
- Error Lens
- TypeScript

### Serviços Auxiliares
- **Redis** - Cache e sessões (porta 6379)
- **PostgreSQL** - Banco de dados (porta 5432)

## 🚀 Início Rápido

### 1. Pré-requisitos
- Docker Desktop instalado
- VS Code com extensão "Dev Containers"
- Variáveis de ambiente configuradas:
  ```bash
  export CONTEXT7_API_KEY="ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032"
  export GITHUB_TOKEN="seu_token_aqui"
  ```

### 2. Abrir no DevContainer

**Opção A - Via Command Palette:**
1. `Cmd+Shift+P` (macOS) ou `Ctrl+Shift+P` (Linux/Windows)
2. Digite: `Dev Containers: Reopen in Container`
3. Aguarde build e inicialização

**Opção B - Via Prompt:**
```bash
cd ~/projects/mcp-central
code .
# VS Code detectará .devcontainer e oferecerá reabrir
```

### 3. Primeiro Uso

O script `setup.sh` executa automaticamente:
- ✅ Configuração do Git
- ✅ Inicialização de submodules
- ✅ Instalação de dependências
- ✅ Build do Context7
- ✅ Criação de arquivos .env
- ✅ Validação do workspace

## 📦 Estrutura

```
.devcontainer/
├── devcontainer.json       # Configuração principal
├── Dockerfile              # Imagem customizada
├── docker-compose.yml      # Serviços (Redis, PostgreSQL)
├── setup.sh               # Script de inicialização
└── README.md              # Este arquivo
```

## 🔧 Comandos Úteis

### Dentro do Container

```bash
# Carregar secrets
source load-secrets.sh

# Acessar Context7 monorepo
ctx7  # alias para cd packages/context7

# Build completo
pnpm build

# Executar testes
pnpm test

# Desenvolvimento
pnpm dev

# Git shortcuts
gs      # git status
glog    # git log --oneline --graph --all
```

### Gerenciar Container

```bash
# Rebuild container
Cmd+Shift+P → "Dev Containers: Rebuild Container"

# Reabrir localmente
Cmd+Shift+P → "Dev Containers: Reopen Folder Locally"

# Logs do container
docker logs mcp-central-dev
```

## 🗄️ Serviços Auxiliares

### Redis
```bash
# Conectar via redis-cli
redis-cli -h redis -p 6379

# Testar conexão
redis-cli -h redis ping
```

### PostgreSQL
```bash
# Conectar via psql
psql -h postgres -U mcp_user -d mcp_central

# String de conexão
postgresql://mcp_user:mcp_password@postgres:5432/mcp_central
```

## 🔐 Variáveis de Ambiente

### Automáticas (via .env)
- `CONTEXT7_API_KEY` - API key do Context7
- `CONTEXT7_MCP_URL` - Endpoint MCP
- `GITHUB_USERNAME` - Usuário GitHub
- `VPS_HOST` - IP do VPS

### Manuais (export)
```bash
export GITHUB_TOKEN="ghp_..."
export OPENAI_API_KEY="sk-..."
```

## 📂 Volumes Persistentes

- `node_modules` - Dependencies isoladas
- `pnpm_store` - Cache do pnpm
- `redis_data` - Dados Redis
- `postgres_data` - Dados PostgreSQL

## 🔄 Sincronização

### SSH Keys
Montadas automaticamente de `~/.ssh` (host → container)

### Git Config
Montado de `~/.gitconfig` (host → container)

### Workspace
Sincronizado em tempo real com consistência cached

## 🐛 Troubleshooting

### Container não inicia
```bash
# Verificar logs
docker logs mcp-central-dev

# Rebuild forçado
docker-compose down -v
docker-compose build --no-cache
```

### Dependências não instalam
```bash
# Limpar caches
rm -rf node_modules packages/*/node_modules
pnpm store prune
pnpm install
```

### Porta já em uso
```bash
# Verificar portas em uso
docker ps
lsof -i :3000

# Mudar porta em devcontainer.json
"forwardPorts": [3001, ...]
```

## 🎨 Personalização

### Adicionar Extensões
Edite `devcontainer.json`:
```json
"extensions": [
  "publisher.extension-name"
]
```

### Adicionar Ferramentas
Edite `Dockerfile`:
```dockerfile
RUN apt-get install -y nova-ferramenta
```

### Scripts Personalizados
Adicione em `setup.sh`:
```bash
# Seu script customizado
echo "Executando script personalizado..."
```

## 📚 Recursos

- [VS Code DevContainers](https://code.visualstudio.com/docs/devcontainers/containers)
- [Docker Compose](https://docs.docker.com/compose/)
- [Context7 Docs](https://github.com/upstash/context7)

## 👤 Autor

**Luiz Fernando Moreira Sena**
- GitHub: [@senal88](https://github.com/senal88)
- Email: luizfernandomoreirasena@gmail.com

---

**Version**: 1.0.0 | **Last Update**: 2025-12-11
