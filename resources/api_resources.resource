*** Settings ***
Documentation     Recursos específicos para testes de API
Library           RequestsLibrary
Library           Collections
Resource          common.resource

*** Variables ***
${API_USUARIOS}       ${API_URL}/usuarios
${API_PRODUTOS}       ${API_URL}/produtos
${API_CARRINHOS}      ${API_URL}/carrinhos
${API_LOGIN}          ${API_URL}/login

# Headers padrão
&{HEADERS}            Content-Type=application/json    accept=application/json

*** Keywords ***
# --- Setup e Teardown ---
Criar Sessão API
    Create Session    serverest    ${API_URL}    headers=${HEADERS}    verify=True

Encerrar Sessão API
    Delete All Sessions

# --- Ações de API para Usuários ---
Cadastrar Usuário Via API
    [Arguments]    ${nome}    ${email}    ${senha}    ${admin}=false
    &{payload}=    Create Dictionary    nome=${nome}    email=${email}    password=${senha}    administrador=${admin}
    ${resp}=    POST On Session    serverest    /usuarios    json=${payload}    expected_status=any
    RETURN    ${resp}

Obter Usuário Por Email
    [Arguments]    ${email}
    ${resp}=    GET On Session    serverest    /usuarios    params=email=${email}    expected_status=any
    RETURN    ${resp}

Deletar Usuário
    [Arguments]    ${id}
    ${resp}=    DELETE On Session    serverest    /usuarios/${id}    expected_status=any
    RETURN    ${resp}

# --- Ações de API para Login ---
Fazer Login Via API
    [Arguments]    ${email}    ${senha}
    &{payload}=    Create Dictionary    email=${email}    password=${senha}
    ${resp}=    POST On Session    serverest    /login    json=${payload}    expected_status=any
    # Armazenar o token se login bem-sucedido
    Run Keyword If    ${resp.status_code} == 200    
    ...    Set Test Variable    ${TOKEN}    ${resp.json()['authorization']}    
    RETURN    ${resp}

Definir Token No Header
    &{auth_header}=    Create Dictionary    Authorization=${TOKEN}
    Set To Dictionary    ${HEADERS}    Authorization=${TOKEN}
    Create Session    serverest    ${API_URL}    headers=${HEADERS}    verify=True

# --- Ações de API para Produtos ---
Obter Produtos
    [Arguments]    ${params}=&{EMPTY}
    ${resp}=    GET On Session    serverest    /produtos    params=${params}    expected_status=any
    RETURN    ${resp}

Criar Produto
    [Arguments]    ${nome}    ${preco}    ${descricao}    ${quantidade}
    &{payload}=    Create Dictionary    nome=${nome}    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}
    ${resp}=    POST On Session    serverest    /produtos    json=${payload}    expected_status=any
    RETURN    ${resp}

# --- Ações de API para Carrinhos ---
Criar Carrinho
    [Arguments]    ${produtos}
    &{payload}=    Create Dictionary    produtos=${produtos}
    ${resp}=    POST On Session    serverest    /carrinhos    json=${payload}    expected_status=any
    RETURN    ${resp}

Obter Carrinhos
    [Arguments]    ${params}=&{EMPTY}
    ${resp}=    GET On Session    serverest    /carrinhos    params=${params}    expected_status=any
    RETURN    ${resp}

Concluir Compra
    ${resp}=    DELETE On Session    serverest    /carrinhos/concluir-compra    expected_status=any
    RETURN    ${resp}

Cancelar Compra
    ${resp}=    DELETE On Session    serverest    /carrinhos/cancelar-compra    expected_status=any
    RETURN    ${resp}

# --- Verificações comuns ---
Validar Status Code
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}

Validar Mensagem De Resposta
    [Arguments]    ${response}    ${expected_message}
    Should Be Equal    ${response.json()['message']}    ${expected_message}

# --- Fluxos de API Comuns ---
Fluxo API Login E Autenticação
    [Arguments]    ${email}    ${senha}
    Criar Sessão API
    ${resp}=    Fazer Login Via API    ${email}    ${senha}
    Validar Status Code    ${resp}    200
    Definir Token No Header
    RETURN    ${resp}