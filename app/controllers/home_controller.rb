class HomeController < ApplicationController
  def index
    @products = Product.on_shelf
  end
end