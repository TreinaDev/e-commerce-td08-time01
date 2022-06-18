class AddOrderToCartItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :cart_items, :order, foreign_key: true
  end
end
