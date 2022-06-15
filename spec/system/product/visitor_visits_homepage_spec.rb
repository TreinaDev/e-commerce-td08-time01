require 'rails_helper'

describe 'Unlogged user visits home page' do
  it 'succesfully' do
    visit root_path

    expect(page).to have_content 'Mercadores'
  end

  it 'and sees products' do
    Product.create!(name: 'Caneca Mon Amour', 
                    brand: 'TOC & Ex-TOC',
                    description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
                    sku: 'TOC1234',
                  )
    Product.create!(name: 'Garrafa Star Wars', 
                    brand: 'Zona Criativa',
                    description: 'Garrafa térmica inox com temática do filme Star Wars',
                    sku: 'ZON0001',
                  )
    visit root_path

    expect(page).to have_text 'Caneca Mon Amour'
    expect(page).to have_text 'TOC & Ex-TOC'
    expect(page).to have_text 'Caneca em cerâmica com desenho de uma flecha do cupido'
    expect(page).to have_text 'Garrafa Star Wars'
    expect(page).to have_text 'Zona Criativa'
    expect(page).to have_text 'Garrafa térmica inox com temática do filme Star Wars'
  end

  it 'but there are no products to show' do
    visit root_path

    expect(page).to have_text 'Não existem produtos cadastrados' 
  end
end