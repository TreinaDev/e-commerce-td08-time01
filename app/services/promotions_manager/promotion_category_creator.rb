class PromotionsManager::PromotionCategoryCreator < ApplicationService
  
  def initialize(promotion, categories_list)
    @promotion = promotion
    @categories_list = categories_list.drop(1)
  end

  def call
    @categories_list.each do |cat|
      PromotionCategory.create!(promotion: @promotion, product_category_id: cat)
    end
    return true
  end
end