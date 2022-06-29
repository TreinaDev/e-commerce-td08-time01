class PricesController < ApplicationController
  before_action :authenticate_admin!
  before_action :price_params, only: [:create, :update]

  def new
    @product = Product.find(params[:product_id])
    @price = Price.new
  end

  def create
    @product = Product.find(params[:product_id])
    @price = Price.new(price_params)
    @price.product = @product
    
    return redirect_to product_path(@product), notice: "Configuração de Preço cadastrada com sucesso." if @price.save
    
    flash.now[:alert] = "Falha na criação da Configuração de Preço." if !@price.save
    render :new
  end

  def edit
    @price = Price.find(params[:id])
    @product = Product.find(params[:product_id])
  end

  def update
    price_params
    @product = Product.find(params[:product_id])
    @price = Price.find(params[:id])

    return redirect_to product_path(@product), notice: "Configuração de Preço atualizada com sucesso." if @price.update(price_params)
   
    flash.now[:alert] = "Falha na atualização da Configuração de Preço." if !@price.update(price_params)
    render :edit
  end

  def destroy
    @price = Price.find(params[:id])
    @product = Product.find(params[:product_id])
    @price.destroy
    redirect_to product_path(@product), notice: 'Configuração de preço removida com sucesso.'
  end

  private

  def price_params
    params.require(:price).permit(:price_in_brl, :product_id, :validity_start)
  end
end