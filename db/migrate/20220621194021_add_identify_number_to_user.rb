class AddIdentifyNumberToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :identify_number, :string, null: false
  end
end
