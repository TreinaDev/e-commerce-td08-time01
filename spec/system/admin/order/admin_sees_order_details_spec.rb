require 'rails_helper'

describe 'Admin enters order details page' do
  it 'and sees order details' do
    allow(Faraday).to receive(:post).and_return(double('faraday_response', status: 201, body: '{ "transaction_code": "nsurg745n" }'))
    admin = create(:admin)
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
    order = create(:order, user: user)
    
    login_as(admin, scope: :admin)
    visit root_path
    within('nav') do
      click_on 'Gerenciar Pedidos'
    end
    click_on 'Detalhes do Pedido'

    expect(page).to have_content "Pedido: #{order.code}"
    expect(page).to have_content "Produto Quantidade Preço Quantidade X Preço"
    expect(page).to have_content "Caneca 3 8 24"
    expect(page).to have_content "Garrafa 7 #{price_2} #{subtotal_2}"
    expect(page).to have_content "Jarra 5 #{price_3} #{subtotal_3}"
    expect(page).not_to have_button "Retirar"
    expect(page).to have_content "Valor Total:"
    expect(page).to have_content "#{(subtotal_1 + subtotal_2 + subtotal_3)}"
    expect(page).to have_content "Endereço de entrega:\nRua da Entrega, 54" 
    expect(page).to have_content "Status:\nPendente"
    expect(page).to have_link "Voltar"
  end
end