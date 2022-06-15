class CreatePrices < ActiveRecord::Migration[7.0]
  def change
    create_table :prices do |t|
      t.decimal :price_in_brl
      t.datetime :validity_start
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
