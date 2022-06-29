require 'rails_helper'

describe 'admin register a product' do
  it 'with success' do
    admin = create(:admin)
    login_as(admin, scope: :admin)
    ProductCategory.create!(name: 'Tecnologia')

    visit admin_session_path
    click_on 'Gerenciar Preços & Produtos'
    click_on 'Cadastrar Produto'
    fill_in "Nome",	with: "Produto teste"
    fill_in "Marca",	with: "Marca do produto teste"
    fill_in "Descrição",	with: "Descrição do produto teste"
    fill_in "SKU",	with: "UU1234567"
    select 'à venda', from: 'Status'
    select 'Tecnologia', from: 'Categoria do produto'
    click_on 'Cadastrar'

    expect(page).to have_content 'Produto cadastrado com sucesso!'
    expect(page).to have_content 'Produto teste'
    expect(page).to have_content 'Marca do produto teste'
    expect(page).to have_content 'on_shelf'
    expect(current_path).to eq admin_products_path
  end

  it 'without all datas' do
    admin = create(:admin)
    login_as(admin, scope: :admin)
    ProductCategory.create!(name: 'Tecnologia')

    visit admin_session_path
    click_on 'Gerenciar Preços & Produtos'
    click_on 'Cadastrar Produto'
    fill_in "Nome",	with: ""
    fill_in "Marca",	with: "Marca do produto teste"
    fill_in "Descrição",	with: "Descrição do produto teste"
    fill_in "SKU",	with: ""
    select 'à venda', from: 'Status'
    select 'Tecnologia', from: 'Categoria do produto'
    click_on 'Cadastrar'

    expect(page).to have_content 'O produto não foi cadastrado.'
    expect(page).to have_content 'Nome não pode estar em branco'
    expect(page).to have_content 'SKU não pode estar em branco'
  end

  it 'whithout authentication' do
    ProductCategory.create!(name: 'Tecnologia')

    visit new_admin_product_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
