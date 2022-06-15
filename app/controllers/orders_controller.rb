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
end