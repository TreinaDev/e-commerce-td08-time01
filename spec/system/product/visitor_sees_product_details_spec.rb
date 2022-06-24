require 'rails_helper'

describe 'Unlogged user tries to see details of a Product' do
  # Correção de palavra
  it 'and is successful' do
    product = create(:product, name: 'Caneca Mon Amour', 
                               status: 'on_shelf',
                               brand: 'TOC & Ex-TOC',
                               description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
                               sku: 'TOCCAN1234')
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
    expect(page).to have_text '14,99' 
    expect(page).not_to have_text 'Status: à venda' 
  end
  # Sugestão de mudança 
  context 'but is redirected to homepage because the product' do
    it 'does not exist' do
      visit product_path(1)
      
      expect(current_path).to eq root_path
      expect(page).to have_text 'Produto não encontrado'
    end

    it 'is a draft' do
      create(:product, status: 'draft')

      visit product_path(1)
      
      expect(current_path).to eq root_path
      expect(page).to have_text 'Produto não encontrado'
    end

    it 'is off shelf' do
      user = create(:user)
      create(:product, status: 'off_shelf')
      
      login_as(user, scope: :user)
      visit product_path(1)
      
      expect(current_path).to eq root_path
      expect(page).to have_text 'Produto não encontrado'
    end
  end
end