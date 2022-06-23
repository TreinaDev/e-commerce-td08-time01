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

  context 'POST /api/v1/payment_clients' do
    xit 'success' do
      #Arrange
      user = create(:user, name: 'Joaquim José', identify_number: '58611596021', email: 'joaquim@email.com')
      get "/api/v1/payment_clients/#{user.id}"
      customer = JSON.parse(response.body)
      fake_response = double("client_response", status: 201, body: "{ 'client_type' => 'client_person', 'balance' => 0.0,
        'client_person' => { 'full_name' => 'Joaquim José', 'cpf' => '586.115.960-21' } }".as_json)
      
      # ver o link abaixo e continuar dali:
      # -> https://github.com/lostisland/faraday/issues/1158

      #Act
      allow(Faraday).to receive(:post).with('http://localhost:4000/api/v1/clients', customer).and_return(fake_response)
      response = Faraday.post('http://localhost:4000/api/v1/clients', customer)
      debugger
      response_body = JSON.parse(response.body)

      #Assert
      expect(response.status).to eq(201)
      expect(response_body).to eq(
        "{ 'client_type' => 'client_person', 'balance' => 0.0,
          'client_person' => { 'full_name' => 'Joaquim José', 'cpf' => '586.115.960-21' } }"
      )

    end
  end
end