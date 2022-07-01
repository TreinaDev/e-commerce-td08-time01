require 'rails_helper'

describe 'Admin access promotions page' do
  it 'and sees promotions history' do
    admin = create(:admin)
    promotion = create(:promotion, start_date: 1.day.from_now, end_date: 3.days.from_now)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Promoções'

    expect(page).to have_content('Dia das mães') 
    expect(page).to have_content(I18n.localize(1.day.from_now)) 
    expect(page).to have_content(I18n.localize(3.days.from_now)) 
    expect(page).to have_content(promotion.code) 
  end

  context 'and registers a new promotion' do
    it 'successfully' do
      admin = create(:admin)
      create(:product_category, name: "Eletrônicos")
      create(:product_category, name: "Têxtil")
      create(:product_category, name: "Comidas")
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')

      login_as(admin, scope: :admin)
      visit root_path
      click_on 'Gerenciar Promoções'
      fill_in 'Nome', with: 'Dia das mães'
      fill_in "Data de início",	with: 1.day.from_now
      fill_in "Data de fim",	with: 3.days.from_now
      fill_in "Porcentagem de desconto",	with: "20"
      fill_in "Valor máximo",	with: "70.00"
      fill_in "Quantidade de usos",	with: "5000"
      select = page.find('select#new_promotion')
      select.select "Eletrônicos"
      select.select "Têxtil"
  
      click_on 'Criar nova promoção'

      expect(page).to have_content('Promoção criada com sucesso.') 
      expect(page).to have_content('Dia das mães')
      expect(page).to have_content("Data de início:\n#{I18n.localize(1.day.from_now)}") 
      expect(page).to have_content("Data de fim:\n#{I18n.localize(3.day.from_now)}") 
      expect(page).to have_content("ABCD1234")
      expect(page).to have_content("Porcentagem de desconto:\n20%")
      expect(page).to have_content("Valor máximo:")
      expect(page).to have_content("70")
      expect(page).to have_content("Quantidade de usos:\n5000")
      expect(page).to have_content("Categorias contempladas:")
      within 'ul#categories' do 
        expect(page).to have_content("Eletrônicos\nTêxtil")
        expect(page).not_to have_content("Comidas")
      end
    end

    it 'unsuccessfully due to missing some attributes and improperly set dates' do
      admin = create(:admin)
      create(:product_category, name: "Eletrônicos")
      create(:product_category, name: "Têxtil")
      create(:product_category, name: "Comidas")
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')

      login_as(admin, scope: :admin)
      visit root_path
      click_on 'Gerenciar Promoções'
      fill_in 'Nome', with: ''
      fill_in "Data de início",	with: 2.days.ago
      fill_in "Data de fim",	with: 3.days.from_now
      fill_in "Porcentagem de desconto",	with: "20"
      fill_in "Valor máximo",	with: "70.00"
      fill_in "Quantidade de usos",	with: ''
      select = page.find('select#new_promotion')
      select.select "Eletrônicos"
      select.select "Têxtil"
      click_on 'Criar nova promoção'

      expect(current_path).to eq promotions_path
      expect(page).to have_content('Promoção não pôde ser criada:') 
      expect(page).to have_content('nome não pode estar em branco') 
      expect(page).to have_content('data de início não pode estar no passado') 
      expect(page).to have_content('quantidade de usos não pode estar em branco') 
    end

    it 'unsuccessfully due to lack of categories' do
      admin = create(:admin)
      create(:product_category, name: "Eletrônicos")
      create(:product_category, name: "Têxtil")
      create(:product_category, name: "Comidas")
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')

      login_as(admin, scope: :admin)
      visit root_path
      click_on 'Gerenciar Promoções'
      fill_in 'Nome', with: 'Dia das mães'
      fill_in "Data de início",	with: 2.days.from_now
      fill_in "Data de fim",	with: 3.days.from_now
      fill_in "Porcentagem de desconto",	with: "20"
      fill_in "Valor máximo",	with: "70.00"
      fill_in "Quantidade de usos",	with: '5000'
      click_on 'Criar nova promoção'

      expect(current_path).to eq promotions_path
      expect(page).to have_content('Promoção não pôde ser criada:') 
      expect(page).to have_content('é necessário atribuição de categorias') 
    end
  end
end
