class AddPromotionToOrder < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :promotion, foreign_key: true
  end
end
