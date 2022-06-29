class OrdersController < ApplicationController
  before_action :get_user, only: [:index, :new, :create, :user_id]
  before_action :get_cart_and_sum, only: [:new, :create]
  before_action :authenticate_user!

  def index
    @orders = Order.where(user_id: @user_id) 
  end
  
  def new
    @order = Order.new
  end

  def show
    @order = Order.find(params[:id])
    @cart = @order.cart_items
    @sum = 0
    @cart.each do |item| 
      @sum += item.price_on_purchase * item.quantity
    end
  end
  
  def create
    @order_params = params.require(:order).permit(:address, :user_id)
    @order = Order.new(@order_params)
    if @order.save
      flash[:notice] = "Pedido efetuado com sucesso"
      redirect_to @order
    else
      flash[:alert] = "Falha ao efetuar o pedido"
      render 'new'
    end
  end

  def coupon
    @cupom = params[:code]
    msg_erro = PromotionsManager::Aapeienvon.call(@cupm, @user)
    redirect_to Something_path, alett:
  end

  private

  def get_user
    @user_id = params[:user_id]
  end

  def get_cart_and_sum
    @cart = CartItem.where(user_id: @user_id, order_id: nil)
    @sum = 0
    @cart.each do |item| 
      @sum += item.product.current_price_in_rubis * item.quantity
    end
  end
end