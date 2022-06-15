class RenameCartsToCartItems < ActiveRecord::Migration[7.0]
  def self.up
    rename_table :carts, :cart_items
  end

  def self.down
    rename_table :cart_items, :carts
  end
end
