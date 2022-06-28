require 'rails_helper'

describe 'User tries to buy rubis' do
  it 'and is successfull' do
    create(:exchange_rate, rate: 5)
    user = create(:user)
    allow(Faraday).to receive(:post).and_return(double('faraday_response', status: 201, body: ''))

    login_as(user, scope: :user)
    visit root_path
    within('nav') do
      click_on('Comprar Rubis')
    end
    fill_in 'Valor em Real', with: 500
    within('#buy-rubis') do
      click_on 'Comprar'
    end
   
    expect(current_path).to eq root_path
    expect(page).to have_content('Compra de rubis solicitada com sucesso')
    expect(page).to have_content('Valor a ser creditado: 100.0 rubis')
  end

  it 'but input is unacceptable' do
    create(:exchange_rate, rate: 5)
    user = create(:user)

    login_as(user, scope: :user)
    visit root_path
    within('nav') do
      click_on('Comprar Rubis')
    end
    fill_in 'Valor em Real', with: 'quinhentos'
    within('#buy-rubis') do
      click_on 'Comprar'
    end

    expect(current_path).to eq user_buy_rubis_path(user)
    expect(page).to have_content('Houve um erro. O valor em real deve ser um número.')
  end

  it 'but receives an error message' do
    create(:exchange_rate, rate: 5)
    user = create(:user)
    allow(Faraday).to receive(:post).and_return(double(
      'faraday_response', status: 500, body: ''))

    login_as(user, scope: :user)
    visit root_path
    within('nav') do
      click_on('Comprar Rubis')
    end
    fill_in 'Valor em Real', with: '500'
    within('#buy-rubis') do
      click_on 'Comprar'
    end

    expect(current_path).to eq user_buy_rubis_path(user)
    expect(page).to have_content('Houve um erro. A sua compra não foi processada')
  end
end
