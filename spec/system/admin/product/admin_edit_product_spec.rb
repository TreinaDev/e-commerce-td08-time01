require 'rails_helper'

describe 'admin update a product' do
  it 'with success' do
    admin = create(:admin)
    create(:exchange_rate)
    product_category = ProductCategory.create!(name: 'Tecnologia')
    product = Product.create!(name: 'Produto teste', brand: 'Marca teste', description: 'Description do produto teste', sku: 'QQ1234567', status: :on_shelf, product_category_id: product_category.id, width: 2, weight: 2, depth: 2, height: 2, is_fragile: 'checked')
    price = Timecop.freeze(1.week.ago) { create(:price, product: product, price_in_brl: 10.00) }

    login_as(admin, scope: :admin)
    visit admin_session_path
    click_on 'Gerenciar Preços & Produtos'
    click_on 'Editar produto'
    fill_in "Nome",	with: "Produto editado"
    select 'suspenso', from: 'Status'
    click_on 'Atualizar produto'

    expect(page).to have_content 'Produto atualizado com sucesso!'
    expect(page).to have_content 'Produto editado'
    expect(page).to have_content 'off_shelf'
    expect(current_path).to eq admin_products_path
  end

  it 'fail' do
    admin = create(:admin)
    create(:exchange_rate)
    product_category = ProductCategory.create!(name: 'Tecnologia')
    product = Product.create!(name: 'Produto teste', brand: 'Marca teste', description: 'Description do produto teste', sku: 'QQ1234567', status: :on_shelf, product_category_id: product_category.id, width: 2, weight: 2, depth: 2, height: 2, is_fragile: 'checked')
    price = Timecop.freeze(1.week.ago) { create(:price, product: product, price_in_brl: 10.00) }

    login_as(admin, scope: :admin)
    visit admin_session_path
    click_on 'Gerenciar Preços & Produtos'
    click_on 'Editar produto'
    fill_in "Nome",	with: "Produto editado"
    fill_in "SKU",	with: "-"
    select 'suspenso', from: 'Status'
    select 'Tecnologia', from: 'Categoria do produto'
    click_on 'Atualizar produto'

    expect(page).to have_content 'O produto não foi alterado.'
    expect(page).to have_content 'SKU deve ter apenas letras e números'
  end
end