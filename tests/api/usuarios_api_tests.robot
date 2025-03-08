*** Settings ***
Documentation     Testes de API para o endpoint de usuários usando abordagem BDD
Resource          ../../resources/api_resources.resource
Suite Setup       Criar Sessão API
Suite Teardown    Encerrar Sessão API
Test Teardown     Log To Console    Teste concluído: ${TEST NAME}

*** Test Cases ***
Cenário: Cadastrar usuário com sucesso
    [Documentation]    Testa o cadastro de um novo usuário via API
    [Tags]    api    usuarios    cadastro
    
    # Dados de teste
    &{usuario}=    Gerar Dados De Teste
    
    # BDD Steps
    Dado que tenho dados válidos para um novo usuário    ${usuario.nome}    ${usuario.email}    ${usuario.senha}
    Quando solicito o cadastro do usuário via API
    Então o usuário deve ser cadastrado com sucesso
    E devo receber o ID do novo usuário
    
    # Limpeza - opcional
    Remover usuário de teste    ${ID_USUARIO}

Cenário: Não deve cadastrar usuário com email duplicado
    [Documentation]    Testa a validação de email já existente
    [Tags]    api    usuarios    validacao
    
    # Dados de teste
    &{usuario}=    Gerar Dados De Teste
    
    # BDD Steps
    Dado que tenho dados válidos para um novo usuário    ${usuario.nome}    ${usuario.email}    ${usuario.senha}
    E este usuário já está cadastrado no sistema
    Quando solicito o cadastro do usuário com o mesmo email
    Então devo receber uma mensagem de erro de email duplicado
    E o código de status deve ser 400
    
    # Limpeza
    Remover usuário de teste    ${ID_USUARIO}

Cenário: Fazer login com credenciais válidas
    [Documentation]    Testa o login com credenciais válidas
    [Tags]    api    login    sucesso
    
    # Dados de teste
    &{usuario}=    Gerar Dados De Teste
    
    # BDD Steps
    Dado que tenho um usuário cadastrado no sistema    ${usuario.nome}    ${usuario.email}    ${usuario.senha}
    Quando faço login com as credenciais corretas    ${usuario.email}    ${usuario.senha}
    Então devo receber um token de autorização
    E a mensagem deve confirmar login bem-sucedido
    
    # Limpeza
    Remover usuário de teste    ${ID_USUARIO}

Cenário: Fluxo completo de uso da API
    [Documentation]    Testa o fluxo completo de uso da API
    [Tags]    api    fluxo    integracao
    
    # Dados de teste
    &{usuario}=    Gerar Dados De Teste
    
    # BDD Steps
    Dado que tenho um usuário cadastrado no sistema    ${usuario.nome}    ${usuario.email}    ${usuario.senha}
    Quando faço login com as credenciais corretas    ${usuario.email}    ${usuario.senha}
    E adiciono um produto ao carrinho
    E finalizo a compra
    Então a compra deve ser concluída com sucesso
    
    # Limpeza
    Remover usuário de teste    ${ID_USUARIO}

*** Keywords ***
# --- Passos para BDD ---
Dado que tenho dados válidos para um novo usuário
    [Arguments]    ${nome}    ${email}    ${senha}
    Set Test Variable    ${NOME}    ${nome}
    Set Test Variable    ${EMAIL}    ${email}
    Set Test Variable    ${SENHA}    ${senha}
    Log    Preparando dados para usuário: ${nome}, ${email}

Quando solicito o cadastro do usuário via API
    ${resp}=    Cadastrar Usuário Via API    ${NOME}    ${EMAIL}    ${SENHA}    false
    Set Test Variable    ${RESP_CADASTRO}    ${resp}

Então o usuário deve ser cadastrado com sucesso
    Validar Status Code    ${RESP_CADASTRO}    201
    Validar Mensagem De Resposta    ${RESP_CADASTRO}    Cadastro realizado com sucesso

E devo receber o ID do novo usuário
    Dictionary Should Contain Key    ${RESP_CADASTRO.json()}    _id
    ${id}=    Set Variable    ${RESP_CADASTRO.json()['_id']}
    Set Test Variable    ${ID_USUARIO}    ${id}
    Log    ID do usuário criado: ${ID_USUARIO}

Dado que tenho um usuário cadastrado no sistema
    [Arguments]    ${nome}    ${email}    ${senha}
    Dado que tenho dados válidos para um novo usuário    ${nome}    ${email}    ${senha}
    Quando solicito o cadastro do usuário via API
    Então o usuário deve ser cadastrado com sucesso
    E devo receber o ID do novo usuário

E este usuário já está cadastrado no sistema
    ${resp}=    Cadastrar Usuário Via API    ${NOME}    ${EMAIL}    ${SENHA}    false
    Validar Status Code    ${resp}    201
    ${id}=    Set Variable    ${resp.json()['_id']}
    Set Test Variable    ${ID_USUARIO}    ${id}

Quando solicito o cadastro do usuário com o mesmo email
    ${resp}=    Cadastrar Usuário Via API    ${NOME}    ${EMAIL}    ${SENHA}    false
    Set Test Variable    ${RESP_CADASTRO}    ${resp}

Então devo receber uma mensagem de erro de email duplicado
    Validar Mensagem De Resposta    ${RESP_CADASTRO}    Este email já está sendo usado

E o código de status deve ser 400
    Validar Status Code    ${RESP_CADASTRO}    400

Quando faço login com as credenciais corretas
    [Arguments]    ${email}    ${senha}
    ${resp}=    Fazer Login Via API    ${email}    ${senha}
    Set Test Variable    ${RESP_LOGIN}    ${resp}

Então devo receber um token de autorização
    Validar Status Code    ${RESP_LOGIN}    200
    Dictionary Should Contain Key    ${RESP_LOGIN.json()}    authorization
    ${token}=    Set Variable    ${RESP_LOGIN.json()['authorization']}
    Set Test Variable    ${TOKEN}    ${token}
    Definir Token No Header

E a mensagem deve confirmar login bem-sucedido
    Dictionary Should Contain Key    ${RESP_LOGIN.json()}    message
    Should Be Equal    ${RESP_LOGIN.json()['message']}    Login realizado com sucesso

E adiciono um produto ao carrinho
    # Listar produtos
    ${produtos_resp}=    Obter Produtos
    Validar Status Code    ${produtos_resp}    200
    
    # Pegar o ID do primeiro produto
    ${produtos}=    Set Variable    ${produtos_resp.json()['produtos']}
    ${primeiro_produto}=    Set Variable    ${produtos}[0]
    ${id_produto}=    Set Variable    ${primeiro_produto['_id']}
    Set Test Variable    ${ID_PRODUTO}    ${id_produto}
    
    # Criar carrinho com o produto
    @{produtos_carrinho}=    Create List    &{{"idProduto": "${id_produto}", "quantidade": 1}}
    ${carrinho_resp}=    Criar Carrinho    ${produtos_carrinho}
    Set Test Variable    ${RESP_CARRINHO}    ${carrinho_resp}
    Validar Status Code    ${carrinho_resp}    201

E finalizo a compra
    ${compra_resp}=    Concluir Compra
    Set Test Variable    ${RESP_COMPRA}    ${compra_resp}

Então a compra deve ser concluída com sucesso
    Validar Status Code    ${RESP_COMPRA}    200
    Validar Mensagem De Resposta    ${RESP_COMPRA}    Registro excluído com sucesso

Remover usuário de teste
    [Arguments]    ${id}
    # Se já temos token, não precisamos fazer login novamente
    ${token_exists}=    Run Keyword And Return Status    Variable Should Exist    ${TOKEN}
    Run Keyword If    not ${token_exists}    Fazer Login Para Limpeza
    
    ${delete_resp}=    Deletar Usuário    ${id}
    Validar Status Code    ${delete_resp}    200

Fazer Login Para Limpeza
    ${login_resp}=    Fazer Login Via API    ${EMAIL}    ${SENHA}
    Validar Status Code    ${login_resp}    200
    ${token}=    Set Variable    ${login_resp.json()['authorization']}
    Set Test Variable    ${TOKEN}    ${token}
    Definir Token No Header