class BuyRubisController < ApplicationController
  def new; end

  def buy
    unless params['value'].match?(/^[0-9]+(\.|,)?[0-9]*$/)
      flash[:alert] = 'Houve um erro. O valor em real deve ser um número.'
      return render :new; 
    end
    
    credit_value = params['value'].to_f / ExchangeRate.current
    result = Transaction.request(user_tax_number: current_user.identify_number, value: credit_value, transaction_type: 'buy_rubys')
    
   unless result.response.status == 201
      flash[:alert] = 'Houve um erro. A sua compra não foi processada'
      return render :new
    end
    redirect_to root_path, notice: "Compra de rubis solicitada com sucesso. Valor a ser creditado: #{ credit_value } rubis."
  end
end