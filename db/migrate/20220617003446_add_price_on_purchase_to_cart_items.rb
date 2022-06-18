class AddPriceOnPurchaseToCartItems < ActiveRecord::Migration[7.0]
  def change
    add_column :cart_items, :price_on_purchase, :decimal
  end
end
