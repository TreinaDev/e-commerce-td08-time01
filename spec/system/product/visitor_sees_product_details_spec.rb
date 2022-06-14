require 'rails_helper'

describe "Visitante acessa página de detalhes de um produto" do
  it "com sucesso" do
    product = Product.create!(name: 'Caneca Mon Amour', 
                              brand: 'TOC & Ex-TOC',
                              description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
                              sku: 'TOCCAN1234')
    Price.create(product: product,
                price_in_brl: 12,
                validity_start: 22.days.ago)
    Price.create(product: product,
                price_in_brl: 14.99,
                validity_start: 9.hours.ago)
    Price.create(product: product,
                price_in_brl: 18,
                validity_start: 2.days.from_now)

    visit root_path
    click_on 'Caneca Mon Amour'

    expect(page).to have_text 'Caneca Mon Amour'
    expect(page).to have_text 'TOC & Ex-TOC'
    expect(page).to have_text 'Caneca em cerâmica com desenho de uma flecha do cupido'
    expect(page).to have_text 'TOCCAN1234'
    expect(page).to have_text 'R$ 14,99' 
  end

  it "mas o produto não existe" do
    visit product_path(1)
    
    expect(current_path).to eq root_path
    expect(page).to have_text 'Produto não encontrado'
  end
end
