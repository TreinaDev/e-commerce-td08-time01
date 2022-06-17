require 'rails_helper'

describe 'A request for status update is denied' do
  it 'when done by an unlogged person' do
    product = create(:product, status: 'draft')

    post update_status_product_path(product), params: { status: 'on_shelf'}

    expect(Product.first.status).to eq 'draft'
  end

  it 'when done by a costumer' do
    user = create(:user)
    product = create(:product, status: 'draft')

    login_as(user, scope: :user)
    post update_status_product_path(product), params: { status: 'on_shelf'}

    expect(Product.first.status).to eq 'draft'
  end
end

describe 'Admin clicks on a button that should' do
  it 'update product status to off_shelf' do
    admin = create(:admin)
    product1 = create(:product, status: 'draft')
    product2 = create(:product, status: 'draft')
    Timecop.freeze(1.year.ago) do
      create(:price, product: product1)
    end

    login_as(admin, scope: :admin)
    visit product_path(product1)
    click_on 'Suspender produto'

    expect(current_path).to eq product_path(product1)
    expect(Product.first.status).to eq 'off_shelf'
    expect(Product.last.status).to eq 'draft' # unchanged
    expect(page).to have_text('Status: suspenso')
    expect(page).to have_text('Status atualizado com sucesso')
    expect(page).not_to have_button('Suspender produto')
    expect(page).to have_button('Tornar produto um rascunho')
    expect(page).to have_button('Colocar produto à venda')
  end

  it 'update product status to draft' do
    admin = create(:admin)
    product = create(:product, status: 'on_shelf')
    Timecop.freeze(1.year.ago) do
      create(:price, product: product)
    end

    login_as(admin, scope: :admin)
    visit product_path(product)
    click_on 'Tornar produto um rascunho'

    expect(Product.first.status).to eq 'draft'
    expect(current_path).to eq product_path(product)
    expect(page).to have_text('Status atualizado com sucesso')
    expect(page).to have_button('Suspender produto')
    expect(page).not_to have_button('Tornar produto um rascunho')
    expect(page).to have_button('Colocar produto à venda')
  end

  context 'update product status to on_shelf' do
    it 'and it works' do
      admin = create(:admin)
      product = create(:product, status: 'off_shelf')
      Timecop.freeze(1.year.ago) do
        create(:price, product: product)
      end

      login_as(admin, scope: :admin)
      visit product_path(product)
      click_on 'Colocar produto à venda'

      expect(Product.first.status).to eq 'on_shelf'
      expect(current_path).to eq product_path(product)
      expect(page).to have_text('Status atualizado com sucesso')
      expect(page).to have_button('Suspender produto')
      expect(page).to have_button('Tornar produto um rascunho')
      expect(page).not_to have_button('Colocar produto à venda')
    end

    it 'but receives an error message' do
      admin = create(:admin)
      product = create(:product, brand: '', status: 'off_shelf')
      Timecop.freeze(1.year.ago) do
        create(:price, product: product)
      end

      login_as(admin, scope: :admin)
      visit product_path(product)
      click_on 'Colocar produto à venda'

      expect(Product.first.status).to eq 'off_shelf'
      expect(page).to have_text('Houve um erro')
      expect(page).to have_text('marca não pode estar em branco')
    end
  end
end