require 'rails_helper'

describe 'Admin visits the page to edit a ProductCategory' do
  it 'and edits it succesfully' do
    admin = create(:admin)
    root_category = create(:product_category, :root)
    product = create(:product_category, :child, parent: root_category)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Categorias'
    first(:link, 'Editar').click
    fill_in 'Nome', with: 'Cadeira Office'
    click_on 'Salvar'

    expect(page).to have_content('Categoria de Produto atualizada com sucesso')
    expect(page).to have_content('Cadeira Office')
  end

  it 'but the edition fails because the proposed input is unacceptable' do
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

  it 'gives up on editing and goes back' do
    admin = create(:admin)
    root_category = create(:product_category, :root)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Categorias'
    first(:link, 'Editar').click
    click_on 'Voltar'

    expect(current_path).to eq(product_categories_path)
  end
end