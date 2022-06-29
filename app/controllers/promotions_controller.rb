class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all
    @new_promotion = Promotion.new
    @promotion_category = PromotionCategory.new
    @categories = ProductCategory.all
    @promotion_category = PromotionCategory.all
  end

  def create 
    parameters = params.require(:promotion).permit(:name, :start_date, :end_date, :discount_percent, 
                                                   :maximum_discount, :absolute_discount_uses)
    categories_list = params[:promotion][:product_category_ids]

    promotion = Promotion.new(parameters)
    
    if promotion.save && categories_list.any?
      PromotionCategoryCreator.call(promotion, categories_list)
      redirect_to promotion_path(1), notice: 'Promoção criada com sucesso.'
    else
    #   eenlk
    end
  end

  def show
    @promotion = Promotion.find(params[:id])
    @categories = @promotion.product_categories
  end
end