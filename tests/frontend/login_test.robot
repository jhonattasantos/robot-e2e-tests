*** Settings ***
Documentation     Teste de login para o site ServeRest
Library           SeleniumLibrary
Test Teardown     Close Browser

*** Variables ***
${URL}            https://front.serverest.dev/login
${BROWSER}        chrome
${EMAIL}          fulano@qa.com
${PASSWORD}       teste

*** Test Cases ***
Cenário: Login com sucesso
    Dado que estou na página de login
    Quando preencho os campos de login
    E clico no botão Entrar
    Então devo ser redirecionado para a página inicial

*** Keywords ***
Dado que estou na página de login
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    css:h1
    Page Should Contain    Login

Quando preencho os campos de login
    Input Text    css:input[data-testid='email']    ${EMAIL}
    Input Text    css:input[data-testid='senha']    ${PASSWORD}

E clico no botão Entrar
    Click Button    css:button[data-testid='entrar']

Então devo ser redirecionado para a página inicial
    Wait Until Page Contains Element    css:div.jumbotron    timeout=10s
    Wait Until Element Contains    css:div.jumbotron > h1    Bem Vindo    timeout=10s
    Page Should Contain    Este é seu sistema para administrar seu ecommerce