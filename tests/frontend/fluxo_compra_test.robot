*** Settings ***
Documentation     Teste do fluxo completo de compra no ServeRest
Library           SeleniumLibrary
Library           String
Test Teardown     Close Browser

*** Variables ***
${URL_CADASTRO}           https://front.serverest.dev/cadastrarusuarios
${URL_LOGIN}              https://front.serverest.dev/login
${BROWSER}                chrome
${NOME}                   Cliente Teste
${PASSWORD}               teste123
${ADMINISTRADOR_SIM}       true
${ADMINISTRADOR_NAO}       false

*** Test Cases ***
Fluxo Completo: Registro, Login e Compra de Produto
    # 1. Registrar novo usuário
    Dado que acesso a página de cadastro
    ${EMAIL_USUARIO}=    Gerar Email Aleatório
    E preencho os dados do novo usuário    ${EMAIL_USUARIO}
    E clico em cadastrar
    Então verifico se o cadastro foi realizado com sucesso
    
    # 2. Fazer login com o usuário criado
    Dado que acesso a página de login
    E preencho os dados de login    ${EMAIL_USUARIO}    ${PASSWORD}
    E clico em entrar
    Então verifico se o login foi realizado com sucesso

    # 3. Adicionar um produto a lista
    Dado que adiciono um produto a lista
    Então verifico se o produto foi adicionado a lista
    
    # 4. Finalizar a compra
    Dado que acesso a pagina do carrinho 
    # E finalizo a compra
    # Então verifico se a compra foi realizada com sucesso

*** Keywords ***
# --- Cadastro de usuário ---
Dado que acesso a página de cadastro
    Open Browser    ${URL_CADASTRO}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    css:h2
    Page Should Contain    Cadastro

Gerar Email Aleatório
    ${RANDOM}=    Generate Random String    8    [LETTERS][NUMBERS]
    Set Test Variable    ${RANDOM}
    Set Test Variable    ${EMAIL}    usuario_teste_${RANDOM}@teste.com
    RETURN    ${EMAIL}

E preencho os dados do novo usuário
    [Arguments]    ${email}
    Input Text    css:input[data-testid='nome']    ${NOME}
    Input Text    css:input[data-testid='email']    ${email}
    Input Text    css:input[data-testid='password']    ${PASSWORD}
    # Seleciona "Não" para administrador (cliente comum)
    Run Keyword If    '${ADMINISTRADOR_NAO}' == 'true'    Select Checkbox    id=administrador  
    Run Keyword If    '${ADMINISTRADOR_NAO}' == 'false'    Unselect Checkbox    id=administrador 

E clico em cadastrar
    Click Button    css:button[data-testid='cadastrar']

Então verifico se o cadastro foi realizado com sucesso
    Wait Until Page Contains    Cadastro realizado com sucesso    timeout=10s
    Page Should Contain    Cadastro realizado com sucesso

# --- Login ---
Dado que acesso a página de login
    Go To    ${URL_LOGIN}
    Wait Until Page Contains Element    css:h1
    Page Should Contain    Login

E preencho os dados de login
    [Arguments]    ${email}    ${senha}
    Input Text    css:input[data-testid='email']    ${email}
    Input Text    css:input[data-testid='senha']    ${senha}

E clico em entrar
    Click Button    css:button[data-testid='entrar']

Então verifico se o login foi realizado com sucesso
    Wait Until Page Contains Element    css:div.jumbotron    timeout=10s
    Wait Until Element Contains    css:div.jumbotron > h1    Serverest Store    timeout=10s
    Page Should Contain    Serverest Store

# --- Adição a Lista ---
Dado que adiciono um produto a lista
    # Espera até que pelo menos um botão "Adicionar ao carrinho" esteja visível
    Wait Until Page Contains Element    css:button[data-testid='adicionarNaLista']    timeout=10s
    
    # Clica no primeiro botão "Adicionar ao carrinho" que encontrar
    Click Element    css:button[data-testid='adicionarNaLista']

Então verifico se o produto foi adicionado a lista
    # Verifica se aparece uma mensagem de confirmação ou o contador do carrinho é atualizado
    Wait Until Page Contains    Lista de Compras    timeout=10s
    # Clica no botão Adicionar no carrinho 
    Click Element    css:button[data-testid='adicionar carrinho']

# --- Finalização ---
Dado que acesso a pagina do carrinho 
    # Verifica se aparece a mensagem "Em construção aguarde"
    Wait Until Page Contains    Em construção aguarde    timeout=10s
