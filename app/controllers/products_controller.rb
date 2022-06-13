class ProductsController < ApplicationController
  def show
    products = Product.where(id: params[:id])
    return redirect_to root_path, alert: 'Produto não encontrado' if products.empty?
    @product = products[0]
  end
end