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
${RADIO_ADMIN_SIM}         css:input[value='true']
${RADIO_ADMIN_NAO}         css:input[value='false']
${BOTAO_CADASTRAR}         css:button[data-testid='cadastrar']
${BOTAO_ENTRAR}            css:button[data-testid='entrar']
${LISTAR_PRODUTOS}         css:a[data-testid='listarProdutos']
${ADICIONAR_CARRINHO}      css:button[data-testid='adicionarNaLista']
${ADICIONAR_AO_CARRINHO}   css:button[data-testid='adicionar carrinho']
${CARRINHO}                css:a[data-testid='shopping-cart']
${FINALIZAR_COMPRA}        css:button[data-testid='checkout']

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
    Wait Until Element Contains    css:div.jumbotron > h1   Serverest Store    timeout=${DEFAULT_TIMEOUT}
    # Page Should Contain    Este é seu sistema para administrar seu ecommerce

E clico no botão Entrar
    Click Button    ${BOTAO_ENTRAR}

# --- BDD Keywords para Cadastro ---
Dado que estou na página de cadastro de usuários
    Ir Para Página De Cadastro

Dado que acesso a página de cadastro de usuários
    Ir Para Página De Cadastro

Então devo ver a mensagem de cadastro com sucesso
    Wait Until Page Contains    Cadastro realizado com sucesso    timeout=${DEFAULT_TIMEOUT}
    Page Should Contain    Cadastro realizado com sucesso

# --- BDD Keywords para Fluxo de Compra ---
Dado que acesso a página de login
    Ir Para Página De Login

Então devo ver a mensagem de sucesso
    Wait Until Page Contains    Cadastro realizado com sucesso    timeout=${DEFAULT_TIMEOUT}
    Page Should Contain    Cadastro realizado com sucesso

# --- Ações de Cadastro ---
Preencher Formulário De Cadastro
    [Arguments]    ${nome}    ${email}    ${senha}    ${admin}=false
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

Verificar Login Com Sucesso
    Wait Until Page Contains Element    css:div.jumbotron    timeout=${DEFAULT_TIMEOUT}
    Wait Until Element Contains    css:div.jumbotron > h1    Bem Vindo    timeout=${DEFAULT_TIMEOUT}

# --- Ações de Compra ---
Navegar Para Lista De Produtos
    Wait Until Element Is Visible    ${LISTAR_PRODUTOS}    timeout=${DEFAULT_TIMEOUT}
    Click Element    ${LISTAR_PRODUTOS}
    Wait Until Page Contains    Lista de Produtos    timeout=${DEFAULT_TIMEOUT}

Adicionar Produto Ao Carrinho
    [Arguments]    ${index}=1
    ${locator}=    Set Variable    (${ADICIONAR_CARRINHO})[${index}]
    Wait Until Element Is Visible    ${locator}    timeout=${DEFAULT_TIMEOUT}
    Click Element    ${locator}
    Wait Until Page Contains    Produto adicionado    timeout=${DEFAULT_TIMEOUT}

Acessar Carrinho
    Wait Until Element Is Visible    ${CARRINHO}    timeout=${DEFAULT_TIMEOUT}
    Click Element    ${CARRINHO}
    Wait Until Page Contains    Seu Carrinho    timeout=${DEFAULT_TIMEOUT}

Finalizar Compra
    Wait Until Element Is Visible    ${FINALIZAR_COMPRA}    timeout=${DEFAULT_TIMEOUT}
    Click Element    ${FINALIZAR_COMPRA}
    Wait Until Page Contains    Compra realizada com sucesso    timeout=${DEFAULT_TIMEOUT}

# --- Fluxos Completos ---
Fluxo De Cadastro Completo
    [Arguments]    ${nome}    ${email}    ${senha}    ${admin}=false
    Ir Para Página De Cadastro
    Preencher Formulário De Cadastro    ${nome}    ${email}    ${senha}    ${admin}
    Submeter Cadastro
    Verificar Cadastro Com Sucesso
    [Return]    ${email}

Fluxo De Login Completo
    [Arguments]    ${email}    ${senha}
    Ir Para Página De Login
    Fazer Login    ${email}    ${senha}
    Verificar Login Com Sucesso