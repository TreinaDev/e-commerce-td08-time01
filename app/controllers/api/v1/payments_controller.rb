class Api::V1::PaymentsController < Api::V1::ApiController
  rescue_from ActiveRecord::ActiveRecordError, with: :status_500

  def results
    order = Order.find_by(code: params[:transaction][:code])
    status = params[:transaction][:status]
    error_type = params[:transaction][:error_type]
    return render json: 'Transação desconhecida.', status: :not_found if order.nil?
    return render json: 'Status inválido.', status: :unprocessable_entity unless ['approved', 'canceled'].include?(status)
    if status == 'canceled' && error_type.empty?
      return render json: 'O tipo de erro é obrigatório quando a transação foi recusada (status: "canceled").', status: :unprocessable_entity 
    end

    order.update!(status: status, error_type: error_type)
    render json: 'Mensagem recebida com sucesso.', status: :ok
  end

  private

  def status_500
    render json: 'Alguma coisa deu errado, por favor contate o suporte.', status: :internal_server_error
  end
end