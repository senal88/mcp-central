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
