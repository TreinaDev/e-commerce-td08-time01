require 'rails_helper'

describe 'Admin sees orders' do
  it 'successfully' do
    user = create(:user)
    admin = create(:admin)
    create(:exchange_rate, rate: 2)
    canecas = create(:product_category, name: 'Canecas')
    product = create(:product, status: 'on_shelf')
    create(:cart_item, product: product, quantity: 5, user: user)
    order = build(:order, user: user)
    order.skip_callback = true
    order.save!
    
    login_as(admin, scope: :admin)
    visit root_path
    within('nav') do
      click_on 'Gerenciar Pedidos'
    end
    
    expect(page).to have_content 'Pedidos'
    expect(page).to have_content order.code
    expect(page).to have_content Order.last.cart_items.reduce(0) {|sum, cart| sum += cart.price_on_purchase * cart.quantity }.to_i
  end
end

