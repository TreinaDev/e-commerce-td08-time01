class Order < ApplicationRecord
  belongs_to :user
  has_many :cart_items

  before_validation :set_code, on: :create
  
  private

  def set_code
    self.code = SecureRandom.alphanumeric(8).upcase.insert(4, '-')
  end
end
