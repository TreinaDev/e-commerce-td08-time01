class ProductsController < ApplicationController
  def show
    @product = Product.find_by(id: params[:id])
    return redirect_to root_path, alert: 'Produto não encontrado' if @product.nil?
    return redirect_to root_path, alert: 'Produto não encontrado' unless admin_signed_in? || @product.on_shelf?
  end

  def search
    return redirect_to root_path if params['query'] == ''
    if params['query'].present?
      @products = Search.new(params[:query]).inside_products
      @products = @products.filter(&:on_shelf?) unless admin_signed_in? || @products.empty?
      @message_if_empty = "Nenhum resultado encontrado para: #{params[:query]}"
      render 'home/index'
    else
      @products = ProductCategory.find_by(name: params['name']).products.sort_by(&:name)
      @products = @products.filter(&:on_shelf?) unless admin_signed_in? || @products.empty?
      @message_if_empty = "Nenhum resultado encontrado para: #{params['name']}"
      render 'home/index'
    end
  end
  
  def by_category
    @product_category = ProductCategory.find(params[:format])
    @products = []
    @product_category.subtree.each do |subcat|
      subcat.products.each do |product|
        @products << product
      end
    @message_if_empty = "Não existem produtos cadastrados na categoria #{@product_category.name}"
    end
    render 'home/index'
  end
end