module OptionsForProductCategoryHelper
  def options_for_product_category
    ProductCategory.order(:name)
  end
end