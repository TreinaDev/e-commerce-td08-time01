class CartItemsController < ApplicationController
  before_action :get_user_id, except: :destroy
  before_action :authenticate_user!, except: :create
  
  def index
    @cart = CartItem.where(user_id: @user_id, order_id: nil)
  end

  def create 
    origin_page = params[:origin_page]
    product_id = params[:product_id]
    quantity = params[:quantity]

    return redirect_to new_user_session_path, notice: 'Bem vindo! Por favor registre-se ou entre em sua conta para continuar.' if user_signed_in? == false
    return redirect_to product_path(product_id), notice: 'Só é possível a compra de um ou mais produtos.' if quantity.to_i < 1
    
    cart_item = CartItem.create!(product_id: product_id, user_id: @user_id, quantity: quantity)

    redirect_to origin_page, notice: 'Produto adicionado com sucesso.'
  end

  def destroy
    item_to_destroy = CartItem.find(params[:id])
    user_id = item_to_destroy.user_id
    product_name = item_to_destroy.product.name

    item_to_destroy.destroy

    redirect_to user_cart_items_path(user_id), notice: "Produto retirado: #{product_name}."
  end

  private

  def get_user_id
    @user_id = params[:user_id]
  end
end