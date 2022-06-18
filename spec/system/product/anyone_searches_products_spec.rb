require 'rails_helper'

feature 'Using the search function on the navbar,' do
  context 'when done by an admin,' do
    it 'returns all matching products regardless of their status' do
      product1 = create(:product, name: 'Caneca Mon Amour', 
                                  status: 'on_shelf',
                                  brand: 'TOC & Ex-TOC',
                                  description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
                                  sku: 'TOCCAN1234')
      product2 = create(:product, name: 'Caneca Santo Café Diário', 
                                  status: 'draft',
                                  brand: 'Vesúvia',
                                  description: 'Caneca em vidro dupla face, ideal para cappuccinos',
                                  sku: 'VES38502')
      product3 = create(:product, name: 'Camiseta Verde-Água', 
                                  status: 'on_shelf',
                                  brand: 'RIP Curva',
                                  description: 'Camiseta 100% algodão com desenho uma caneca',
                                  sku: 'RIP00748')
      admin = create(:admin)

      login_as(admin, scope: :admin)
      visit root_path
      fill_in 'Busque aqui seu produto', with: 'Caneca'
      click_on 'Procurar'

      expect(page).to have_text('Caneca Mon Amour')
      expect(page).to have_text('Caneca Santo Café Diário')
      expect(page).not_to have_text('Camiseta')
    end
  end

  context 'when done by a logged user' do
    it 'returns only matching products on shelf' do
      product1 = create(:product, name: 'Caneca Mon Amour', 
                                  status: 'on_shelf',
                                  brand: 'TOC & Ex-TOC',
                                  description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
                                  sku: 'TOCCAN1234')
      product2 = create(:product, name: 'Caneca Santo Café Diário', 
                                  status: 'draft',
                                  brand: 'Vesúvia',
                                  description: 'Caneca em vidro dupla face, ideal para cappuccinos',
                                  sku: 'VES38502')
      product3 = create(:product, name: 'Camiseta Verde-Água', 
                                  status: 'on_shelf',
                                  brand: 'RIP Curva',
                                  description: 'Camiseta 100% algodão com desenho uma caneca',
                                  sku: 'RIP00748')
      user = create(:user)

      login_as(user, scope: :user)
      visit root_path
      fill_in 'Busque aqui seu produto', with: 'Caneca'
      click_on 'Procurar'

      expect(page).to have_text('Caneca Mon Amour')
      expect(page).not_to have_text('Caneca Santo Café Diário')
      expect(page).not_to have_text('Camiseta')
    end
  end
end