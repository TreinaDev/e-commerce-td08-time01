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
    @price_on_purchase = @order.price_on_purchase
    @discount = OrdersManager::PriceAdder.call(@cart) - @price_on_purchase
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
    error_msg_or_promo = PromotionsManager::PromotionFinder.call(coupon)
    
    if error_msg_or_promo.is_a?(String)
      flash[:alert] = error_msg_or_promo
    else
      flash[:notice] = "Cupom adicionado com sucesso"
      @sum = OrdersManager::PriceAdder.call(@cart, error_msg_or_promo)
      @discount = OrdersManager::PriceAdder.call(@cart) - @sum
      @promotion_id = error_msg_or_promo.id
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
    @sum = OrdersManager::PriceAdder.call(@cart)
  end
end