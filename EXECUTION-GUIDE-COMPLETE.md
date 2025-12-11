# Context7 - Guia de Execução Completo
**Versão: 1.0.0** | **Data: 2025-12-11** | **Autor: luiz.sena88@icloud.com**

---

## 🎯 Visão Geral

Este documento descreve a implementação completa e automatizada do Context7 MCP em todos os ambientes de desenvolvimento, conforme especificado no `PROMPT_CONTEXT7.TXT`.

### ✅ O Que Foi Implementado

- ✅ Estrutura de dados versionada e modular
- ✅ Configuração automática de MCP em todas IDEs
- ✅ Integração com 1Password para gerenciamento de secrets
- ✅ Sincronização GitHub com prompts modulares
- ✅ Scripts de deploy VPS via Coolify
- ✅ Sistema de validação e testes automatizados
- ✅ Documentação completa e templates reutilizáveis

---

## 📦 Estrutura de Arquivos Gerada

```
context7-setup/
├── MASTER-INSTALL.sh              # Orquestrador principal (EXECUTE ESTE!)
├── data-structure.json             # Estrutura versionada de dados
│
├── Módulos de Instalação:
│   ├── module-1-ide-config.sh      # Config VS Code, Cursor, Claude, Codex, Gemini
│   ├── module-2-1password.sh       # Integração 1Password CLI
│   ├── module-3-github-sync.sh     # Sync GitHub + prompts modulares
│   └── module-4-vps-deploy.sh      # Deploy VPS Ubuntu via Coolify
│
├── Scripts Auxiliares:
│   ├── load-secrets.sh             # Carrega secrets do 1Password
│   ├── deploy-global.sh            # Deploy global existente
│   ├── deploy-vps.sh               # Deploy VPS existente
│   ├── setup-1password.sh          # Setup 1Password existente
│   └── sync-github.sh              # Sync GitHub existente
│
├── Prompts Modulares:
│   ├── prompts/
│   │   ├── core/                   # Prompts fundamentais
│   │   │   └── BASE_CONFIG.md
│   │   ├── modules/                # Módulos reutilizáveis
│   │   │   ├── IDE_CONFIGURATION.md
│   │   │   ├── ONEPASSWORD_INTEGRATION.md
│   │   │   └── API_INTEGRATION.md
│   │   ├── examples/               # Exemplos práticos
│   │   │   └── COMPLETE_SETUP.md
│   │   └── README.md
│   │
│   └── templates/                  # Templates de configuração
│       ├── ide/
│       │   ├── vscode-settings.json
│       │   └── cursor-mcp.json
│       ├── api/
│       │   └── api-examples.sh
│       └── deployment/
│           ├── remote-install.sh
│           ├── configure-context7.sh
│           ├── test-deployment.sh
│           └── coolify-compose.yml
│
├── Documentação:
│   ├── README.md                   # Documentação principal
│   ├── EXECUTION-GUIDE.md          # Este guia
│   └── .env                        # Variáveis de ambiente (geradas)
│
└── Logs e Backups:
    ├── installation-*.log          # Logs de instalação
    └── .context7-backups/          # Backups de configs
```

---

## 🚀 Execução Rápida (Recomendado)

### Opção 1: Instalação Completa Automatizada

```bash
cd ~/context7-setup
./MASTER-INSTALL.sh
```

Este script executará automaticamente:
1. ✅ Configuração de IDEs (VS Code, Cursor, Claude CLI, Codex, Gemini CLI)
2. ✅ Integração 1Password (se CLI estiver instalado)
3. ✅ Criação de prompts modulares e sincronização GitHub
4. ✅ Preparação para deploy VPS (com confirmação interativa)
5. ✅ Validação e testes de todas as integrações

**Tempo estimado**: 10-15 minutos

---

## 📋 Execução Modular (Passo a Passo)

Se preferir executar módulos individualmente:

### Módulo 1: Configuração de IDEs

```bash
./module-1-ide-config.sh
```

**O que faz:**
- Valida conectividade com API Context7
- Cria backups das configurações existentes
- Configura MCP em VS Code, Cursor, Claude CLI, Codex e Gemini CLI
- Gera relatório de configuração

**Arquivos criados:**
- `~/Library/Application Support/Code/User/settings.json` (VS Code)
- `~/.cursor/mcp.json` (Cursor)
- `~/.claude.json` (Claude CLI)
- `~/.codex/config.toml` (Codex)
- `~/.config/gemini/config.json` (Gemini CLI)

### Módulo 2: Integração 1Password

```bash
./module-2-1password.sh
```

**Pré-requisitos:**
- 1Password CLI instalado: `brew install --cask 1password-cli`
- Autenticado: `eval $(op signin)`

**O que faz:**
- Salva credenciais Context7 nos vaults do 1Password
- Salva configurações VPS e GitHub
- Gera script `load-secrets.sh` para carregar secrets
- Cria arquivo `.env` com todas as variáveis
- Testa integração com API usando secret do 1Password

**Vaults utilizados:**
- `1p_macos`: Context7 API credentials
- `1p_vps`: VPS Hostinger credentials
- `1p_personal`: GitHub credentials

### Módulo 3: Sincronização GitHub e Prompts Modulares

```bash
./module-3-github-sync.sh
```

**O que faz:**
- Configura Git (username, email)
- Clona/atualiza repositório `senal88/context7`
- Cria estrutura completa de prompts modulares
- Gera templates de configuração reutilizáveis
- Versiona todas as alterações
- Faz push para GitHub (se autenticado)
- Gera README.md completo

**Estrutura gerada:**
- `/prompts/core/` - Prompts base
- `/prompts/modules/` - Módulos reutilizáveis
- `/prompts/examples/` - Exemplos práticos
- `/templates/ide/` - Templates IDEs
- `/templates/api/` - Exemplos API
- `/templates/deployment/` - Scripts deployment

### Módulo 4: Deploy VPS via Coolify

```bash
./module-4-vps-deploy.sh
```

**Pré-requisitos:**
- SSH configurado para VPS: `ssh-copy-id -p 22 admin@147.79.81.59`

**O que faz:**
- Verifica conectividade SSH com VPS (147.79.81.59)
- Gera scripts de instalação remota
- Prepara configuração Context7 para VPS
- Cria serviço systemd para MCP server
- Gera docker-compose.yml para Coolify
- Executa deploy remoto (com confirmação)
- Valida instalação no servidor

**Scripts gerados para VPS:**
- `deployment/remote-install.sh` - Instalação base no VPS
- `deployment/configure-context7.sh` - Configuração Context7
- `deployment/test-deployment.sh` - Testes de validação
- `deployment/coolify-compose.yml` - Compose para Coolify

---

## 🔐 Gerenciamento de Secrets

### Carregar Secrets do 1Password

```bash
# Carregar todas as variáveis de ambiente
source ~/context7-setup/load-secrets.sh
```

Este script exporta automaticamente:
- `CONTEXT7_API_KEY`
- `CONTEXT7_MCP_URL`
- `CONTEXT7_API_URL`
- Outras variáveis configuradas

### Usar Arquivo .env

```bash
# Carregar do arquivo .env (alternativa)
source ~/context7-setup/.env

# Verificar variável carregada
echo $CONTEXT7_API_KEY
```

### Recuperar Secret Manualmente

```bash
# Recuperar API key do 1Password
op item get "Context7_API" \
  --vault "gkpsbgizlks2zknwzqpppnb2ze" \
  --fields "api_key"
```

---

## 🧪 Validação e Testes

### Testar API Context7

```bash
# Usando variável de ambiente
curl -X GET "https://context7.com/api/v2/search?query=next.js" \
  -H "Authorization: Bearer ${CONTEXT7_API_KEY}" | jq

# Buscar documentação de código
curl -X GET "https://context7.com/api/v2/docs/code/vercel/next.js?type=json&topic=ssr" \
  -H "Authorization: Bearer ${CONTEXT7_API_KEY}" | jq
```

### Testar MCP em IDEs

**VS Code:**
1. Reabra VS Code
2. Abra Command Palette (Cmd+Shift+P)
3. Digite "MCP"
4. Verifique se Context7 aparece como servidor conectado

**Cursor:**
1. Reabra Cursor
2. Abra configurações MCP
3. Verifique status do servidor Context7

**Claude CLI:**
```bash
claude
> /mcp
# Deve mostrar context7 como ✓ connected
```

### Verificar Prompts Modulares

```bash
# Listar estrutura de prompts
tree ~/context7-setup/prompts

# Ver exemplo completo
cat ~/context7-setup/prompts/examples/COMPLETE_SETUP.md

# Ver módulo de API
cat ~/context7-setup/prompts/modules/API_INTEGRATION.md
```

---

## 🌐 Deploy VPS

### Preparação

```bash
# 1. Gerar chave SSH (se não tiver)
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "luiz.sena88@icloud.com"

# 2. Copiar chave para VPS
ssh-copy-id -p 22 admin@147.79.81.59

# 3. Testar conexão
ssh -p 22 admin@147.79.81.59 "echo 'Conexão OK'"
```

### Executar Deploy

```bash
# Deploy completo
./module-4-vps-deploy.sh

# Ou executar manualmente cada etapa:
cd ~/context7-setup/deployment

# 1. Copiar scripts para VPS
scp -P 22 *.sh admin@147.79.81.59:~/context7-setup/

# 2. Executar instalação remota
ssh -p 22 admin@147.79.81.59 "bash ~/context7-setup/remote-install.sh"

# 3. Configurar Context7
ssh -p 22 admin@147.79.81.59 "bash ~/context7-setup/configure-context7.sh YOUR_API_KEY"

# 4. Testar
ssh -p 22 admin@147.79.81.59 "bash ~/context7-setup/test-deployment.sh"
```

### Gerenciar Serviço no VPS

```bash
# Conectar ao VPS
ssh -p 22 admin@147.79.81.59

# Iniciar serviço Context7
sudo systemctl start context7-mcp

# Verificar status
sudo systemctl status context7-mcp

# Ver logs
sudo journalctl -u context7-mcp -f

# Habilitar inicialização automática
sudo systemctl enable context7-mcp
```

---

## 📚 Uso dos Prompts Modulares

### Estrutura

Os prompts seguem uma arquitetura modular:

1. **Core** - Prompts fundamentais e configurações base
2. **Modules** - Módulos reutilizáveis para tarefas específicas
3. **Examples** - Exemplos práticos de uso combinado
4. **Templates** - Templates prontos para customização

### Exemplo de Uso

```bash
# 1. Navegar para prompts
cd ~/context7-setup/prompts

# 2. Ver prompt base
cat core/BASE_CONFIG.md

# 3. Usar módulo específico
# Copie o conteúdo de modules/IDE_CONFIGURATION.md
# Cole no seu assistente IA (Claude, ChatGPT, etc.)

# 4. Customizar template
# Abra templates/ide/vscode-settings.json
# Substitua {{CONTEXT7_API_KEY}} pela sua chave
# Aplique na sua instalação
```

### Criar Novo Módulo

```bash
# Criar módulo customizado
cat > ~/context7-setup/prompts/modules/CUSTOM_MODULE.md << 'EOF'
# Módulo: Meu Módulo Custom
Versão: 1.0.0

## Descrição
[Descreva seu módulo]

## Entradas
- Input 1
- Input 2

## Saídas
- Output 1
- Output 2

## Dependências
- Módulo: BASE_CONFIG
EOF
```

---

## 🔄 Sincronização GitHub

### Setup Inicial

```bash
cd ~/context7-setup

# Configurar remote (se não estiver)
git remote add origin https://github.com/senal88/context7

# Verificar status
git status

# Adicionar arquivos
git add -A

# Commit
git commit -m "feat: setup completo Context7 - $(date +%Y-%m-%d)"

# Push
git push -u origin master
```

### Manter Sincronizado

```bash
# Atualizar do remoto
git pull origin master

# Fazer alterações locais
# ... editar arquivos ...

# Commit e push
git add -A
git commit -m "feat: descrição das alterações"
git push origin master
```

### Versionamento de Prompts

Todos os prompts seguem **Semantic Versioning**:

```markdown
# Módulo: Nome do Módulo
Versão: 1.2.3

## Changelog
### [1.2.3] - 2025-12-11
- Fixed: Correção de bug X
- Changed: Melhoria Y

### [1.2.0] - 2025-12-10
- Added: Nova funcionalidade Z
```

---

## 🛠️ Troubleshooting

### API Context7 Não Responde

```bash
# Verificar API key
echo $CONTEXT7_API_KEY

# Testar manualmente
curl -v "https://context7.com/api/v2/search?query=test" \
  -H "Authorization: Bearer ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032"

# Recarregar do 1Password
source ~/context7-setup/load-secrets.sh
```

### MCP Não Conecta nas IDEs

```bash
# VS Code:
# 1. Abrir Output panel (Cmd+Shift+U)
# 2. Selecionar "MCP" no dropdown
# 3. Verificar erros

# Cursor:
# 1. Verificar ~/.cursor/mcp.json
# 2. Reiniciar Cursor completamente

# Claude CLI:
claude --debug
> /mcp
```

### SSH para VPS Falha

```bash
# Verificar conectividade
nc -zv 147.79.81.59 22

# Verificar chave SSH
ssh-add -l

# Testar com verbose
ssh -v -p 22 admin@147.79.81.59

# Regenerar e copiar chave
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_vps
ssh-copy-id -i ~/.ssh/id_ed25519_vps.pub -p 22 admin@147.79.81.59
```

### 1Password CLI Não Autentica

```bash
# Verificar instalação
op --version

# Fazer signin
eval $(op signin)

# Listar vaults
op vault list

# Forçar reautenticação
op signout
eval $(op signin)
```

### Git Push Falha

```bash
# Verificar autenticação GitHub
gh auth status

# Login GitHub CLI
gh auth login

# Ou usar token pessoal
git remote set-url origin https://TOKEN@github.com/senal88/context7
```

---

## 📊 Estrutura de Dados Versionada

O arquivo `data-structure.json` contém toda a configuração estruturada:

```json
{
  "version": "1.0.0",
  "metadata": {...},
  "credentials": {...},
  "environments": {...},
  "ides": [...],
  "mcp_configurations": {...},
  "api_endpoints": {...},
  "deployment_strategy": {...},
  "validation_tests": [...]
}
```

### Uso Programático

```bash
# Ler configuração programaticamente
jq '.credentials.context7.api_key' ~/context7-setup/data-structure.json

# Listar todos os IDEs
jq '.ides[].name' ~/context7-setup/data-structure.json

# Obter endpoint API
jq '.api_endpoints.search.url' ~/context7-setup/data-structure.json
```

---

## 🎓 Recursos Adicionais

### Documentação Oficial

- **Context7 Dashboard**: https://context7.com/dashboard
- **API Documentation**: https://context7.com/docs
- **Add Library**: https://context7.com/add-library
- **Task List**: https://context7.com/tasklist?tab=repo

### Links GitHub

- **Repositório**: https://github.com/senal88/context7
- **Issues**: https://github.com/senal88/context7/issues
- **Wiki**: https://github.com/senal88/context7/wiki

### Comunidade

- **1Password CLI Docs**: https://developer.1password.com/docs/cli
- **MCP Protocol**: https://modelcontextprotocol.com
- **Coolify Docs**: https://coolify.io/docs

---

## 📝 Notas de Versão

### Versão 1.0.0 (2025-12-11)

**Inicial Release - Setup Completo**

✅ **Implementado:**
- Estrutura de dados versionada (JSON)
- 4 módulos de instalação automatizados
- Integração completa 1Password
- Prompts modulares e templates
- Deploy VPS via Coolify
- Sincronização GitHub
- Documentação completa

🔐 **Segurança:**
- Secrets gerenciados via 1Password
- Backups automáticos de configs
- Validação de API keys

📚 **Documentação:**
- README.md completo
- Este guia de execução
- Prompts modulares documentados
- Templates prontos para uso

---

## 🆘 Suporte

### Logs

Todos os logs de instalação são salvos em:
```
~/context7-setup/installation-YYYYMMDD-HHMMSS.log
```

### Contato

- **Email**: luiz.sena88@icloud.com
- **GitHub**: @senal88
- **1Password Account**: luiz.sena88@icloud.com

---

**Última atualização:** 2025-12-11
**Versão do guia:** 1.0.0
**Autor:** Luiz Sena

---

## ✅ Checklist de Conclusão

Após executar tudo, verifique:

- [ ] API Context7 responde corretamente
- [ ] VS Code MCP configurado e conectado
- [ ] Cursor MCP configurado e conectado
- [ ] Claude CLI mostra context7 conectado
- [ ] 1Password secrets carregam corretamente
- [ ] Prompts modulares criados em ~/context7-setup/prompts
- [ ] Templates disponíveis em ~/context7-setup/templates
- [ ] GitHub sincronizado (se aplicável)
- [ ] VPS configurado (se aplicável)
- [ ] Documentação lida e compreendida

**Se todos os itens estão marcados, seu ambiente Context7 está 100% operacional! 🎉**
