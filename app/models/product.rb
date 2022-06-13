class Product < ApplicationRecord
  validates_presence_of :name, :brand, :description, :sku
  validates_uniqueness_of :sku
  validates_format_of :sku, with: /\A[A-Z0-9]+\z/, message: 'deve ter apenas letras e números'
end
