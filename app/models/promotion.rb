class Promotion < ApplicationRecord
  has_many :promotion_categories 
  has_many :product_categories, through: :promotion_categories
end
