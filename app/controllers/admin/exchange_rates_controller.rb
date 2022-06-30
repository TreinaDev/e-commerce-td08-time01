class Admin::ExchangeRatesController < ApplicationController
  before_action :authenticate_admin!

  def index
    # checnk this below is the same as rate.current
    @current_rate = ExchangeRate.take
  end

  def collect_rate
    old_rate = ExchangeRate.current
    if ExchangeRate.get
      redirect_to admin_exchange_rates_path, notice: "Taxa atualizada de #{old_rate} para #{ExchangeRate.current}"
    else
    end
  end
end