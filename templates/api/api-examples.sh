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
