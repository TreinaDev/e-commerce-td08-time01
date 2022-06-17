require 'rails_helper'

describe 'User enters cart page' do
  it 'and sees cart items' do
    user = create(:user)
    user_2 = create(:user, name: 'Jaime', email: 'jaime@meuemail.com')
    product_1 = create(:product, name: 'Caneca')
    product_2 = create(:product, name: 'Garrafa', sku: 'GRF9933')
    product_3 = create(:product, name: 'Jarra', sku: 'JRA68755')
    product_4 = create(:product, name: 'Pote', sku: 'PTE68755')
    Timecop.freeze(1.month.ago) do
      create(:price, product: product_1, price_in_brl: "11.99")
      create(:price, product: product_2, price_in_brl: "4.99")
      create(:price, product: product_3, price_in_brl: "15.99")
      create(:price, product: product_4, price_in_brl: "2.99")
    end
    create(:cart_item, product: product_1, quantity: 3, user: user)
    create(:cart_item, product: product_2, quantity: 7, user: user)
    create(:cart_item, product: product_3, quantity: 5, user: user_2)

    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    
    expect(page).to have_content "Produto Quantidade Preço"
    expect(page).to have_content "Caneca 3 R$ 11,99"
    expect(page).to have_content "Garrafa 7 R$ 4,99"
    expect(page).not_to have_content "Jarra 5 R$ 15,99"
    expect(page).not_to have_content "Pote 7 R$ 2,99"
  end

  it 'and there is no cart items' do
    user = create(:user)
    user_2 = create(:user, name: 'Jaime', email: 'jaime@meuemail.com')
    product_1 = create(:product, name: 'Jarra', sku: 'JRA68755')
    product_2 = create(:product, name: 'Pote', sku: 'PTE68755')
    Timecop.freeze(1.month.ago) do
      create(:price, product: product_1, price_in_brl: "15.99")
      create(:price, product: product_2, price_in_brl: "2.99")
    end
    create(:cart_item, product: product_1, quantity: 7, user: user_2)
    create(:cart_item, product: product_2, quantity: 5, user: user_2)

    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    
    expect(page).to have_content "Adicione um produto ao carrinho!"
    expect(page).not_to have_content "Jarra 5 R$ 15,99"
    expect(page).not_to have_content "Pote 7 R$ 2,99"
  end
  
  it 'after adding a product' do
    user = create(:user)
    product_1 = create(:product, name: 'Caneca')
    product_2 = create(:product, name: 'Garrafa', sku: 'GRF9933')
    product_3 = create(:product, name: 'Jarra', sku: 'JRA68755')
    Timecop.freeze(1.month.ago) do
      create(:price, product: product_1, price_in_brl: "11.99")
      create(:price, product: product_2, price_in_brl: "4.99")
      create(:price, product: product_3, price_in_brl: "15.99")
    end
    create(:cart_item, product: product_1, quantity: 3, user:  user)
    create(:cart_item, product: product_2, quantity: 7, user:  user)

    login_as(user, scope: :user)
    visit root_path
    click_on "Jarra"
    fill_in "Quantidade", with: '5'
    click_on "Adicionar ao carrinho"
    click_on "Meu Carrinho"
    
    expect(page).to have_content "Caneca"
    expect(page).to have_content "Garrafa"
    expect(page).to have_content "Jarra"
  end

  it 'and withdraws an item ' do
    user = create(:user)
    product_1 = create(:product, name: 'Caneca')
    product_2 = create(:product, name: 'Garrafa', sku: 'GRF9933')
    product_3 = create(:product, name: 'Jarra', sku: 'JRA68755')
    Timecop.freeze(1.month.ago) do
      create(:price, product: product_1, price_in_brl: "11.99")
      create(:price, product: product_2, price_in_brl: "4.99")
      create(:price, product: product_3, price_in_brl: "15.99")
    end
    create(:cart_item, product: product_1, quantity: 3, user: user)
    create(:cart_item, product: product_2, quantity: 7, user: user)
    create(:cart_item, product: product_3, quantity: 5, user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    within('tbody') do
      first('tr').click_on("Retirar")
    end
    
    expect(page).to have_content "Produto retirado: Caneca."
    within('tbody') do
      expect(page).not_to have_content "Caneca"
    end
    expect(page).to have_content "Garrafa"
    expect(page).to have_content "Jarra"
  end

  it 'and enters product page through cart link' do
    user = create(:user)
    product = create(:product, name: 'Caneca')
    Timecop.freeze(1.month.ago) do
      create(:price, product: product)
    end
    create(:cart_item, product: product, quantity: 3, user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    within('tbody') do
      first('tr').click_on("Caneca")
    end
    
    expect(page).to have_text 'Caneca'
    expect(page).to have_text 'TOC & Ex-TOC'
    expect(page).to have_text 'Caneca em cerâmica com desenho de uma flecha do cupido'
    expect(page).to have_text 'TOC1234'
    expect(page).to have_text 'R$ 9,99' 
  end
end