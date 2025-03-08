*** Settings ***
Documentation     Arquivo de recursos comuns para todos os testes
Library           SeleniumLibrary
Library           RequestsLibrary
Library           String
Library           DateTime
Library           FakerLibrary    locale=pt_BR

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

Gerar Email Faker
    ${email}=    FakerLibrary.Email
    RETURN       ${email}

Gerar Nome Completo
    ${nome}=    FakerLibrary.Name
    RETURN     ${nome}

Gerar Senha Aleatória
    ${senha}=    FakerLibrary.Password   length=8   digits=True    upper_case=True    special_chars=True
    RETURN      ${senha}

Gerar Dados De Teste
    ${nome}=         Gerar Nome Completo
    ${email}=        Gerar Email Faker
    ${senha}=        Set Variable            teste123
    &{usuario}=      Create Dictionary       nome=${nome}    email=${email}    senha=${senha}
    RETURN         &{usuario}