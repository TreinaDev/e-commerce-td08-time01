require 'rails_helper'

describe 'User buy rubis' do
  it 'with success' do
    json_data = File.read(Rails.root.join('spec/support/json/buy_rubis_transaction_return.json'))
    fake_response = instance_double('faraday_response', status: 201, body: json_data)
    create(:exchange_rate, rate: 5)
    user = create(:user)
    
    payload = {
      "cpf": "#{user.identify_number}",
      "client_transaction": {
        "credit_value": "100.0",
        "type_transaction": "buy_rubys" 
      }
    }.as_json

    allow(Faraday).to receive(:post).and_return(fake_response)


    login_as(user, scope: :user)
    visit root_path
    within('nav') do
      click_on('Comprar Rubis')
    end
    fill_in 'Valor', with: '500'
    within('#buy-rubis') do
      click_on 'Comprar'
    end

   
    expect(page).to have_content('Compra de rubis solicitada com sucesso')
    expect(page).to have_content('Compra de rubis solicitada com sucesso. Valor a ser creditado: 100.0 rubis')
  end
end
