require 'rails_helper'

feature 'Using the search function on the navbar,' do
  context 'when done by an admin,' do
    it 'returns all matching products regardless of their status' do
      admin = create(:admin)
      product1 = create(:product, status: 'off_shelf',name: 'Pracha de surf')
      product2 = create(:product, status: 'draft',    name: 'Twilight Patrol - Wetsuit para Surf')
      product3 = create(:product, status: 'on_shelf', name: 'Malucos do kitesurf - uma biografia')
      product4 = create(:product, status: 'on_shelf', name: 'Camiseta com onda', description: 'Camiseta 100% algodão com motivos de surf')
      product5 = create(:product, status: 'on_shelf', name: 'Boardshort com bolso', brand: 'Surf me')
      product6 = create(:product, status: 'on_shelf', name: 'Parafina', sku: 'SURF9045')
      unrelated_product = create(:product, name: 'Caneca Mon Amour', 
                                            status: 'on_shelf',
                                            brand: 'TOC & Ex-TOC',
                                            description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
                                            sku: 'TOCCAN1234')

      login_as(admin, scope: :admin)
      visit root_path
      fill_in 'Busque aqui seu produto', with: 'surf'
      click_on 'Procurar'

      expect(page).to have_text(product1.name) # off_shelf | keyword on title
      expect(page).to have_text(product2.name) # draft     | keyword on title
      expect(page).to have_text(product3.name) # on_shelf  | keyword on title, part of another word 
      expect(page).to have_text(product4.name) # lowercase | keyword on description
      expect(page).to have_text(product5.name) # mixed case| keyword on brand
      expect(page).to have_text(product6.name) # uppercase | keyword on SKU
      expect(page).not_to have_text(unrelated_product.name)
    end
  end

  context 'when done by a logged user' do
    it 'returns only matching products on shelf' do
      product1 = create(:product, status: 'on_shelf',  name: 'Caneca Mon Amour')
      product2 = create(:product, status: 'draft',     name: 'Caneca Santo Café Diário')
      product3 = create(:product, status: 'off_shelf', name: 'Caneca Moonbucks')
      user = create(:user)

      login_as(user, scope: :user)
      visit root_path
      fill_in 'Busque aqui seu produto', with: 'Caneca'
      click_on 'Procurar'

      expect(page).to have_text(product1.name)
      expect(page).not_to have_text(product2.name)
      expect(page).not_to have_text(product3.name)
    end
  end
end