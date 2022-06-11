class ProductCategory < ApplicationRecord
  belongs_to :parent, class_name: 'ProductCategory', optional: true, foreign_key: :product_category_id
  has_many :children, class_name: 'ProductCategory', dependent: :destroy
end
