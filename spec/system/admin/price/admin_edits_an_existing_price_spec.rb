require 'rails_helper'

describe 'admin edits an existing price' do
  it 'with success' do
    admin = create(:admin)
    login_as(admin, scope: :admin)
    create(:exchange_rate)
    product_category = ProductCategory.create!(name: 'Tecnologia')
    product = Product.create!(name: 'Produto teste', brand: 'Marca teste', description: 'Description do produto teste', sku: 'QQ1234567', status: :on_shelf, product_category_id: product_category.id, width: (1..5).to_a.sample.to_i, weight: (1..5).to_a.sample.to_i, depth: (1..5).to_a.sample.to_i, height: (1..5).to_a.sample.to_i, is_fragile: ['unchecked', 'checked'].sample)
    price = Timecop.freeze(1.week.ago) { create(:price, product: product, price_in_brl: 10.00) }
    date = DateTime.current + 1.minute

    visit admin_session_path
    click_on 'Gerenciar Preços & Produtos'
    click_on 'Editar produto'
    click_on 'Editar'
    fill_in 'Preço em reais', with: 15.55
    select date.day, from: 'price_validity_start_3i'
    select I18n.l(date, format: "%B"), from: 'price_validity_start_2i'
    select date.year, from: 'price_validity_start_1i'
    select date.strftime('%H'), from: 'price_validity_start_4i'
    select date.strftime('%M'), from: 'price_validity_start_5i'
    click_on 'Salvar'

    expect(page).to have_content('Configurações de Preço do Produto')
    expect(page).to have_content('R$ 15,55')
    expect(page).to have_content(I18n.l(product.prices.last.validity_start))
  end

  it 'and fail beacause the date is past' do
    admin = create(:admin)
    login_as(admin, scope: :admin)
    create(:exchange_rate)
    product_category = ProductCategory.create!(name: 'Tecnologia')
    product = Product.create!(name: 'Produto teste', brand: 'Marca teste', description: 'Description do produto teste', sku: 'QQ1234567', status: :on_shelf, product_category_id: product_category.id, width: (1..5).to_a.sample.to_i, weight: (1..5).to_a.sample.to_i, depth: (1..5).to_a.sample.to_i, height: (1..5).to_a.sample.to_i, is_fragile: ['unchecked', 'checked'].sample)
    price = Timecop.freeze(1.week.ago) { create(:price, product: product, price_in_brl: 10.00) }
    date = DateTime.current - 1.minute

    visit admin_session_path
    click_on 'Gerenciar Preços & Produtos'
    click_on 'Editar produto'
    click_on 'Editar'
    fill_in 'Preço em reais', with: 15.55
    select date.day, from: 'price_validity_start_3i'
    select I18n.l(date, format: "%B"), from: 'price_validity_start_2i'
    select date.year, from: 'price_validity_start_1i'
    select date.strftime('%H'), from: 'price_validity_start_4i'
    select date.strftime('%M'), from: 'price_validity_start_5i'
    click_on 'Salvar'

    expect(page).to have_content('Início da validade não pode estar no passado')
  end

  it 'and fails because the price is empty' do
    admin = create(:admin)
    login_as(admin, scope: :admin)
    create(:exchange_rate)
    product_category = ProductCategory.create!(name: 'Tecnologia')
    product = Product.create!(name: 'Produto teste', brand: 'Marca teste', description: 'Description do produto teste', sku: 'QQ1234567', status: :on_shelf, product_category_id: product_category.id, width: (1..5).to_a.sample.to_i, weight: (1..5).to_a.sample.to_i, depth: (1..5).to_a.sample.to_i, height: (1..5).to_a.sample.to_i, is_fragile: ['unchecked', 'checked'].sample)
    price = Timecop.freeze(1.week.ago) { create(:price, product: product, price_in_brl: 10.00) }
    date = DateTime.current + 1.minute

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Preços & Produtos'
    click_on 'Editar produto'
    click_on 'Editar'
    
    fill_in 'Preço em reais', with: ''
    select date.day, from: 'price_validity_start_3i'
    select I18n.l(date, format: "%B"), from: 'price_validity_start_2i'
    select date.year, from: 'price_validity_start_1i'
    select date.strftime('%H'), from: 'price_validity_start_4i'
    select date.strftime('%M'), from: 'price_validity_start_5i'
    click_on 'Salvar'

    expect(page).to have_content('Preço em reais não pode estar em branco')
  end
end
