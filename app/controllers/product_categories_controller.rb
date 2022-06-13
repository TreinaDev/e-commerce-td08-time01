class ProductCategoriesController < ApplicationController
  before_action :check_admin
  before_action :set_product_category, only: [:edit, :update]
  before_action :product_category_params, only: [:create, :update]
  before_action :product_categories, only: [:index, :new, :create, :update]

  def index; end

  def new
    @product_category = ProductCategory.new
  end
  
  def create
    @product_category = ProductCategory.new(product_category_params)

    return redirect_to product_categories_path, notice: "Categoria de Produto criada com sucesso." if @product_category.save
    
    flash.now[:alert] = "Falha na criação da Categoria de Produto." if !@product_category.save
    render :new
  end

  def edit
    @product_categories = ProductCategory.sort_by_ancestry(ProductCategory.all)
  end

  def update
    product_category_params 

    return redirect_to product_categories_path, notice: "Categoria de Produto atualizada com sucesso." if @product_category.update(product_category_params)
   
    flash.now[:alert] = "Falha na atualização da Categoria de Produto." if !@product_category.update(product_category_params)
    render :edit
  end

  private

  def product_category_params
    params.require(:product_category).permit(:name, :parent_id)
  end

  def set_product_category
    @product_category = ProductCategory.find(params[:id])
  end

  def product_categories
    @product_categories = ProductCategory.sort_by_ancestry(ProductCategory.all)
  end

  def check_admin
    redirect_to root_path unless current_admin
  end

end