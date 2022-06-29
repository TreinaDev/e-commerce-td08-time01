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
    @product = Product.find(params[:product_id])
    @price = Price.find([params[:id]])
  end

  def update
    price_params 

    return redirect_to product_categories_path, notice: "Configuração de Preço cadastrada com sucessp." if @price.update(price_params)
   
    flash.now[:alert] = "Falha na atualização da Configuração de Preço." if !@price.update(price_params)
    render :edit
  end

  private

  def price_params
    params.require(:price).permit(:price_in_brl, :product_id, :validity_start)
  end
end