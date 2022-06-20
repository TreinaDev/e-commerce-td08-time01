require 'rails_helper'

describe 'Admin create new product' do
  it 'successfully' do
    admin = create(:admin)
    create(:product_category, name: 'Casa')

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Novo Produto'
    fill_in 'Nome', with: 'Tapeçaria Indiana'
    fill_in 'Marca', with: 'Hindi Cult'
    fill_in 'SKU', with: 'HND0987'
    fill_in 'Descrição', with: 'Tapeçaria indiana com fios de altíssima qualidade.'
    fill_in 'Preço', with: '5_000'
    select 'Casa', from: 'Categoria'
    fill_in 'Status', with: 'on_shelf'
    click_on 'Salvar' 

    expect('Produto adicionado com sucesso')
    expect('Tapeçaria Indiana')
    expect('Marca: Hindi Cult')
    expect('Tapeçaria indiana com fios de altíssima qualidade')
  end
end