*** Setting ***
Documentation  Documentacao da API: https://fakerestapi.azurewebsites.net/swagger/ui/index#/Books
Resource       ResourceAPI.robot
Suite Setup    Conectar a API

*** Test Case ***
Boscar a listagem de todos os livros (GET em todos os livros)
    Requisitar todos os livros
    Conferir o Status Code  200
    Conferir o Reason  OK
    Conferir se retornou uma lista com "200" livros

Buscar um livro específico (GET de um livro específico)
    Requisitar o livro "15"
    Conferir o Status Code  200
    Conferir o Reason  OK
    Conferir o retorno de todos os dados corretos do livro 15

Cadastrar um novo livro (POST)
    Cadastrar um novo livro
    Conferir o Status Code  200
    Conferir o Reason  OK
    Conferir se retorna todos os dados cadastrados para o novo livro

Alterar um livro (PUT)
   Alterar o livro "32"
   Conferir o status code  200
   Conferir o reason   OK
   Conferir se retorna todos os dados alterados do livro "32"

Deletar um livro (DELETE)
   Excluir o livro "200"
   Conferir o status code    200
   Conferir o reason   OK
   Conferir se excluiu o livro "200"
