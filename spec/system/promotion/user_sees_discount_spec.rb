require 'rails_helper'

describe "User applies coupon to product" do
  it 'successfully' do
    user = create(:user)
    category = create(:product_category, name: 'Eletrônicos')
    create(:exchange_rate, rate: 2)
    product = create(:product, product_category: category).set_brl_price(50.0) 
    product_2 = create(:product).set_brl_price(50.0)
    create(:cart_item, product: product, user: user)
    create(:cart_item, product: product_2, user: user)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ASDF1234')
    promotion = create(:promotion, discount_percent: 20)
    promotion_category = create(:promotion_category, product_category: category, promotion: promotion)
    
    login_as(user, scope: :user)
    visit root_path
    click_on "Meu Carrinho"
    click_on "Finalizar"
    fill_in "Cupom de desconto",	with: "ASDF1234" 
    click_on "Adicionar"

    expect(page).to have_content("Valor Total: 180,0")

  end
end