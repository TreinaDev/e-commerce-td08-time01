class PromotionCategory < ApplicationRecord
  belongs_to :product_category
  belongs_to :promotion
  
end
