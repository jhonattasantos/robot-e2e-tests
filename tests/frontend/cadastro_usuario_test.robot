*** Settings ***
Documentation     Teste de cadastro de usuário para o site ServeRest
Resource          ../../resources/web_resources.resource
Test Setup        Abrir Navegador
Test Teardown     Fechar Navegador
Test Timeout      2 minutes

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
Quando preencho os campos do formulário como administrador
    ${email}=    Gerar Email Aleatório
    Input Text    ${CAMPO_NOME}    ${CAMPO_NOME}
    Input Text    ${CAMPO_EMAIL}    ${email}
    Input Text    ${CAMPO_SENHA}    ${CAMPO_SENHA}
    # Seleciona "Sim" para administrador
    Select Checkbox    id=administrador

Quando preencho os campos do formulário como não administrador
    ${email}=    Gerar Email Aleatório
    Input Text    ${CAMPO_NOME}    ${CAMPO_NOME}
    Input Text    ${CAMPO_EMAIL}    ${email}
    Input Text    ${CAMPO_SENHA}    ${CAMPO_SENHA}
    # Não marca o checkbox de administrador
    Unselect Checkbox    id=administrador

E clico no botão Cadastrar
    Click Button    css:button[data-testid='cadastrar']

Então devo ver a mensagem de cadastro com sucesso
    Wait Until Page Contains    Cadastro realizado com sucesso    timeout=${DEFAULT_TIMEOUT}
    Page Should Contain    Cadastro realizado com sucesso