require 'rails_helper'

describe "User applies coupon to product" do
  it 'successfully' do
    user = create(:user)
    category = create(:product_category, name: 'Eletrônicos')
    create(:exchange_rate, rate: 0.5)
    product = create(:product, name: 'Notebook', product_category: category).set_brl_price(25.0) 
    product_2 = create(:product, name: 'Caneca').set_brl_price(50.0)
    create(:cart_item, product: product, user: user, quantity: 2)
    create(:cart_item, product: product_2, user: user)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ASDF1234')
    promotion = create(:promotion, discount_percent: 20)
    promotion_category = create(:promotion_category, product_category: category, promotion: promotion)
    
    login_as(user, scope: :user)
    visit root_path
    click_on class: 'bi bi-cart3'
    click_on "Finalizar"
    fill_in "Cupom de desconto",	with: "ASDF1234" 
    click_on "Adicionar"

    expect(page).to have_content("Valor Total:   180")
    expect(page).to have_content("Você economizou:   20")
  end

  it 'unsuccessfully' do
    user = create(:user)
    category = create(:product_category, name: 'Eletrônicos')
    create(:exchange_rate, rate: 0.5)
    product = create(:product, name: 'Notebook', product_category: category).set_brl_price(25.0) 
    product_2 = create(:product, name: 'Caneca').set_brl_price(50.0)
    create(:cart_item, product: product, user: user, quantity: 2)
    create(:cart_item, product: product_2, user: user)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ASDF1234')
    promotion = create(:promotion, discount_percent: 20)
    promotion_category = create(:promotion_category, product_category: category, promotion: promotion)
    
    login_as(user, scope: :user)
    visit root_path
    click_on class: 'bi bi-cart3'
    click_on "Finalizar"
    fill_in "Cupom de desconto",	with: "CODIGOERRADO" 
    click_on "Adicionar"

    expect(page).to have_content("Cupom inexistente")
  end
  
  it 'successfully and finishes the purchase' do
    user = create(:user)
    category = create(:product_category, name: 'Eletrônicos')
    create(:exchange_rate, rate: 0.5)
    product = create(:product, name: 'Notebook', product_category: category).set_brl_price(50.0) 
    product_2 = create(:product, name: 'Caneca').set_brl_price(50.0)
    create(:cart_item, product: product, user: user)
    create(:cart_item, product: product_2, user: user)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ASDF1234')
    promotion = create(:promotion, name: 'Dia das mães', discount_percent: 20)
    promotion_category = create(:promotion_category, product_category: category, promotion: promotion)
    fake_response = double('faraday_response', status: 201, 
                            body: '{ "transaction_code": "nsurg745n" }')
    allow(Faraday).to receive(:post).and_return(fake_response)
    
    login_as(user, scope: :user)
    visit root_path
    click_on class: 'bi bi-cart3'
    click_on "Finalizar"
    fill_in "Cupom de desconto",	with: "ASDF1234" 
    click_on "Adicionar"
    fill_in "Endereço de entrega", with: "Rua da entrega, 45"
    click_on "Confirmar"

    expect(page).to have_content("Valor Total:   180")
    expect(page).to have_content("Cupom:\nDia das mães")
    expect(page).to have_content("Você economizou:   20")
  end
end