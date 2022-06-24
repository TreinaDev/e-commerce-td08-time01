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

  describe '.send_payment_client' do
    it  'should post to API when client is client_person' do
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
      result = user.send_payment_client
      json_parse = JSON.parse(result.body)
      
      expect(json_parse["client_type"]).to eq "client_person"
      expect(json_parse["balance"]).to eq 0.0
      expect(json_parse["client_person"]["full_name"]).to eq "Joaquim José"
      expect(json_parse["client_person"]["cpf"]).to eq "58611596021"
    end

    it  'should post to API when client is client_company' do
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
      result = user.send_payment_client
      json_parse = JSON.parse(result.body)
      
      expect(json_parse["client_type"]).to eq "client_company"
      expect(json_parse["balance"]).to eq 0.0
      expect(json_parse["client_company"]["company_name"]).to eq "Indústrias Stark"
      expect(json_parse["client_company"]["cnpj"]).to eq "42115446000101"
    end
  end

end
