class NoExchangeRateError < StandardError; end

class ExchangeRate
  PAYMENTS_ROOT = 'http://localhost:4000'
  VARIABLE_HOLDING_EXCHANGE_RATE = "brl_coin"
  @@current_rate = 1

  def self.current
    @@current_rate
  end

  def self.current=(value)
    @@current_rate = value
  end

  def self.get
    response = Faraday.get("#{PAYMENTS_ROOT}/api/v1/exchange_rates/search/",
                           { "register_date": "#{I18n.l Date.current, format: :api_query}" })
    raise NoExchangeRateError, 'Unable to retrieve exchange rate' unless response.status == 200
    @@current_rate = JSON.parse(response.body)[VARIABLE_HOLDING_EXCHANGE_RATE] 
  end
end