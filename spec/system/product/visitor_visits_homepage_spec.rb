require 'rails_helper'

describe 'Unlogged user visits home page' do
  it 'succesfully' do
    visit root_path

    expect(page).to have_content 'Mercadores'
  end

  it 'and sees only active products' do
    create(:product, name: 'Sabre Jedi', status: 'off_shelf', sku: SecureRandom.alphanumeric(6).upcase)
    create(:product, name: 'Katana do Kill Bill', status: 'draft', sku: SecureRandom.alphanumeric(6).upcase)
    create(:product, name: 'Caneca Mon Amour', status: 'on_shelf', sku: SecureRandom.alphanumeric(6).upcase,
                     brand: 'TOC & Ex-TOC',
                     description: 'Caneca em cerâmica com desenho de uma flecha do cupido')
    create(:product, name: 'Garrafa Star Wars', status: 'on_shelf', sku: SecureRandom.alphanumeric(6).upcase,
                     brand: 'Zona Criativa',
                     description: 'Garrafa térmica inox com temática do filme Star Wars')
    
    visit root_path

    expect(page).to have_text 'Caneca Mon Amour'
    expect(page).to have_text 'TOC & Ex-TOC'
    expect(page).to have_text 'Caneca em cerâmica com desenho de uma flecha do cupido'
    expect(page).to have_text 'Garrafa Star Wars'
    expect(page).to have_text 'Zona Criativa'
    expect(page).to have_text 'Garrafa térmica inox com temática do filme Star Wars'
    expect(page).not_to have_text 'Sabre Jedi'
    expect(page).not_to have_text 'Katana do Kill Bill'
  end

  it 'but there are no products to show' do
    visit root_path

    expect(page).to have_text 'Não existem produtos cadastrados' 
  end
end