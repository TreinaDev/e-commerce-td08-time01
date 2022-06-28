class AddTransactionCodeToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :transaction_code, :string
  end
end
