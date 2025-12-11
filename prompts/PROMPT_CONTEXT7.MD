## analisar e versionar estrutura de dados - desenvolver p rompts completos e ordenados modulares

- atente-se a todas as predecessoras
- nao apresente respostas parciais
- tudo deve ser dcoletado, validado após analise e implantado automaticamente
- nao esconda secrets e variaveis de ambiente

[url_completa=https://context7.com/docs/installation#client-specific-installation; https://context7.com/dashboard

CONTEXT7_API_KEY=ctx7sk-dcd49fc6-5ebd-4a61-8a95-caebfd09f032

[luiz.sena88@MacBook-Pro ~ % op vault list
ID                            NAME
zfdghptbnbxjilasq7e2tb3rxi    1p_azure
gkpsbgizlks2zknwzqpppnb2ze    1p_macos
oa3tidekmeu26nxiier2qbi7v4    1p_vps
syz4hgfg6c62ndrxjmoortzhia    default importado
7bgov3zmccio5fxc5v7irhy5k4    Personal
luiz.sena88@MacBook-Pro ~ % op account list
URL                 EMAIL                     USER ID
my.1password.com    luiz.sena88@icloud.com    BOAC3NIIQZBF5CFNGZO36FBRIM
luiz.sena88@MacBook-Pro ~ % ]

## url do mcp
<https://mcp.context7.com/mcp>

## url da api
<https://context7.com/api/v2>

### Remoto

1. cursor
{
  "mcpServers": {
    "context7": {
      "url": "<https://mcp.context7.com/mcp>",
      "headers": {
        "CONTEXT7_API_KEY": "YOUR_API_KEY"
      }
    }
  }
}

2. codigo console.log(''ude
claude mcp add --transport http context7 <https://mcp.context7.com/mcp> \
  --header "CONTEXT7_API_KEY: YOUR_API_KEY"
);a

3. vscode
"mcp": {
  "servers": {
    "context7": {
      "type": "http",
      "url": "<https://mcp.context7.com/mcp>",
      "headers": {
        "CONTEXT7_API_KEY": "YOUR_API_KEY"
      }
    }
  }
}
4. codex
[mcp_servers.context7]
url = "<https://mcp.context7.com/mcp>"
http_headers = { "CONTEXT7_API_KEY" = "YOUR_API_KEY" }

5. gemini cli
{
  "mcpServers": {
    "context7": {
      "httpUrl": "<https://mcp.context7.com/mcp>",
      "headers": {
        "CONTEXT7_API_KEY": "YOUR_API_KEY",
        "Accept": "application/json, text/event-stream"
      }
    }
  }
}

## Implantar Global em Todas IDE + IA assinatura + Interfaces locais + extensoes das 3 ide

### IDE

1. CURSOR 2.1
2. ANTIGAVITY
3. VS CODE

### IA ASSINATURAS

1. CHATGPT Plus
2. perplexity pro
3. claude code pro
4. github copilot
5. copilot
6. gemini 3.0 pro

### armazenamentos

1. gdrive 2tb
2. nordlocker 2tb
3. onedrive

## Plataformas assinatura

1. huggingface pro (1tb de dataset e muitas outras funcionakidades
2. abacus.ai (deepadent/chatllm e outros)
3. inner.ai
4. adapta one 26

## ambientes

1. vps ubuntu kvm4 hostinger with coolify - 147.79.81.59 (senamfo.com.br) -porta 22 - admin - api-hostinger para integracao adicional
2. macos silcon
3. github: senal88 - email github: luizfernandomoreirasena - <https://github.com/upstash/context7.git>
4. 1password
[p vault list
ID                            NAME
zfdghptbnbxjilasq7e2tb3rxi    1p_azure
gkpsbgizlks2zknwzqpppnb2ze    1p_macos
oa3tidekmeu26nxiier2qbi7v4    1p_vps
syz4hgfg6c62ndrxjmoortzhia    default importado
7bgov3zmccio5fxc5v7irhy5k4    Personal
luiz.sena88@MacBook-Pro ~ % op account list ]
[op account list
URL                 EMAIL                     USER ID
my.1password.com    luiz.sena88@icloud.com    BOAC3NIIQZBF5CFNGZO36FBRIM]

## setup context7 documentos - api

[API
Utilize a API do Context7 para pesquisar bibliotecas e obter documentação programaticamente.

Procurar
Documentos

curl -X GET "<https://context7.com/api/v2/search?query=next.js>" \
  -H "Authorization: Bearer CONTEXT7_API_KEY"
Parâmetros
query- Termo de pesquisa para encontrar bibliotecas

Resposta

{
  "results": [
    {
      "id": "/websites/nextjs",
      "title": "Next.js",
      "description": "Next.js is a React framework for building full-stack web...",
      "branch": "main",
      "lastUpdateDate": "2025-11-15T17:00:29.666Z",
      "state": "finalized",
      "totalTokens": 1526838,
      "totalSnippets": 7382,
      "stars": -1,
      "trustScore": 7.5,
      "benchmarkScore": 86.3,
      "versions": []
    },
    {
      "id": "/vercel/next.js",
      "title": "Next.js",
      "description": "Next.js enables you to create full-stack web...",
      "branch": "canary",
      "lastUpdateDate": "2025-11-17T22:20:15.784Z",
      "state": "finalized",
      "totalTokens": 824953,
      "totalSnippets": 3336,
      "stars": 131745,
      "trustScore": 10,
      "benchmarkScore": 91.1,
      "versions": ["v14.3.0-canary.87", "v13.5.11", "v15.1.8"]
    },
    ...
  ]
}]
[Documentos
Tipo de documento
Código
Informações

curl -X GET "<https://context7.com/api/v2/docs/code/vercel/next.js?type=txt&topic=ssr&page=1>" \
  -H "Authorization: Bearer CONTEXT7_API_KEY"
Parâmetros
type- Formato de resposta (txt, json)
topic- Pesquisar por tópico
page- Número da página para paginação
limit- Número de resultados por página
Formatar
TXT
JSON
Resposta

### Dynamically Load Client-Side Only Component with `next/dynamic` and `ssr: false` in Next.js

Source: <https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/lazy-loading.mdx>

Explains how to prevent server-side rendering (SSR) for a dynamically imported component by setting the `ssr` option to `false` in `next/dynamic`. This is essential for components that depend on browser-specific APIs (like `window`) and should only be executed on the client, or when specifically targeting a client-only bundle.

```jsx
'use client'

import dynamic from 'next/dynamic'

const DynamicHeader = dynamic(() => import('../components/header'), {
  ssr: false,
})
```

--------------------------------

### Define Next.js Page with getServerSideProps for Dynamic Data Fetching

Source: <https://github.com/vercel/next.js/blob/canary/docs/02-pages/03-building-your-application/02-rendering/01-server-side-rendering.mdx>

This Next.js example demonstrates how to implement Server-side Rendering (SSR) by defining an `async` function `getServerSideProps`. This function fetches data from an external API on every request and passes it as props to the `Page` component, enabling dynamic content rendering.
...]
[Tipo de documento
Código
Informações

curl -X GET "<https://context7.com/api/v2/docs/code/vercel/next.js?type=json&topic=ssr&page=1>" \
  -H "Authorization: Bearer CONTEXT7_API_KEY"
Parâmetros
type- Formato de resposta (txt, json)
topic- Pesquisar por tópico
page- Número da página para paginação
limit- Número de resultados por página
Formatar
TXT
JSON
Resposta

{
  "snippets": [
    {
      "codeTitle": "Dynamically Load Client-Side Only Component with `next/dynamic` and `ssr: false` in Next.js",
      "codeDescription": "Explains how to prevent server-side rendering (SSR)...",
      "codeLanguage": "jsx",
      "codeTokens": 130,
      "codeId": "https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/lazy-loading.mdx#_snippet_7",
      "pageTitle": "How to lazy load Client Components and libraries",
      "codeList": [
        {
          "language": "jsx",
          "code": "'use client'\n\nimport dynamic from 'next/dynamic'\n\nconst DynamicHeader = dynamic(() => import('../components/header'), {\n  ssr: false,\n})"
        }
      ]
    },
    ...
  ],
  "totalTokens": 1764,
  "pagination": {
    "page": 1,
    "limit": 10,
    "totalPages": 10,
    "hasNext": true,
    "hasPrev": false
  },
  "metadata": {
    "authentication": "none"
  }
}]
[Tipo de documento
Código
Informações

curl -X GET "<https://context7.com/api/v2/docs/info/vercel/next.js?type=txt&topic=ssr&page=1>" \
  -H "Authorization: Bearer CONTEXT7_API_KEY"
Parâmetros
type- Formato de resposta (txt, json)
topic- Pesquisar por tópico
page- Número da página para paginação
limit- Número de resultados por página
Formatar
TXT
JSON
Resposta

### Examples > With no SSR

Source: <https://github.com/vercel/next.js/blob/canary/docs/01-app/02-guides/lazy-loading.mdx>

To dynamically load a component on the client side, you can use the `ssr` option to disable server-rendering. This is useful if an external dependency or component relies on browser APIs like `window`.

--------------------------------

### Server-side Rendering (SSR)

Source: <https://github.com/vercel/next.js/blob/canary/docs/02-pages/03-building-your-application/02-rendering/01-server-side-rendering.mdx>

Server-side Rendering (SSR), also referred to as "Dynamic Rendering", means that if a page uses **Server-side Rendering**, the page HTML is generated on **each request**. To use Server-side Rendering for a page, you need to `export` an `async` function called `getServerSideProps`. This function will be called by the server on every request.
...]

## add library

[https://context7.com/add-library]
Contexto7 MCP
<https://github.com/senal88/context7>
O Context7 MCP fornece documentação de código atualizada e específica da versão, além de ...
Gerenciar

Contexto

Bater papo

Referência

Mais recente
Status da tarefa: Processando - Iniciando a análise do repositório
11 de dezembro, 18:32:01
Limpando as pastas existentes do projeto /sinal88/context7
11 de dezembro, 18:32:01
Recursos do projeto /sinal88/context7 redefinidos com sucesso
11 de dezembro, 18:32:01
Limpeza concluída para o projeto /sinal88/context7
11 de dezembro, 18:32:01
Análise iniciada /sinal88/context7
11 de dezembro, 18:32:01
Verificando o tamanho do repositório antes de clonar...
11 de dezembro, 18:32:01
Clonando o repositório <https://github.com/senal88/context7> da branch master. Isso pode levar algum tempo...
11 de dezembro, 18:32:02
Repositório clonado com sucesso
11 de dezembro, 18:32:02
Wiki não disponível ou acessível (isso é normal)
11 de dezembro, 18:32:02
Repositório clonado <https://github.com/senal88/context7> em 563ms
11 de dezembro, 18:32:02
Verificando a documentação RST...
11 de dezembro, 18:32:02
Nenhum projeto RST encontrado (nenhum arquivo conf.py)
11 de dezembro, 18:32:02
Encontrando todos os arquivos Markdown em todo o repositório, sem especificar pastas.
11 de dezembro, 18:32:02
Ignorando arquivo excluído: CHANGELOG.md (2)
11 de dezembro, 18:32:02
Gerando context7.md usando Claude

## tarefas em andamento
<https://context7.com/tasklist?tab=repo>

Tarefas do repositório
(-)

Tarefas do site
(-)

Atualizar
FONTE TIPO DE TAREFA ESTADO TEMPO DECORRIDO
/openapi/chainels_openapi_bundle_json
atualizar-openapi
Iniciando a atualização do OpenAPI
1 dia
/billsonnn/nitro-renderer
Analisar
Finalizando o projeto
7 minutos
/sinal88/contexto7
Analisar
Analisando arquivos do repositório
57 segundos
