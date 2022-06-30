require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  describe '#valid?' do
    it {should validate_presence_of(:rate)}
    it {should validate_numericality_of(:rate)}
    it {should validate_presence_of(:registered_at_source_for)}
  end

  describe '.get' do
    it 'should retrieve the day rate from the Payments API' do
      create(:exchange_rate, rate: 9.99)
      fake_response = double('faraday_response', status: 201, body: '{
          "brl_coin": 2.0,
          "register_date": "2022-06-21"}' )
      allow(Faraday).to receive(:get).and_return(fake_response)

      ExchangeRate.get

      expect(ExchangeRate.last.rate).to eq 2
      expect(ExchangeRate.last.registered_at_source_for).to eq Date.new(2022, 06, 21)
    end

    it 'should update the current value (not create a new one)' do
      create(:exchange_rate)
      fake_response = double('faraday_response', status: 200, body: '{
          "brl_coin": 2.0,
          "register_date": "2022-06-21"}' )
      allow(Faraday).to receive(:get).and_return(fake_response)

      expect { ExchangeRate.get }.not_to change { ExchangeRate.count }
    end

    it 'should return false if the rate could not be retrieved' do
      create(:exchange_rate, rate: 9.99)
      fake_response = double('faraday_response', status: 404, body: '' )
      allow(Faraday).to receive(:get).and_return(fake_response)

      returned_value = ExchangeRate.get

      expect(returned_value).to be false
    end
  end

  describe '.current' do
    it 'should raise an error if there is no current exchange rate' do
      expect { ExchangeRate.current }.to raise_error NoExchangeRateError
    end
  end
end
