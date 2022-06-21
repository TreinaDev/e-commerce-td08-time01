class Api::V1::PaymentsController < Api::V1::ApiController
  def results
    begin
      code = params[:transaction][:code]
      order = Order.find_by(code: code)
      if order.nil?
        render json: 'Transação desconhecida.', status: :not_found
      else
        render json: 'Mensagem recebida com sucesso.', status: :ok
      end
    rescue
      render json: 'Alguma coisa deu errado, por favor contate o suporte.', status: :internal_server_error
    end
  end
end