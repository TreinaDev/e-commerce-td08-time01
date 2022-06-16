class Product < ApplicationRecord
  validates_presence_of :name, :brand, :description, :sku
  validates_uniqueness_of :sku
  validates_format_of :sku, with: /\A[A-Z0-9]+\z/, message: 'deve ter apenas letras e números'
  
  has_many :prices

  enum status: { off_shelf: 0, draft: 5, on_shelf: 9 }
end
