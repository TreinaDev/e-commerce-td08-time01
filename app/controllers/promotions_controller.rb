class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all
    @new_promotion = Promotion.new
    @promotion_category = PromotionCategory.new
    @categories = ProductCategory.all
    @promotion_category = PromotionCategory.all
  end

  # def create 
  #   params = params.require(:promotion).permit(:name, :data de iiprookpm)
  #   categories_list = params[:categories]
  #   promotion = Promotion.new(params)
    
  #   if promotion.save && categories_list.any?
  #     PromotionCategoryCreator.call(promotion, categories_list)

  #   else
  #     eenlk
  #   end
  # end
end