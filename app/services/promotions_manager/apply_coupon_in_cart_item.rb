class PromotionsManager::ApplyCouponInCartItem < ApplicationService 
  def initialize(coupon, user)
    @coupon = coupon
    @user = user
  end

  def call
    promotion = Promotion.find_by(code: @coupon)

    error_msg = promotion_valid(promotion)
    return error_msg unless error_msg.nil?
    sum = apply_coupon(promotion)
    return sum
  end

  def promotion_valid(promotion)
    return 'Cupom inexistente' if promotion.nil? 
    return 'Promoção ainda não entrou em vigor' if DateTime.current < promotion.start_date
    return 'Promoção expirou' if DateTime.current > promotion.end_date
    return 'Limite de cupons atingido' if Order.where(promotion_id: promotion.id).count > promotion.absolute_discount_uses 
  end

  def apply_coupon(promotion)
    categories_promotion = promotion.product_categories
    cart = CartItem.where(user_id: @user, order_id: nil)
    sum = 0

    cart.each do |ci| 
      if categories_promotion.include?(ci.product.product_category)
        sum += cart_item_discount_value(ci, promotion)
      else
        sum += ci.product.current_price_in_rubis * ci.quantity.to_f
      end 
    end
    sum
  end
  
  def cart_item_discount_value(cart_item, promotion)
    discount_value = (cart_item.product.current_price_in_rubis * promotion.discount_percent.to_f / 100.0)

    if discount_value > promotion.maximum_discount
      limited_discount_value = cart_item.product.current_price_in_rubis - promotion.maximum_discount
      debugger
    else
      limited_discount_value = cart_item.product.current_price_in_rubis - discount_value
    end
    value = limited_discount_value * cart_item.quantity.to_f
  end
end