# Padrões do time

## Língua

#### em inglês:
* nomes de variáveis/métodos  
* comentários no código   
* texto dos testes (o que vai dentro do `it`)  
  
#### em português:
* documentação (readmes, explicação de decisões de projeto, manual de uso das APIs)  
* mensagens de commit  
* issues (cards do github)  
* pull requests (pedidos de revisão de código)  

## Mensagens de commit

### O título...
1. deve ser sucinto, com no máximo 50 caracteres

2. deve ser composto de um tipo seguido de uma descrição
    - o tipo deve ser todo em letras minúsculas e respeitar a tabela abaixo
    - a descrição deve começar com letra maiúscula e terminar sem pontuação

3. deve usar o modo imperativo (hack: deve completar bem a frase "Se implementado, este commit ___")

### O corpo, se existir, ...
4. deve estar separado do título por uma linha em branco

5. deve explicar **o que** está sendo adicionado/mudado, e **por que** a adição/mudança deve ser feita

6. **não** deve explicar *como* as alterações foram feitas, já que isso pode ser compreendido do código

7. deve sofrer quebra de linha ± a cada 72 caracteres

8. deve conter o número do card/issue como última coisa


### Tipos de commit

(parágrafo copiado de [iuricode](https://github.com/iuricode/padroes-de-commits/blob/main/README.md#-tipo-e-descri%C3%A7%C3%A3o))

- `feat`- Commits do tipo feat indicam que seu trecho de código está incluindo um **novo recurso** (se relaciona com o MINOR do versionamento semântico).

- `fix` - Commits do tipo fix indicam que seu trecho de código commitado está **solucionando um problema** (bug fix), (se relaciona com o PATCH do versionamento semântico).

- `docs` - Commits do tipo docs indicam que houveram **mudanças na documentação**, como por exemplo no Readme do seu repositório. (Não inclui alterações em código).

- `test` - Commits do tipo test são utilizados quando são realizadas **alterações em testes**, seja criando, alterando ou excluindo testes unitários. (Não inclui alterações em código)

- `build` - Commits do tipo build são utilizados quando são realizadas modificações em **arquivos de build e dependências**.

- `perf` - Commits do tipo perf servem para identificar quaisquer alterações de código que estejam relacionadas a **performance**.

- `style` - Commits do tipo style indicam que houveram alterações referentes a **formatações de código**, semicolons, trailing spaces, lint... (Não inclui alterações em código).

- `refactor` - Commits do tipo refactor referem-se a mudanças devido a **refatorações que não alterem sua funcionalidade**, como por exemplo, uma alteração no formato como é processada determinada parte da tela, mas que manteve a mesma funcionalidade, ou melhorias de performance devido a um code review.

- `chore` - Commits do tipo chore indicam **atualizações de tarefas** de build, configurações de administrador, pacotes... como por exemplo adicionar um pacote no gitignore. (Não inclui alterações em código)

- `ci` - Commits do tipo ci indicam mudanças relacionadas a **integração contínua** (*continuous integration*).

### Exemplo
```
feat: Adiciona captcha no registro de usuário  
  
Foram detectadas algumas contas aparentemente criadas por bots. A 
ideia é que o captcha dificulte isso.  
  
A gem com manutenção mais ativa, MyCaptcha365, fez o Devise parar de 
funcionar depois de instalada. Então se preferiu a 2ª mais ativa.   
  
Issue #4  
```

## Uso do I18n

* Colocar traduções de models em arquivos com o nome do model, que fica dentro da pasta `models`.   
  
* Ex: o arquivo de tradução do `model Product` fica em: `config/locales/models/product_pt-BR.yml`  
  
* Ao traduzir coisas nas views, preferir usar [lazy look-up](https://guides.rubyonrails.org/i18n.html#lazy-lookup). Colocar traduções de uma view no arquivo do model de mesmo nome. Ex: traduções da view `edit` do modelo `carrier` vão no arquivo `carrier_pt-BR.yml`  
  
### Exemplo

*`app/views/carriers/edit.html.erb`*
```
<h2><%= t('.title_for_this_view') %></h2>

<%= form_with model: @order do |f| %>
  <%= f.label :name, t('activerecord.attributes.shipping_company.name') %>
  <%= f.text_field :name %>
  
  <%= f.label :cnpj, Carrier.human_attribute_name('cnpj') %>
  <%= f.text_field :cnpj %>
  <%= f.submit %>
<% end %>
```

*`config/locales/models/carrier_pt-BR.yml`*
```
pt-BR:
  # aqui são as traduções das views
  carriers:
    edit:
      title_for_this_view: Editar dados da transportadora
      
  # aqui são as traduções do model
  activerecord:
    models:
      carrier: transportadora
    attributes:
      carrier:
        name: nome fantasia
        status: status
        cnpj: CNPJ
      # aqui é uma maneira de traduzir enum 
      carrier/status:
        suspended: suspensa
        in_registration: em processo de cadastro
        active: ativa
    # aqui é um exemplo de tradução personalizada para 
    # erro de validação 
    errors:
      models:
        carrier:
          attributes:
            cnpj:
              wrong_length: deve ter %{count} números
```
