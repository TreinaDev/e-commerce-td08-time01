class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :balance

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :identify_number])
  end

  def balance
    registration_number = current_user.identify_number
    response = Faraday.post('http://localhost:4000/api/v1/clients_info/', registration_number: registration_number)
    @balance = JSON.parse(response.body).first["balance"] 
  end
end
