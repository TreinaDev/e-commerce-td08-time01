require 'rails_helper'

describe 'Admin register new price configuration' do
  it 'with succesful' do
    admin = create(:admin)
    product = create(:product)
    old_price = Timecop.freeze(1.week.ago) { create(:price, product: product, price_in_brl: 10.00) }

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Preços & Produtos'
    click_on product.name
    click_on 'Cadastrar nova configuração de preço'
    fill_in 'Preço em reais', with: 15.55
    select DateTime.current.day, from: 'price_validity_start_3i'
    select I18n.l(DateTime.current, format: "%B"), from: 'price_validity_start_2i'
    select DateTime.current.year, from: 'price_validity_start_1i'
    select DateTime.current.hour, from: 'price_validity_start_4i'
    select (DateTime.current.minute+1), from: 'price_validity_start_5i'
    click_on 'Salvar'

    expect(page).to have_content('Cadastrar nova configuração de preço')
    expect(page).to have_content('R$ 10,00')
    expect(page).to have_content(I18n.l(old_price.validity_start))
    expect(page).to have_content('R$ 15,55')
    expect(page).to have_content(I18n.l(product.prices.last.validity_start))
  end

  it 'and fail beacause the date past' do
    admin = create(:admin)
    product = create(:product)
    old_price = Timecop.freeze(1.week.ago) { create(:price, product: product, price_in_brl: 10.00) }

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Preços & Produtos'
    click_on product.name
    click_on 'Cadastrar nova configuração de preço'
    fill_in 'Preço em reais', with: ''
    select DateTime.current.day, from: 'price_validity_start_3i'
    select I18n.l(DateTime.current, format: "%B"), from: 'price_validity_start_2i'
    select DateTime.current.year, from: 'price_validity_start_1i'
    select DateTime.current.hour, from: 'price_validity_start_4i'
    select (DateTime.current.minute+1), from: 'price_validity_start_5i'
    click_on 'Salvar'

    expect(page).to have_content('Preço em reais não pode estar em branco')
  end

  it 'and fail beacause the date past' do
    admin = create(:admin)
    product = create(:product)
    old_price = Timecop.freeze(1.week.ago) { create(:price, product: product, price_in_brl: 10.00) }

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Gerenciar Preços & Produtos'
    click_on product.name
    click_on 'Cadastrar nova configuração de preço'
    fill_in 'Preço em reais', with: 15.55
    select DateTime.current.day, from: 'price_validity_start_3i'
    select I18n.l(DateTime.current, format: "%B"), from: 'price_validity_start_2i'
    select DateTime.current.year, from: 'price_validity_start_1i'
    select DateTime.current.hour, from: 'price_validity_start_4i'
    select (DateTime.current.minute), from: 'price_validity_start_5i'
    click_on 'Salvar'

    expect(page).to have_content('Início da validade não pode estar no passado')
  end
end