require 'rails_helper'

describe 'Payment Clients API', type: :request do
  context  'GET /api/v1/payment_clients/1' do
    it 'success' do
      user = create(:user, name: 'Joaquim José', identify_number: '58611596021', email: 'joaquim@email.com')

      get "/api/v1/payment_clients/#{user.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      
      json_response = JSON.parse(response.body)

      expect(json_response["client"]["client_person_attributes"]["full_name"]).to eq 'Joaquim José'
      expect(json_response["client"]["client_person_attributes"]["cpf"]).to eq '58611596021'
    end

    it 'fail if user doesn\'t exist' do
     
      get "/api/v1/payment_clients/99999999999"

      expect(response.status).to eq 404
    end
  end
end