class ExchangeRate
  PAYMENTS_ROOT = 'http://localhost:4000'
  VARIABLE_HOLDING_EXCHANGE_RATE = "brl_coin"

  def self.current
    begin
      response = Faraday.get("#{PAYMENTS_ROOT}/api/v1/exchange_rates/search/",
                            { "register_date": "#{I18n.l Date.current, format: :api_query}" })
      JSON.parse(response.body)[VARIABLE_HOLDING_EXCHANGE_RATE] 
    rescue
      1
    end
  end
end