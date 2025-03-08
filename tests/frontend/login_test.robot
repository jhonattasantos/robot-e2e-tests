*** Settings ***
Documentation     Teste de login para o site ServeRest
Resource          ../../resources/web_resources.resource
Test Setup        Abrir Navegador
Test Teardown     Fechar Navegador

*** Variables ***
${EMAIL_FIXO}     fulano@qa.com
${SENHA_FIXA}     teste

*** Test Cases ***
Cenário: Login com sucesso usando credenciais fixas
    Dado que estou na página de login
    Quando preencho os campos com credenciais fixas
    E clico no botão Entrar
    Então devo ser redirecionado para a página inicial

Cenário: Login após cadastro de novo usuário
    # Primeiro cadastramos um usuário
    Dado que crio um novo usuário no sistema
    # Depois fazemos login com ele
    Quando faço login com o usuário recém-criado
    Então devo ser redirecionado para a página inicial com a lista de produtos

*** Keywords ***
Quando preencho os campos com credenciais fixas
    Input Text    ${CAMPO_EMAIL}    ${EMAIL_FIXO}
    Input Text    ${CAMPO_SENHA_LOGIN}    ${SENHA_FIXA}

E clico no botão Entrar
    Click Button    ${BOTAO_ENTRAR}

Dado que crio um novo usuário no sistema
    Ir Para Página De Cadastro
    ${email}=    Gerar Email Faker
    Set Test Variable    ${EMAIL_NOVO}    ${email}
    Preencher Formulário De Cadastro   ${EMAIL_NOVO}     ${CAMPO_SENHA}    false
    Submeter Cadastro
    Verificar Cadastro Com Sucesso

Quando faço login com o usuário recém-criado
    Ir Para Página De Login
    Input Text    ${CAMPO_EMAIL}    ${EMAIL_NOVO}
    Input Text    ${CAMPO_SENHA_LOGIN}    ${CAMPO_SENHA}
    Click Button    ${BOTAO_ENTRAR}