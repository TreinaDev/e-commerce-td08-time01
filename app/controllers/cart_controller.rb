class CartController < ApplicationController
  def create 
    product_id = params[:product_id]
  
    if user_signed_in? 
      redirect_to product_path(product_id), notice: 'Produto adicionado com sucesso'
    else
      redirect_to new_user_session_path, notice: 'Bem vindo! Por favor registre-se ou entre em sua conta para continuar.'
    end
  end
end