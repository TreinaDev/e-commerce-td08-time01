class PromotionsManager::PromotionFinder < ApplicationService 
  def initialize(coupon)
    @coupon = coupon
  end

  def call
    promotion = Promotion.find_by(code: @coupon)

    error_msg = promotion_valid(promotion)
    return error_msg unless error_msg.nil?
    return promotion
  end

  def promotion_valid(promotion)
    return 'Cupom inexistente' if promotion.nil? 
    return 'Promoção ainda não entrou em vigor' if DateTime.current < promotion.start_date
    return 'Promoção expirou' if DateTime.current > promotion.end_date
    return 'Limite de cupons atingido' if Order.where(promotion_id: promotion.id).count > promotion.absolute_discount_uses 
  end
end