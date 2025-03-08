*** Settings ***
Documentation     Teste de cadastro de usuário para o site ServeRest
Resource          ../../resources/web_resources.resource
Test Setup        Abrir Navegador
Test Teardown     Fechar Navegador
Test Timeout      2 minutes

*** Test Cases ***
Cenário: Cadastrar novo usuário com sucesso
    [Documentation]    Cadastra um usuário como administrador
    [Tags]    cadastro    regressao    faker    admin

    ${usuario}=    Gerar dados do cadastro do usuário

    Dado que estou na página de cadastro de usuários
    Quando preencho o formulário com dados aleatórios     ${usuario['nome']}    ${usuario['email']}    ${usuario['senha']}    admin=true
    E clico no botão Cadastrar
    Então devo ver a mensagem de cadastro com sucesso

    Log Dados do Usuário    ${usuario}

Cenário: Cadastrar usuário não administrador
    [Documentation]    Cadastra um usuário sem ser administrador
    [Tags]    cadastro    regressao    faker

    ${usuario}=    Gerar dados do cadastro do usuário

    Dado que estou na página de cadastro de usuários
    Quando preencho o formulário com dados aleatórios    ${usuario['nome']}    ${usuario['email']}    ${usuario['senha']}   admin=false
    E clico no botão Cadastrar
    Então devo ver a mensagem de cadastro com sucesso

    Log Dados do Usuário    ${usuario}

*** Keywords ***
E clico no botão Cadastrar
    Click Button    css:button[data-testid='cadastrar']