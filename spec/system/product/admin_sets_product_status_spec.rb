require 'rails_helper'

describe 'When an admin visits the show of a Product, the button with the same 
          status of the Product is hidden' do
  it '(case: product is still a draft)' do
    product = create(:product, status: 'draft')
    Timecop.freeze(1.year.ago) do
      create(:price, product: product)
    end
    admin = create(:admin)

    login_as(admin, scope: :admin)
    visit product_path(product)

    expect(page).to have_button('Suspender produto')
    expect(page).not_to have_button('Tornar produto um rascunho')
    expect(page).to have_button('Colocar produto à venda')
  end

  it '(case: product is on shelf)' do
    product = create(:product, status: 'on_shelf')
    Timecop.freeze(1.year.ago) do
      create(:price, product: product)
    end
    admin = create(:admin)

    login_as(admin, scope: :admin)
    visit product_path(product)

    expect(page).to have_button('Suspender produto')
    expect(page).to have_button('Tornar produto um rascunho')
    expect(page).not_to have_button('Colocar produto à venda')
  end

  it '(case: product is off shelf)' do
    product = create(:product, status: 'off_shelf')
    Timecop.freeze(1.year.ago) do
      create(:price, product: product)
    end
    admin = create(:admin)

    login_as(admin, scope: :admin)
    visit product_path(product)

    expect(page).not_to have_button('Suspender produto')
    expect(page).to have_button('Tornar produto um rascunho')
    expect(page).to have_button('Colocar produto à venda')
  end
end