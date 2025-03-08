*** Settings ***
Documentation     Teste do fluxo completo de compra no ServeRest
Resource          ../../resources/web_resources.resource
Test Setup        Abrir Navegador
Test Teardown     Fechar Navegador
Test Timeout      3 minutes

*** Test Cases ***
Fluxo Completo: Registro, Login e Compra de Produto
    [Documentation]    Simula o processo completo de um usuário se registrando, fazendo login e realizando uma compra
    [Tags]    fluxo    regressao    frontend
    
    # 1. Registrar novo usuário
    Dado que acesso a página de cadastro de usuários
    ${EMAIL_USUARIO}=    Gerar Email Aleatório
    E preencho os dados do novo usuário    ${EMAIL_USUARIO}
    E clico no botão Cadastrar
    Então devo ver a mensagem de cadastro com sucesso
    
    # 2. Fazer login com o usuário criado
    Dado que acesso a página de login
    E preencho os dados de login    ${EMAIL_USUARIO}    ${CAMPO_SENHA}
    E clico no botão Entrar
    Então devo ser redirecionado para a página inicial

    # 3. Navegar para produtos e adicionar ao carrinho
    Dado que navego para a lista de produtos
    E adiciono um produto à lista
    Então verifico se o produto foi adicionado à lista
    
    # 4. Finalizar a compra
    Dado que acesso a página do carrinho
    E verifico se a página está em construção

*** Keywords ***
E preencho os dados do novo usuário
    [Arguments]    ${email}
    Input Text    ${CAMPO_NOME}    ${CAMPO_NOME}
    Input Text    ${CAMPO_EMAIL}    ${email}
    Input Text    ${CAMPO_SENHA}    ${CAMPO_SENHA}
    # Não marca o checkbox de administrador (cliente comum)
    Unselect Checkbox    id=administrador

E clico no botão Cadastrar
    Click Button    css:button[data-testid='cadastrar']

E preencho os dados de login
    [Arguments]    ${email}    ${senha}
    Input Text    ${CAMPO_EMAIL}    ${email}
    Input Text    ${CAMPO_SENHA_LOGIN}    ${senha}

Dado que navego para a lista de produtos
    Wait Until Element Is Visible    ${LISTAR_PRODUTOS}    timeout=${DEFAULT_TIMEOUT}
    Click Element    ${LISTAR_PRODUTOS}
    Wait Until Page Contains    Lista de Produtos    timeout=${DEFAULT_TIMEOUT}

E adiciono um produto à lista
    # Espera até que pelo menos um botão "Adicionar ao carrinho" esteja visível
    Wait Until Page Contains Element    css:button[data-testid='adicionarNaLista']    timeout=${DEFAULT_TIMEOUT}
    
    # Clica no primeiro botão "Adicionar ao carrinho" que encontrar
    Click Element    css:button[data-testid='adicionarNaLista']

Então verifico se o produto foi adicionado à lista
    # Verifica se aparece uma mensagem de confirmação ou redireciona para página
    Wait Until Page Contains    Lista de Compras    timeout=${DEFAULT_TIMEOUT}
    # Clica no botão Adicionar no carrinho 
    Wait Until Element Is Visible    css:button[data-testid='adicionar carrinho']    timeout=${DEFAULT_TIMEOUT}
    Click Element    css:button[data-testid='adicionar carrinho']

Dado que acesso a página do carrinho
    # Verificar se acessamos a página do carrinho
    Wait Until Page Contains    Seu Carrinho    timeout=${DEFAULT_TIMEOUT}
    
E verifico se a página está em construção
    # Verifica se aparece a mensagem "Em construção aguarde"
    Wait Until Page Contains    Em construção aguarde    timeout=${DEFAULT_TIMEOUT}
    Page Should Contain    Em construção aguarde