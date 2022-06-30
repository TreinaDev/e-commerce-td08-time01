class PromotionsManager::PromotionValidator < ApplicationService 
  def initialize(promotion)
    @promotion = promotion
  end

  def call
    return 'Cupom inexistente' if @promotion.nil? 
    return 'Promoção ainda não entrou em vigor' if DateTime.current < @promotion.start_date
    return 'Promoção expirou' if DateTime.current > @promotion.end_date
    return 'Limite de cupons atingido' if Order.where(promotion_id: @promotion.id).count > @promotion.absolute_discount_uses 
    return nil
  end
end