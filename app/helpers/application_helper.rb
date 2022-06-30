module ApplicationHelper
  PRODUCT_STATUS = [
    ['suspenso', :off_shelf],
    ['à venda', :on_shelf],
    ['em rascunho', :draft]
  ].freeze

  def options_for_product_status(selected)
    options_for_select(PRODUCT_STATUS, selected)
  end
end
