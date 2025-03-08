# Projeto de Testes Automatizados - ServeRest

Este projeto contém testes automatizados para a aplicação ServeRest, abrangendo tanto testes de frontend (UI) quanto testes de API REST.

## Estrutura do Projeto

```
serverest-test-project/
│
├── README.md                      # Esta documentação
├── requirements.txt               # Dependências do projeto
│
├── resources/                     # Recursos compartilhados
│   ├── common.resource            # Configurações e keywords comuns
│   ├── api_resources.resource     # Keywords específicas para testes de API
│   ├── web_resources.resource     # Keywords específicas para testes Web
│   └── test_data/                 # Dados de teste
│
├── libraries/                     # Bibliotecas personalizadas
│
├── tests/                         # Pasta principal de testes
│   ├── frontend/                  # Testes de frontend (UI)
│   └── api/                       # Testes de API
│
└── results/                       # Pasta para armazenar resultados dos testes
```

## Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/serverest-test-project.git
cd serverest-test-project
```

2. Instale as dependências:
```bash
pip install -r requirements.txt
```

3. Instale o WebDriver adequado para seu navegador:
   - Para Chrome: [ChromeDriver](https://sites.google.com/chromium.org/driver/)
   - Para Firefox: [GeckoDriver](https://github.com/mozilla/geckodriver/releases)

## Configuração

No arquivo `resources/common.resource`, você pode ajustar:
- URLs dos ambientes
- Navegador padrão
- Timeouts padrão

## Execução dos Testes

### Todos os testes
```bash
robot -d results tests/
```

### Apenas testes de frontend
```bash
robot -d results tests/frontend/
```

### Apenas testes de API
```bash
robot -d results tests/api/
```

### Execução de um caso de teste específico
```bash
robot -d results -t "Nome do Teste" tests/
```

### Execução por tags
```bash
robot -d results -i regressao tests/
```

## Relatórios

Após a execução, os relatórios serão gerados na pasta `results/`:
- `report.html`: Relatório resumido
- `log.html`: Log detalhado da execução
- `output.xml`: Dados brutos para processamento

## Convenções

### Tags
- `api`: Testes de API REST
- `frontend`: Testes de UI
- `regressao`: Testes para suíte de regressão
- `smoke`: Testes críticos para verificação rápida
- `integracao`: Testes que abrangem múltiplos fluxos

## Boas Práticas

1. **Separação de responsabilidades**:
   - Use arquivos `.resource` para agrupar keywords relacionadas
   - Mantenha testes de frontend e API separados

2. **Reúso de código**:
   - Crie keywords de alto nível para fluxos comuns
   - Use variáveis para elementos UI e endpoints de API

3. **Dados de teste**:
   - Gere dados dinâmicos para evitar conflitos
   - Limpe dados criados durante os testes (quando possível)

4. **Documentação**:
   - Documente todas as test cases e keywords
   - Use tags para categorizar testes

5. **Capturas de tela**:
   - Configure para capturar screenshots em casos de falha

## Manutenção

Para adicionar novos testes:

1. **Frontend**:
   - Crie um novo arquivo `.robot` na pasta `tests/frontend/`
   - Importe os recursos necessários com `Resource`
   - Siga o padrão existente para organização dos testes

2. **API**:
   - Crie um novo arquivo `.robot` na pasta `tests/api/`
   - Importe os recursos da API com `Resource`
   - Organize os testes por endpoint e funcionalidade