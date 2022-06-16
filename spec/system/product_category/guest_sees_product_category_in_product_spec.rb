require 'rails_helper'

describe 'Guest visit product page' do
  include ActiveSupport::Testing::TimeHelpers
  
  it 'and sees product category' do
    product_category_root = create(:product_category, name: 'Cozinha')
    product_category_child = create(:product_category, name: 'Acessórios', parent: product_category_root)
    product_category_grandchild = create(:product_category, name: 'Garrafa Térmica', parent: product_category_child)
    product = create(:product, product_category: product_category_grandchild)

    travel_to 1.day.ago do
      price = create(:price, product: product, price_in_brl: 10.00)
    end

    visit root_path
    click_on product.name
  
    within '.breadcrumb' do
      expect(current_path).to eq product_path(product)
      expect(page).to have_content(product_category_grandchild.name)
      expect(page).to have_content(product_category_child.name)
    end
  end

  it 'and product haven\'t product category' do
    product = create(:product)

    travel_to 1.day.ago do
      price = create(:price, product: product, price_in_brl: 10.00)
    end

    visit root_path
    click_on product.name

    within '.breadcrumb' do
      expect(current_path).to eq product_path(product)
      expect(page).to have_content('Sem categoria')
    end
  end


end