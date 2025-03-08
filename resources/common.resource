*** Settings ***
Documentation     Arquivo de recursos comuns para todos os testes
Library           SeleniumLibrary
Library           RequestsLibrary
Library           String
Library           DateTime

*** Variables ***
# URLs de ambiente
${BASE_URL}                       https://front.serverest.dev
${API_URL}                        https://serverest.dev
${BROWSER}                        chrome

# Timeout padrão
${DEFAULT_TIMEOUT}                10s

*** Keywords ***
Gerar Email Aleatório
    ${random_string}=    Generate Random String    8    [LETTERS][NUMBERS]
    ${current_time}=     Get Current Date    result_format=%H%M%S
    ${email}=            Set Variable    usuario_${random_string}_${current_time}@teste.com
    RETURN             ${email}

Gerar Dados De Teste
    ${nome}=         Set Variable            Usuário Teste
    ${email}=        Gerar Email Aleatório
    ${senha}=        Set Variable            teste123
    &{usuario}=      Create Dictionary       nome=${nome}    email=${email}    senha=${senha}
    RETURN         &{usuario}