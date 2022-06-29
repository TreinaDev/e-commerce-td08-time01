require 'rails_helper'

describe 'Unlogged user visits home page' do
  it 'succesfully' do
    create(:exchange_rate, rate: 2)
    
    visit root_path

    expect(page).to have_content 'Mercadores'
  end

  it 'and sees only active products' do
    create(:exchange_rate, rate: 2)
    create(:product, name: 'Sabre Jedi', status: 'off_shelf')
    create(:product, name: 'Katana do Kill Bill', status: 'draft')
    create(:product, name: 'Caneca Mon Amour', status: 'on_shelf',
                     brand: 'TOC & Ex-TOC',
                     description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
                    ).set_brl_price(12)
    create(:product, name: 'Garrafa Star Wars', status: 'on_shelf',
                     brand: 'Zona Criativa',
                     description: 'Garrafa térmica inox com temática do filme Star Wars',
                    ).set_brl_price(15)
    
    visit root_path

    expect(page).to have_text 'Caneca Mon Amour'
    expect(page).to have_text 'TOC & Ex-TOC'
    expect(page).to have_text 'Caneca em cerâmica com desenho de uma flecha do cupido'
    expect(page).to have_content '6'
    expect(page).to have_text 'Garrafa Star Wars'
    expect(page).to have_text 'Zona Criativa'
    expect(page).to have_text 'Garrafa térmica inox com temática do filme Star Wars'
    expect(page).to have_content "#{Product.last.current_price_in_rubis}"
    expect(page).not_to have_text 'Sabre Jedi'
    expect(page).not_to have_text 'Katana do Kill Bill'
  end

  it 'but there are no products to show' do
    visit root_path

    expect(page).to have_text 'Não existem produtos cadastrados' 
  end
end