class AddColumnsToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :status, :integer, default: 5
    add_column :products, :stock, :integer
    add_reference :products, :product_category, foreign_key: true
  end
end