# Projeto de Testes Automatizados - ServeRest

Este projeto contém testes automatizados para a aplicação ServeRest, abrangendo tanto testes de frontend (UI) quanto testes de API REST. Os testes são escritos usando Robot Framework com abordagem BDD.

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
│   └── web_resources.resource     # Keywords específicas para testes Web
│
├── tests/                         # Pasta principal de testes
│   ├── frontend/                  # Testes de frontend (UI)
│   │   ├── cadastro_usuario_test.robot      # Testes de cadastro
│   │   ├── login_test.robot                 # Testes de login
│   │   └── fluxo_compra_test.robot          # Testes de fluxo de compra
│   │
│   └── api/                       # Testes de API
│       └── usuarios_api_tests.robot         # Testes da API de usuários
│
└── results/                       # Pasta para armazenar resultados dos testes
```

## Pré-requisitos

- Python 3.6 ou superior
- Robot Framework
- Selenium WebDriver
- RequestsLibrary para testes de API
- Navegador (Chrome ou Firefox)

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

O arquivo `resources/common.resource` contém variáveis globais e funções utilitárias:
```robotframework
*** Variables ***
${BASE_URL}        https://front.serverest.dev
${API_URL}         https://serverest.dev
${BROWSER}         chrome
${DEFAULT_TIMEOUT} 10s
```

Você pode personalizar estas configurações conforme necessário.

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

### Executar um teste específico
```bash
robot -d results tests/frontend/login_test.robot
```

### Executar um caso de teste específico
```bash
robot -d results -t "Cenário: Login com sucesso" tests/frontend/login_test.robot
```

### Executar testes por tags
```bash
robot -d results -i regressao tests/
```

## Estrutura dos Testes

### Testes de Frontend

Os testes de frontend seguem um padrão BDD com keywords como:
- `Dado que estou na página de login`
- `Quando preencho os campos de login`
- `Então devo ser redirecionado para a página inicial`

Exemplo:
```robotframework
*** Test Cases ***
Cenário: Login com sucesso
    Dado que estou na página de login
    Quando preencho os campos de login
    E clico no botão Entrar
    Então devo ser redirecionado para a página inicial
```

### Testes de API

Os testes de API também seguem o padrão BDD:
```robotframework
*** Test Cases ***
Cenário: Cadastrar usuário com sucesso
    Dado que tenho dados válidos para um novo usuário
    Quando solicito o cadastro do usuário via API
    Então o usuário deve ser cadastrado com sucesso
    E devo receber o ID do novo usuário
```

## Recursos Compartilhados

### web_resources.resource
Contém keywords reutilizáveis para testes de UI:
- Ações de navegação
- Ações de cadastro
- Ações de login
- Ações de compra
- Keywords BDD para diferentes funcionalidades

### api_resources.resource
Contém keywords reutilizáveis para testes de API:
- Criação e gerenciamento de sessões de API
- Ações para endpoints de usuários
- Ações para endpoints de login
- Ações para endpoints de produtos
- Ações para endpoints de carrinhos
- Keywords BDD para diferentes operações de API

## Boas Práticas

1. **Manutenção dos testes**:
   - Use os arquivos de resources para centralizar mudanças
   - Mantenha os seletores atualizados no arquivo `web_resources.resource`

2. **Independência dos testes**:
   - Cada teste deve ser capaz de executar independentemente
   - Use setup e teardown para garantir um estado limpo

3. **Testes de regressão**:
   - Marque testes críticos com a tag `regressao`
   - Execute a suíte completa antes de cada release

4. **Geração de relatórios**:
   - Revise os relatórios gerados em `results/`
   - Capture screenshots em caso de falha

## Solução de Problemas

Se você encontrar o erro "Undefined keyword", verifique:
1. Se o arquivo .resource está sendo importado corretamente
2. Se a keyword está definida no arquivo de resource
3. Se há conflitos de nomes entre keywords

Para erros de timeout, ajuste o valor de `${DEFAULT_TIMEOUT}` para dar mais tempo para carregamento de elementos.

## Contribuição

1. Faça um fork do projeto
2. Crie sua branch de feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request