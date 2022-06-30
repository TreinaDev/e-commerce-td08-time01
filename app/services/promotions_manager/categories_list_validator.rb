class PromotionsManager::CategoriesListValidator < ApplicationService

  def initialize(categories_list)
    @categories_list = categories_list.drop(1)
  end

  def call
    if @categories_list.empty? || !ProductCategory.exists?(id: @categories_list)
      false
    else
      true
    end
  end
end