class Product < ApplicationRecord
  validates_presence_of :name, :brand, :description, :sku
  validates_uniqueness_of :sku
  validates_format_of :sku, with: /\A[A-Z0-9]+\z/, message: 'deve ter apenas letras e números'
  
  has_many :prices

  def set_price(price_in_brl, validity_start = 1.second.ago)
    Price.create!(price_in_brl: price_in_brl,
                  validity_start: validity_start,
                  product_id: self.id)
    return self
  end
end
