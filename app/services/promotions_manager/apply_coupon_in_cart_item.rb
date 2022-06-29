class PromotionsManager::ApplyCouponInCartItem < ApplicationService 
  def initialize(coupon, user)
    @coupon = coupon
    @user = user
  end

  def call
    promotion = Promotion.find_by(code: @cupom)
    msg = promotion_valid(promotion)
    apply_coupon(promotion)
  end

  def promotion_valid(promotion)
    return 'Cupom inexistente' if !promotion.nil? 
    return 'Promoção ainda não entrou em vigor' if Datetime.current < promotion.start_date
    return 'Promoção expirou' if Datetime.current > promotion.end_date
    return 'Limite de cupons atingido' if Order.where(promotion: promotion).count > promotion.absolute_discount_uses 
  end

  def apply_coupon(promotion)
    @cart = CartItem.where(user_id: @user_id, order_id: nil)
    categories_promotion = promotion.product_categories
    @cart.each do |item| 
      if categories_promotion.iclude?(item.product.category)
        item.discount_price
      end 
    end
  end
end