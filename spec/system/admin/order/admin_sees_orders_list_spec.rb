require 'rails_helper'

describe 'Admin sees pending orders' do
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

  it 'and doesn\'t exist pending orders' do
    user = create(:user)
    admin = create(:admin)
    create(:exchange_rate, rate: 2)
    canecas = create(:product_category, name: 'Canecas')
    product = create(:product, status: 'on_shelf')
    orders_array = build_list(:order, 5, user: user)
    orders_array.each do |ord| 
      ord.skip_callback = true
      create(:cart_item, product: product, quantity: 5, user: user)
      ord.save!
      ord.approved!
    end

    login_as(admin, scope: :admin)
    visit root_path
    within('nav') do
      click_on 'Gerenciar Pedidos'
    end

    expect(page).to have_content 'Pedidos'
    expect(page).to have_content 'Não há pedidos pendentes'
  end 

  it 'and sees total value pending' do
    user = create(:user)
    admin = create(:admin)
    create(:exchange_rate, rate: 2)
    canecas = create(:product_category, name: 'Canecas')
    product = create(:product, status: 'on_shelf').set_brl_price(10)
    orders_array = build_list(:order, 5, user: user)
    orders_array.each do |ord| 
      ord.skip_callback = true
      create(:cart_item, product: product, quantity: 1, user: user)
      ord.save!
    end

    login_as(admin, scope: :admin)
    visit root_path
    within('nav') do
      click_on 'Gerenciar Pedidos'
    end

    expect(page).to have_content 'Pedidos'
    expect(page).to have_content '25'
    expect(page).to have_content 'R$ 50,00'
  end 
end

describe 'Admin sees approved orders' do
  it 'successfully' do
    user = create(:user)
    admin = create(:admin)
    create(:exchange_rate, rate: 2)
    canecas = create(:product_category, name: 'Canecas')
    product = create(:product, status: 'on_shelf')
    orders_array = build_list(:order, 5, user: user)
    orders_array.each do |ord| 
      ord.skip_callback = true
      create(:cart_item, product: product, quantity: 5, user: user)
      ord.save!
      ord.approved!
    end

    login_as(admin, scope: :admin)
    visit root_path
    within('nav') do
      click_on 'Gerenciar Pedidos'
    end

    expect(page).to have_content 'Pedidos'
    Order.approved.each do |ord|
      expect(page).to have_content ord.code
      expect(page).to have_content ord.price_on_purchase
    end
  end

  it 'and there are no approved orders' do
    user = create(:user)
    admin = create(:admin)
    create(:exchange_rate, rate: 2)
    canecas = create(:product_category, name: 'Canecas')
    product = create(:product, status: 'on_shelf')
    orders_array = build_list(:order, 5, user: user)
    orders_array.each do |ord| 
      ord.skip_callback = true
      create(:cart_item, product: product, quantity: 5, user: user)
      ord.save!
      ord.canceled!
    end

    login_as(admin, scope: :admin)
    visit root_path
    within('nav') do
      click_on 'Gerenciar Pedidos'
    end

    expect(page).to have_content 'Pedidos'
    expect(page).to have_content 'Não há pedidos aprovados'
  end 
end

describe 'Admin sees canceled orders' do
  it 'successfully' do
    user = create(:user)
    admin = create(:admin)
    create(:exchange_rate, rate: 2)
    canecas = create(:product_category, name: 'Canecas')
    product = create(:product, status: 'on_shelf')
    orders_array = build_list(:order, 5, user: user)
    orders_array.each do |ord| 
      ord.skip_callback = true
      create(:cart_item, product: product, quantity: 5, user: user)
      ord.save!
      ord.canceled!
    end

    login_as(admin, scope: :admin)
    visit root_path
    within('nav') do
      click_on 'Gerenciar Pedidos'
    end

    expect(page).to have_content 'Pedidos'
    Order.approved.each do |ord|
      expect(page).to have_content ord.code
      expect(page).to have_content ord.price_on_purchase
    end
  end

  it 'and there are no canceled orders' do
    user = create(:user)
    admin = create(:admin)
    create(:exchange_rate, rate: 2)
    canecas = create(:product_category, name: 'Canecas')
    product = create(:product, status: 'on_shelf')
    orders_array = build_list(:order, 5, user: user)
    orders_array.each do |ord| 
      ord.skip_callback = true
      create(:cart_item, product: product, quantity: 5, user: user)
      ord.save!
      ord.approved!
    end

    login_as(admin, scope: :admin)
    visit root_path
    within('nav') do
      click_on 'Gerenciar Pedidos'
    end

    expect(page).to have_content 'Pedidos'
    expect(page).to have_content 'Não há pedidos cancelados'
  end 
end

