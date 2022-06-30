class CreatePromotionCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :promotion_categories do |t|
      t.references :product_category, null: false, foreign_key: true
      t.references :promotion, null: false, foreign_key: true

      t.timestamps
    end
  end
end
