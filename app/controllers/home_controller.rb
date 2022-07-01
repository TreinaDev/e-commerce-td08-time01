class HomeController < ApplicationController
  def index
    redirect_to admin_index_path if admin_signed_in? 
    @products = Product.on_shelf.sort_by(&:name)
    @message_if_empty = 'Não existem produtos cadastrados'
  end
end