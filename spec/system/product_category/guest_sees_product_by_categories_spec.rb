require 'rails_helper'

describe 'Guest user visit a product category' do
  it 'and sees products within this category' do
    category1 = create(:product_category, name: 'Cozinha')
    product1 = create(:product, name: 'Conjunto Pratos de Porcelana', product_category: category1, status: :on_shelf)
    product2 = create(:product, name: 'Garrafa Térmica Inox 500ml', product_category: category1, status: :on_shelf)
    category2 = create(:product_category, name: 'Carro e Acessórios')
    product3 = create(:product, name: 'Pneu Aro 15', product_category: category2)
    Timecop.freeze(1.day.ago) do
      create(:price, product: product1, price_in_brl: 30.00)
      create(:price, product: product2, price_in_brl: 120.00)
      create(:price, product: product3, price_in_brl: 300.00)
    end

    visit root_path
    click_on product1.name
    within '.catnav' do 
      click_on category1.name
    end

    expect(current_path).to eq by_category_products_path(category1)
    expect(page).to have_content('Cozinha')
    expect(page).to have_content('Conjunto Pratos de Porcelana')
    expect(page).to have_content('Garrafa Térmica Inox 500ml')
    expect(page).not_to have_content('Categoria: Carro e Acessórios')
    expect(page).not_to have_content('Pneu Aro 15')
  end

  it 'and sees products within this category and subcategories' do
    category1 = create(:product_category, name: 'Cozinha')
    category2 = create(:product_category, name: 'Mesa', parent: category1)
    category3 = create(:product_category, name: 'Garrafas Térmicas', parent: category1)
    product1 = create(:product, name: 'Conjunto Pratos de Porcelana', product_category: category2, status: :on_shelf)
    product2 = create(:product, name: 'Garrafa Térmica Inox 500ml', product_category: category3, status: :on_shelf)
    Timecop.freeze(1.day.ago) do
      create(:price, product: product1, price_in_brl: 120.00)
      create(:price, product: product2, price_in_brl: 25.00)
    end

    visit root_path
    click_on product1.name
    within '.catnav' do 
      click_on category1.name
    end

    expect(current_path).to eq by_category_products_path(category1)
    expect(page).to have_content('Cozinha')
    expect(page).to have_content('Categoria: Mesa')
    expect(page).to have_content('Conjunto Pratos de Porcelana')
    expect(page).to have_content('Categoria: Garrafas Térmicas')
    expect(page).to have_content('Garrafa Térmica Inox 500ml')
  end

  it 'and the category doesn\'t have any product registered yet' do
    category = create(:product_category, name: 'Cozinha')

    visit by_category_products_path(category)

    expect(page).to have_content('Não existem produtos cadastrados nesta categoria')
  end


end