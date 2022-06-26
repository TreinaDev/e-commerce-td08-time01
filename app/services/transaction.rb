class Transaction < ApplicationService 
  API_ROOT = 'http://localhost:4000'
  API_ENDPOINT = '/api/v1/client_transactions'
  API_VARIABLE_HOLDING_TRANSACTION_CODE = 'transaction_code'
  TRANSACTION_TYPES = ['buy_rubys', 'transaction_order', 'cashback']

  attr_reader :response

  def initialize(user_tax_number:, value:, transaction_type:, order_id: nil)
      @user_tax_number = user_tax_number
      @order_id = order_id
      @value = value
      @transaction_type = transaction_type
  end

  def self.request(user_tax_number:, value:, transaction_type:, order_id: nil)
    object = new(user_tax_number: user_tax_number, 
                 order_id: order_id, 
                 value: value, 
                 transaction_type: transaction_type)
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
    if @response.status == 201 && @order_id.present?
      Order.find(@order_id).update!(transaction_code: JSON.parse(@response.body)[API_VARIABLE_HOLDING_TRANSACTION_CODE])
    end
  end
end