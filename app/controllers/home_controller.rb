class HomeController < ApplicationController
  def index
    @products = Product.on_shelf.sort_by(&:name)
    @message_if_empty = 'Não existem produtos cadastrados'
  end
end