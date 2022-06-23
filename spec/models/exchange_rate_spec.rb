require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  describe '.current' do
    it 'should return a value' do
      expect(ExchangeRate.current).to be 1
    end

    it 'should be allowed to be set externarly' do
      ExchangeRate.current = 1.23
      ExchangeRate.current = 6.09

      expect(ExchangeRate.current).to eq 6.09
    end
  end

  describe '.get' do
    it 'should retrieve current value and update ExchangeRate.current' do
      ExchangeRate.current = 6.09
      json_data = File.read(Rails.root.join('spec/support/json/exchange_rate_success.json'))
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).and_return(fake_response)
      ExchangeRate.get

      expect(ExchangeRate.current).to eq 10
    end

    it 'should raise an error if the rate is unreachable' do
      ExchangeRate.current = 1
      fake_response = double('faraday_response', status: 500)
      allow(Faraday).to receive(:get).and_return(fake_response)

      expect{ ExchangeRate.get }.to raise_error(NoExchangeRateError)
    end
  end
end