require 'rails_helper'

describe 'Unlogged user tries to see details of a Product' do
  it 'and is successful' do
    create(:exchange_rate, rate: 2)
    product = create(:product, name: 'Caneca Mon Amour', 
                      status: 'on_shelf',
                      brand: 'TOC & Ex-TOC',
                      description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
                      sku: 'TOCCAN1234',
                      width: (1..5).to_a.sample.to_i,
                      weight: (1..5).to_a.sample.to_i,
                      depth: (1..5).to_a.sample.to_i,
                      height: (1..5).to_a.sample.to_i,
                      is_fragile: ['unchecked', 'checked'].sample
                    ).set_brl_price(15)

    visit root_path
    click_on 'Caneca Mon Amour'

    expect(page).to have_text 'Caneca Mon Amour'
    expect(page).to have_text 'TOC & Ex-TOC'
    expect(page).to have_text 'Caneca em cerâmica com desenho de uma flecha do cupido'
    expect(page).to have_text 'TOCCAN123'
    expect(page).to have_text '8' 
    expect(page).not_to have_text 'Status: à venda' 
  end

  context 'but is redirected to homepage because the product' do
    it 'does not exist' do
      visit product_path(1)
      
      expect(current_path).to eq root_path
      expect(page).to have_text 'Produto não encontrado'
    end

    it 'is a draft' do
      create(:product, status: 'draft')

      visit product_path(1)
      
      expect(current_path).to eq root_path
      expect(page).to have_text 'Produto não encontrado'
    end

    it 'is off shelf' do
      user = create(:user)
      create(:product, status: 'off_shelf')
      
      login_as(user, scope: :user)
      visit product_path(1)
      
      expect(current_path).to eq root_path
      expect(page).to have_text 'Produto não encontrado'
    end

    it 'product has an image and guide' do
      admin = create(:admin)
      login_as(admin, scope: :admin)
      create(:exchange_rate)
      product_category = ProductCategory.create!(name: 'Tecnologia')
      product = Product.create!(
                              name: 'Produto teste',
                              brand: 'Marca teste',
                              description: 'Description do produto teste',
                              sku: 'QQ1234567',
                              status: :on_shelf,
                              product_category_id: product_category.id,
                              width: (1..5).to_a.sample.to_i,
                              weight: (1..5).to_a.sample.to_i,
                              depth: (1..5).to_a.sample.to_i,
                              height: (1..5).to_a.sample.to_i,
                              is_fragile: ['unchecked', 'checked'].sample
                            )
      product.picture.attach(
        io: File.open('spec/support/attach_file/pagamento.png'),
        filename: 'pagamento.png'
      )
      product.file.attach(
        io: File.open('spec/support/attach_file/manual_teste.txt'),
        filename: 'manual_teste.txt'
      )
      price = Timecop.freeze(1.week.ago) { create(:price, product: product, price_in_brl: 10.00) }

      visit root_path
      click_on 'Produto teste'

      expect(page).to have_content 'Produto teste'
      expect(page).to have_content 'manual_teste.txt'
      expect(page).to have_css("img[src*='pagamento.png']")
    end
  end
end