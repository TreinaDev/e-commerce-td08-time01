require 'rails_helper'

describe "Visitante vê detalhes de um produto" do
  it "com sucesso" do
    Product.create!(name: 'Caneca Mon Amour', 
                    brand: 'TOC & Ex-TOC',
                    description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
                    sku: 'TOCCAN1234')

    visit root_path
    click_on 'Caneca Mon Amour'

    expect(page).to have_text 'Caneca Mon Amour'
    expect(page).to have_text 'TOC & Ex-TOC'
    expect(page).to have_text 'Caneca em cerâmica com desenho de uma flecha do cupido'
    expect(page).to have_text 'TOCCAN1234'
  end
end