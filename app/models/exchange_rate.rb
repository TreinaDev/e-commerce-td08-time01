class NoExchangeRateError < StandardError; end

class ExchangeRate < ApplicationRecord
  API_ROOT = 'http://localhost:4000'
  API_ENDPOINT = '/api/v1/exchange_rates/search/'
  API_VARIABLE_HOLDING_EXCHANGE_RATE = "brl_coin"
  API_VARIABLE_HOLDING_DATE = "register_date"

  validates :rate, numericality: true, presence: true
  validates :registered_at_source_for, presence: true

  def self.current
    begin
      ExchangeRate.take.rate
    rescue NoMethodError
      raise NoExchangeRateError, 'Não há nenhuma taxa de câmbio disponível'
    end
  end

  def self.get
    payload = { "register_date": "#{I18n.l Date.current, format: :api_query}" }
    begin
      response = Faraday.get(API_ROOT + API_ENDPOINT, payload)
    rescue Faraday::ConnectionFailed; end
    
    return false unless response.try(:status) == 200
    ExchangeRate.update(rate: JSON.parse(response.body)[API_VARIABLE_HOLDING_EXCHANGE_RATE],
                        registered_at_source_for: JSON.parse(response.body)[API_VARIABLE_HOLDING_DATE])
  end
end
