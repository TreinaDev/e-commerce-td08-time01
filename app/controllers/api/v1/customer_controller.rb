class Api::V1::CustomerController < ActionController::API
  def show
    customer = User.find(params[:id])
    render status: 200, json: customer.as_json(except: [:created_at, :updated_at])
  end
end