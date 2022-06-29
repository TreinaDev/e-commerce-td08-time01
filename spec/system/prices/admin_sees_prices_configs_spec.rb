require 'rails_helper'

describe 'Admin sees product in admin view' do
  it 'and sees prices configurations' do
    admin = create(:admin)
    product = create(:product)
    price1 = Timecop.freeze(1.week.ago) { create(:price, product: product, price_in_brl: 10.00) }
    price2 = Timecop.freeze(3.days.ago) { create(:price, product: product, price_in_brl: 15.00) }
    price3 = Timecop.freeze(1.day.ago) { create(:price, product: product, price_in_brl: 20.00) }

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Preços & Produtos'
    click_on product.name

    expect(page).to have_content('Configurações de Preço do Produto')
    expect(page).to have_content(product.name)
    expect(page).to have_content(product.brand)
    expect(page).to have_content('R$ 10,00')
    expect(page).to have_content(I18n.l(price1.validity_start))
    expect(page).to have_content('R$ 15,00')
    expect(page).to have_content(I18n.l(price2.validity_start))
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content(I18n.l(price3.validity_start))
  end
end