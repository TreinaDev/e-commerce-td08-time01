class AddAttributesToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :height, :float
    add_column :products, :width, :float
    add_column :products, :depth, :float
    add_column :products, :weight, :float
    add_column :products, :is_fragile, :integer
  end
end
