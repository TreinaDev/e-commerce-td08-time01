class Admin::ExchangeRatesController < ApplicationController
  before_action :authenticate_admin!

  def index
    # checnk this below is the same as rate.current
    @current_rate = ExchangeRate.take
  end
end