require 'rails_helper'

describe 'User enters order detail page' do
  it "and sees prices set on date of purchase" do
    user = create(:user)
    product = create(:product, name: 'Caneca').set_price(11.99)
    create(:cart_item, product: product, quantity: 3, user: user)
    create(:order, user: user)
    
    login_as(user, scope: :user)
    visit root_path
    click_on "Meus Pedidos"
    click_on "Detalhes do Pedido"

    expect(page).to have_content "R$ 11,99 R$ 35,97"
    expect(page).to have_content "Valor Total: R$ 35,97"
    expect(page).not_to have_content "Saldo insuficiente para quitar pedido."
  end

  it "and sees a message if the order was canceled due to insufficiente funds" do
    user = create(:user)
    product = create(:product, name: 'Caneca').set_price(4.99)
    create(:cart_item, product: product, user: user)
    create(:order, user: user, status: 'canceled', error_type: 'insufficient_funds')
    
    login_as(user, scope: :user)
    visit root_path
    click_on "Meus Pedidos"
    click_on "Detalhes do Pedido"

    expect(page).to have_content "Cancelado"
    expect(page).to have_content "saldo insuficiente para quitar pedido."
  end
end