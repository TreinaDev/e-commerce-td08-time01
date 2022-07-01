require 'rails_helper'

describe 'Admin remove an existing price configuration' do
  it 'with success' do
    admin = create(:admin)
    login_as(admin, scope: :admin)
    create(:exchange_rate)
    product_category = ProductCategory.create!(name: 'Tecnologia')
    product = Product.create!(name: 'Produto teste', brand: 'Marca teste', description: 'Description do produto teste', sku: 'QQ1234567', status: :on_shelf, product_category_id: product_category.id, width: (1..5).to_a.sample.to_i, weight: (1..5).to_a.sample.to_i, depth: (1..5).to_a.sample.to_i, height: (1..5).to_a.sample.to_i, is_fragile: ['unchecked', 'checked'].sample)
    price1 = Timecop.freeze(1.week.ago) { create(:price, product: product, price_in_brl: 10.00) }
    price2 = Timecop.freeze(3.days.ago) { create(:price, product: product, price_in_brl: 15.00) }
    price3 = Timecop.freeze(1.day.ago) { create(:price, product: product, price_in_brl: 20.00) }

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Preços & Produtos'
    click_on 'Editar produto'
    first(:button, 'Remover').click
    first(:button, 'Remover').click

    expect(page).to have_content('Configurações de Preço do Produto')
    expect(page).to have_content('R$ 10,00')
    expect(page).to have_content(I18n.l(price1.validity_start))
    expect(page).not_to have_content('R$ 15,00')
    expect(page).not_to have_content(I18n.l(price2.validity_start))
    expect(page).not_to have_content('R$ 20,00')
    expect(page).not_to have_content(I18n.l(price3.validity_start))
  end
end
