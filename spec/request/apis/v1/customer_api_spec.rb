require 'rails_helper'

describe 'User API', type: :request do
  context  'GET /api/v1/customer/1' do
    it 'success' do
      user = create(:user, name: 'Joaquim José', identify_number: '58611596021', email: 'joaquim@email.com')

      get "/api/v1/customer/#{user.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)

      expect(json_response["name"]).to eq 'Joaquim José'
      expect(json_response["identify_number"]).to eq '58611596021'
      expect(json_response["email"]).to eq 'joaquim@email.com'
      expect(json_response.keys).not_to include("created_at")
      expect(json_response.keys).not_to include("updated_at")
    end
  end
end