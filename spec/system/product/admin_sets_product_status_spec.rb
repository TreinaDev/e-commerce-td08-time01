require 'rails_helper'

describe 'When an admin visits the show of a Product, the button with the same 
          status of the Product is hidden' do
  it '(case: product is still a draft)' do
    product = create(:product, name: 'Sabre Jedi', status: 'draft')
    admin = create(:admin)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Sabre Jedi'

    expect(page).to have_button('Colocar produto à venda')
    expect(page).to have_button('Suspender produto')
  end

  xit '(case: product is on shelf)' do
  end

  xit '(case: product is off shelf)' do
  end
end