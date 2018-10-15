*** Setting ***
Documentation  Documentacao da API: https://fakerestapi.azurewebsites.net/swagger/ui/index#/Books
Library        RequestsLibrary
Library        Collections

*** Variables ***
${URL_API}  https://fakerestapi.azurewebsites.net/api/
&{BOOK_15}  ID=15
...         Title=Book 15
...         PageCount=1500
&{BOOK_7}   ID=7
...         Title=Teste
...         Description=Teste API
...         PageCount=700
...         Excerpt=Teste de API
&{BOOK_32}  ID=32
...         Title=Book 32 - Alteraçao Luana
...         Description=Book 32 alterado por Luana
...         PageCount=150
...         Excerpt=alterar book 32
...         PublishDate=2018-10-08T01:24:45.557Z

*** Keywords ***
#SETUP E TEARDOWN
Conectar a API
    Create Session    FakeAPI    ${URL_API}

#AÇÕES
Requisitar todos os livros
  ${RESPOSTA}  Get Request    FakeAPI    Books
  Log          ${RESPOSTA.text}
  Set Test Variable    ${RESPOSTA}

Requisitar o livro "${ID_LIVRO}"
  ${RESPOSTA}  Get Request    FakeAPI    Books/${ID_LIVRO}
  Log          ${RESPOSTA.text}
  Set Test Variable    ${RESPOSTA}

Cadastrar um novo livro
  ${HEADERS}   Create Dictionary    content-type=application/json
  Set Suite Variable    ${HEADERS}
  ${RESPOSTA}  Post Request   FakeAPI   Books
  ...                         data={"ID": 7,"Title": "Teste","Description": "Teste API","PageCount": 700,"Excerpt": "Teste de API","PublishDate": "2018-10-05T12:50:27.161Z"}
  ...                         headers=${HEADERS}
  Log         ${RESPOSTA.text}
  Set Test Variable    ${RESPOSTA}

Alterar o livro "${ID_LIVRO}"
  ${RESPOSTA}    Put Request    fakeAPI    Books/${ID_LIVRO}
  ...                           data={"ID": ${BOOK_32.ID},"Title": "${BOOK_32.Title}","Description": "${BOOK_32.Description}","PageCount": ${BOOK_32.PageCount},"Excerpt": "${BOOK_32.Excerpt}","PublishDate": "${BOOK_32.PublishDate}"}
  ...                           headers=${HEADERS}
  Log            ${RESPOSTA.text}
  Set Test Variable    ${RESPOSTA}

Excluir o livro "${ID_LIVRO}"
  ${RESPOSTA}    Delete Request    fakeAPI    Books/${ID_LIVRO}
  Log            ${RESPOSTA.text}
  Set Test Variable    ${RESPOSTA}

#CONFERÊNCIAS
Conferir o Status Code
  [Arguments]  ${STATUSCODE_DESEJADO}
  Should Be Equal As Strings    ${RESPOSTA.status_code}    ${STATUSCODE_DESEJADO}

Conferir o Reason
  [Arguments]  ${REASON_DESEJADO}
  Should Be Equal As Strings    ${RESPOSTA.reason}    ${REASON_DESEJADO}

Conferir se retornou uma lista com "${QTDE_LIVROS}" livros
  Length Should Be    ${RESPOSTA.json()}    ${QTDE_LIVROS}

Conferir o retorno de todos os dados corretos do livro 15
  Dictionary Should Contain Item    ${RESPOSTA.json()}    ID            ${BOOK_15.ID}
  Dictionary Should Contain Item    ${RESPOSTA.json()}    Title         ${BOOK_15.Title}
  Dictionary Should Contain Item    ${RESPOSTA.json()}    PageCount     ${BOOK_15.PageCount}

  Should Not Be Empty   ${RESPOSTA.json()["Description"]}
  Should Not Be Empty   ${RESPOSTA.json()["Excerpt"]}
  Should Not Be Empty   ${RESPOSTA.json()["PublishDate"]}

Conferir se retorna todos os dados cadastrados para o novo livro
  Dictionary Should Contain Item    ${RESPOSTA.json()}    ID            ${BOOK_7.ID}
  Dictionary Should Contain Item    ${RESPOSTA.json()}    Title         ${BOOK_7.Title}
  Dictionary Should Contain Item    ${RESPOSTA.json()}    Description   ${BOOK_7.Description}
  Dictionary Should Contain Item    ${RESPOSTA.json()}    PageCount     ${BOOK_7.PageCount}
  Dictionary Should Contain Item    ${RESPOSTA.json()}    Excerpt       ${BOOK_7.Excerpt}

  Should Not Be Empty   ${RESPOSTA.json()["PublishDate"]}

Conferir se retorna todos os dados alterados do livro "${ID_LIVRO}"
  Conferir livro    ${ID_LIVRO}

Conferir livro
      [Arguments]     ${ID_LIVRO}
      Dictionary Should Contain Item    ${RESPOSTA.json()}    ID              ${BOOK_${ID_LIVRO}.ID}
      Dictionary Should Contain Item    ${RESPOSTA.json()}    Title           ${BOOK_${ID_LIVRO}.Title}
      Dictionary Should Contain Item    ${RESPOSTA.json()}    Description     ${BOOK_${ID_LIVRO}.Description}
      Dictionary Should Contain Item    ${RESPOSTA.json()}    PageCount       ${BOOK_${ID_LIVRO}.PageCount}
      Dictionary Should Contain Item    ${RESPOSTA.json()}    Excerpt         ${BOOK_${ID_LIVRO}.Excerpt}
      Dictionary Should Contain Item    ${RESPOSTA.json()}    PublishDate     ${BOOK_${ID_LIVRO}.PublishDate}

Conferir se excluiu o livro "${ID_LIVRO}"
  Should Be Empty     ${RESPOSTA.content}
