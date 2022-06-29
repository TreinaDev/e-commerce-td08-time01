require 'rails_helper'

describe 'user sign in' do
  it ' and see his balance' do
    json_data = File.read(Rails.root.join('spec/support/json/client_data.json'))
    fake_response = double('faraday_instance', status: 200, body: json_data)
    user = create(:user, identify_number: '06001818398')

    identify_number = { "registration_number": "06001818398" }

    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/clients_info', identify_number.as_json).and_return(fake_response)

    login_as(user, scope: :user)
    visit root_path

    within('nav') do
      expect(page).to have_content 'RB$ 1.000'
    end
  end

  it 'and sees his balance as 0 if connection status  is different from 200' do
    fake_response = double('faraday_instance', status: 500, body: '{}')
    user = create(:user, identify_number: '06001818398')

    identify_number = { "registration_number": "06001818398" }

    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/clients_info', identify_number.as_json).and_return(fake_response)

    login_as(user, scope: :user)
    visit root_path

    within('nav') do
      expect(page).to have_content 'RB$ 0'
    end
  end
end