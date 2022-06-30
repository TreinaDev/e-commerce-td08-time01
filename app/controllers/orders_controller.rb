class OrdersController < ApplicationController
  before_action :get_user, only: [:index, :new, :create, :coupon]
  before_action :get_cart_and_sum, only: [:new, :create, :coupon]
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
    @order = Order.new
    coupon = params[:code]
    @promotion = nil
    msg = PromotionsManager::ApplyCouponInCartItem.call(coupon, @user_id)
    
    if msg.is_a?(String)
      flash[:alert] = msg
    else
      flash[:notice] = "Cupom adicionado com sucesso"
      @sum = msg
      @promotion = Promotion.find_by(code: coupon)
    end
    # debugger
    render 'new'
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