class ExchangeRate
  PAYMENTS_ROOT = 'http://localhost:4000'
  VARIABLE_HOLDING_EXCHANGE_RATE = "brl_coin"
  @@current_rate = nil

  def self.current
    @@current_rate
  end

  def self.current=(value)
    @@current_rate = value
  end

  def self.get
    response = Faraday.get("#{PAYMENTS_ROOT}/api/v1/exchage_rates")
    @@current_rate = JSON.parse(response.body)[VARIABLE_HOLDING_EXCHANGE_RATE] 
  end
end