class Order < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  validates_presence_of :address
  validate :must_have_cart

  before_create :set_code
  after_create :process_cart

  enum status: {pending: 0, approved: 5, canceled: 9}
  
  private

  def set_code
    self.code = SecureRandom.alphanumeric(8).upcase.insert(4, '-')
  end

  def process_cart
    CartItem.where(order_id: nil, user: self.user).each do |item|
      item.update(order_id: self.id)
      item.update(price_on_purchase: item.product.current_price_in_rubis)
    end
  end

  def must_have_cart
    return errors.add(:pedido, 'deve possuir carrinho.') if CartItem.where(order_id: nil, user: self.user).empty?
  end
end
