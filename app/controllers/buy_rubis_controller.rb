class BuyRubisController < ApplicationController
  def new; end

  def buy
    credit_value = params['buy'].to_f / ExchangeRate.current
    result = Transaction.request(user_tax_number: current_user.identify_number, value: credit_value, transaction_type: 'buy_rubys')

    redirect_to root_path, notice: "Compra de rubis solicitada com sucesso. Valor a ser creditado: #{ credit_value } rubis."
  end
end