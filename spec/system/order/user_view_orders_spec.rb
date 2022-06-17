require 'rails_helper'

describe "User enters orders page" do
  it "and views own orders" do
    user = create(:user)
    user_2 = create(:user, name: 'Maciel', email: 'maciel@meuemail.com')
    product_1 = create(:product, name: 'Caneca')
    product_2 = create(:product, name: 'Garrafa', sku: 'GRF9933')
    product_3 = create(:product, name: 'Jarra', sku: 'JRA68755')
    Timecop.freeze(1.month.ago) do
      create(:price, product: product_1, price_in_brl: "11.99")
      create(:price, product: product_2, price_in_brl: "4.99")
      create(:price, product: product_3, price_in_brl: "15.99")
    end
    create(:cart_item, product: product_1, quantity: 3, user: user)
    create(:cart_item, product: product_2, quantity: 7, user: user)
    create(:cart_item, product: product_3, quantity: 5, user: user_2)
    order_1 = create(:order, user: user, status: 'pending')
    order_3 = create(:order, user: user_2, status: 'pending')

    login_as(user, scope: :user)
    visit root_path
    click_on "Meus Pedidos"

    expect(page).to have_content "Pedido #{order_1.code} - Pendente"
    expect(page).not_to have_content "Pedido #{order_3.code} - Pendente"
  end

  it "and enters a order page after some time" do
    user = create(:user)
    product = create(:product, name: 'Caneca')
    Timecop.freeze(1.month.ago) do
      create(:price, product: product, price_in_brl: "11.99")
      create(:price, product: product, price_in_brl: "4.99", validity_start: 15.days.from_now)
    end
    Timecop.freeze(20.days.ago) do
      create(:cart_item, product: product, quantity: 3, user: user)
      @order_1 = create(:order, user: user, status: 'pending')
    end
    
    login_as(user, scope: :user)
    visit root_path
    click_on "Meus Pedidos"
    click_on "#{@order_1.code}"

    expect(page).to have_content "R$ 11,99"
    expect(page).to have_content "Valor Total: R$ 35,97"
  end

  it "and there is no orders" do
    user = create(:user)
    
    login_as(user, scope: :user)
    visit root_path
    click_on "Meus Pedidos"

    expect(page).to have_content "Você ainda não possui nenhum pedido."
  end
end
