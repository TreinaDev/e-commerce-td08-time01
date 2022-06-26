require 'rails_helper'

describe 'User enters order detail page' do
  it "and sees prices as of on date of purchase" do
    user = create(:user)
    Timecop.freeze(1.month.ago) do
      create(:exchange_rate, rate: 2)
      product = create(:product)
      create(:price, product: product, price_in_brl: "11", validity_start: Time.current)
      create(:cart_item, product: product, quantity: 3, user: user)
      create(:order, user: user)
    end
    create(:price, product: Product.last, price_in_brl: "15", validity_start: Time.current)
    price_in_rubis_at_time_of_purchase = 11 * 2
    price_in_rubis_now = 15 * 2

    login_as(user, scope: :user)
    visit root_path
    click_on "Meus Pedidos"
    click_on "Detalhes do Pedido"

    expect(page).to have_content "#{price_in_rubis_at_time_of_purchase} #{3 * price_in_rubis_at_time_of_purchase}"
    expect(page).not_to have_content "#{price_in_rubis_now}"
  end
end