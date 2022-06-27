class CreatePromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :promotions do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.string :name
      t.integer :discount_percent
      t.decimal :maximum_discount
      t.integer :absolute_discount_uses
      t.string :code

      t.timestamps
    end
  end
end
