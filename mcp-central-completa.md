# 🏗️ CENTRAL DE MCP SERVERS – ARQUITETURA COMPLETA

**Status:** Production Ready v1.0  
**Data:** Dezembro 2025  
**Ambientes:** macOS Silicon (dev) + VPS Ubuntu (prod)  
**Linguagem:** Português (BR)

---

## 📋 ÍNDICE

1. [Visão Geral Arquitetônica](#visão-geral-arquitetônica)
2. [Estrutura de Contextos](#estrutura-de-contextos)
3. [Workflow de Prompts](#workflow-de-prompts)
4. [Tipos de MCP Servers](#tipos-de-mcp-servers)
5. [Setup macOS Silicon](#setup-macos-silicon)
6. [Setup VPS Ubuntu](#setup-vps-ubuntu)
7. [Integração HuggingFace](#integração-huggingface)
8. [Integração GitHub](#integração-github)
9. [Ambientes Personalizados](#ambientes-personalizados)
10. [Sistema de Orchestration](#sistema-de-orchestration)
11. [Monitoramento & Observabilidade](#monitoramento--observabilidade)
12. [Segurança & Autenticação](#segurança--autenticação)
13. [CI/CD Pipeline](#cicd-pipeline)
14. [Troubleshooting & Debugging](#troubleshooting--debugging)
15. [Roadmap & Inovações](#roadmap--inovações)

---

## VISÃO GERAL ARQUITETÔNICA

### Modelo Conceitual

```
┌────────────────────────────────────────────────────────────────────────┐
│                    CENTRAL DE MCP SERVERS ECOSYSTEM                    │
├────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────────┐  ┌──────────────────────────┐   │
│  │    DEVELOPMENT (macOS Silicon)  │  │  PRODUCTION (VPS Ubuntu) │   │
│  │                                 │  │                          │   │
│  │  ├─ Local MCP Servers (5)       │  │  ├─ Orchestration       │   │
│  │  ├─ IDE Integration             │  │  ├─ Load Balancing      │   │
│  │  ├─ Testing & Debugging         │  │  ├─ High Availability   │   │
│  │  ├─ Hot Reload                  │  │  ├─ Monitoring & Logs   │   │
│  │  └─ Development Tools           │  │  └─ Backup & Failover   │   │
│  └─────────────────────────────────┘  └──────────────────────────┘   │
│                │                                  │                    │
│                └──────────────┬───────────────────┘                    │
│                               │                                        │
│  ┌────────────────────────────▼────────────────────────────────────┐  │
│  │           CONTEXT MANAGEMENT LAYER (Centralized)               │  │
│  │                                                                 │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │  │
│  │  │ Repo Schemas │  │ API Contexts │  │ User Contexts│         │  │
│  │  └──────────────┘  └──────────────┘  └──────────────┘         │  │
│  │                                                                 │  │
│  └─────────────────────────────────────────────────────────────────┘  │
│                               │                                        │
│  ┌────────────────────────────▼────────────────────────────────────┐  │
│  │          PROMPT ORCHESTRATION LAYER                             │  │
│  │                                                                 │  │
│  │  Dynamic Prompt Generation → Context Injection → Execution    │  │
│  └─────────────────────────────────────────────────────────────────┘  │
│                               │                                        │
│  ┌────────────────────────────▼────────────────────────────────────┐  │
│  │      MULTI-TYPE MCP SERVERS (10+ Tipos)                        │  │
│  │                                                                 │  │
│  │  ├─ File System       ├─ API Gateway       ├─ Database         │  │
│  │  ├─ Git/GitHub        ├─ AI Models (HF)    ├─ Cache            │  │
│  │  ├─ Code Analysis     ├─ DevOps            ├─ Queue            │  │
│  │  ├─ ML/Data           ├─ Auth/Security     ├─ Monitoring       │  │
│  │  └─ Custom            └─ Integrations      └─ Webhooks         │  │
│  │                                                                 │  │
│  └─────────────────────────────────────────────────────────────────┘  │
│                               │                                        │
│  ┌────────────────────────────▼────────────────────────────────────┐  │
│  │         EXTERNAL INTEGRATIONS (Clouds & Platforms)             │  │
│  │                                                                 │  │
│  │  ├─ GitHub API/Webhooks          ├─ HuggingFace Hub           │  │
│  │  ├─ AWS/GCP/Azure (optional)    ├─ Local System Integration   │  │
│  │  ├─ Docker Registry              ├─ Custom Enterprise APIs     │  │
│  │  └─ Kubernetes (prod)            └─ Third-party Services      │  │
│  │                                                                 │  │
│  └─────────────────────────────────────────────────────────────────┘  │
│                                                                         │
└────────────────────────────────────────────────────────────────────────┘
```

### Filosofia de Design

**3 Camadas Fundamentais:**

1. **Contexto (Context Layer)**
   - Define "o que" o sistema conhece
   - Schemas, tipos, metadados
   - Imutável, versionado, auditado

2. **Prompts (Orchestration Layer)**
   - Define "como" comunicar com agentes
   - Dynamic generation baseado em contexto
   - Template system com injeção de variáveis

3. **Execução (Execution Layer)**
   - Define "onde" e "quando" executar
   - Roteamento entre servers
   - Resiliência e retry logic

---

## ESTRUTURA DE CONTEXTOS

### 1. Context Types (Tipos de Contexto)

```typescript
// 1. REPO CONTEXT
{
  type: "repository",
  id: "github:username/repo",
  version: "1.0.0",
  metadata: {
    language: "typescript",
    framework: "nextjs",
    environment: "monorepo",
    rootPath: "/path/to/repo"
  },
  schema: {
    // TypeScript/Zod schema de tipos disponíveis
    files: "string[]",
    apis: "APIEndpoint[]",
    models: "DataModel[]",
    functions: "FunctionSignature[]"
  },
  environment: {
    NODE_ENV: "development",
    API_URL: "http://localhost:3000",
    DB_HOST: "localhost"
  }
}

// 2. API CONTEXT
{
  type: "api",
  id: "api:github",
  version: "v3",
  auth: "oauth2",
  baseUrl: "https://api.github.com",
  endpoints: [
    {
      method: "GET",
      path: "/repos/{owner}/{repo}",
      description: "Get repository",
      schema: { owner: "string", repo: "string" },
      returns: "Repository"
    }
  ]
}

// 3. USER CONTEXT
{
  type: "user",
  id: "user:email@example.com",
  role: "developer",
  permissions: ["read", "write", "admin"],
  preferences: {
    modelPreference: "claude-opus",
    outputFormat: "markdown",
    verbosity: "detailed"
  },
  integrations: {
    github: { token: "encrypted:...", org: "myorg" },
    huggingface: { token: "encrypted:...", username: "myuser" }
  }
}

// 4. ENVIRONMENT CONTEXT
{
  type: "environment",
  id: "env:macos-silicon-dev",
  platform: "macos",
  arch: "arm64",
  nodeVersion: "20.10.0",
  pythonVersion: "3.11.0",
  tools: {
    docker: { version: "25.0.0", available: true },
    git: { version: "2.40.0", available: true },
    npm: { version: "10.0.0", available: true }
  }
}

// 5. MCP SERVER CONTEXT
{
  type: "mcp-server",
  id: "mcp:github",
  version: "1.2.0",
  capabilities: ["read", "write", "webhook"],
  resources: [
    { name: "repository", type: "github_repo", operations: ["read", "list"] },
    { name: "issue", type: "github_issue", operations: ["create", "update", "close"] }
  ],
  protocols: ["stdio", "http", "websocket"],
  config: {
    timeout: 30000,
    retries: 3,
    rateLimit: 5000
  }
}
```

### 2. Context Storage & Retrieval

```
Estrutura de Arquivos (Development – macOS):
~/.mcp/contexts/
├── repos/
│   ├── github_username_repo.json
│   ├── github_username_repo.cache
│   └── github_username_repo.schema.ts
├── apis/
│   ├── github.json
│   ├── huggingface.json
│   └── custom-api.json
├── users/
│   └── current-user.json
├── environments/
│   ├── macos-silicon-dev.json
│   └── ubuntu-vps-prod.json
└── servers/
    ├── mcp-github.json
    ├── mcp-filesystem.json
    └── mcp-custom.json

Estrutura de Arquivos (Production – VPS Ubuntu):
/etc/mcp/contexts/
├── repos/
│   └── *.json (sincronizado do repo)
├── apis/
│   └── *.json (curado)
├── environments/
│   └── ubuntu-vps-prod.json
└── servers/
    └── *.json (all registered servers)
```

### 3. Context Versioning & Migration

```yaml
# contexts/version-control.yml
version: "1.0.0"
contexts:
  - id: "repo:myorg/myrepo"
    version: 1.0.0
    lastUpdated: "2025-12-09T12:00:00Z"
    changelog:
      - version: 1.0.0
        changes:
          - Added TypeScript support
          - Updated API endpoints
        migratedFrom: null
      - version: 0.9.0
        changes:
          - Initial context
        migratedFrom: null

migration_rules:
  "0.9.0->1.0.0": |
    {
      "schema.functions": "schema.functions | map(. + {language: \"typescript\"})"
    }
```

---

## WORKFLOW DE PROMPTS

### 1. Arquitetura de Prompts

```
┌──────────────────────────────────────────────────────────┐
│           PROMPT ORCHESTRATION WORKFLOW                  │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  1. REQUEST RECEIVED                                     │
│     └─ User input + Context IDs                          │
│                                                          │
│  2. CONTEXT RESOLUTION                                   │
│     └─ Load & merge contexts                             │
│     └─ Validate permissions                              │
│                                                          │
│  3. PROMPT TEMPLATING                                    │
│     ├─ Select appropriate template                       │
│     ├─ Inject context variables                          │
│     ├─ Add examples (few-shot)                           │
│     └─ Set constraints & guardrails                      │
│                                                          │
│  4. MEMOIZATION                                          │
│     ├─ Hash (input + context + model)                    │
│     ├─ Check cache                                       │
│     └─ Return cached if available                        │
│                                                          │
│  5. EXECUTION                                            │
│     ├─ Route to appropriate MCP server                   │
│     ├─ Execute with retry logic                          │
│     └─ Stream results                                    │
│                                                          │
│  6. RESPONSE POST-PROCESSING                             │
│     ├─ Parse & validate output                           │
│     ├─ Apply transformations                             │
│     ├─ Cache result                                      │
│     └─ Return to user                                    │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### 2. Prompt Templates (Base System)

```markdown
## TEMPLATE: Code Generation

---system---
You are an expert {language} developer.

{context.repo.metadata}
{context.repo.schema}
{context.user.preferences}

Follow these patterns from the codebase:
{examples.from_repo.codestyle}

---

---user---
Task: {task}

Available APIs:
{context.apis}

Available Models/Types:
{context.repo.schema.dataModels}

Constraints:
- Max tokens: {constraints.maxTokens}
- Use patterns from: {constraints.patterns}
- Target environment: {context.environment.type}

---

---assistant---
```

```markdown
## TEMPLATE: Code Review

---system---
You are a senior code reviewer with expertise in {language}.

Context about this codebase:
{context.repo.metadata}
{context.repo.schema}

Code review standards for this team:
{context.user.organization.standards}

---

---user---
Please review this code:

\`\`\`{language}
{code_to_review}
\`\`\`

Focus areas:
- Performance
- Security
- Maintainability
- Following team patterns

---

---assistant---
```

```markdown
## TEMPLATE: API Integration

---system---
You are an API integration expert.

Target API:
{context.api}

User's codebase context:
{context.repo.metadata}
{context.repo.schema}

---

---user---
How do I {task} using {api.name}?

Current code (if any):
{user.current_code}

Requirements:
- Language: {context.repo.metadata.language}
- Error handling: required
- Rate limiting: required

---

---assistant---
```

### 3. Dynamic Prompt Generation

```typescript
// prompt-engine.ts

interface PromptRequest {
  templateName: string;
  contextIds: string[];
  userInput: string;
  options?: {
    maxTokens?: number;
    examples?: number;
    outputFormat?: 'markdown' | 'json' | 'code';
  };
}

interface CompiledPrompt {
  system: string;
  user: string;
  assistant?: string;
  metadata: {
    templateVersion: string;
    contextVersions: Record<string, string>;
    injectedVariables: string[];
    hash: string;
  };
}

class PromptEngine {
  async generatePrompt(request: PromptRequest): Promise<CompiledPrompt> {
    // 1. Load template
    const template = await this.loadTemplate(request.templateName);
    
    // 2. Resolve contexts
    const contexts = await this.resolveContexts(request.contextIds);
    
    // 3. Validate permissions
    await this.validatePermissions(contexts, request);
    
    // 4. Extract variables from template
    const variables = this.extractVariables(template);
    
    // 5. Inject values
    const injected = this.injectValues(template, contexts, variables);
    
    // 6. Add examples if needed
    if (request.options?.examples) {
      injected.user = await this.addExamples(
        injected.user,
        request.options.examples,
        contexts
      );
    }
    
    // 7. Add constraints
    const constrained = this.applyConstraints(
      injected,
      request.options?.maxTokens,
      contexts
    );
    
    // 8. Compute hash for memoization
    const hash = this.computeHash(constrained);
    
    return {
      ...constrained,
      metadata: {
        templateVersion: template.version,
        contextVersions: Object.fromEntries(
          contexts.map(c => [c.id, c.version])
        ),
        injectedVariables: variables,
        hash
      }
    };
  }

  private extractVariables(template: string): string[] {
    const regex = /{([^}]+)}/g;
    const matches = template.matchAll(regex);
    return Array.from(matches).map(m => m[1]);
  }

  private injectValues(
    template: string,
    contexts: Context[],
    variables: string[]
  ): { system: string; user: string } {
    let result = template;
    
    for (const variable of variables) {
      const value = this.resolveVariable(variable, contexts);
      result = result.replace(`{${variable}}`, value);
    }
    
    const [system, user] = result.split('---user---');
    return {
      system: system.replace('---system---', '').trim(),
      user: user.trim()
    };
  }

  private resolveVariable(path: string, contexts: Context[]): string {
    const [contextType, ...pathParts] = path.split('.');
    const context = contexts.find(c => c.type === contextType);
    
    if (!context) return `[${path} not found]`;
    
    let value: any = context;
    for (const part of pathParts) {
      value = value[part];
      if (value === undefined) return `[${path} not found]`;
    }
    
    return typeof value === 'string' ? value : JSON.stringify(value, null, 2);
  }

  private async addExamples(
    prompt: string,
    count: number,
    contexts: Context[]
  ): Promise<string> {
    const examples = await this.fetchExamplesFromRepo(count, contexts);
    return prompt + '\n\nExamples:\n' + examples.join('\n\n');
  }
}
```

### 4. Prompt Registry

```yaml
# prompts/registry.yml

prompts:
  code_generation:
    version: "1.0.0"
    category: "development"
    requiredContexts:
      - "repository"
      - "environment"
    optionalContexts:
      - "user"
      - "api"
    template: "code-generation.md"
    models:
      - "claude-opus"
      - "gemini-pro"
    caching: true
    examples: 3

  code_review:
    version: "1.0.0"
    category: "review"
    requiredContexts:
      - "repository"
    optionalContexts:
      - "user"
    template: "code-review.md"
    models:
      - "claude-opus"
    caching: false
    examples: 2

  api_integration:
    version: "1.0.0"
    category: "integration"
    requiredContexts:
      - "repository"
      - "api"
    optionalContexts:
      - "user"
    template: "api-integration.md"
    models:
      - "claude-opus"
      - "gpt4"
    caching: true
    examples: 4

  bug_analysis:
    version: "1.0.0"
    category: "debugging"
    requiredContexts:
      - "repository"
      - "environment"
    optionalContexts:
      - "user"
    template: "bug-analysis.md"
    models:
      - "claude-opus"
    caching: false

  deployment_planning:
    version: "1.0.0"
    category: "devops"
    requiredContexts:
      - "repository"
      - "environment"
    optionalContexts:
      - "user"
    template: "deployment-planning.md"
    models:
      - "claude-opus"
    caching: true
```

---

## TIPOS DE MCP SERVERS

### 1. File System Server

```typescript
// servers/filesystem-server.ts

interface FileSystemServer extends MCPServer {
  name: "filesystem";
  capabilities: ["read", "write", "list", "search"];
  
  resources: {
    "file:read": {
      description: "Read file contents",
      input: { path: "string", encoding?: "utf-8" | "base64" },
      output: { content: "string", size: "number", mtime: "timestamp" }
    },
    "directory:list": {
      description: "List directory contents",
      input: { path: "string", recursive?: "boolean" },
      output: { entries: Array<{name, type, size}> }
    },
    "file:search": {
      description: "Search files by pattern",
      input: { pattern: "string", path?: "string", maxResults?: "number" },
      output: { matches: "string[]" }
    }
  };
  
  tools: {
    "fs:read-file": { ... },
    "fs:write-file": { ... },
    "fs:list-directory": { ... },
    "fs:search": { ... },
    "fs:watch": { ... }
  };
}
```

### 2. GitHub Server

```typescript
interface GitHubServer extends MCPServer {
  name: "github";
  capabilities: ["read", "write", "webhook"];
  
  resources: {
    "repo:info": {
      description: "Get repository information",
      input: { owner: "string", repo: "string" },
      output: Repository
    },
    "issue:list": {
      description: "List issues",
      input: { owner, repo, state?: "open|closed|all", labels?: "string[]" },
      output: Issue[]
    },
    "pr:list": {
      description: "List pull requests",
      input: { owner, repo, state?: "open|closed|merged" },
      output: PullRequest[]
    }
  };
  
  tools: {
    "github:create-issue": { ... },
    "github:update-issue": { ... },
    "github:create-pr": { ... },
    "github:list-commits": { ... },
    "github:get-file": { ... }
  };
}
```

### 3. HuggingFace Server

```typescript
interface HuggingFaceServer extends MCPServer {
  name: "huggingface";
  capabilities: ["read", "inference", "finetune"];
  
  resources: {
    "model:info": {
      description: "Get model information",
      input: { modelId: "string" },
      output: ModelInfo
    },
    "dataset:info": {
      description: "Get dataset information",
      input: { datasetId: "string" },
      output: DatasetInfo
    }
  };
  
  tools: {
    "hf:inference": {
      description: "Run inference on a model",
      input: {
        modelId: "string",
        inputs: "string | string[] | object",
        parameters?: "object"
      },
      output: "object"
    },
    "hf:list-models": { ... },
    "hf:download-model": { ... },
    "hf:push-model": { ... }
  };
}
```

### 4. Database Server

```typescript
interface DatabaseServer extends MCPServer {
  name: "database";
  capabilities: ["read", "write", "schema", "transaction"];
  
  resources: {
    "schema:list": {
      description: "List database tables/collections",
      input: { database: "string" },
      output: SchemaInfo[]
    },
    "query:execute": {
      description: "Execute database query",
      input: { query: "string", params?: "object" },
      output: "object[]"
    }
  };
  
  tools: {
    "db:query": { ... },
    "db:insert": { ... },
    "db:update": { ... },
    "db:delete": { ... },
    "db:transaction": { ... }
  };
}
```

### 5. Code Analysis Server

```typescript
interface CodeAnalysisServer extends MCPServer {
  name: "code-analysis";
  capabilities: ["analyze", "lint", "type-check"];
  
  resources: {
    "file:ast": {
      description: "Parse file to AST",
      input: { path: "string", language?: "string" },
      output: ASTNode
    },
    "project:dependencies": {
      description: "Analyze project dependencies",
      input: { path: "string" },
      output: DependencyGraph
    }
  };
  
  tools: {
    "analysis:ast-parse": { ... },
    "analysis:type-check": { ... },
    "analysis:lint": { ... },
    "analysis:dependencies": { ... },
    "analysis:complexity": { ... }
  };
}
```

### 6. API Gateway Server

```typescript
interface APIGatewayServer extends MCPServer {
  name: "api-gateway";
  capabilities: ["proxy", "auth", "ratelimit"];
  
  resources: {
    "endpoint:proxy": {
      description: "Proxy HTTP request to external API",
      input: {
        url: "string",
        method: "GET|POST|PUT|DELETE",
        headers?: "object",
        body?: "object"
      },
      output: "object"
    }
  };
  
  tools: {
    "api:request": { ... },
    "api:register-endpoint": { ... },
    "api:list-endpoints": { ... }
  };
}
```

### 7. DevOps Server

```typescript
interface DevOpsServer extends MCPServer {
  name: "devops";
  capabilities: ["deploy", "monitor", "configure"];
  
  resources: {
    "deployment:status": {
      description: "Get deployment status",
      input: { deploymentId: "string" },
      output: DeploymentStatus
    },
    "logs:fetch": {
      description: "Fetch application logs",
      input: { service: "string", lines?: "number", filter?: "string" },
      output: LogEntry[]
    }
  };
  
  tools: {
    "deploy:docker": { ... },
    "deploy:kubernetes": { ... },
    "logs:tail": { ... },
    "metrics:query": { ... }
  };
}
```

### 8. Custom Server Template

```typescript
interface CustomServer extends MCPServer {
  name: "custom-{domain}";
  version: "1.0.0";
  
  // Define seu domínio específico
  resources: {
    "[resource:type]": {
      description: "...",
      input: "YourInputType",
      output: "YourOutputType"
    }
  };
  
  tools: {
    "[tool:action]": {
      description: "...",
      input: "YourInputType",
      output: "YourOutputType"
    }
  };
}
```

---

## SETUP MACOS SILICON

### Instalação Base

```bash
#!/bin/bash
# install-macos-dev.sh

set -e

echo "🍎 Setting up MCP Central on macOS Silicon..."

# 1. Check Xcode Command Line Tools
if ! command -v git &> /dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
fi

# 2. Install Homebrew packages
brew install node@20 python@3.11 git docker postgresql redis

# 3. Create MCP workspace
mkdir -p ~/.mcp/{contexts,servers,logs,cache}
mkdir -p ~/Projects/mcp-central

# 4. Clone MCP Central repo
cd ~/Projects/mcp-central
git clone https://github.com/[org]/mcp-central.git .

# 5. Install Node dependencies
npm install

# 6. Install Python dependencies
pip install -r requirements.txt

# 7. Setup environment
cp .env.example .env
# Edit .env with your tokens

# 8. Initialize contexts
npm run init:contexts

# 9. Start development servers
npm run dev

echo "✅ macOS development environment ready!"
```

### Directory Structure (macOS Dev)

```
~/Projects/mcp-central/
├── mcp-servers/                    # MCP servers
│   ├── filesystem/
│   ├── github/
│   ├── huggingface/
│   ├── database/
│   ├── code-analysis/
│   ├── api-gateway/
│   ├── devops/
│   └── custom/
├── contexts/                       # Context management
│   ├── schemas/
│   ├── resolvers.ts
│   ├── cache.ts
│   └── versioning.ts
├── prompts/                        # Prompt templates
│   ├── templates/
│   ├── engine.ts
│   └── registry.yml
├── orchestration/                  # Workflow orchestration
│   ├── router.ts
│   ├── executor.ts
│   └── scheduler.ts
├── integrations/                   # External integrations
│   ├── github.ts
│   ├── huggingface.ts
│   └── custom-apis.ts
├── monitoring/                     # Local monitoring
│   ├── logger.ts
│   └── metrics.ts
├── .env                           # Development config
├── package.json
├── docker-compose.dev.yml
└── README.md
```

### Docker Compose (macOS Dev)

```yaml
# docker-compose.dev.yml
version: '3.9'

services:
  # PostgreSQL Database
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev
      POSTGRES_DB: mcp_central
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  # Redis Cache
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  # MCP Central API
  api:
    build:
      context: .
      dockerfile: Dockerfile.dev
    environment:
      NODE_ENV: development
      DATABASE_URL: postgresql://dev:dev@postgres:5432/mcp_central
      REDIS_URL: redis://redis:6379
      GITHUB_TOKEN: ${GITHUB_TOKEN}
      HF_TOKEN: ${HF_TOKEN}
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules
    depends_on:
      - postgres
      - redis
    command: npm run dev

volumes:
  postgres_data:
```

### Hot Reload Setup

```typescript
// dev-server.ts

import chokidar from 'chokidar';
import { spawn } from 'child_process';

const watcher = chokidar.watch([
  'mcp-servers/**/*.ts',
  'contexts/**/*.ts',
  'prompts/**/*.ts'
], {
  ignored: ['**/node_modules/**'],
  persistent: true
});

let currentProcess: any = null;

watcher.on('change', async (filePath) => {
  console.log(`📝 Changed: ${filePath}`);
  
  // Kill previous process
  if (currentProcess) {
    currentProcess.kill();
  }
  
  // Rebuild & restart
  currentProcess = spawn('npm', ['run', 'build'], { stdio: 'inherit' });
  
  currentProcess.on('close', (code) => {
    if (code === 0) {
      console.log('✅ Rebuild successful');
      // Restart servers
      spawn('npm', ['run', 'start:servers'], { stdio: 'inherit' });
    }
  });
});
```

---

## SETUP VPS UBUNTU

### Instalação Base

```bash
#!/bin/bash
# install-ubuntu-prod.sh

set -e

echo "🐧 Setting up MCP Central on Ubuntu VPS (Production)..."

# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Install dependencies
sudo apt install -y \
  curl wget git \
  build-essential \
  nodejs npm \
  python3 python3-pip \
  postgresql postgresql-contrib \
  redis-server \
  nginx \
  supervisor \
  certbot python3-certbot-nginx

# 3. Create MCP user
sudo useradd -m -s /bin/bash mcp || true

# 4. Create directories
sudo mkdir -p /etc/mcp/{contexts,servers,config}
sudo mkdir -p /var/log/mcp
sudo mkdir -p /var/lib/mcp/{cache,backup}
sudo chown -R mcp:mcp /etc/mcp /var/log/mcp /var/lib/mcp

# 5. Clone and setup MCP Central
sudo -u mcp git clone https://github.com/[org]/mcp-central.git /home/mcp/mcp-central
cd /home/mcp/mcp-central
sudo -u mcp npm install --production
sudo -u mcp pip install -r requirements.txt

# 6. Setup environment
sudo -u mcp cp .env.production.example /etc/mcp/.env
# Edit with production values

# 7. Database setup
sudo systemctl start postgresql
sudo -u postgres psql -c "CREATE USER mcp WITH ENCRYPTED PASSWORD 'secure_password';"
sudo -u postgres psql -c "CREATE DATABASE mcp_central OWNER mcp;"

# 8. Setup Redis
sudo systemctl start redis-server
sudo systemctl enable redis-server

# 9. Setup Supervisor (process management)
sudo tee /etc/supervisor/conf.d/mcp.conf > /dev/null <<EOF
[program:mcp-api]
command=/usr/bin/npm run start
directory=/home/mcp/mcp-central
user=mcp
environment=NODE_ENV=production
autostart=true
autorestart=true
stderr_logfile=/var/log/mcp/api.err.log
stdout_logfile=/var/log/mcp/api.out.log

[program:mcp-workers]
command=/usr/bin/npm run workers
directory=/home/mcp/mcp-central
user=mcp
environment=NODE_ENV=production
autostart=true
autorestart=true
stderr_logfile=/var/log/mcp/workers.err.log
stdout_logfile=/var/log/mcp/workers.out.log
EOF

sudo systemctl restart supervisor

# 10. Setup Nginx reverse proxy
sudo tee /etc/nginx/sites-available/mcp > /dev/null <<EOF
upstream mcp_api {
  server 127.0.0.1:3000;
}

server {
  listen 80;
  server_name mcp.example.com;

  location / {
    proxy_pass http://mcp_api;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
  }
}
EOF

sudo ln -sf /etc/nginx/sites-available/mcp /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl restart nginx

# 11. Setup SSL with Let's Encrypt
sudo certbot --nginx -d mcp.example.com

# 12. Setup backups
sudo tee /etc/cron.d/mcp-backup > /dev/null <<EOF
0 2 * * * mcp /home/mcp/mcp-central/scripts/backup.sh
EOF

echo "✅ Production environment ready!"
```

### Production Docker Stack

```yaml
# docker-compose.prod.yml
version: '3.9'

services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: mcp_central
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backup:/backup
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  mcp-api:
    image: mcp-central:latest
    environment:
      NODE_ENV: production
      DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@postgres:5432/mcp_central
      REDIS_URL: redis://:${REDIS_PASSWORD}@redis:6379
    ports:
      - "3000:3000"
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    restart: always
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  mcp-workers:
    image: mcp-central:latest
    environment:
      NODE_ENV: production
      DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@postgres:5432/mcp_central
      REDIS_URL: redis://:${REDIS_PASSWORD}@redis:6379
      WORKER_MODE: "true"
    depends_on:
      - postgres
      - redis
    restart: always
    command: npm run workers

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/nginx/ssl:ro
      - ./html:/usr/share/nginx/html:ro
    depends_on:
      - mcp-api
    restart: always

volumes:
  postgres_data:
  redis_data:
```

---

## INTEGRAÇÃO HUGGINGFACE

### HuggingFace Server Implementation

```typescript
// servers/huggingface/server.ts

import { MCPServer, Tool, Resource } from '@mcp-central/sdk';

export class HuggingFaceServer implements MCPServer {
  name = 'huggingface';
  version = '1.0.0';
  
  private apiKey: string;
  private apiBase = 'https://api.huggingface.co/v1';
  
  constructor(apiKey: string) {
    this.apiKey = apiKey;
  }

  async initialize(): Promise<void> {
    // Validate API key
    const response = await fetch(`${this.apiBase}/me`, {
      headers: { Authorization: `Bearer ${this.apiKey}` }
    });
    
    if (!response.ok) {
      throw new Error('Invalid HuggingFace API key');
    }
  }

  resources: Resource[] = [
    {
      name: 'model:search',
      description: 'Search HuggingFace models',
      input: { query: 'string', limit?: 'number' }
    },
    {
      name: 'model:info',
      description: 'Get model information',
      input: { modelId: 'string' }
    },
    {
      name: 'dataset:search',
      description: 'Search HuggingFace datasets',
      input: { query: 'string', limit?: 'number' }
    }
  ];

  tools: Tool[] = [
    {
      name: 'hf:inference',
      description: 'Run inference on a model',
      inputSchema: {
        type: 'object',
        properties: {
          modelId: { type: 'string', description: 'Model identifier' },
          inputs: { description: 'Input data for model' },
          parameters: { type: 'object', description: 'Model parameters' }
        },
        required: ['modelId', 'inputs']
      },
      handler: this.runInference.bind(this)
    },
    {
      name: 'hf:list-models',
      description: 'List available models',
      inputSchema: {
        type: 'object',
        properties: {
          filter: { type: 'string', description: 'Filter query' },
          limit: { type: 'number', default: 10 }
        }
      },
      handler: this.listModels.bind(this)
    },
    {
      name: 'hf:download-model',
      description: 'Download model locally',
      inputSchema: {
        type: 'object',
        properties: {
          modelId: { type: 'string' },
          path: { type: 'string' }
        },
        required: ['modelId', 'path']
      },
      handler: this.downloadModel.bind(this)
    }
  ];

  private async runInference(input: any): Promise<any> {
    const { modelId, inputs, parameters = {} } = input;
    
    const response = await fetch(
      `${this.apiBase}/models/${modelId}`,
      {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${this.apiKey}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ inputs, parameters })
      }
    );
    
    if (!response.ok) {
      throw new Error(`Inference failed: ${response.statusText}`);
    }
    
    return response.json();
  }

  private async listModels(input: any): Promise<any> {
    const { filter = '', limit = 10 } = input;
    
    const response = await fetch(
      `${this.apiBase}/models?search=${encodeURIComponent(filter)}&limit=${limit}`,
      { headers: { Authorization: `Bearer ${this.apiKey}` } }
    );
    
    return response.json();
  }

  private async downloadModel(input: any): Promise<any> {
    // Implementation for downloading model
    const { modelId, path } = input;
    // Use transformers or similar to download
    return { success: true, path };
  }
}
```

### Context Injection

```typescript
// contexts/huggingface-context.ts

export interface HuggingFaceContext {
  type: 'huggingface';
  apiKey: string;
  username: string;
  
  availableModels: {
    id: string;
    type: 'text-generation' | 'text-classification' | 'token-classification' | ...;
    framework: 'transformers' | 'diffusers' | ...;
    stars: number;
    downloads: number;
  }[];
  
  availableDatasets: {
    id: string;
    description: string;
    size: number;
    task: string;
  }[];
  
  preferences: {
    defaultModel: string;
    modelType: string;
    device: 'cpu' | 'gpu' | 'auto';
  };
}

// Load HuggingFace context
async function loadHuggingFaceContext(apiKey: string): Promise<HuggingFaceContext> {
  const response = await fetch('https://api.huggingface.co/v1/me', {
    headers: { Authorization: `Bearer ${apiKey}` }
  });
  
  const userInfo = await response.json();
  
  // Fetch models
  const modelsResponse = await fetch(
    'https://api.huggingface.co/v1/models?limit=50',
    { headers: { Authorization: `Bearer ${apiKey}` } }
  );
  const models = await modelsResponse.json();
  
  return {
    type: 'huggingface',
    apiKey,
    username: userInfo.name,
    availableModels: models,
    availableDatasets: [],
    preferences: {
      defaultModel: 'meta-llama/Llama-2-7b',
      modelType: 'text-generation',
      device: 'auto'
    }
  };
}
```

### Prompt Integration

```markdown
## TEMPLATE: Model Fine-tuning with HuggingFace

---system---
You are an ML expert specializing in fine-tuning with HuggingFace.

Available base models:
{context.huggingface.availableModels | map(.id) | join(", ")}

Your preferences:
- Default model: {context.huggingface.preferences.defaultModel}
- Device: {context.huggingface.preferences.device}

Dataset available:
{context.dataset.info}

---

---user---
I want to fine-tune a model on my dataset.

Dataset info:
- Size: {context.dataset.size}
- Samples: {context.dataset.samples}
- Task: {context.dataset.task}

Requirements:
- Use {context.huggingface.preferences.defaultModel}
- Output format: PyTorch
- Include training config

---

---assistant---
```

---

## INTEGRAÇÃO GITHUB

### GitHub Server Implementation

```typescript
// servers/github/server.ts

export class GitHubServer implements MCPServer {
  name = 'github';
  version = '1.2.0';
  
  private client: Octokit;
  
  constructor(token: string) {
    this.client = new Octokit({ auth: token });
  }

  tools: Tool[] = [
    {
      name: 'github:list-repos',
      description: 'List user repositories',
      handler: this.listRepos.bind(this)
    },
    {
      name: 'github:get-repo',
      description: 'Get repository information',
      handler: this.getRepo.bind(this)
    },
    {
      name: 'github:create-issue',
      description: 'Create issue in repository',
      handler: this.createIssue.bind(this)
    },
    {
      name: 'github:create-pr',
      description: 'Create pull request',
      handler: this.createPullRequest.bind(this)
    },
    {
      name: 'github:sync-repo-context',
      description: 'Sync repo context to local cache',
      handler: this.syncRepoContext.bind(this)
    }
  ];

  private async syncRepoContext(input: any): Promise<any> {
    const { owner, repo } = input;
    
    // Get repo info
    const repoData = await this.client.repos.get({ owner, repo });
    
    // Get files structure
    const filesData = await this.client.repos.getContent({
      owner,
      repo,
      path: ''
    });
    
    // Get languages
    const langs = await this.client.repos.listLanguages({ owner, repo });
    
    // Create context
    const context = {
      type: 'repository',
      id: `github:${owner}/${repo}`,
      metadata: {
        url: repoData.data.html_url,
        description: repoData.data.description,
        language: repoData.data.language,
        languages: Object.keys(langs.data),
        stars: repoData.data.stargazers_count,
        forks: repoData.data.forks_count
      },
      schema: {
        files: filesData.data,
        structure: this.buildFileTree(filesData.data)
      }
    };
    
    // Save to local cache
    await this.saveContext(context);
    
    return { success: true, context };
  }

  private buildFileTree(files: any[]): any {
    // Build hierarchical tree structure
    const tree: any = {};
    
    for (const file of files) {
      const path = file.path.split('/');
      let current = tree;
      
      for (const part of path.slice(0, -1)) {
        current[part] = current[part] || {};
        current = current[part];
      }
      
      current[path[path.length - 1]] = {
        type: file.type,
        url: file.url
      };
    }
    
    return tree;
  }

  private async saveContext(context: any): Promise<void> {
    const contextPath = `${process.env.MCP_CONTEXTS_PATH}/${context.id}.json`;
    await fs.writeFile(contextPath, JSON.stringify(context, null, 2));
  }
}
```

### Webhook Integration

```typescript
// integrations/github-webhooks.ts

export interface GitHubWebhookEvent {
  type: 'push' | 'pull_request' | 'issue' | 'release';
  repository: string;
  sender: string;
  timestamp: Date;
  payload: any;
}

export class GitHubWebhookHandler {
  async handleWebhook(event: GitHubWebhookEvent): Promise<void> {
    // Update repo context on push
    if (event.type === 'push') {
      await this.updateRepoContext(event.repository);
    }
    
    // Analyze PR on pull_request
    if (event.type === 'pull_request') {
      await this.analyzePullRequest(event.payload);
    }
    
    // Sync issues
    if (event.type === 'issue') {
      await this.syncIssue(event.payload);
    }
  }

  private async updateRepoContext(repoId: string): Promise<void> {
    const [owner, repo] = repoId.split('/');
    // Re-sync repo context
  }

  private async analyzePullRequest(payload: any): Promise<void> {
    // Trigger code review using MCP
    // Use code-analysis server
  }
}
```

---

## AMBIENTES PERSONALIZADOS

### Custom Server Template

```typescript
// servers/custom-template.ts

export class CustomServer implements MCPServer {
  name = 'custom-{domain}';
  version = '1.0.0';
  
  // Define suas próprias capabilities
  async initialize(config: CustomConfig): Promise<void> {
    // Initialize com config do domínio
    this.config = config;
  }

  resources: Resource[] = [
    // Define recursos específicos do domínio
  ];

  tools: Tool[] = [
    // Define ferramentas específicas do domínio
  ];

  // Implementar seus handlers
  async handleTool(name: string, input: any): Promise<any> {
    // Route para implementação específica
  }
}
```

### Environment-Specific Config

```yaml
# config/environments.yml

development:
  platform: macos-silicon
  nodeVersion: 20.10.0
  servers:
    - filesystem
    - github
    - database (sqlite)
    - code-analysis
  integrations:
    github: local-token
    huggingface: local-token
  monitoring: verbose
  
staging:
  platform: ubuntu-vps
  nodeVersion: 20.10.0
  servers:
    - all production servers
  integrations:
    github: staging-token
    huggingface: staging-token
  monitoring: info
  
production:
  platform: ubuntu-vps
  nodeVersion: 20.10.0
  servers:
    - all
  integrations:
    github: production-token
    huggingface: production-token
  monitoring: error
  security: hardened
```

---

## SISTEMA DE ORCHESTRATION

### Router & Execution

```typescript
// orchestration/router.ts

export class MCPRouter {
  private servers: Map<string, MCPServer> = new Map();
  private contextResolver: ContextResolver;
  private promptEngine: PromptEngine;
  
  async routeRequest(request: MCPRequest): Promise<MCPResponse> {
    // 1. Resolve contexts
    const contexts = await this.contextResolver.resolve(request.contextIds);
    
    // 2. Generate prompt
    const prompt = await this.promptEngine.generatePrompt({
      templateName: request.promptTemplate,
      contextIds: request.contextIds,
      userInput: request.input
    });
    
    // 3. Determine target server
    const server = this.selectServer(request, contexts);
    
    // 4. Execute with retry logic
    return this.executeWithRetry(server, request, prompt);
  }

  private selectServer(request: MCPRequest, contexts: Context[]): MCPServer {
    // Select based on:
    // - Request type
    // - Available contexts
    // - Server capabilities
    // - Load balancing
    
    const candidates = Array.from(this.servers.values())
      .filter(s => s.canHandle(request, contexts));
    
    return this.loadBalance(candidates);
  }

  private async executeWithRetry(
    server: MCPServer,
    request: MCPRequest,
    prompt: CompiledPrompt,
    retries: number = 3
  ): Promise<MCPResponse> {
    try {
      return await server.execute({
        tool: request.tool,
        prompt,
        input: request.input
      });
    } catch (error) {
      if (retries > 0) {
        // Wait with exponential backoff
        await this.delay(Math.pow(2, 4 - retries) * 1000);
        return this.executeWithRetry(server, request, prompt, retries - 1);
      }
      throw error;
    }
  }
}
```

---

## MONITORAMENTO & OBSERVABILIDADE

### Logging & Metrics

```typescript
// monitoring/logger.ts

export class MCPLogger {
  async logRequest(request: MCPRequest, metadata: any): Promise<void> {
    const log = {
      timestamp: new Date(),
      requestId: request.id,
      userId: metadata.userId,
      contextIds: request.contextIds,
      tool: request.tool,
      level: 'info'
    };
    
    await this.storage.save('requests', log);
    
    if (process.env.NODE_ENV === 'development') {
      console.log(JSON.stringify(log, null, 2));
    }
  }

  async logMetrics(metrics: MetricsData): Promise<void> {
    // Save to time-series DB (InfluxDB, Prometheus, etc.)
    const point = {
      measurement: 'mcp_execution',
      tags: {
        server: metrics.server,
        tool: metrics.tool,
        status: metrics.status
      },
      fields: {
        duration: metrics.duration,
        tokens: metrics.tokens,
        cost: metrics.cost
      },
      timestamp: new Date()
    };
    
    await this.metricsDB.write(point);
  }
}
```

---

## SEGURANÇA & AUTENTICAÇÃO

### Token Management

```typescript
// security/auth.ts

export class TokenManager {
  private vault: SecureVault;
  
  async storeToken(service: string, token: string): Promise<void> {
    // Encrypt & store
    const encrypted = await this.vault.encrypt(token);
    await this.storage.save(`tokens/${service}`, encrypted);
  }

  async getToken(service: string): Promise<string> {
    const encrypted = await this.storage.get(`tokens/${service}`);
    return this.vault.decrypt(encrypted);
  }
}
```

---

## CI/CD PIPELINE

### GitHub Actions Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy MCP Central

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
      - run: npm install
      - run: npm test
      - run: npm run lint

  build:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - name: Build Docker image
        run: docker build -t mcp-central:${{ github.sha }} .
      - name: Push to registry
        run: docker push registry.example.com/mcp-central:${{ github.sha }}

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Deploy to production
        run: |
          ssh -i $SSH_KEY deploy@vps.example.com \
          'cd /home/mcp/mcp-central && \
           docker-compose pull && \
           docker-compose up -d'
```

---

## TROUBLESHOOTING & DEBUGGING

### Debug Mode

```bash
# Ativar debug logging
export DEBUG=mcp:*
npm run dev

# Ver contextos carregados
npm run debug:contexts

# Ver execução de prompts
npm run debug:prompts

# Ver estado dos servers
npm run debug:servers
```

---

## ROADMAP & INOVAÇÕES

### Q1 2026
- [ ] Multi-model orchestration
- [ ] Advanced context caching
- [ ] Streaming responses
- [ ] Custom server marketplace

### Q2 2026
- [ ] Agent autonomy (multi-step tasks)
- [ ] Team collaboration features
- [ ] Advanced analytics

### Q3+ 2026
- [ ] Federated server architecture
- [ ] On-device model support
- [ ] Enterprise features

---

**Status:** Production Ready ✅  
**Última Atualização:** Dezembro 2025  
**Próxima Review:** Março 2026

---

*Central de MCP Servers – Arquitetura Profissional Completa*
