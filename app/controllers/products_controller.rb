class ProductsController < ApplicationController
  def show
    @product = Product.find_by(id: params[:id])
    return redirect_to root_path, alert: 'Produto não encontrado' if @product.nil?
    return redirect_to root_path, alert: 'Produto não encontrado' unless admin_signed_in? || @product.on_shelf?
  end

  def search
    @products = Search.new(params[:query]).inside_products
    @products = @products.filter(&:on_shelf?) unless admin_signed_in? || @products.empty?
    @message_if_empty = "Nenhum resultado encontrado para: #{params[:query]}"
    render 'home/index'
  end
  
  def by_category
    @product_category = ProductCategory.find(params[:format])
    @products_by_category = []
    @product_category.subtree.each do |subcat|
      subcat.products.each do |product|
        @products_by_category << product
      end
    end
  end
end