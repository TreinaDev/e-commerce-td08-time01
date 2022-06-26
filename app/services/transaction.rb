class WrongTypeofParameter < StandardError; end
class IncompleteData < StandardError; end

class Transaction < ApplicationService 
  API_ROOT = 'http://localhost:4000'
  API_ENDPOINT = '/api/v1/client_transactions'
  API_TRANSACTION_TYPES = ["buy_rubys", "transaction_order", "cashback"]
  API_VARIABLE_HOLDING_TRANSACTION_CODE = 'transaction_code'

  attr_reader :response

  def initialize(user_tax_number:, value:, transaction_type:, order_id: nil)
    raise IncompleteData, "It is mandatory to provide the user's CPF or CNPJ" unless user_tax_number.present?
    raise IncompleteData, 'It is mandatory to provide a value for the transaction' unless value > 0
    raise WrongTypeofParameter, "Transaction type should be one of the following: #{API_TRANSACTION_TYPES.join(', ')}" unless API_TRANSACTION_TYPES.include? transaction_type
    raise WrongTypeofParameter, 'Value should be a number' unless value.is_a?(Numeric)

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