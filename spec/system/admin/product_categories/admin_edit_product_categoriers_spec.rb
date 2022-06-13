require 'rails_helper'

describe 'Admin entra no gerenciamento de Categoria de Produtos' do
  it 'e edita Categoria do Produto com sucesso' do
    admin = create(:admin)
    root_product = create(:product_category, :root)
    product = create(:product_category, :child, parent: root_product)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Categorias'
    first(:link, 'Editar').click
    fill_in 'Nome', with: 'Cadeira Office'
    click_on 'Salvar'

    expect(page).to have_content('Categoria de Produto atualizada com sucesso')
    expect(page).to have_content('Cadeira Office')
  end

  it 'e edita Categoria do Produto sem sucesso #1' do
    admin = create(:admin)
    root_product = create(:product_category, :root)
    product = create(:product_category, :child, parent: root_product)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Categorias'
    first(:link, 'Editar').click
    fill_in 'Nome', with: ''
    click_on 'Salvar'

    expect(page).to have_content('Falha na atualização da Categoria de Produto')
    expect(page).not_to have_content('Cadeira Office')
  end

  it 'e edita Categoria do Produto sem sucesso #2' do
    admin = create(:admin)
    root_product = create(:product_category, :root)
    product1 = create(:product_category, :child, parent: root_product)
    product2 = create(:product_category, name: 'Cadeira Office' , parent: root_product)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Categorias'
    first(:link, 'Editar').click
    fill_in 'Nome', with: 'Cadeira Office'
    click_on 'Salvar'

    expect(page).to have_content('Falha na atualização da Categoria de Produto')
  end

  it 'e desiste de editar Categoria do Produto e volta ao index de Categorias de Produto' do
    admin = create(:admin)
    root_product = create(:product_category, :root)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Categorias'
    first(:link, 'Editar').click
    click_on 'Voltar'

    expect(current_path).to eq(product_categories_path)
  end
end