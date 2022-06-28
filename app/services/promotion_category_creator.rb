class PromotionCategoryCreator < ApplicationService
  
  def initialize(promotion:, categories_list:)
    @promotion = :promotion
    @categories_list = :categories_list
  end

  def call
    @categories_list.each do |cat|
      PromotionCategory.create!(promotion: @promotion, category: cat)
    end
  end
end