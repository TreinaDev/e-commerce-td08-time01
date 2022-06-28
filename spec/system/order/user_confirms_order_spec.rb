require 'rails_helper'

describe "User confirms order from cart" do
  it "and sees page with order summary and field for address input" do
    create(:exchange_rate, rate: 2)
    user = create(:user)
    product_1 = create(:product, name: 'Caneca').set_brl_price(15)
    product_2 = create(:product, name: 'Garrafa')
    product_3 = create(:product, name: 'Jarra')
    create(:cart_item, product: product_1, quantity: 3, user: user)
    create(:cart_item, product: product_2, quantity: 7, user: user)
    create(:cart_item, product: product_3, quantity: 5, user: user)
    price_1 = product_1.current_price_in_rubis
    price_2 = product_2.current_price_in_rubis
    price_3 = product_3.current_price_in_rubis
    subtotal_1 = price_1 * 3
    subtotal_2 = price_2 * 7
    subtotal_3 = price_3 * 5

    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    click_on "Finalizar Pedido"
    
    expect(page).to have_text "Meu Pedido"
    expect(page).to have_text "Produto Quantidade Preço Quantidade X Preço"
    expect(page).to have_text "Caneca 3 8 24"
    expect(page).to have_text "Garrafa 7 #{price_2} #{subtotal_2}"
    expect(page).to have_text "Jarra 5 #{price_3} #{subtotal_3}"
    expect(page).to have_text "Valor Total:"
    expect(page).to have_text "#{(subtotal_1 + subtotal_2 + subtotal_3)}"
    expect(page).to have_field "Endereço de entrega" 
    expect(page).to have_button "Confirmar" 
    expect(page).to have_link "Voltar"
  end

  it "and generates order succesfully" do
    allow(Faraday).to receive(:post).and_return(double('faraday_response', status: 201, body: '{ "transaction_code": "nsurg745n" }'))
    # above: mock for API call when creating an order
    
    create(:exchange_rate, rate: 2)
    user = create(:user)
    product_1 = create(:product, name: 'Caneca').set_brl_price(15)
    product_2 = create(:product, name: 'Garrafa')
    product_3 = create(:product, name: 'Jarra')
    create(:cart_item, product: product_1, quantity: 3, user: user)
    create(:cart_item, product: product_2, quantity: 7, user: user)
    create(:cart_item, product: product_3, quantity: 5, user: user)
    price_1 = product_1.current_price_in_rubis
    price_2 = product_2.current_price_in_rubis
    price_3 = product_3.current_price_in_rubis
    subtotal_1 = price_1 * 3
    subtotal_2 = price_2 * 7
    subtotal_3 = price_3 * 5
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('123ASD45')

    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    click_on "Finalizar Pedido"
    fill_in "Endereço de entrega", with: "Rua da entrega, 45"
    click_on "Confirmar"

    expect(page).to have_content 'Pedido 123A-SD45'
    expect(page).to have_content "Produto Quantidade Preço Quantidade X Preço"
    expect(page).to have_content "Caneca 3 8 24"
    expect(page).to have_content "Garrafa 7 #{price_2} #{subtotal_2}"
    expect(page).to have_content "Jarra 5 #{price_3} #{subtotal_3}"
    expect(page).not_to have_button "Retirar"
    expect(page).to have_content "Valor Total:"
    expect(page).to have_content "#{(subtotal_1 + subtotal_2 + subtotal_3)}"
    expect(page).to have_content "Endereço de entrega:\nRua da entrega, 45" 
    expect(page).to have_content "Status:\nPendente"
    expect(page).to have_link "Voltar"
  end

  it "and receives error message if address input is unacceptable" do
    user = create(:user)
    product = create(:product)
    create(:cart_item, product: product, quantity: 3, user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    click_on "Finalizar Pedido"
    fill_in "Endereço de entrega", with: ""
    click_on "Confirmar"

    expect(page).to have_content "Endereço de entrega não pode estar em branco"
  end
end