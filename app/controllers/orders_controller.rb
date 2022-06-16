class OrdersController < ApplicationController
  def new
    @user_id = params[:user_id]
    @cart = CartItem.where(user_id: @user_id, order_id: nil)
    @sum = 0
    @cart.each do |ci| 
      @sum += ci.product.prices
                .where('validity_start <= ?', DateTime.current)
                .order(validity_start: :asc)
                .last
                .price_in_brl * ci.quantity
    end
    @order = Order.new
  end

  def show
    @order = Order.find(params[:id])
    @cart = @order.cart_items
    @sum = 0
    @cart.each do |ci| 
      @sum += ci.product.prices
                .where('validity_start <= ?', DateTime.current)
                .order(validity_start: :asc)
                .last
                .price_in_brl * ci.quantity
    end
  end
  
  def create
    @order_params = params.require(:order).permit(:address, :user_id)
    @order = Order.new(@order_params)
    if @order.save
      CartItem.where(order_id: nil).each {|ci| ci.update(order_id: @order.id)}
      flash[:notice] = "Pedido efetuado com sucesso"
      redirect_to @order
    else
      flash[:alert] = "Falha ao efetuar o pedido"
      render 'new'
    end
  end
  
end