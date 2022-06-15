require 'rails_helper'

describe 'Unlogged user visits show of a Product' do
  it 'succesfully' do
    allow(SecureRandom).to receive(:alphanumeric).with(9).and_return('TOCCAN123')
    product = create(:product, name: 'Caneca Mon Amour',
                               brand: 'TOC & Ex-TOC',
                               description: 'Caneca em cerâmica com desenho de uma flecha do cupido')
    Timecop.freeze(1.month.ago) do
      create(:price, product: product, price_in_brl: 12, validity_start: 2.seconds.from_now)
      create(:price, product: product, price_in_brl: 14.99, validity_start: 28.days.from_now)
      create(:price, product: product, price_in_brl: 18, validity_start: 2.months.from_now)
    end

    visit root_path
    click_on 'Caneca Mon Amour'

    expect(page).to have_text 'Caneca Mon Amour'
    expect(page).to have_text 'TOC & Ex-TOC'
    expect(page).to have_text 'Caneca em cerâmica com desenho de uma flecha do cupido'
    expect(page).to have_text 'TOCCAN123'
    expect(page).to have_text 'R$ 14,99' 
  end

  it 'but is redirected to homepage because the product does not exists' do
    visit product_path(1)
    
    expect(current_path).to eq root_path
    expect(page).to have_text 'Produto não encontrado'
  end
end