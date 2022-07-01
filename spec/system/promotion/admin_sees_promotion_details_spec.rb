require 'rails_helper'

describe "Admin sees promotion details" do
  it "successfully" do
    admin = create(:admin)
    category_1 = create(:product_category, name: 'Vestuário')
    category_2 = create(:product_category, name: 'Eletrônicos')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')
    promotion = create(:promotion, name: 'Dia das mães', start_date: 1.day.from_now, 
                       end_date: 3.day.from_now, maximum_discount: 70, 
                       discount_percent: 20, absolute_discount_uses: 5000)
    promotion_category_1 = create(:promotion_category, product_category: category_1, promotion: promotion)
    promotion_category_2 = create(:promotion_category, product_category: category_2, promotion: promotion)



    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Promoções'
    click_on 'Dia das mães'

    expect(page).to have_content('Detalhes da promoção') 
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
      expect(page).to have_content("Eletrônicos")
      expect(page).to have_content("Vestuário")
    end
  end

  it "and goes back to index" do
    admin = create(:admin)
    category_1 = create(:product_category, name: 'Vestuário')
    category_2 = create(:product_category, name: 'Eletrônicos')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')
    promotion = create(:promotion, name: 'Dia das mães', start_date: 1.day.from_now, 
                       end_date: 3.day.from_now, maximum_discount: 70, 
                       discount_percent: 20, absolute_discount_uses: 5000)
    promotion_category_1 = create(:promotion_category, product_category: category_1, promotion: promotion)
    promotion_category_2 = create(:promotion_category, product_category: category_2, promotion: promotion)



    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Promoções'
    click_on 'Dia das mães'
    click_on 'Voltar'

    expect(current_path).to eq promotions_path
  end
end
