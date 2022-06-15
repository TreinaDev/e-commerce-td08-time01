class Product < ApplicationRecord
  validates_presence_of :name, :brand, :description, :sku
  validates_uniqueness_of :sku
  validates_format_of :sku, with: /\A[A-Z0-9]+\z/, message: 'deve ter apenas letras e números'
  validates_length_of :sku, is: 9, message: 'deve ter 9 caracteres'

  has_many :prices

  before_validation :fill_sku, on: :create

  def fill_sku
    self.sku = SecureRandom.alphanumeric(9).upcase unless self.sku.present?
  end
end
