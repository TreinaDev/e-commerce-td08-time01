class Promotion < ApplicationRecord
  has_many :promotion_categories 
  has_many :product_categories, through: :promotion_categories

  before_create :set_code

  private

  def set_code
    self.code = SecureRandom.alphanumeric(8)
  end
end
