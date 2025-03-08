*** Settings ***
Documentation     Recursos específicos para testes de interface web
Resource          common.resource

*** Variables ***
# URLs específicas
${URL_CADASTRO}            ${BASE_URL}/cadastrarusuarios
${URL_LOGIN}               ${BASE_URL}/login
${URL_PRODUTOS}            ${BASE_URL}/listagemDeProdutos

# Seletores de elementos
${CAMPO_NOME}              css:input[data-testid='nome']
${CAMPO_EMAIL}             css:input[data-testid='email']
${CAMPO_SENHA}             css:input[data-testid='password']
${CAMPO_SENHA_LOGIN}       css:input[data-testid='senha']
${BOTAO_CADASTRAR}         css:button[data-testid='cadastrar']
${BOTAO_ENTRAR}            css:button[data-testid='entrar']


*** Keywords ***
# --- Setup e Teardown ---
Abrir Navegador
    Open Browser    about:blank    ${BROWSER}
    Maximize Browser Window

Fechar Navegador
    Close Browser

# --- Ações de Navegação ---
Ir Para Página De Cadastro
    Go To    ${URL_CADASTRO}
    Wait Until Page Contains Element    css:h2.font-robot    timeout=${DEFAULT_TIMEOUT}
    Element Should Contain    css:h2.font-robot    Cadastro
    Page Should Contain    Cadastro

Ir Para Página De Login
    Go To    ${URL_LOGIN}
    Wait Until Page Contains Element    css:h1    timeout=${DEFAULT_TIMEOUT}
    Page Should Contain    Login

# --- BDD Keywords para Login ---
Dado que estou na página de login
    Ir Para Página De Login

Então devo ser redirecionado para a página inicial
    Wait Until Page Contains Element    css:div.jumbotron    timeout=${DEFAULT_TIMEOUT}
    Wait Until Element Contains    css:div.jumbotron > h1    Bem Vindo    timeout=${DEFAULT_TIMEOUT}
    Page Should Contain    Este é seu sistema para administrar seu ecommerce
    Page Should Contain Element    css:a[data-testid='listarProdutos'] 

Então devo ser redirecionado para a página inicial com a lista de produtos
    Wait Until Page Contains    Serverest Store    timeout=${DEFAULT_TIMEOUT}
    Page Should Contain    Produtos

E clico no botão Entrar
    Click Button    ${BOTAO_ENTRAR}

# --- BDD Keywords para Cadastro ---
Dado que estou na página de cadastro de usuários
    Ir Para Página De Cadastro

Então devo ver a mensagem de cadastro com sucesso
    Wait Until Page Contains    Cadastro realizado com sucesso    timeout=${DEFAULT_TIMEOUT}
    Page Should Contain    Cadastro realizado com sucesso

Gerar dados do cadastro do usuário
    [Documentation]    Gera dados de usuário aleatórios e retorna um dicionário
    ${nome}=    Gerar Nome Completo
    ${email}=   Gerar Email Faker
    ${senha}=   Gerar Senha Aleatória

    ${usuario}=    Create Dictionary    nome=${nome}    email=${email}    senha=${senha}
    RETURN    ${usuario}

Log Dados do Usuário
    [Documentation]    Exibe os dados do usuário no log
    [Arguments]    ${usuario}
    Log    Usuário criado:
    Log    Nome: ${usuario['nome']}
    Log    Email: ${usuario['email']}
    Log    Senha: ${usuario['senha']}

Quando preencho o formulário com dados aleatórios
    [Arguments]    ${nome}    ${email}    ${senha}    ${admin}=false
    Input Text    ${CAMPO_NOME}    ${nome}
    Input Text    ${CAMPO_EMAIL}    ${email}
    Input Text    ${CAMPO_SENHA}    ${senha}
    Run Keyword If    '${admin}' == 'true'    Select Checkbox    id=administrador
    ...    ELSE    Unselect Checkbox    id=administrador


# --- BDD Keywords para Fluxo de Compra ---
Dado que acesso a página de login
    Ir Para Página De Login

Então devo ver a mensagem de sucesso
    Wait Until Page Contains    Cadastro realizado com sucesso    timeout=${DEFAULT_TIMEOUT}
    Page Should Contain    Cadastro realizado com sucesso

# --- Ações de Cadastro ---
Preencher Formulário De Cadastro
    [Arguments]    ${email}    ${senha}    ${admin}=false
    ${nome}=    Gerar Nome Completo
    Input Text    ${CAMPO_NOME}    ${nome}
    Input Text    ${CAMPO_EMAIL}    ${email}
    Input Text    ${CAMPO_SENHA}    ${senha}
    Run Keyword If    '${admin}' == 'true'    Select Checkbox    id=administrador
    ...    ELSE    Unselect Checkbox    id=administrador

Submeter Cadastro
    Click Button    ${BOTAO_CADASTRAR}

Verificar Cadastro Com Sucesso
    Wait Until Page Contains    Cadastro realizado com sucesso    timeout=${DEFAULT_TIMEOUT}

# --- Ações de Login ---
Fazer Login
    [Arguments]    ${email}    ${senha}
    Input Text    ${CAMPO_EMAIL}    ${email}
    Input Text    ${CAMPO_SENHA_LOGIN}    ${senha}
    Click Button    ${BOTAO_ENTRAR}

