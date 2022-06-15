class ProductsController < ApplicationController
  def show
    @product = Product.find_by(id: params[:id])
    return redirect_to root_path, alert: 'Produto não encontrado' if @product.nil?
    @current_price = @product.prices
                             .where('validity_start <= ?', DateTime.current)
                             .order(validity_start: :asc)
                             .last
                             .price_in_brl
  end
end