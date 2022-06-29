require 'rails_helper'

describe 'Admin sees the product' do
  it 'in a admin view' do
    admin = create(:admin)
    product = create(:product)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Produtos'
    click_on product.name

    expect(page).to have_content('Gerenciar Produtos')
    expect(page).to have_content(product.name)
    expect(page).to have_content(product.brand)

  end
end