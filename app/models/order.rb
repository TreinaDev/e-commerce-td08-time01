class Order < ApplicationRecord
  belongs_to :user
  has_many :cart_items

  before_create :set_code
  after_create :process_cart

  enum status: {pending: 0, approved: 5, canceled: 9}
  
  private

  def set_code
    self.code = SecureRandom.alphanumeric(8).upcase.insert(4, '-')
  end

  def process_cart
    CartItem.where(order_id: nil, user: self.user).each do |ci|
      ci.update(order_id: self.id)
      ci.update(price_on_purchase: ci.product.prices
                                     .where('validity_start <= ?', DateTime.current)
                                     .order(validity_start: :asc)
                                     .last
                                     .price_in_brl)
    end
  end
end