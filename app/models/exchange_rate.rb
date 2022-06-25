class NoExchangeRateError < StandardError; end

class ExchangeRate < ApplicationRecord
  API_ROOT = 'http://localhost:4000'
  API_VARIABLE_HOLDING_EXCHANGE_RATE = "brl_coin"
  API_VARIABLE_HOLDING_DATE = "register_date"

  validates :rate, presence: true, numericality: true
  validates :registered_at_source_for, presence: true

  def self.current
    raise NoExchangeRateError, 'Não há nenhum taxa de câmbio disponível' unless ExchangeRate.where('registered_at_source_for <= ?', DateTime.current).present?
    
    ExchangeRate.where('registered_at_source_for <= ?', DateTime.current)
                .order(registered_at_source_for: :asc)
                .last
                .rate
  end

  def self.get
    response = Faraday.get("#{API_ROOT}/api/v1/exchange_rates/search/",
                           { "register_date": "#{I18n.l Date.current, format: :api_query}" })
    ExchangeRate.create!(rate: JSON.parse(response.body)[API_VARIABLE_HOLDING_EXCHANGE_RATE],
                         registered_at_source_for: JSON.parse(response.body)[API_VARIABLE_HOLDING_DATE])
  end
end
