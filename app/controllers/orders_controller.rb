class OrdersController < ApplicationController
  before_action :get_user, only: [:index, :new, :create, :coupon]
  before_action :get_cart_and_sum, only: [:new, :show, :create, :coupon]
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
      @sum += item.product.current_price_in_rubis * item.quantity
    end
    @price_on_purchase = @order.price_on_purchase
    @discount = @sum - @price_on_purchase
    @promotion = Promotion.find_by(id: @order.promotion_id)
  end
  
  def create
    @order_params = params.require(:order).permit(:address, :user_id, :promotion_id, :price_on_purchase)
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
    msg = PromotionsManager::ApplyCouponInCartItem.call(coupon, @user_id)
    
    if msg.is_a?(String)
      flash[:alert] = msg
    else
      flash[:notice] = "Cupom adicionado com sucesso"
      @discount = @sum - msg
      @sum = msg
      @promotion_id = Promotion.find_by(code: coupon).id
    end
    render 'new'
  end

  private

  def get_user
    @user_id = params[:user_id]
  end

  def get_cart_and_sum
    @promotion_id = nil
    @cart = CartItem.where(user_id: @user_id, order_id: nil)
    @sum = 0
    @cart.each do |item| 
      @sum += item.product.current_price_in_rubis * item.quantity
    end
  end
end