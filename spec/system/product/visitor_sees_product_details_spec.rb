require 'rails_helper'

describe 'Unlogged user sees details of a Product' do
  it 'succesfully' do
    product = create(:product, name: 'Caneca Mon Amour', 
                               status: 'on_shelf',
                               brand: 'TOC & Ex-TOC',
                               description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
                               sku: 'TOCCAN1234')
    Timecop.freeze(1.month.ago) do
      Price.create!(product: product, price_in_brl: 12, validity_start: 2.seconds.from_now)
      Price.create!(product: product,  price_in_brl: 14.99, validity_start: 28.days.from_now)
    end
    Price.create!(product: product, price_in_brl: 18, validity_start: 2.days.from_now)

    visit root_path
    click_on 'Caneca Mon Amour'

    expect(page).to have_text 'Caneca Mon Amour'
    expect(page).to have_text 'TOC & Ex-TOC'
    expect(page).to have_text 'Caneca em cerâmica com desenho de uma flecha do cupido'
    expect(page).to have_text 'TOCCAN1234'
    expect(page).to have_text 'R$ 14,99' 
    expect(page).not_to have_text 'Status: à venda' 
  end

  it 'but is redirected to homepage because the product does not exists' do
    visit product_path(1)
    
    expect(current_path).to eq root_path
    expect(page).to have_text 'Produto não encontrado'
  end
end