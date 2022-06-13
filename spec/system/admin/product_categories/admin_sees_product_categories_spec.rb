require 'rails_helper'

describe 'Admin entra na tela de gerenciamento de categorias de produto' do
  it 'e vê a lista de categorias' do
    admin = Admin.create!(email: 'alguem@mercadores.com.br', password: '123456', name: 'Alguém')
    eletronicos = ProductCategory.create!(name: 'Eletrônicos' )
    moveis = ProductCategory.create!(name: 'Móveis' )
    eletrodomesticos = ProductCategory.create!(name: 'Eletrodomésticos', parent: eletronicos )
    ProductCategory.create!(name: 'Computadores', parent: eletronicos )
    ProductCategory.create!(name: 'Geladeiras', parent: eletrodomesticos )
    ProductCategory.create!(name: 'Racks', parent: moveis )
    ProductCategory.create!(name: 'Guarda-Roupas', parent: moveis )

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Categorias'

    expect(page).to have_content 'Eletrônicos'
    expect(page).to have_content 'Eletrônicos > Eletrodomésticos > Geladeiras'
    expect(page).to have_content 'Eletrônicos > Computadores'
    expect(page).to have_content 'Móveis'
    expect(page).to have_content 'Móveis > Racks'
    expect(page).to have_content 'Móveis > Guarda-Roupas'
  end
end