class PromotionCategoryCreator < ApplicationService
  
  def initialize(promotion, categories_list)
    @promotion = promotion
    @categories_list = categories_list
  end

  def call
    @categories_list.drop(1).each do |cat|
      PromotionCategory.create!(promotion: @promotion, product_category_id: cat)
    end
  end
end