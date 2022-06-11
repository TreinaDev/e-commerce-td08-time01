require 'rails_helper'

describe 'Admin entra na tela de gerenciamento de categorias de produto' do
  it 'e vê a lista de categorias' do
    admin = Admin.create!(email: 'alguem@mercadores.com.br', password: '123456', name: 'Alguém')
    ProductCategory.create!(name: 'Eletrônicos', product_category_id: nil )
    ProductCategory.create!(name: 'Móveis', product_category_id: nil )
    ProductCategory.create!(name: 'Computadores', product_category_id: 1 )
    ProductCategory.create!(name: 'Eletrodomésticos', product_category_id: 1 )
    ProductCategory.create!(name: 'Geladeiras', product_category_id: 4 )
    ProductCategory.create!(name: 'Racks', product_category_id: 2 )
    ProductCategory.create!(name: 'Guarda-Roupas', product_category_id: 2 )

    login_as admin
    visit root_path
    click_on 'Gerenciar Categorias'

    expect(page).to have_content 'Eletrônicos/ Eletrodomésticos/ Geladeiras'
    expect(page).to have_content 'Eletrônicos/ Computadores'
    expect(page).to have_content 'Móveis/ Racks'
    expect(page).to have_content 'Móveis/ Guarda-Roupas'
  end
end