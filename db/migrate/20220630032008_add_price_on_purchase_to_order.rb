class AddPriceOnPurchaseToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :price_on_purchase, :integer
  end
end
