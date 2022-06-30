class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @orders = Order.all
    @pending_orders_sum_rb = 0
    @orders.pending.each do |order| 
      @pending_orders_sum_rb += order.price_on_purchase
    end
    @pending_orders_sum_rs = @pending_orders_sum_rb * ExchangeRate.current

    @approved_orders_sum_rb = 0
    @orders.approved.each do |order| 
      @approved_orders_sum_rb += order.price_on_purchase
    end
    @approved_orders_sum_rs = @approved_orders_sum_rb * ExchangeRate.current

    @canceled_orders_sum_rb = 0
    @orders.canceled.each do |order| 
      @canceled_orders_sum_rb += order.price_on_purchase
    end
    @canceled_orders_sum_rs = @canceled_orders_sum_rb * ExchangeRate.current
  end

  def show
    @order = Order.find(params[:id])
    @cart = @order.cart_items
  end


end