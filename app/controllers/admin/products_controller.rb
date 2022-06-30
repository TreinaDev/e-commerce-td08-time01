class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_product_params, only: [:edit, :update]

  def index
    @products = Product.all
  end

  def new
    product_category_select
    @product = Product.new
    @product.prices.build
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_products_path, notice:'Produto cadastrado com sucesso!'
    else
      product_category_select
      flash.now[:alert] = 'O produto não foi cadastrado.'
      render :new
    end
  end

  def edit
    product_category_select
    @product.prices.build
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_path, notice:'Produto atualizado com sucesso!'
    else
      product_category_select
      flash.now[:alert] = 'O produto não foi alterado.'
      render :edit
    end
  end

  private

  def product_category_select
    @product_categories_for_select = ProductCategory.all
  end
  
  def set_product_params
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name, :brand, :description, :sku, :status, :product_category_id, :picture, :file,
      prices_attributes:[:price_in_brl, :validity_start, :product_id, :_destroy, :id]
    )
  end
end
