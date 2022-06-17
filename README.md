# Mercadores - Um site de regate de pontos

:warning:  projeto em desenvolvimento  
  
Mercadores é uma loja virtual que permite a compra de produtos mediante pagamento com Rubis, um sistema de pontos.  

## Domínio

Um **produto** (`Product`) é o que se vende. Ele pode ter status *em rascunho* (`draft`), *à venda*(`on_shelf`) e *suspenso* (`off_shelf`). Apenas produtos à venda aparecem para os usuários finais.  
  
Desses produtos que aparecem, um usuário pode colocá-los num carrinho e gerar um **pedido** (`Order`), que é posteriormente processado pelo [serviço de pagamentos](https://github.com/TreinaDev/pagamentos-td08-time01).  
  
Os **preço**s (`Price`) de um produto podem ser atualizados automaticamente de acordo com uma data previamente indicada por algum admin do sistema.


## Versão do Ruby
![This app requires Ruby 3.1.0 to be installed](https://img.shields.io/static/v1?label=ruby&message=version%203.1.0&color=B61D1D&style=for-the-badge&logo=ruby)  
  
## Dependências de sistema
 - sqlite3  

## Configuração
Clonar repositório  
`$ git clone git@github.com:TreinaDev/e-commerce-td08-time01.git`  
  
Navegar para a pasta do repositório  
`$ cd e-commerce-td08-time01.git`  
  
Preparar a aplicação   
`$ bin/setup`   

## Demonstração

Para fazer um simulado do funcionamento da aplicação, é interessante popular o banco de dados. Isso pode ser feito rodando o comando abaixo no diretório do projeto:    
`$ bin/rails db:seed`  
  
Isso vai ativar as seguintes credenciais de acesso:    
| tipo | email | senha | página de login |
| -------- | -------- | -------- | -------- | 
| admin   | claudia@mercadores.com.br | 123456 | http://localhost:3000/admins/sign_in |
| cliente | joaquim@meuemail.com.br   | 123456 | http://localhost:3000/users/sign_in |

Para reinicializar o banco de dados, rode o comando abaixo no diretório do projeto:  
`$ bin/rails db:drop db:create db:migrate`  
(observe que isso irá limpar todos os dados, não apenas os da demo)  

## Testes

No diretório do projeto, rode:  
`$ bin/bundle exec rspec`   

## Contexto de criação

Este app foi desenvolvido como um projeto em equipe para a 2ª parte do bootcamp [Treinadev](https://treinadev.com.br/), turma 8.  
  
Esta é a equipe 1, composta por 9 pessoas divididas na frente de **e-commerce** (este repositório) e **[pagamentos](https://github.com/TreinaDev/pagamentos-td08-time01)**. Durante 4 semanas, nos encontramos para pair programming todos os dias, simulando a rotina real de uma empresa:  
- *plannings* todas as segundas-feiras
- *dailies* todos os dias no início da jornada
- apresentação de evolução do projeto todas as sexta-feiras
- tarefas organizadas em *stories* num *board* de projeto
- desenvolvimento em *branches*, passando por *pull requests* e *code review*

### Membros da equipe:
- [Davide Almeida](https://github.com/davide-almeida)
- [Jhonny Toledo](https://github.com/Jhonny4975)
- [Júnior Beto](https://github.com/b-sep)
- [kyrir](https://github.com/kyriri)
- [Lucas Borges](https://github.com/LucasDLAB)
- [Maciel Júnior](https://github.com/macieljuniormax)
- [Philipe Leandro](https://github.com/philipeleandro)
- [Thiago Gondim](https://github.com/thiagogondim)
- [Vector54](https://github.com/Vector54)
