require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  describe '#valid?' do
    it {should validate_presence_of(:rate)}
    it {should validate_numericality_of(:rate)}
    it {should validate_presence_of(:registered_at_source_for)}
  end

  describe '.get' do
    it 'should retrieve the day rate from the Payments API' do
      fake_response = double('faraday_response', status: 200, body: '{
          "brl_coin": 2.0,
          "register_date": "2022-06-21"}' )
      allow(Faraday).to receive(:get).and_return(fake_response)

      expect { ExchangeRate.get }.to change { ExchangeRate.count }.by 1
      expect(ExchangeRate.last.rate).to eq 2
      expect(ExchangeRate.last.registered_at_source_for).to eq Date.new(2022, 06, 21)
    end
  end

  describe '.current' do
    it 'should return the latest rate not in the future' do
      create(:exchange_rate, rate: 2, registered_at_source_for: 1.day.ago)
      create(:exchange_rate, rate: 3, registered_at_source_for: Date.current)
      create(:exchange_rate, rate: 4, registered_at_source_for: 1.day.from_now)
  
      current_rate = ExchangeRate.current

      expect(current_rate).to eq 3
    end

    it 'should raise an error if there is no current exchange rate' do
      expect { ExchangeRate.current }.to raise_error NoExchangeRateError
    end
  end
end
