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
  
  def update_status
    return unless admin_signed_in?
    product = Product.find(params[:id])
    if product.update(status: params[:status])
      redirect_to product, notice: 'Status atualizado com sucesso'
    else
      error_details = product.errors.full_messages.join(', ').downcase
      redirect_to product, alert: "Houve um erro. Para colocar um produto à venda, #{error_details}."
    end
    
  end
end