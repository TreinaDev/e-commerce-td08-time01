require 'rails_helper'

describe 'Usuário acessa carrinho de compras' do
  it 'e vê lista de produtos' do
    user = create(:user)
    create(:user, name: 'Jaime', email: 'jaime@meuemail.com')
    create(:product, name: 'Caneca')
    create(:product, name: 'Garrafa', sku: 'GRF9933')
    create(:product, name: 'Jarra', sku: 'JRA68755')
    create(:product, name: 'Pote', sku: 'PTE68755')
    create(:cart_item, product_id: 1, quantity: 3, user_id: 1)
    create(:cart_item, product_id: 2, quantity: 7, user_id: 1)
    create(:cart_item, product_id: 3, quantity: 5, user_id: 2)

    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    
    expect(page).to have_content "Produto Quantidade"
    expect(page).to have_content "Caneca 3"
    expect(page).to have_content "Garrafa 7"
    expect(page).not_to have_content "Jarra 5"
    expect(page).not_to have_content "Pote"
  end
  
  it 'e adiciona um produto' do
    user = create(:user)
    create(:product, name: 'Caneca')
    create(:product, name: 'Garrafa', sku: 'GRF9933')
    create(:product, name: 'Jarra', sku: 'JRA68755')
    create(:cart_item, product_id: 1, quantity: 3, user_id: 1)
    create(:cart_item, product_id: 2, quantity: 7, user_id: 1)

    login_as(user, scope: :user)
    visit root_path
    click_on "Jarra"
    fill_in "Quantidade", with: '5'
    click_on "Adicionar ao carrinho"
    click_on "Meu Carrinho"
    
    expect(page).to have_content "Produto Quantidade"
    expect(page).to have_content "Caneca 3"
    expect(page).to have_content "Garrafa 7"
    expect(page).to have_content "Jarra 5"
  end

  it 'e retira um produto' do
    user = create(:user)
    create(:user, name: 'Jaime', email: 'jaime@meuemail.com')
    create(:product, name: 'Caneca')
    create(:product, name: 'Garrafa', sku: 'GRF9933')
    create(:product, name: 'Jarra', sku: 'JRA68755')
    create(:cart_item, product_id: 1, quantity: 3, user_id: 1)
    create(:cart_item, product_id: 2, quantity: 7, user_id: 1)
    create(:cart_item, product_id: 3, quantity: 5, user_id: 1)

    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    within('tbody') do
      first('tr').click_on("Retirar")
    end
    
    expect(page).to have_content "Produto retirado: Caneca."
    expect(page).to have_content "Produto Quantidade"
    expect(page).not_to have_content "Caneca 3"
    expect(page).to have_content "Garrafa 7"
    expect(page).to have_content "Jarra 5"
  end
end