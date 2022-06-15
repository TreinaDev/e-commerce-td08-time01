require 'rails_helper'

describe "User adds product to cart" do
  it "successfully" do
    create(:product, name: 'Caneca Mon Amour')
    user = create(:user)
    
    login_as(user, scope: :user)
    visit root_path
    click_on 'Caneca Mon Amour'
    fill_in 'Quantidade', with: 1
    click_on 'Adicionar ao carrinho'
    
    expect(page).to have_content('Produto adicionado com sucesso') 
  end
  
  it "and is redirected to login page when logged out" do
    create(:product, name: 'Caneca Mon Amour')
  
    visit root_path
    click_on 'Caneca Mon Amour'
    click_on 'Adicionar ao carrinho'
  
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Bem vindo! Por favor registre-se ou entre em sua conta para continuar.'
  end
  
  it 'and is rejected for invalid quantity' do
    user = create(:user)
    create(:user, name: 'Jaime', email: 'jaime@meuemail.com')
    create(:product, name: 'Caneca')
    create(:product, name: 'Garrafa', sku: 'GRF9933')
    create(:product, name: 'Jarra', sku: 'JRA68755')
    create(:cart_item, product_id: 1, quantity: 3, user_id: 1)
    create(:cart_item, product_id: 2, quantity: 7, user_id: 1)
  
    login_as(user, scope: :user)
    visit root_path
    click_on "Jarra"
    fill_in "Quantidade", with: '0'
    click_on "Adicionar ao carrinho"
    
    expect(page).to have_content "Só é possível a compra de um ou mais produtos."
    expect(CartItem.count).to eq 2
  end
end