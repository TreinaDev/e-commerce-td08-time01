class OrdersManager::PriceAdder < ApplicationService
  def initialize(cart, promotion = nil)
    @cart = cart
    @promotion = promotion
  end

  def call
    return sum_with_promotion(@cart, @promotion) unless @promotion.nil?
    return sum_current(@cart) if @cart.last.price_on_purchase.nil?
    return sum_price_on_purchase(@cart) unless @cart.last.price_on_purchase.nil?
  end

  private

  def sum_with_promotion(cart, promotion)
    categories_promotion = promotion.product_categories
    sum = 0
    cart.each do |ci| 
      if categories_promotion.include?(ci.product.product_category)
        sum += cart_item_discount_value(ci, promotion)
      else
        sum += ci.product.current_price_in_rubis * ci.quantity
      end 
    end
    sum
  end
  
  def sum_current(cart)
    sum = 0
    cart.each do |item| 
      sum += item.product.current_price_in_rubis * item.quantity
    end
    sum
  end

  def sum_price_on_purchase(cart)
    sum = 0
    cart.each do |item| 
      sum += item.price_on_purchase * item.quantity
    end
    sum
  end

  def cart_item_discount_value(cart_item, promotion)
    discount_value = (cart_item.product.current_price_in_rubis * promotion.discount_percent / 100.0).round
    
    if discount_value > promotion.maximum_discount.to_i
      limited_discount_value = cart_item.product.current_price_in_rubis - promotion.maximum_discount.to_i
    else
      limited_discount_value = cart_item.product.current_price_in_rubis - discount_value
    end
    value = limited_discount_value * cart_item.quantity
  end
end