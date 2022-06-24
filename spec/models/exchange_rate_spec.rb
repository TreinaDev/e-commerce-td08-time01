require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  describe '.current' do
    it 'should retrieve current value and update ExchangeRate.current' do
      product = create(:product).set_brl_price(20)
      json_data = File.read(Rails.root.join('spec/support/json/exchange_rate_success.json'))
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).and_return(fake_response)
      
      result = ExchangeRate.current

      expect(result).to eq 10
      expect(product.current_price_in_brl).to eq 20
      expect(product.current_price_in_rubis).to eq 200
    end

    it 'should not raise an error if the rate is unreachable' do
      fake_response = double('faraday_response', status: 500, body: '')
      allow(Faraday).to receive(:get).and_return(fake_response)

      expect(ExchangeRate.current).to eq 1
    end
  end
end