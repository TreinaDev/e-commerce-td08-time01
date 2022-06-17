require 'rails_helper'

describe "User confirms order from cart" do
  it "and sees order generate page" do
    user = create(:user)
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
    create(:cart_item, product: product_3, quantity: 5, user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    click_on "Finalizar Pedido"
    
    expect(page).to have_content "Meu Pedido"
    expect(page).to have_content "Produto Quantidade Preço"
    expect(page).to have_content "Caneca 3 R$ 11,99"
    expect(page).to have_content "Garrafa 7 R$ 4,99"
    expect(page).to have_content "Jarra 5 R$ 15,99"
    expect(page).to have_content "Valor Total: R$ 150,85"
    expect(page).to have_field "Endereço de entrega" 
    expect(page).to have_button "Confirmar" 
    expect(page).to have_link "Voltar"
  end

  it "and generates order" do
    user = create(:user)
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
    create(:cart_item, product: product_3, quantity: 5, user: user)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('123ASD45')

    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    click_on "Finalizar Pedido"
    fill_in "Endereço de entrega", with: "Rua da entrega, 45"
    click_on "Confirmar"

    expect(page).to have_content 'Pedido 123A-SD45'
    expect(page).to have_content "Produto Quantidade Preço"
    expect(page).to have_content "Caneca 3 R$ 11,99"
    expect(page).to have_content "Garrafa 7 R$ 4,99"
    expect(page).to have_content "Jarra 5 R$ 15,99"
    expect(page).not_to have_button "Retirar"
    expect(page).to have_content "Valor Total: R$ 150,85"
    expect(page).to have_content "Endereço de entrega: Rua da entrega, 45" 
    expect(page).to have_content "Status: Pendente"
    expect(page).to have_link "Voltar"
  end

  it "and fails to generate order" do
    user = create(:user)
    product_1 = create(:product, name: 'Caneca')
    Timecop.freeze(1.month.ago) do
      create(:price, product: product_1)
    end
    create(:cart_item, product: product_1, quantity: 3, user: user)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('123ASD45')

    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    click_on "Finalizar Pedido"
    fill_in "Endereço de entrega", with: ""
    click_on "Confirmar"

    expect(page).to have_content "Endereço de entrega não pode ficar em branco"
  end
end