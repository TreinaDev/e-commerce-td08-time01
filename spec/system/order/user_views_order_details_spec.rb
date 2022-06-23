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
  end

  xit "and sees error type when the order was canceled" do
    user = create(:user)
    product = create(:product, name: 'Caneca').set_price(4.99)
    create(:cart_item, product: product, user: user)
    create(:order, user: user, status: 'canceled', error_type: 'Saldo insuficiente.')
    
    login_as(user, scope: :user)
    visit root_path
    click_on "Meus Pedidos"
    click_on "Detalhes do Pedido"

    expect(page).to have_content "Status: Cancelado"
    expect(page).to have_content "Motivo de recusa: Saldo insuficiente"
  end
end