require 'rails_helper'

describe 'Unlogged user tries to see details of a Product' do
  it 'and is successful' do
    create(:exchange_rate, rate: 2)
    product = create(:product, name: 'Caneca Mon Amour', 
                               status: 'on_shelf',
                               brand: 'TOC & Ex-TOC',
                               description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
                               sku: 'TOCCAN1234',
                    ).set_brl_price(15)

    visit root_path
    click_on 'Caneca Mon Amour'

    expect(page).to have_text 'Caneca Mon Amour'
    expect(page).to have_text 'TOC & Ex-TOC'
    expect(page).to have_text 'Caneca em cerâmica com desenho de uma flecha do cupido'
    expect(page).to have_text 'TOCCAN123'
    expect(page).to have_text '30' 
    expect(page).not_to have_text 'Status: à venda' 
  end

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