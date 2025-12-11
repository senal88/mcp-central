# 🏢 SISTEMA EMPRESARIAL MODULAR – ARQUITETURA COMPLETA

**Status:** Enterprise Ready v1.0  
**Data:** Dezembro 2025  
**Stack:** n8n + MCP Servers + LLMs + NocoDB + Antigravity  
**Ambientes:** macOS Silicon (dev) + VPS Ubuntu (prod/Coolify)  
**Linguagem:** Português (BR)

---

## 📋 ÍNDICE

1. [Visão Geral da Arquitetura](#visão-geral-da-arquitetura)
2. [Módulo 1: Cadastros](#módulo-1-cadastros)
3. [Módulo 2: Contas a Pagar/Receber](#módulo-2-contas-a-pagarreceber)
4. [Módulo 3: ETL Multiformat](#módulo-3-etl-multiformat)
5. [Módulo 4: Backend n8n + MCP](#módulo-4-backend-n8n--mcp)
6. [Módulo 5: Inteligência com LLMs](#módulo-5-inteligência-com-llms)
7. [Integração IDE Cursor + Antigravity](#integração-ide-cursor--antigravity)
8. [Plataformas de IA & Assinaturas](#plataformas-de-ia--assinaturas)
9. [Deploy em Coolify (VPS Ubuntu)](#deploy-em-coolify-vps-ubuntu)
10. [Monitoring & Logs](#monitoring--logs)
11. [Relatórios & Exportação](#relatórios--exportação)
12. [Troubleshooting Enterprise](#troubleshooting-enterprise)

---

## VISÃO GERAL DA ARQUITETURA

### Stack Completo Integrado

```
┌────────────────────────────────────────────────────────────────────────┐
│                     FRONTEND (Cursor IDE + Antigravity)               │
│                                                                         │
│  ├─ Antigravity IDE: Agent-first development                          │
│  ├─ Cursor 2.1: AI-powered code editor                                │
│  └─ VS Code Extensions: para customização local                       │
│                                                                         │
└────────────────┬────────────────────────────────────────┬──────────────┘
                 │                                        │
                 ▼                                        ▼
        ┌─────────────────┐              ┌─────────────────────┐
        │  DEVELOPMENT    │              │ PRODUCTION (VPS)    │
        │  macOS Silicon  │              │ Ubuntu + Coolify    │
        │                 │              │                     │
        │ • Cursor        │              │ • n8n (automação)   │
        │ • Node.js 20+   │              │ • NocoDB (DB)       │
        │ • PostgreSQL    │              │ • Chatwoot (CRM)    │
        │ • Redis         │              │ • Nginx (proxy)     │
        │ • Docker        │              │ • SSL/TLS           │
        └────────┬────────┘              └────────┬────────────┘
                 │ Git Sync                       │
                 │ (commits)                      │ Deployment
                 └───────────┬────────────────────┘
                             │
                ┌────────────▼────────────┐
                │   MCP SERVERS LAYER     │
                │                         │
                │ ├─ Cadastros Server     │
                │ ├─ Financeiro Server    │
                │ ├─ ETL Server           │
                │ ├─ Document Server      │
                │ └─ Reporting Server     │
                │                         │
                └────────────┬────────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
    ┌─────────┐      ┌──────────────┐      ┌─────────┐
    │ NocoDB  │      │     n8n      │      │   LLMs  │
    │         │      │              │      │         │
    │ • DB    │      │ • Workflows  │      │ • Claude│
    │ • API   │      │ • Triggers   │      │ • GPT-4 │
    │ • Forms │      │ • Webhooks   │      │ • Gemini│
    │ • Views │      │ • Integr.    │      │ • Local │
    └─────────┘      └──────────────┘      └─────────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
                        ┌────▼────┐
                        │ Google   │
                        │ Sheets   │
                        │ Data     │
                        │ Studio   │
                        └──────────┘

```

### Fluxo de Dados Completo

```
1. ENTRADA (Múltiplos Formatos)
   ├─ CSV Upload (n8n webhook)
   ├─ XML Parse (ETL Server)
   ├─ XLSX Sheet (Document Server)
   ├─ PDF Extração (LLM Vision)
   ├─ JSON API (n8n HTTP)
   └─ Email Attachment (Chatwoot)

                    ↓ PROCESSAMENTO

2. ETL PIPELINE
   ├─ Validação de schema
   ├─ Deduplicação automática
   ├─ Normalização (moeda, data, etc)
   ├─ Categorização com IA
   └─ Enriquecimento de dados

                    ↓ ARMAZENAMENTO

3. BANCO DE DADOS (NocoDB + PostgreSQL)
   ├─ Cadastros (Pessoas Físicas/Jurídicas)
   ├─ Contas Bancárias
   ├─ Contas a Pagar/Receber
   ├─ Documentos digitais
   ├─ Logs de operações
   └─ Auditoria completa

                    ↓ ORQUESTRAÇÃO

4. MCP SERVERS (Lógica de Negócio)
   ├─ Validações complexas
   ├─ Cálculos contábeis
   ├─ Reconciliação automática
   ├─ Sugestões de IA
   └─ Geração de documentos

                    ↓ INTELIGÊNCIA

5. LLMs (Análise & Insight)
   ├─ Análise de texto (notas fiscais)
   ├─ Categorização automática
   ├─ Previsão de fluxo de caixa
   ├─ Detecção de anomalias
   └─ Recomendações

                    ↓ VISUALIZAÇÃO & EXPORT

6. SAÍDA (Google Sheets + Reports)
   ├─ Dashboards em tempo real
   ├─ PDFs automatizados
   ├─ Excel com pivots
   ├─ JSON API
   └─ Email com relatórios
```

---

## MÓDULO 1: CADASTROS

### Estrutura de Dados em NocoDB

```sql
-- Table: pessoas_fisicas
CREATE TABLE pessoas_fisicas (
  id UUID PRIMARY KEY,
  cpf VARCHAR(11) UNIQUE NOT NULL,
  nome_completo VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  telefone VARCHAR(20),
  endereco_completo TEXT,
  data_nascimento DATE,
  profissao VARCHAR(100),
  renda_anual DECIMAL(15,2),
  status VARCHAR(50), -- 'ativo', 'inativo', 'bloqueado'
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  created_by UUID,
  updated_by UUID,
  
  -- Relacionamentos
  contas_bancarias UUID[],
  documentos UUID[],
  transacoes UUID[]
);

-- Table: pessoas_juridicas
CREATE TABLE pessoas_juridicas (
  id UUID PRIMARY KEY,
  cnpj VARCHAR(14) UNIQUE NOT NULL,
  razao_social VARCHAR(255) NOT NULL,
  nome_fantasia VARCHAR(255),
  email_corporativo VARCHAR(255),
  telefone_corporativo VARCHAR(20),
  endereco_matriz TEXT,
  endereco_filial TEXT,
  setor_atividade VARCHAR(100),
  data_constituicao DATE,
  capital_social DECIMAL(15,2),
  regime_tributario VARCHAR(50), -- 'simples', 'presumido', 'real'
  status VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  created_by UUID,
  
  -- Relacionamentos
  contas_bancarias UUID[],
  funcionarios UUID[],
  documentos UUID[],
  notas_fiscais UUID[]
);

-- Table: contas_bancarias
CREATE TABLE contas_bancarias (
  id UUID PRIMARY KEY,
  pessoa_id UUID NOT NULL, -- PF ou PJ
  banco_codigo VARCHAR(10),
  agencia VARCHAR(10),
  numero_conta VARCHAR(20),
  tipo_conta VARCHAR(50), -- 'corrente', 'poupança', 'investimento'
  saldo_atual DECIMAL(15,2),
  saldo_bloqueado DECIMAL(15,2),
  data_abertura DATE,
  data_fechamento DATE,
  status VARCHAR(50), -- 'ativa', 'inativa', 'bloqueada'
  restricao_origem VARCHAR(255), -- JSON string de padrões permitidos
  restricao_destino VARCHAR(255), -- JSON string de padrões permitidos
  created_at TIMESTAMP DEFAULT NOW(),
  
  FOREIGN KEY (pessoa_id) REFERENCES pessoas_fisicas(id) 
    ON DELETE CASCADE
);

-- Table: documentos_cadastrais
CREATE TABLE documentos_cadastrais (
  id UUID PRIMARY KEY,
  pessoa_id UUID NOT NULL,
  tipo_documento VARCHAR(50), -- 'identidade', 'cpf', 'cnpj', 'comprovante_endereco', etc
  numero_documento VARCHAR(100),
  data_emissao DATE,
  data_validade DATE,
  url_arquivo TEXT,
  status_verificacao VARCHAR(50), -- 'pendente', 'verificado', 'rejeitado'
  observacoes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Table: contas_bancarias_historico
CREATE TABLE contas_bancarias_historico (
  id UUID PRIMARY KEY,
  conta_id UUID NOT NULL,
  saldo_anterior DECIMAL(15,2),
  saldo_novo DECIMAL(15,2),
  motivo_alteracao VARCHAR(255),
  data_alteracao TIMESTAMP DEFAULT NOW(),
  
  FOREIGN KEY (conta_id) REFERENCES contas_bancarias(id)
);
```

### NocoDB Views & Forms

```yaml
# View 1: Pessoas Físicas - Grid Completo
Campos Visíveis:
  ├─ CPF (filtro)
  ├─ Nome Completo
  ├─ Email
  ├─ Telefone
  ├─ Status
  └─ Data Criação

Filtros Pré-configurados:
  ├─ Ativos
  ├─ Inativos
  ├─ Bloqueados
  └─ Criados este mês

# View 2: Pessoas Jurídicas - Kanban por Status
Colunas:
  ├─ Ativo (drag-drop)
  ├─ Inativo (drag-drop)
  └─ Bloqueado (drag-drop)

# View 3: Contas Bancárias - Mapa por Banco
Organizado por:
  ├─ Banco (coluna de grupo)
  │  ├─ Itaú
  │  ├─ Bradesco
  │  ├─ Santander
  │  └─ Nubank
  └─ Status (sub-grupo)

# Form: Novo Cadastro Pessoa Física
Campos:
  ├─ CPF (validação automática)
  ├─ Nome Completo
  ├─ Email (validação)
  ├─ Telefone (máscara)
  ├─ Data Nascimento (date picker)
  ├─ Profissão (autocomplete)
  ├─ Renda Anual
  └─ Foto (upload)

# Form: Nova Conta Bancária
Campos:
  ├─ Selecionar Pessoa (dropdown)
  ├─ Banco (dropdown com busca)
  ├─ Agência
  ├─ Número Conta
  ├─ Tipo (corrente/poupança)
  ├─ Data Abertura
  ├─ Restrição Origem (JSON textarea)
  └─ Restrição Destino (JSON textarea)

# Restrição de Origem (exemplo JSON)
{
  "permitir_apenas": ["transf_bancaria", "deposito"],
  "bloquear": ["saque_especie"],
  "limite_diario": 50000
}
```

### MCP Server de Cadastros

```typescript
// servers/cadastros/server.ts

export interface CadastrosServer extends MCPServer {
  name: "cadastros";
  version: "1.0.0";
  
  resources: [
    {
      name: "pessoas:fisica:schema";
      description: "Schema validação pessoa física";
    },
    {
      name: "pessoas:juridica:schema";
      description: "Schema validação pessoa jurídica";
    },
    {
      name: "contas:bancarias:restrictions";
      description: "Regras de restrição de contas";
    }
  ];
  
  tools: [
    {
      name: "cadastro:validar-cpf";
      description: "Validar CPF com algoritmo oficial";
      handler: async (cpf: string) => {
        // Validação de dígitos verificadores
        // Verificar duplicação em banco
        // Retornar: válido/inválido + motivo
      }
    },
    {
      name: "cadastro:validar-cnpj";
      description: "Validar CNPJ com algoritmo oficial";
      handler: async (cnpj: string) => {}
    },
    {
      name: "cadastro:verificar-duplicacao";
      description: "Verificar se pessoa já existe (CPF/CNPJ/Email)";
      handler: async (dados: any) => {}
    },
    {
      name: "cadastro:criar-pessoa-fisica";
      description: "Criar novo cadastro PF com validações";
      handler: async (input: any) => {
        // 1. Validar CPF
        // 2. Verificar duplicação
        // 3. Validar email
        // 4. Criar em NocoDB
        // 5. Registrar auditoria
        // 6. Retornar ID gerado
      }
    },
    {
      name: "cadastro:criar-pessoa-juridica";
      description: "Criar novo cadastro PJ com validações";
      handler: async (input: any) => {
        // Similar ao PF, mas com CNPJ, regime tributário, etc
      }
    },
    {
      name: "cadastro:criar-conta-bancaria";
      description: "Associar conta bancária a pessoa";
      handler: async (input: any) => {
        // 1. Verificar pessoa existe
        // 2. Validar restrições (origem/destino)
        // 3. Criar conta em NocoDB
        // 4. Retornar confirmação
      }
    },
    {
      name: "cadastro:listar-contas-pessoa";
      description: "Listar todas contas bancárias de uma pessoa";
      handler: async (pessoaId: string) => {
        // Retornar array com restrições expandidas
      }
    },
    {
      name: "cadastro:atualizar-status";
      description: "Mudar status de pessoa (ativo/inativo/bloqueado)";
      handler: async (pessoaId: string, novoStatus: string) => {
        // 1. Validar transição permitida
        // 2. Atualizar em NocoDB
        // 3. Notificar sistemas dependentes
      }
    }
  ];
}
```

---

## MÓDULO 2: CONTAS A PAGAR/RECEBER

### Estrutura de Dados

```sql
-- Table: contas_receber
CREATE TABLE contas_receber (
  id UUID PRIMARY KEY,
  numero_documento VARCHAR(50) UNIQUE,
  pessoa_id UUID NOT NULL, -- Quem deve receber
  conta_bancaria_origem UUID NOT NULL, -- Conta que receberá
  valor_original DECIMAL(15,2) NOT NULL,
  valor_pago DECIMAL(15,2) DEFAULT 0,
  valor_juros DECIMAL(15,2) DEFAULT 0,
  valor_desconto DECIMAL(15,2) DEFAULT 0,
  data_emissao DATE NOT NULL,
  data_vencimento DATE NOT NULL,
  data_pagamento DATE,
  status VARCHAR(50), -- 'em_aberto', 'parcial', 'pago', 'vencido', 'cancelado'
  tipo_documento VARCHAR(50), -- 'nf', 'boleto', 'duplicata', 'fatura', 'outro'
  descricao TEXT,
  observacoes TEXT,
  
  -- Integridade referencial
  FOREIGN KEY (pessoa_id) REFERENCES pessoas_juridicas(id),
  FOREIGN KEY (conta_bancaria_origem) REFERENCES contas_bancarias(id),
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: contas_pagar
CREATE TABLE contas_pagar (
  id UUID PRIMARY KEY,
  numero_documento VARCHAR(50) UNIQUE,
  pessoa_id UUID NOT NULL, -- Quem deve pagar
  conta_bancaria_destino UUID NOT NULL, -- Conta que pagará
  valor_original DECIMAL(15,2) NOT NULL,
  valor_pago DECIMAL(15,2) DEFAULT 0,
  valor_juros DECIMAL(15,2) DEFAULT 0,
  valor_desconto DECIMAL(15,2) DEFAULT 0,
  data_emissao DATE NOT NULL,
  data_vencimento DATE NOT NULL,
  data_pagamento DATE,
  status VARCHAR(50), -- 'em_aberto', 'agendado', 'pago', 'vencido', 'cancelado'
  tipo_documento VARCHAR(50), -- 'nf', 'boleto', 'duplicata', 'fatura', 'outro'
  descricao TEXT,
  observacoes TEXT,
  
  -- Restrição de conta
  validar_restricao_destino BOOLEAN DEFAULT TRUE,
  
  FOREIGN KEY (pessoa_id) REFERENCES pessoas_juridicas(id),
  FOREIGN KEY (conta_bancaria_destino) REFERENCES contas_bancarias(id),
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Table: pagamentos_recebimentos
CREATE TABLE pagamentos_recebimentos (
  id UUID PRIMARY KEY,
  tipo VARCHAR(50), -- 'recebimento' ou 'pagamento'
  conta_relacionada_id UUID NOT NULL, -- ID do contas_receber ou contas_pagar
  data_operacao TIMESTAMP DEFAULT NOW(),
  valor_processado DECIMAL(15,2),
  forma_pagamento VARCHAR(50), -- 'transferencia', 'cartao', 'cheque', 'dinheiro'
  comprovante_arquivo TEXT,
  status_confirmacao VARCHAR(50), -- 'pendente', 'confirmado', 'falha'
  
  created_at TIMESTAMP DEFAULT NOW()
);

-- Table: contas_pagar_receber_historico
CREATE TABLE contas_historico (
  id UUID PRIMARY KEY,
  conta_id UUID NOT NULL,
  tipo VARCHAR(50), -- 'pagar' ou 'receber'
  acao VARCHAR(100), -- 'criada', 'paga', 'atrasada', 'cancelada'
  valor_anterior DECIMAL(15,2),
  valor_novo DECIMAL(15,2),
  status_anterior VARCHAR(50),
  status_novo VARCHAR(50),
  motivo TEXT,
  usuario_id UUID,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### MCP Server Financeiro

```typescript
// servers/financeiro/server.ts

export interface FinanceiroServer extends MCPServer {
  name: "financeiro";
  version: "1.0.0";
  
  resources: [
    {
      name: "contas:receber:pendentes";
      description: "Todas as contas a receber em aberto";
      updateFrequency: "realtime";
    },
    {
      name: "contas:pagar:proximas-30-dias";
      description: "Contas a pagar com vencimento nos próximos 30 dias";
      updateFrequency: "hourly";
    },
    {
      name: "cash:flow:forecast-30-dias";
      description: "Projeção de fluxo de caixa";
      updateFrequency: "daily";
    },
    {
      name: "contas:atrasadas";
      description: "Contas vencidas não pagas";
      updateFrequency: "hourly";
    }
  ];
  
  tools: [
    {
      name: "financeiro:criar-conta-receber";
      description: "Criar nova conta a receber com validações";
      input: {
        pessoaId: string;
        valor: number;
        dataVencimento: string;
        tipoDocumento: string;
        descricao: string;
      };
      handler: async (input) => {
        // 1. Validar pessoa existe e está ativa
        // 2. Validar valor > 0
        // 3. Validar data vencimento > hoje
        // 4. Gerar número documento único
        // 5. Criar em NocoDB
        // 6. Retornar ID + número
      }
    },
    {
      name: "financeiro:criar-conta-pagar";
      description: "Criar nova conta a pagar com validação de restrição";
      input: {
        pessoaId: string;
        contaBancariaId: string;
        valor: number;
        dataVencimento: string;
      };
      handler: async (input) => {
        // 1. Validar pessoa existe
        // 2. Validar conta bancária
        // 3. VERIFICAR RESTRIÇÃO DE DESTINO
        //    - Se tem restrição_destino definida
        //    - Se tipo de operação é permitido
        //    - Se valor <= limite_diario
        // 4. Criar conta
        // 5. Se restrição violada: lançar erro com motivo
      }
    },
    {
      name: "financeiro:registrar-pagamento";
      description: "Registrar que uma conta foi paga";
      input: {
        contaPagarId: string;
        valor: number;
        dataPagamento: string;
        formaPagamento: string;
        comprovante?: File;
      };
      handler: async (input) => {
        // 1. Validar conta existe
        // 2. Validar valor <= valor_original
        // 3. Se valor == valor_original: marcar como pago
        // 4. Se valor < valor_original: marcar como parcial
        // 5. Atualizar histórico
        // 6. Notificar n8n para processamento
      }
    },
    {
      name: "financeiro:registrar-recebimento";
      description: "Registrar que uma conta foi recebida";
      handler: async (input) => {
        // Similar ao pagamento
      }
    },
    {
      name: "financeiro:listar-contas-pessoa";
      description: "Listar contas a pagar E receber de uma pessoa";
      input: {
        pessoaId: string;
        status?: string; // Opcional: filtrar por status
        dataInicio?: string;
        dataFim?: string;
      };
      handler: async (input) => {
        // Retornar ambas as listas consolidadas
      }
    },
    {
      name: "financeiro:gerar-fluxo-caixa";
      description: "Gerar projeção de fluxo de caixa para N dias";
      input: {
        contaBancariaId: string;
        dias: number; // default: 30
        incluirSeasonalidade: boolean; // default: true
      };
      handler: async (input) => {
        // 1. Puxar saldo atual da conta
        // 2. Puxar contas_receber.status='em_aberto' com data_vencimento <= hoje+dias
        // 3. Puxar contas_pagar.status='em_aberto' com data_vencimento <= hoje+dias
        // 4. Simular dia a dia
        // 5. Aplicar sazonalidade histórica se solicitado
        // 6. Retornar forecast com intervalo de confiança
      }
    },
    {
      name: "financeiro:detectar-anomalias";
      description: "Detectar contas suspeitas ou anomalias (para enviar para LLM)";
      handler: async () => {
        // Retornar array de contas que saem da normalidade
        // Exemplos: valor muito alto, pessoa com múltiplos atrasos, etc
      }
    }
  ];
}
```

### NocoDB Views para Contas

```yaml
# View: Contas a Receber - Calendário
Exibir:
  ├─ Por data de vencimento
  ├─ Código de cor por status (verde=pago, vermelho=vencido, amarelo=próximo)
  └─ Valor em tooltip

# View: Contas a Pagar - Timeline
Exibir:
  ├─ Linha do tempo de próximos 90 dias
  ├─ Ícone alerta para vencidas
  ├─ Agrupamento por conta bancária de destino
  └─ Valor total por data

# View: Contas Atrasadas - Crítico
Filtro automático:
  └─ status = 'vencido' AND data_vencimento < TODAY

Campos:
  ├─ Pessoa
  ├─ Valor
  ├─ Dias em Atraso (calculado)
  ├─ Contato (email + telefone)
  └─ Última tentativa cobrança

# Form: Novo Recebimento Manual
Campos:
  ├─ Selecionar Conta a Receber (autocomplete com search)
  ├─ Valor Recebido
  ├─ Data do Recebimento
  ├─ Forma de Pagamento
  ├─ Upload Comprovante (opcional)
  └─ Observações
```

---

## MÓDULO 3: ETL MULTIFORMAT

### Fluxos de Importação

```yaml
# ETL Pipeline: CSV → Validação → Deduplicação → NocoDB

## Suportar Formatos:
1. CSV (delimitador: comma/semicolon auto-detect)
2. XLSX (múltiplas abas)
3. JSON (array ou objects)
4. XML (parsing recursivo)
5. TXT (fixed width, identificar colunas por padrão)
6. PDF (extrair tabelas com IA vision)
7. Email Attachment (integração com Chatwoot)

## Exemplo: Importar Extrato CSV

Arquivo: extrato-itau-202512.csv
├─ Data,Descrição,Débito,Crédito,Saldo

Processo:
1. Upload via n8n webhook
2. Detecção automática:
   ├─ Encoding (UTF-8, ISO-8859-1, etc)
   ├─ Delimitador (,;|\t)
   ├─ Tipo de dados (number, date, string)
   └─ Mapeamento para schema NocoDB

3. Validação:
   ├─ Nenhuma linha vazia na chave
   ├─ Datas em formato válido
   ├─ Números com vírgula/ponto correto
   └─ CPF/CNPJ válidos (se houver)

4. Deduplicação:
   ├─ Por hash SHA256 da linha
   ├─ Por combinação de (Data, Descrição, Valor)
   └─ Comparar com últimas 100 importações

5. Transformação:
   ├─ Normalizar moedas (R$ → número)
   ├─ Normalizar datas (DD/MM/YYYY, etc)
   ├─ Limpar whitespace
   └─ Categorizar com IA (se necessário)

6. Enriquecimento:
   ├─ Buscar pessoa pela descrição
   ├─ Buscar conta bancária pelo ID
   ├─ Adicionar metadata (origem arquivo, timestamp import)
   └─ Calcular hash para dedup futuro

7. Armazenamento:
   ├─ Inserir em staging table (contas_pagar_receber_staging)
   ├─ Registrar audit trail
   ├─ Notificar para revisão manual (se muitas divergências)
   └─ Se validação OK: mover para contas_pagar/receber

## Exemplo: Importar Nota Fiscal XML

Arquivo: NF-123456.xml

Processo:
1. Parse XML:
   ├─ Extrair CNPJ emitente
   ├─ Extrair CNPJ destinatário
   ├─ Extrair data emissão
   ├─ Extrair valor total
   ├─ Extrair itens (quantidade × valor)
   └─ Validar assinatura digital

2. Validação NF:
   ├─ CNPJ válidos
   ├─ Série/número válido
   ├─ Chave NF está no padrão
   └─ Data não em futuro

3. Mapping:
   ├─ CNPJ emitente → localizar pessoa_juridica
   ├─ CNPJ destinatário → localizar pessoa_juridica
   ├─ Valor total → tipo documento 'nf'
   └─ Data vencimento = data_emissao + 30 dias (default)

4. Armazenar:
   ├─ Inserir em contas_receber (para emitente)
   ├─ Inserir em contas_pagar (para destinatário)
   ├─ Armazenar XML bruto em blob storage (auditoria)
   └─ Retornar JSON com resultado

## Exemplo: Importar PDF Extrato Bancário

Arquivo: extrato-bradesco-202512.pdf

Processo:
1. Enviar para LLM Vision (Claude/GPT-4):
   ├─ "Extraia as transações deste extrato"
   ├─ Retorna: JSON estruturado com Data, Descrição, Valor, Saldo
   └─ Confiança: 85% (exemplar)

2. Validar estrutura:
   ├─ Todas as linhas têm data?
   ├─ Todas têm valor?
   └─ Saldo final bate com inicial + movimentações?

3. Converter para CSV estruturado:
   ├─ Aplicar mesmo pipeline de CSV
   └─ Retornar linhas processadas

## Exemplo: Importar de Email (via Chatwoot)

Email recebido: cliente@fornecedor.com.br
Assunto: "Fatura outubro 2025"
Attachment: fatura-2025-10.pdf

Processo:
1. Chatwoot webhook → n8n:
   ├─ Capturar email metadata
   ├─ Extrair attachment
   ├─ Salvar em storage temporário
   └─ Notificar n8n para processar

2. Processar documento:
   ├─ Se PDF: extrair com LLM Vision
   ├─ Se Imagem: OCR + LLM
   └─ Se Texto: parse direto

3. Extrair dados:
   ├─ Localizar valor total
   ├─ Localizar data de vencimento
   ├─ Localizar número de nota/fatura
   ├─ Localizar CNPJ emitente
   └─ Retornar objeto estruturado

4. Criar conta_pagar:
   ├─ Com dados extraídos
   ├─ Status: pendente_revisao
   ├─ Link ao email original (em observações)
   └─ Notificar usuário para revisar

# MCP Server ETL

```typescript
// servers/etl/server.ts

export interface ETLServer extends MCPServer {
  name: "etl";
  version: "1.0.0";
  
  tools: [
    {
      name: "etl:importar-csv";
      description: "Importar CSV (auto-detect delimitador e encoding)";
      handler: async (file: File, targetTable: string) => {
        // 1. Detectar delimitador
        // 2. Detectar encoding
        // 3. Validar
        // 4. Deduplicate
        // 5. Transformar
        // 6. Retornar preview (primeiras 5 linhas)
      }
    },
    {
      name: "etl:importar-xlsx";
      description: "Importar XLSX com suporte a múltiplas abas";
      handler: async (file: File) => {
        // Retornar lista de abas para seleção
      }
    },
    {
      name: "etl:importar-json";
      description: "Importar JSON (array ou objects)";
      handler: async (file: File) => {}
    },
    {
      name: "etl:importar-xml";
      description: "Importar XML (NF-e, XML bancário, etc)";
      handler: async (file: File) => {}
    },
    {
      name: "etl:importar-pdf";
      description: "Importar PDF (extrair tabelas com OCR + LLM)";
      handler: async (file: File) => {
        // Usar LLM Vision para extrair conteúdo
      }
    },
    {
      name: "etl:validar-dados";
      description: "Validar dados contra schema";
      handler: async (dados: any[], schema: any) => {}
    },
    {
      name: "etl:deduplicate";
      description: "Remover duplicatas";
      handler: async (dados: any[], chaveUnica: string[]) => {}
    },
    {
      name: "etl:normalizar";
      description: "Normalizar moedas, datas, etc";
      handler: async (dados: any[], mapeamento: any) => {}
    }
  ];
}
```

---

## MÓDULO 4: BACKEND n8n + MCP

### Arquitetura n8n

```yaml
# n8n Workflows Principais

Workflow 1: "ETL - Importar Arquivo"
├─ Trigger: Webhook (POST /n8n/import)
├─ Input: { fileUrl, targetTable, format }
│
├─ Nó 1: Download arquivo
├─ Nó 2: Detectar formato
├─ Nó 3: Chamar MCP ETL Server
│  └─ Parseou conversor específico
├─ Nó 4: Chamar MCP Cadastros/Financeiro
│  └─ Validar dados
├─ Nó 5: Deduplicate com query PostgreSQL
├─ Nó 6: Insert em NocoDB (staging table)
├─ Nó 7: Webhook → Frontend (resultado)
└─ Nó 8: Email notificação

Workflow 2: "Contas a Pagar - Alerta Vencimento"
├─ Trigger: Cron (todo dia às 8 AM)
│
├─ Nó 1: Query NocoDB
│  └─ SELECT * FROM contas_pagar WHERE data_vencimento = HOJE+3
├─ Nó 2: Para cada conta:
│  ├─ Chamar LLM para gerar aviso personalizado
│  ├─ Buscar email da pessoa em Cadastros MCP
│  └─ Enviar email (Gmail integração)
│
└─ Nó 3: Registrar em log

Workflow 3: "Reconciliação Bancária Automática"
├─ Trigger: Cron (diário)
│
├─ Nó 1: Para cada conta_bancaria:
│  ├─ Chamar ETL para puxar extrato (se API disponível)
│  ├─ Validar com MCP Financeiro
│  ├─ Comparar com contas_pagar/receber abertas
│  ├─ Detectar divergências
│  └─ Se divergência: criar alerta
│
└─ Nó 4: Atualizar status automaticamente (se match 100%)

Workflow 4: "Geração de Relatórios"
├─ Trigger: Webhook + Schedule
│
├─ Nó 1: Chamar MCP Reporting
│  └─ Gerar dados para relatório
├─ Nó 2: Chamar LLM para análise
│  └─ Gerar insights + recomendações
├─ Nó 3: Formatar PDF (com template)
├─ Nó 4: Upload Google Sheets
├─ Nó 5: Enviar por email
└─ Nó 6: Log auditoria

Workflow 5: "Integração Email → NocoDB"
├─ Trigger: Chatwoot Webhook (novo email)
│
├─ Nó 1: Extrair metadata:
│  ├─ From (email sender)
│  ├─ Subject
│  ├─ Attachments
│  └─ Body
├─ Nó 2: Se attachment:
│  ├─ Chamar MCP ETL para processar
│  ├─ Extrair dados do arquivo
│  └─ Criar contas_receber/pagar com status 'pendente_revisao'
├─ Nó 3: Se menção a pessoa/conta:
│  └─ Atualizar observações em NocoDB
└─ Nó 4: Notificar usuário (comentário em issue)

# n8n HTTP Nodes para MCP Servers

Chamar MCP Cadastros:
POST http://mcp-server-cadastros:3001/tool
{
  "tool": "cadastro:validar-cpf",
  "params": { "cpf": "123.456.789-00" }
}

Chamar MCP Financeiro:
POST http://mcp-server-financeiro:3002/tool
{
  "tool": "financeiro:criar-conta-receber",
  "params": {
    "pessoaId": "uuid-123",
    "valor": 1500.00,
    "dataVencimento": "2025-01-31"
  }
}

Chamar MCP ETL:
POST http://mcp-server-etl:3003/tool
{
  "tool": "etl:importar-csv",
  "params": {
    "fileUrl": "s3://bucket/file.csv",
    "targetTable": "contas_pagar"
  }
}
```

### n8n Triggers & Webhooks

```yaml
# Webhooks Disponíveis

POST /n8n/import
├─ Body: { fileUrl, format, targetTable }
├─ Response: { success, rowsImported, errors }
└─ Exemplo: curl -X POST http://localhost:5678/webhook/import \
     -d '{"fileUrl":"s3://...", "format":"csv"}'

POST /n8n/registrar-pagamento
├─ Body: { contaPagarId, valor, dataPagamento }
├─ Validação: contra restrições de conta
└─ Action: Atualizar NocoDB + enviar email

GET /n8n/fluxo-caixa?contaId=uuid&dias=30
├─ Response: JSON com forecast de 30 dias
└─ Atualização: tempo real (recalcula a cada request)

POST /n8n/analisar-documento
├─ Body: { fileUrl, tipo } // tipo: 'nf', 'extrato', 'fatura'
├─ Action: Enviar para LLM Vision + parse
└─ Response: { dados_extraidos, confianca, sugestoes }

GET /n8n/alertas?tipo=vencidas
├─ Retorna: contas vencidas + dias em atraso
└─ Response: JSON array com detalhes

# Roteiros de Integração

n8n → NocoDB (via API):
├─ Usar NocoDB Node (plugin nativo)
└─ SQL queries direto em PostgreSQL

n8n → LLM:
├─ Claude: via Anthropic API
├─ GPT-4: via OpenAI API
├─ Gemini: via Google Vertex API
└─ Local: via Ollama (se disponível)

n8n → Email:
├─ Gmail (OAuth2)
├─ Sendgrid (API key)
├─ SMTP customizado
└─ Chatwoot (para gerenciar threads)

n8n → Storage:
├─ AWS S3 (node nativo)
├─ Google Drive (node nativo)
└─ FTP (node genérico)
```

---

## MÓDULO 5: INTELIGÊNCIA COM LLMS

### Prompts & Contextos para Análise

```yaml
# Prompt 1: Categorizar Transação Bancária

system: |
  Você é um assistente contábil especializado em categorização de transações financeiras.
  Categorize a transação com base na descrição e valor.
  Retorne JSON com: categoria, confiança (0-1), motivo.

user: |
  Descrição: "PADARIA DO JOE"
  Valor: R$ 45.90
  Tipo: Débito
  Contexto: Empresa de software, sem vendas de padaria

Resposta:
  {
    "categoria": "Despesa Operacional > Alimentação",
    "subCategoria": "Refeições",
    "confianca": 0.95,
    "motivo": "Padrão de transação recorrente em padaria",
    "sugestao": "Possível despesa com café do escritório"
  }

# Prompt 2: Detectar Anomalia

system: |
  Analise a transação e identifique anomalias.
  Compare com padrão histórico da conta.
  Retorne: anomalia_detectada (bool), risco (low/medium/high), ação.

user: |
  Transação: R$ 250.000 para conta externa
  Padrão histórico: transferências médias de R$ 5.000
  Contexto: Conta de PJ, primeira vez enviando para essa conta

Resposta:
  {
    "anomalia_detectada": true,
    "risco": "high",
    "tipo": "Valor discrepante + Conta nova",
    "acao": "Requer aprovação manual",
    "sugestao": "Verificar se é operação legítima antes de liberar"
  }

# Prompt 3: Extrair Dados de Documento

system: |
  Você é um especialista em OCR e extração de dados de documentos financeiros.
  Extraia informações estruturadas de Notas Fiscais, Boletos, Extratos.
  Retorne JSON com campos identificados e confiança.

user: |
  [PDF image of NF-e]
  Extraia: CNPJ, Razão Social, Data Emissão, Valor Total, Itens, Data Vencimento

Resposta:
  {
    "cnpj_emitente": "12.345.678/0001-90",
    "razao_social": "Empresa XYZ Ltda",
    "data_emissao": "2025-12-09",
    "valor_total": 15234.50,
    "data_vencimento": "2026-01-08",
    "itens": [
      {
        "descricao": "Serviço de consultoria",
        "quantidade": 1,
        "valor_unitario": 15234.50,
        "confianca": 0.98
      }
    ]
  }

# Prompt 4: Análise de Fluxo de Caixa

system: |
  Analise o fluxo de caixa projetado e identifique períodos críticos.
  Retorne: previsão com confiança, períodos de risco, recomendações.

user: |
  [Dados de contas_receber e contas_pagar para próximos 30 dias]
  Saldo atual: R$ 50.000
  Gerar: análise de liquidez, recomendações

Resposta:
  {
    "saldo_projetado_fim_mes": 35000,
    "minimo_projetado": 15000,
    "data_minimo": "2025-12-25",
    "risco": "medium",
    "periodos_criticos": [
      {
        "data": "2025-12-20 a 2025-12-27",
        "motivo": "Múltiplos pagamentos + feriados",
        "recomendacao": "Antecipar recebimentos ou conseguir crédito"
      }
    ],
    "recomendacoes": [
      "Priorizar cobrança de 3 maiores devedores",
      "Renegociar prazos com 2 fornecedores principais",
      "Manter colchão mínimo de R$ 20k"
    ]
  }

# Prompt 5: Gerar Relatório Executivo

system: |
  Gere um relatório executivo para CFO com análise de performance,
  comparações YoY, trends e recomendações estratégicas.
  Formato: Markdown + números em português (R$ e %).

user: |
  [Dados financeiros: receitas, despesas, margens, comparações]
  Período: Dezembro 2025 vs Dezembro 2024

Resposta:
  # Relatório Financeiro - Dezembro 2025

  ## Resumo Executivo
  - Receita Total: R$ 1.234.567 (↑ 23% vs Dez/2024)
  - Lucro Líquido: R$ 234.567 (↑ 45% vs Dez/2024)
  - Margem Bruta: 68% (↑ 5 pp vs Dez/2024)

  ## Highlights
  ✅ Maior receita do ano
  ✅ Margem acima da meta (68% vs 65% orçado)
  ⚠️ Despesa operacional 12% acima do previsto

  ## Análise Detalhada
  [...]

  ## Recomendações
  1. Manter ritmo de vendas em janeiro
  2. Revisar despesas operacionais
  3. [...]
```

### Integrações LLM em n8n

```yaml
# Node 1: OpenAI (GPT-4 + Vision)
config:
  api_key: ${OPENAI_API_KEY}
  model: gpt-4-vision
  temperature: 0.7
  max_tokens: 2000

input:
  - Messages:
    - role: user
      content:
        - type: text
          text: "Categorize esta transação"
        - type: image_url
          image_url: ${fileUrl}

# Node 2: Claude (Anthropic)
config:
  api_key: ${ANTHROPIC_API_KEY}
  model: claude-3-opus
  temperature: 0.5

input:
  - System prompt
  - User message + data

# Node 3: Gemini (Google)
config:
  project_id: ${GCP_PROJECT}
  api_key: ${GEMINI_API_KEY}

input:
  - Content + images
  - System instruction

# Node 4: Ollama (Local LLM)
config:
  endpoint: http://localhost:11434
  model: llama2 # ou mistral, neural-chat, etc

input:
  - Prompt
  - Context
  - Temperature, top_p, etc

# Example n8n Workflow Node

Analyze Document (HTTP POST):
├─ URL: https://api.openai.com/v1/chat/completions
├─ Headers: Authorization: Bearer ${OPENAI_API_KEY}
├─ Body:
│  ├─ model: "gpt-4-vision"
│  ├─ messages:
│  │  └─ content:
│  │     ├─ type: "text"
│  │     │  text: "Extract NF-e data and return JSON"
│  │     └─ type: "image_url"
│  │        url: ${attachment_url}
│  └─ temperature: 0.5
│
└─ Parse response:
   ├─ Extract JSON from response
   ├─ Validate against schema
   └─ Return to NocoDB
```

---

## INTEGRAÇÃO IDE: CURSOR + ANTIGRAVITY

### Fluxo Desenvolvimento Integrado

```yaml
# Cenário: Desenvolvedor usa Cursor + Antigravity

1. Antigravity (Agent-First Planning)
   ├─ Descrição: "Criar novo MCP Server para validar CPF"
   ├─ Outputs:
   │  ├─ Task List (priorizado)
   │  ├─ Implementation Plan
   │  ├─ File Structure
   │  └─ Tests a Implementar
   │
   └─ Tempo: 5 minutos (agente planning)

2. Cursor (Implementação)
   ├─ Abrir projeto em Cursor
   ├─ Usar Antigravity outputs como referência
   ├─ @symbols para autocomplete de MCP patterns
   ├─ Ctrl+K para gerar código com contexto
   │
   └─ Implementação: 30 minutos

3. Antigravity (Testes & Validação)
   ├─ Agente executa suite de testes
   ├─ Testa endpoints do servidor
   ├─ Valida schemas
   │
   └─ Tempo: 10 minutos

4. Cursor (Deployment)
   ├─ Build & push Docker
   ├─ Deploy no Coolify
   ├─ Verificar health check
   │
   └─ Tempo: 5 minutos

# Shortcuts Cursor para MCP Patterns

Digitar "@mcp" → autocomplete:
├─ @mcp:resource → template Resource
├─ @mcp:tool → template Tool
├─ @mcp:server → template Server completo
└─ @mcp:context → template Context

Digitar "@n8n" → autocomplete:
├─ @n8n:workflow → template Workflow
├─ @n8n:node:http → Node HTTP
├─ @n8n:trigger:webhook → Trigger Webhook
└─ @n8n:trigger:cron → Trigger Cron

Digitar "@nocodb" → autocomplete:
├─ @nocodb:table → criar table SQL
├─ @nocodb:view:grid → criar Grid view
├─ @nocodb:form → criar Form
└─ @nocodb:api → exemplo API call

# Workflow Cursor + Antigravity

1. Abrir Command Palette (Cmd+Shift+P)
2. "Antigravity: Plan MCP Server"
3. Descrever funcionalidade
4. Antigravity gera artifacts + task list
5. Cursor recebe referência automática
6. Implementar com @mcp autocompletes
7. Antigravity testa automaticamente
8. Push para VPS via GitHub Actions
```

---

## PLATAFORMAS DE IA & ASSINATURAS

### Stack Recomendado (Otimizado)

```yaml
# TIER 1: IDEs + Desenvolvimento
Cursor 2.1 Pro:
  ├─ Preço: $20/mês
  ├─ Modelos: GPT-4, Claude 3.5 Sonnet
  ├─ Recursos: Codebase context, refactoring
  └─ Uso: Desenvolvimento MCP servers, n8n workflows

Google Antigravity (Preview):
  ├─ Preço: Gratuito (preview)
  ├─ Modelos: Gemini 3 Pro
  ├─ Recursos: Agent planning, artifact generation
  └─ Uso: Planejamento e validação de features

# TIER 2: LLMs Premium
OpenAI ChatGPT Plus Pro:
  ├─ Preço: $20/mês (Plus) + $20/mês (Pro quando disponível)
  ├─ Modelos: GPT-4, GPT-4 Vision, GPT-4 Turbo
  ├─ Recursos: 50 GPT-4 calls/3h, vision, file upload (25MB)
  └─ Uso: Análise de documentos PDF, categorização com vision

Claude Pro (Anthropic):
  ├─ Preço: $20/mês
  ├─ Modelos: Claude 3 Opus, Sonnet
  ├─ Recursos: 100k tokens/dia, longContext, análise profunda
  ├─ Força: Excelente para análise financeira complexa
  └─ Uso: Análise de fluxo de caixa, relatórios estratégicos

Gemini 3.0 Pro (Google):
  ├─ Preço: Gratuito (tier grátis) + $20/mês (Pro, em breve)
  ├─ Modelos: Gemini 3 Pro, Ultra
  ├─ Recursos: Vision, 2M token context
  ├─ Integrado: Com Google Workspace (Sheets, Docs, Drive)
  └─ Uso: Análise de documentos, categorização automática

Perplexity Pro:
  ├─ Preço: $20/mês
  ├─ Modelos: GPT-4, Claude, Gemini (access simultâneo)
  ├─ Força: Busca em tempo real + análise
  └─ Uso: Pesquisa de taxas/impostos atualizados

# TIER 3: Plataformas Especializadas
HuggingFace Pro:
  ├─ Preço: $9/mês (Pro)
  ├─ Recursos: 3000 compute credits, private models, datasets
  ├─ Modelos: Llama 2, Mistral, Falcon (open source)
  └─ Uso: Fine-tuning de modelos customizados, LLMs locais

GitHub Copilot:
  ├─ Preço: $10/mês (individual)
  ├─ Recursos: Code completion em IDE, Copilot Chat
  ├─ Integrado: VS Code, JetBrains, Vim, NeoVim
  └─ Uso: Complementa Cursor para autocomplete em n8n

# TIER 4: Ferramentas Infraestrutura
n8n Cloud (opcional, nosso é self-hosted):
  ├─ Preço: Gratuito (self-hosted) até $100+/mês (cloud)
  ├─ Hosting: VPS Ubuntu (Coolify) - GRATUITO
  └─ Uso: Orquestração workflows + ETL

NocoDB Cloud (opcional, nosso é self-hosted):
  ├─ Preço: Gratuito (self-hosted) até $50+/mês (cloud)
  ├─ Hosting: VPS Ubuntu (Coolify) - GRATUITO
  └─ Uso: Database + UI gerada automaticamente

# RECOMENDAÇÃO: Custo Mínimo Otimizado

Essencial (para funcionalidade completa):
  ├─ Cursor Pro: $20/mês
  ├─ OpenAI ChatGPT Plus: $20/mês (para vision em PDFs)
  ├─ Claude Pro: $20/mês (para análise financeira)
  ├─ Gemini Pro (quando lançar): ~$20/mês
  └─ TOTAL: ~$80/mês (assinaturas)

Self-Hosted (GRATUITO):
  ├─ n8n: $0 (Coolify)
  ├─ NocoDB: $0 (Coolify)
  ├─ PostgreSQL: $0 (Coolify)
  ├─ Redis: $0 (Coolify)
  ├─ MCP Servers: $0 (você implementa)
  └─ TOTAL: $0 (infrastructure)

VPS Ubuntu (Coolify):
  ├─ Linode/DigitalOcean: ~$25-50/mês (1GB RAM é suficiente)
  └─ TOTAL VPS: ~$25-50/mês

CUSTO TOTAL MENSAL ESTIMADO:
  ├─ Assinaturas LLMs: $80/mês
  ├─ VPS: $25-50/mês
  └─ TOTAL: $105-130/mês

Versus alternativas como:
  ├─ Zapier: $200+/mês (workflows)
  ├─ Make (antigo Integromat): $100+/mês
  ├─ Airtable + Integrations: $300+/mês
  └─ Software contábil tradicional: $500+/mês

# ECONOMIA: 50-75% vs alternativas
```

---

## DEPLOY EM COOLIFY (VPS UBUNTU)

### Status Atual (Conforme Sua Descrição)

```bash
# Verificar serviços rodando:
ssh seu-usuario@seu-vps.com

# Docker containers
docker ps

# Deve mostrar:
├─ coolify (painel de controle)
├─ n8n (automação)
├─ nocodb (database UI)
├─ chatwoot (CRM)
├─ nginx (reverse proxy)
└─ postgresql (banco de dados)

# Logs em tempo real
docker logs -f coolify
docker logs -f n8n
docker logs -f nocodb
```

### Adicionar MCP Servers ao Coolify

```yaml
# Passo 1: Criar Dockerfile para MCP Server

# Dockerfile (servers/cadastros/Dockerfile)
FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY src ./src

EXPOSE 3001

CMD ["npm", "start"]

# Passo 2: Fazer build e push para Docker Hub

docker build -t seu-usuario/mcp-cadastros:latest servers/cadastros/
docker push seu-usuario/mcp-cadastros:latest

# Passo 3: Adicionar em Coolify

Web: https://coolify.io
├─ New Service → Docker Container
├─ Image: seu-usuario/mcp-cadastros:latest
├─ Port: 3001
├─ Environment:
│  ├─ DATABASE_URL=postgresql://user:pass@postgres:5432/empresa
│  ├─ REDIS_URL=redis://redis:6379
│  ├─ NODE_ENV=production
│  └─ LOG_LEVEL=info
├─ Health Check: GET http://localhost:3001/health
└─ Auto-deploy: On (GitHub integration)

# Resultado em Coolify:
├─ mcp-cadastros (running)
├─ mcp-financeiro (running)
├─ mcp-etl (running)
├─ mcp-document (running)
└─ mcp-reporting (running)

# Todos acessíveis internamente:
├─ http://mcp-cadastros:3001
├─ http://mcp-financeiro:3002
├─ http://mcp-etl:3003
└─ etc
```

### Configurar n8n para Chamar MCP Servers

```yaml
# Em n8n, adicionar variáveis de ambiente

MCP_CADASTROS_URL=http://mcp-cadastros:3001
MCP_FINANCEIRO_URL=http://mcp-financeiro:3002
MCP_ETL_URL=http://mcp-etl:3003
MCP_DOCUMENT_URL=http://mcp-document:3004
MCP_REPORTING_URL=http://mcp-reporting:3005

# Em n8n Workflow, usar HTTP Request Node:

POST {{ $env.MCP_CADASTROS_URL }}/tool
{
  "tool": "cadastro:validar-cpf",
  "params": {
    "cpf": "{{ $item.json.cpf }}"
  }
}
```

### Monitoramento em Coolify

```bash
# Ver status de todos os serviços
curl http://seu-vps.com:9000/api/status

# Logs centralizados
docker logs -f coolify

# Healthcheck de MCP Servers
curl http://seu-vps.com:3001/health
curl http://seu-vps.com:3002/health
curl http://seu-vps.com:3003/health

# Se algum falhar:
docker restart mcp-cadastros
docker restart n8n
```

---

## MONITORING & LOGS

### Logging Estruturado

```typescript
// Exemplo: MCP Server com logging

import pino from 'pino';

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  transport: {
    target: 'pino-pretty',
    options: {
      colorize: true,
      translateTime: 'SYS:standard',
      ignore: 'pid,hostname'
    }
  }
});

// Em cada handler:
export async function cadastroValidarCPF(cpf: string) {
  logger.info({ cpf }, 'Validando CPF');
  
  try {
    const resultado = validarCPF(cpf);
    
    logger.info({
      cpf,
      resultado,
      timestamp: new Date()
    }, 'CPF validado com sucesso');
    
    return resultado;
  } catch (error) {
    logger.error({
      cpf,
      erro: error.message,
      stack: error.stack
    }, 'Erro ao validar CPF');
    
    throw error;
  }
}

// Logs centralizados em Coolify:
// Acessar via: Coolify → Logs → mcp-cadastros
```

### Métricas com Prometheus

```yaml
# Instalar Prometheus no Coolify

# Adicionar scrape config para MCP Servers
prometheus:
  scrape_configs:
    - job_name: 'mcp-servers'
      static_configs:
        - targets:
          - 'mcp-cadastros:3001/metrics'
          - 'mcp-financeiro:3002/metrics'
          - 'mcp-etl:3003/metrics'

# Métricas importantes a trackear:
├─ Request latency (p95, p99)
├─ Error rate
├─ Database query time
├─ Memory usage
├─ CPU usage
└─ n8n workflow success rate
```

---

## RELATÓRIOS & EXPORTAÇÃO

### Geração Automatizada

```yaml
# Workflow n8n: "Gerar Relatório Mensal"

Trigger: Cron (1º de cada mês, 8 AM)

├─ Nó 1: Query NocoDB
│  └─ SELECT * FROM contas_pagar, contas_receber WHERE MONTH=PREV_MONTH
│
├─ Nó 2: Chamar MCP Reporting
│  └─ Gerar dados agregados (totais, médias, comparações)
│
├─ Nó 3: Chamar LLM (Claude Pro)
│  ├─ Análise de performance
│  ├─ Identificar trends
│  ├─ Gerar recomendações
│  └─ Escrever relatório em Markdown
│
├─ Nó 4: Criar documento Google Sheets
│  ├─ Tabelas com dados
│  ├─ Gráficos pivots
│  └─ Formatação automática
│
├─ Nó 5: Exportar como PDF
│  ├─ Template profissional
│  ├─ Adicionar logo + branding
│  └─ Compactar com gzip
│
├─ Nó 6: Enviar por Email
│  ├─ Para: cfo@empresa.com
│  ├─ CC: gerentes@empresa.com
│  ├─ Assunto: "Relatório Financeiro - Dezembro 2025"
│  └─ Body: Resumo executivo + link para Sheets
│
└─ Nó 7: Log Auditoria
   └─ Registrar: quem recebeu, quando, status envio

# Formatos de Exportação Disponíveis:
├─ PDF (via Puppeteer/Wkhtmltopdf)
├─ Excel com múltiplas abas (xlsx)
├─ Google Sheets (via API)
├─ JSON (estruturado)
├─ CSV (para importação em sistemas terceiros)
└─ HTML (para visualização web)
```

---

## TROUBLESHOOTING ENTERPRISE

### Problemas Comuns & Soluções

```yaml
# Problema 1: n8n não consegue conectar a MCP Server

Sintoma:
  └─ HTTP 503: Service Unavailable em webhook

Diagnóstico:
  ├─ curl http://mcp-cadastros:3001/health
  ├─ docker ps | grep mcp-cadastros
  ├─ docker logs mcp-cadastros
  └─ Verificar rede: docker network inspect bridge

Solução:
  1. Reiniciar container:
     └─ docker restart mcp-cadastros
  2. Verificar variáveis ambiente:
     └─ docker inspect mcp-cadastros | grep Env
  3. Se persistir: rebuild:
     ├─ docker build -t seu-usuario/mcp-cadastros:v2 .
     ├─ docker stop mcp-cadastros
     ├─ docker rm mcp-cadastros
     └─ docker run -d ... seu-usuario/mcp-cadastros:v2

# Problema 2: ETL importação falha em PDF

Sintoma:
  └─ "OCR failed" ou "Não conseguiu extrair texto"

Diagnóstico:
  ├─ PDF é imagem ou texto?
     └─ pdfimages -list arquivo.pdf
  ├─ Encoding correto?
     └─ file arquivo.pdf
  └─ Tamanho muito grande?
     └─ ls -lh arquivo.pdf

Solução:
  1. Se PDF é imagem:
     ├─ Usar Tesseract OCR
     └─ pdftoimage → tesseract → JSON
  2. Se muito grande:
     ├─ Dividir em páginas
     ├─ Processar cada página
     └─ Consolidar resultados
  3. Se encoding:
     ├─ Converter para UTF-8
     └─ Tentar novamente

# Problema 3: NocoDB fica lento

Sintoma:
  └─ Grid view demora >2s para carregar

Diagnóstico:
  ├─ Quantas linhas na tabela?
     └─ SELECT COUNT(*) FROM contas_receber;
  ├─ Quantos índices?
     └─ \d contas_receber
  └─ Uso de RAM/CPU?
     └─ docker stats nocodb

Solução:
  1. Adicionar índices:
     ├─ CREATE INDEX idx_pessoa_id ON contas_receber(pessoa_id);
     ├─ CREATE INDEX idx_status ON contas_receber(status);
     └─ VACUUM ANALYZE;
  2. Paginar dados:
     └─ Grid view com limit: LIMIT 100 OFFSET 0
  3. Se persistir: escalar VPS
     └─ Aumentar RAM: DigitalOcean → Resize → +1GB

# Problema 4: LLM timeout em análise de documento grande

Sintoma:
  └─ Timeout após 30s em análise PDF

Diagnóstico:
  ├─ Tamanho do PDF?
     └─ du -h arquivo.pdf
  ├─ Quantas páginas?
     └─ pdfinfo arquivo.pdf | grep Pages
  └─ Payload para LLM é válido?

Solução:
  1. Dividir em páginas:
     ├─ pdfimages -pdf arquivo.pdf páginas.pdf
     └─ Processar cada página separadamente
  2. Usar modelo com contexto maior:
     ├─ Claude 3 Opus (200k tokens)
     └─ Gemini 1.5 (1M tokens)
  3. Aumentar timeout em n8n:
     └─ HTTP node → Timeout: 120s

# Problema 5: Duplicação de dados após ETL

Sintoma:
  └─ Mesma NF importada 2x

Diagnóstico:
  ├─ Verificar hash em tabela staging:
     └─ SELECT hash, COUNT(*) FROM staging GROUP BY hash HAVING COUNT(*) > 1;
  └─ Último import estava com dedup desligado?

Solução:
  1. Sempre usar dedup:
     └─ n8n Workflow → MCP ETL → deduplicate: true
  2. Se já duplicado:
     ├─ Identificar duplicata
     ├─ DELETE FROM contas_receber WHERE id = 'dup_id'
     └─ Registrar em audit log
  3. Implementar constraint único:
     └─ ALTER TABLE contas_receber ADD UNIQUE(numero_documento);
```

---

## IMPLEMENTAÇÃO STEP-BY-STEP

### Fase 1: Setup Base (Semana 1)

```bash
# 1. Validar VPS Ubuntu com Coolify
ssh seu-usuario@seu-vps.com
docker ps
# Deve mostrar: coolify, n8n, nocodb, postgresql, redis

# 2. Criar banco de dados
docker exec postgresql psql -U postgres -c "CREATE DATABASE empresa;"

# 3. Executar migration SQL (tabelas)
docker exec postgresql psql -U postgres -d empresa -f - < migrations/001-schema.sql

# 4. Verificar NocoDB
curl http://seu-vps.com:8080
# Deve abrir UI de NocoDB
```

### Fase 2: Implementar MCP Servers (Semana 2-3)

```bash
# 1. Criar estrutura em macOS (Cursor)
mkdir -p mcp-servers/{cadastros,financeiro,etl}

# 2. Implementar Cadastros Server
cd mcp-servers/cadastros
npm init -y
npm install @mcp-central/sdk

# Implementar seguindo template em Cursor
# ... (código TypeScript)

# 3. Build & Deploy
docker build -t seu-usuario/mcp-cadastros:latest .
docker push seu-usuario/mcp-cadastros:latest

# 4. Adicionar em Coolify
# Via web interface: New Service → Docker Container
```

### Fase 3: Configurar Workflows n8n (Semana 4)

```bash
# 1. Acessar n8n
http://seu-vps.com:5678

# 2. Criar primeiro workflow:
#    "Importar CSV → Validar CPF → Criar Cadastro"

# 3. Configurar webhooks
#    POST /n8n/import → MCP cadastros → NocoDB

# 4. Testar com arquivo de exemplo
```

### Fase 4: Conectar LLMs (Semana 5)

```bash
# 1. Adicionar API keys em Coolify
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-...
GEMINI_API_KEY=...

# 2. Criar workflow com LLM:
#    "Extrair PDF → Claude Pro → Categorizar → NocoDB"

# 3. Testar com documentos reais
```

### Fase 5: Relatórios & Exportação (Semana 6)

```bash
# 1. Criar template Google Sheets
# 2. Configurar automação n8n para gerar relatórios
# 3. Agendar envio por email diário
```

---

**Status:** Enterprise Ready v1.0 ✅  
**Última Atualização:** Dezembro 2025  
**Próxima Review:** Março 2026  
**Stack Validado:** n8n + NocoDB + MCP + Coolify + LLMs

---

*Sistema Empresarial Modular – Guia Completo de Implementação*
