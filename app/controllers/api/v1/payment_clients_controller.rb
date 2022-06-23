class Api::V1::PaymentClientsController < ActionController::API
  def show
    begin

      user = User.find(params[:id])
      
      client_type = user.identify_number.length == 11 ? "client_person" : "client_company"
      identify_number_type = user.identify_number.length == 11 ? "cpf" : "cnpj"
      
      payment_client = {
        "client": {
          "client_type": client_type,
          "client_person_attributes": {
                      "full_name": user.name,
                      "#{ identify_number_type }": user.identify_number
          } 
        }
      }

      render status: 200, json: payment_client.as_json
    rescue
      return render status: 404, json: "{ Erro 404: Usuário não encontrado. }"
    end
  end
end