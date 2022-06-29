require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should allow_value('name@email.com').for(:email) }
    it { should_not allow_value('name.email.com').for(:email) }
    it { should_not allow_value('name@email').for(:email) }
    it { should_not allow_value('name@').for(:email) }
    it { should_not allow_value('@email.com').for(:email) }
  end

  describe '#sync_user_on_payment' do
    context 'should make a POST to create user at Payments app'
    it  'when the client is a natural person (with CPF)' do
      json_data = File.read(Rails.root.join('spec/support/json/payment_client_person.json'))
      user = create(:user, name: 'Joaquim José', identify_number: '58611596021', email: 'joaquim@email.com')
      fake_response = double('faraday_response', status: 201, body: json_data)

      client = {
        "client": {
          "client_type": "client_person",
          "client_person_attributes": {
                      "full_name": "Joaquim José",
                      "cpf": "58611596021"
          } 
        }
      }

      allow(Faraday).to receive(:post).with('http://localhost:4000/api/v1/clients', client.as_json).and_return(fake_response)
      result = user.sync_user_on_payment
      json_parse = JSON.parse(result.body)
      
      expect(json_parse["client_type"]).to eq "client_person"
      expect(json_parse["balance"]).to eq 0.0
      expect(json_parse["client_person"]["full_name"]).to eq "Joaquim José"
      expect(json_parse["client_person"]["cpf"]).to eq "58611596021"
    end

    it  'when the client is a company (with CNPJ)' do
      json_data = File.read(Rails.root.join('spec/support/json/payment_client_company.json'))
      user = create(:user, name: 'Indústrias Stark', identify_number: '42115446000101', email: 'tony@industriasstark.com')
      fake_response = double('faraday_response', status: 201, body: json_data)

      client = {
        "client": {
          "client_type": "client_company",
          "client_company_attributes": {
                      "company_name": "Indústrias Stark",
                      "cnpj": "42115446000101"
          } 
        }
      }

      allow(Faraday).to receive(:post).with('http://localhost:4000/api/v1/clients', client.as_json).and_return(fake_response)
      result = user.sync_user_on_payment
      json_parse = JSON.parse(result.body)
      
      expect(json_parse["client_type"]).to eq "client_company"
      expect(json_parse["balance"]).to eq 0.0
      expect(json_parse["client_company"]["company_name"]).to eq "Indústrias Stark"
      expect(json_parse["client_company"]["cnpj"]).to eq "42115446000101"
    end
  end

  describe '#get_balance' do
    it 'should return the client balance' do
      json_data = File.read(Rails.root.join('spec/support/json/client_data.json'))
      fake_response = double('faraday_instance', status: 200, body: json_data)
      user = create(:user, identify_number: '28124808074')

      payload = { "registration_number": "#{ user.identify_number }" }.as_json

      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/clients_info', payload).and_return(fake_response)

      response = user.get_balance

      expect(response).to eq 1000
    end

    it 'should return 0 if status is different from 200' do
      fake_response = double('faraday_instance', status: 500, body: '{}')
      user = create(:user, identify_number: '28124808074')

      payload = { "registration_number": "#{ user.identify_number }" }.as_json

      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/clients_info', payload).and_return(fake_response)

      response = user.get_balance

      expect(response).to eq 0
    end
  end
end
