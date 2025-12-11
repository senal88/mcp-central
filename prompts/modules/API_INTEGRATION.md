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
