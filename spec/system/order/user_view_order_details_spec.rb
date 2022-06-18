require 'rails_helper'

describe 'User enters order detail page' do
  it "and sees prices set on date of purchase" do
    user = create(:user)
    product = create(:product, name: 'Caneca')
    Timecop.freeze(1.month.ago) do
      create(:price, product: product, price_in_brl: "11.99")
      create(:price, product: product, price_in_brl: "4.99", validity_start: 15.days.from_now)
    end
    Timecop.freeze(20.days.ago) do
      create(:cart_item, product: product, quantity: 3, user: user)
      @order_1 = create(:order, user: user)
    end
    
    login_as(user, scope: :user)
    visit root_path
    click_on "Meus Pedidos"
    click_on "Detalhes do Pedido"

    expect(page).to have_content "R$ 11,99 R$ 35,97"
    expect(page).to have_content "Valor Total: R$ 35,97"
  end
end