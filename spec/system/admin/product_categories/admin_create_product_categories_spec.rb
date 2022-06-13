require 'rails_helper'

describe 'Admin entra no gerenciamento de Categoria de Produtos' do
  it 'e cria nova Categoria do Produto com sucesso' do
    admin = create(:admin)
    root_product = create(:product_category, :root)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Categorias'
    click_on 'Nova Categoria de Produto'
    fill_in 'Nome', with: 'Cadeira Office'
    select root_product.name, from: 'Categoria Pai'
    click_on 'Salvar'

    expect(page).to have_content('Categoria de Produto criada com sucesso')
    expect(page).to have_content('Cadeira Office')
  end

  it 'e não cria Categoria do Produto sem nome' do
    admin = create(:admin)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Categorias'
    click_on 'Nova Categoria de Produto'
    fill_in 'Nome', with: ''
    click_on 'Salvar'

    expect(page).to_not have_content('Categoria de Produto criada com sucesso')
    expect(page).to have_content('Nome não pode ficar em branco')
  end

  it 'e desiste de criar Categoria do Produto e volta ao index de Categorias de Produto' do
    admin = create(:admin)
    root_category = create(:product_category, :root)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Categorias'
    click_on 'Nova Categoria de Produto'
    click_on 'Voltar'

    expect(current_path).to eq(product_categories_path)
  end

end