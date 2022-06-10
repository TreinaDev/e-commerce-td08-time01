require 'rails_helper'

describe 'Visitante visita a app' do
  it 'com sucesso' do
    visit root_path

    expect(page).to have_content 'E-Commerce'
  end

  it 'e vê produtos' do
    Product.create!(name: 'Caneca Mon Amour', 
                    brand: 'TOC & Ex-TOC',
                    description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
    )
    Product.create!(name: 'Garrafa Star Wars', 
                    brand: 'Zona Criativa',
                    description: 'Garrafa térmica inox, star wars'
    )
    visit root_path

    expect(Product.count).to be 2
    expect(page).to have_text 'Caneca Mon Amour'
    expect(page).to have_text 'TOC & Ex-TOC'
    expect(page).to have_text 'Caneca em cerâmica com desenho de uma flecha do cupido'
    expect(page).to have_text 'Garrafa Star Wars'
    expect(page).to have_text 'Zona Criativa'
    expect(page).to have_text 'Garrafa térmica inox, star wars'
  end

  it "e não vê produtos" do
    visit root_path

    expect(page).to have_text 'Não existem produtos cadastrados' 
  end
end