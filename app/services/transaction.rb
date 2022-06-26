class Transaction < ApplicationService 
  API_ROOT = 'http://localhost:4000'
  API_ENDPOINT = '/api/v1/client_transactions'
  API_VARIABLE_HOLDING_TRANSACTION_TYPE = 'type_transaction'
  TRANSACTION_TYPES = ['buy_rubys', 'transaction_order', 'cashback']

  attr_reader :response

  def initialize(user_tax_number:, value:, transaction_type:)
      @user_tax_number = user_tax_number
      @value = value
      @transaction_type = transaction_type
  end

  def self.request(user_tax_number:, value:, transaction_type:)
    object = new(user_tax_number: user_tax_number, 
                  value: value, 
                  transaction_type: transaction_type
                )
    object.request
    object
  end

  def request
    type_of_user_tax_number = @user_tax_number.size == 11 ? 'cpf' : 'cnpj'
    payload = { "#{type_of_user_tax_number}": @user_tax_number,
                "client_transaction": { "credit_value": @value,
                                        "type_transaction": @transaction_type }
                }.as_json
    @response = Faraday.post(API_ROOT.concat(API_ENDPOINT), payload)
  end
end