require 'rails_helper'

describe 'Admin tries to update exchange rate' do
  it 'and can access page correctly' do
    create(:exchange_rate, rate: 5.99, registered_at_source_for: Date.new(2022, 07, 01))
    admin = create(:admin)

    login_as(admin, scope: :admin)
    visit root_path
    click_on 'Taxa de Câmbio'

    expect(current_path).to eq admin_exchange_rates_path
    expect(page).to have_text 'Valor atual'
    expect(page).to have_text '1 rubi = 5,99 reais'
    expect(page).to have_text '1 real = 0,1669 rubis'
    expect(page).to have_text 'Data de referência'
    expect(page).to have_text '01/07/2022'
    expect(page).to have_text 'Última atualização'
    expect(page).to have_button 'Atualizar taxa de câmbio'
  end

  it 'and is succesful' do
    create(:exchange_rate, rate: 4.52)
    fake_response = double('faraday_response', status: 200, body: '{
        "brl_coin": 2.5,
        "register_date": "2022-06-21"}' )
    allow(Faraday).to receive(:get).and_return(fake_response)
    admin = create(:admin)

    login_as(admin, scope: :admin)
    visit admin_exchange_rates_path
    click_on 'Atualizar taxa de câmbio'

    expect(ExchangeRate.current).to eq 2.50
    expect(page).to have_text '1 rubi = 2,50 reais'
    expect(page).to have_text '1 real = 0,4000 rubis'
  end

  it 'but access is denied because they are not logged in' do
    visit admin_exchange_rates_path

    expect(current_path).not_to eq admin_exchange_rates_path
    expect(current_path).to eq new_admin_session_path
  end
end