class Product < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :brand, :description, :sku, if: Proc.new { |p| p.on_shelf? }
  validates_uniqueness_of :sku, allow_blank: true
  validates_format_of :sku, with: /\A[A-Z0-9]+\z/, message: 'deve ter apenas letras e números', if: Proc.new { |p| p.sku.present? }
  
  has_many :prices

  enum status: { off_shelf: 0, draft: 5, on_shelf: 9 }
end
