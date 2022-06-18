require 'rails_helper'

feature 'Using the search function on the navbar,' do
  context 'when done by an admin,' do
    it 'returns all matching products regardless of their status' do
      admin = create(:admin)
      product1 = create(:product, status: 'off_shelf',name: 'Pracha de surf')
      product2 = create(:product, status: 'draft',    description: 'Wetsuit para Surf')
      product3 = create(:product, status: 'on_shelf', brand: 'Surf me')
      unrelated_product = create(:product, name: 'Caneca Morning Coffee', 
                                           status: 'on_shelf',
                                           brand: 'TOC & Ex-TOC',
                                           description: 'Caneca em cerâmica',
                                           sku: 'TOCCAN1234')

      login_as(admin, scope: :admin)
      visit root_path
      fill_in 'Busque aqui seu produto', with: 'surf'
      click_on 'Procurar'

      expect(page).to have_text(product1.name) 
      expect(page).to have_text(product2.name)
      expect(page).to have_text(product3.name)
      expect(page).not_to have_text(unrelated_product.name)
    end
  end

  context 'when done by a logged user' do
    it 'returns only matching products that are on shelf' do
      product1 = create(:product, status: 'on_shelf',  name: 'Caneca Mon Amour')
      product2 = create(:product, status: 'on_shelf',  name: 'Café com caneca de brinde')
      product3 = create(:product, status: 'draft',     name: 'Caneca Santo Café Diário')
      product4 = create(:product, status: 'off_shelf', name: 'Caneca Moonbucks')
      user = create(:user)

      login_as(user, scope: :user)
      visit root_path
      fill_in 'Busque aqui seu produto', with: 'Caneca'
      click_on 'Procurar'

      expect(page).to have_text(product1.name)
      expect(page).to have_text(product2.name)
      expect(page).not_to have_text(product3.name)
      expect(page).not_to have_text(product4.name)
    end
  end
end