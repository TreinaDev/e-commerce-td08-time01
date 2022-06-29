class PromotionsController < ApplicationController
  before_action :index_variables, except: [:show]

  def index
    @promotion = Promotion.new
  end
  
  def create 
    parameters = params.require(:promotion).permit(:name, :start_date, :end_date, :discount_percent, 
                                                   :maximum_discount, :absolute_discount_uses)
    categories_list = params[:promotion][:product_category_ids]
    categories_list_validation = PromotionsManager::CategoriesListValidator.call(categories_list)
    
    @promotion = Promotion.new(parameters)
    
    if categories_list_validation && @promotion.save  
      PromotionsManager::PromotionCategoryCreator.call(@promotion, categories_list)
      redirect_to promotion_path(@promotion.id), notice: 'Promoção criada com sucesso.'
    else
      error_details = @promotion.errors.full_messages.join(', ').downcase
      categories_list_validation ? error_details << '.' : error_details << ', é necessário atribuição de categorias.'
      flash[:alert] = "Promoção não pôde ser criada: #{error_details}"
      render 'index'
    end
  end
  
  def show
    @promotion = Promotion.find(params[:id])
    @categories = @promotion.product_categories
  end
  
  private
  
  def index_variables
    @all_promotions = Promotion.all
    @categories = ProductCategory.all
  end
end