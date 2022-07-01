require 'rails_helper'

describe 'User adds same product to cart twice' do
  it 'and it is not repeated' do
    create(:exchange_rate, rate: 2)
    product_1 = create(:product, name: 'Caneca', status: 'on_shelf').set_brl_price(12)
    product_2 = create(:product, name: 'Garrafa', status: 'on_shelf').set_brl_price(5)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    find("input[id='put_on_cart_#{product_2.id}']").click # Colocar no carrinho
    find("input[id='put_on_cart_#{product_2.id}']").click # Colocar no carrinho
    find("input[id='put_on_cart_#{product_2.id}']").click # Colocar no carrinho
    visit user_cart_items_path(user)

    expect(page).to have_text 'Garrafa 3'
  end
end