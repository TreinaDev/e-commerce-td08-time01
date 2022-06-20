class RemoveColumnsFromProducts < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :stock, :integer
    remove_column :products, :status, :integer
  end
end
