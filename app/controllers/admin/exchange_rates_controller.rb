class Admin::ExchangeRatesController < ApplicationController
  before_action :authenticate_admin!

  def index
    # checnk this below is the same as rate.current
    @current_rate = ExchangeRate.take
  end

  def collect_rate
    old_rate = ExchangeRate.current
    if ExchangeRate.get
      if old_rate == ExchangeRate.current # before update is the same as after update
        redirect_to admin_exchange_rates_path, notice: 'A taxa de câmbio foi atualizada, mas o seu valor continua o mesmo'
      else
        redirect_to admin_exchange_rates_path, notice: "Taxa atualizada de #{old_rate} para #{ExchangeRate.current}"
      end
    else
      redirect_to admin_exchange_rates_path, alert: 'Não foi possível obter a taxa de câmbio atualizada'
    end
  end
end