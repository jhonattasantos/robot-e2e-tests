*** Settings ***
Documentation     Teste de cadastro de usuário para o site ServeRest
Library           SeleniumLibrary
Library           String
Test Teardown     Close Browser

*** Variables ***
${URL}                     https://front.serverest.dev/cadastrarusuarios
${BROWSER}                 chrome
${NOME}                    Usuário Teste
${PASSWORD}                teste123
${ADMINISTRADOR_SIM}       true
${ADMINISTRADOR_NAO}       false

*** Test Cases ***
Cenário: Cadastrar novo usuário com sucesso
    Dado que estou na página de cadastro de usuários
    Quando preencho os campos do formulário como administrador
    E clico no botão Cadastrar
    Então devo ver a mensagem de cadastro com sucesso

Cenário: Cadastrar usuário não administrador
    Dado que estou na página de cadastro de usuários
    Quando preencho os campos do formulário como não administrador
    E clico no botão Cadastrar
    Então devo ver a mensagem de cadastro com sucesso

*** Keywords ***
Dado que estou na página de cadastro de usuários
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    css:h2.font-robot
    Element Should Contain    css:h2.font-robot    Cadastro
    Page Should Contain    Cadastro

Gerar Email Aleatório
    ${RANDOM}=    Generate Random String    8    [LETTERS][NUMBERS]
    Set Test Variable    ${RANDOM}
    Set Test Variable    ${EMAIL}    usuario_teste_${RANDOM}@teste.com
    [Return]    ${EMAIL}

Quando preencho os campos do formulário como administrador
    ${EMAIL}=    Gerar Email Aleatório
    Input Text    css:input[data-testid='nome']    ${NOME}
    Input Text    css:input[data-testid='email']    ${EMAIL}
    Input Text    css:input[data-testid='password']    ${PASSWORD}
    # Seleciona "Sim" para administrador
    Run Keyword If    '${ADMINISTRADOR_SIM}' == 'true'    Select Checkbox    id=administrador  
    Run Keyword If    '${ADMINISTRADOR_SIM}' == 'false'    Unselect Checkbox    id=administrador  

Quando preencho os campos do formulário como não administrador
    ${email}=    Gerar Email Aleatório
    Input Text    css:input[data-testid='nome']    ${NOME}
    Input Text    css:input[data-testid='email']    ${email}
    Input Text    css:input[data-testid='password']    ${PASSWORD}
    # Não marca o checkbox de administrador
    Run Keyword If    '${ADMINISTRADOR_NAO}' == 'true'    Select Checkbox    id=administrador    
    Run Keyword If    '${ADMINISTRADOR_NAO}' == 'false'    Unselect Checkbox    id=administrador

E clico no botão Cadastrar
    Click Button    css:button[data-testid='cadastrar']

Então devo ver a mensagem de cadastro com sucesso
    Wait Until Page Contains    Cadastro realizado com sucesso    timeout=10s
    Page Should Contain    Cadastro realizado com sucesso
