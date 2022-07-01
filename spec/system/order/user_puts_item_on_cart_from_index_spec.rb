require 'rails_helper'

describe 'User puts item on cart' do
  it 'from homepage' do
    create(:exchange_rate, rate: 2)
    product_1 = create(:product, name: 'Caneca', status: 'on_shelf').set_brl_price(12)
    product_2 = create(:product, name: 'Garrafa', status: 'on_shelf').set_brl_price(5)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    find("input[id='put_on_cart_#{product_2.id}']").click # Colocar no carrinho
    cart_items = CartItem.where(user_id: user.id, order_id: nil)

    expect(cart_items.size).to be 1
    expect(cart_items.last.product.name).to eq 'Garrafa'
    expect(cart_items.last.product.name).to eq 'Garrafa'
  end
end