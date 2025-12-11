#!/usr/bin/env bash
# Script para carregar secrets do 1Password
# Uso: source load-secrets.sh

VAULT_MACOS="gkpsbgizlks2zknwzqpppnb2ze"

if ! command -v op &> /dev/null; then
    echo "❌ 1Password CLI não instalado"
    return 1
fi

if ! op vault list &> /dev/null; then
    echo "❌ Não autenticado no 1Password. Execute: eval \$(op signin)"
    return 1
fi

# Carregar Context7 API Key
export CONTEXT7_API_KEY=$(op item get "Context7_API" --vault "$VAULT_MACOS" --fields "api_key" 2>/dev/null)

if [ -n "$CONTEXT7_API_KEY" ]; then
    echo "✅ CONTEXT7_API_KEY carregada do 1Password"
else
    echo "⚠️  Não foi possível carregar CONTEXT7_API_KEY"
fi

# Carregar outras variáveis de ambiente
export CONTEXT7_MCP_URL="https://mcp.context7.com/mcp"
export CONTEXT7_API_URL="https://context7.com/api/v2"

echo "✅ Variáveis de ambiente carregadas"
