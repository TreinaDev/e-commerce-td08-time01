require 'rails_helper'

describe 'user filter the search of product by category' do
  it 'with success' do
    ExchangeRate.create!(rate: 2, registered_at_source_for: 2)
    category_tv = ProductCategory.create!(name: 'TVs')
    category_smartphone = ProductCategory.create!(name: 'Smartphones')
    Product.create!(name: 'Smart TV 43', brand: 'Samsung', description: 'TV LED ultrafina',
                    sku: 'SAMLED1234', product_category_id: category_tv.id, status: 'on_shelf',
                    width: 2, weight: 2, depth: 2, height: 2, is_fragile: 'checked')
    Product.create!(name: 'Iphone 13', brand: 'Apple', description: 'Preto com 256 GB',
                    sku: 'APPIPO1234', product_category_id: category_smartphone.id, status: 'on_shelf',
                    width: 2, weight: 2, depth: 2, height: 2, is_fragile: 'checked')
    user = create(:user)

    login_as(user, scope: user)
    visit root_path
    select 'TVs', from: 'name'
    click_on 'Procurar'

    expect(page).to have_content 'Smart TV 43'
    expect(page).not_to have_content 'Iphone 13'
  end

  it 'when product is not on shelf' do
    ExchangeRate.create!(rate: 2, registered_at_source_for: 2)
    category_tv = ProductCategory.create!(name: 'TVs')
    Product.create!(name: 'Smart TV 43', brand: 'Samsung', description: 'TV LED ultrafina',
                    sku: 'SAMLED1234', product_category_id: category_tv.id, status: 'draft',
                    width: 2, weight: 2, depth: 2, height: 2, is_fragile: 'checked')
    user = create(:user)

    login_as(user, scope: user)
    visit root_path
    select 'TVs', from: 'name'
    click_on 'Procurar'

    expect(page).not_to have_content 'Smart TV 43'
    expect(page).to have_content "Nenhum resultado encontrado para: #{category_tv.name}"
  end
end