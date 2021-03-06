class Order < ApplicationRecord
  attr_accessor :skip_callback

  belongs_to :user
  has_many :cart_items
  validates_presence_of :address
  validate :must_have_cart, on: :create

  before_create :set_code, :set_price_on_purchase
  after_create :process_cart 
  after_create :request_payment, unless: :skip_callback

  enum status: { pending: 0, approved: 5, canceled: 9 }
  
  def value
    self.cart_items.reduce(0) {|sum, cart| sum += cart.price_on_purchase * cart.quantity }
  end

  private

  def set_code
    self.code = SecureRandom.alphanumeric(8).upcase.insert(4, '-')
  end

  def set_price_on_purchase
    promotion = Promotion.find_by(id: self.promotion_id)
    cart = CartItem.where(order_id: nil, user: self.user)
    error_msg = PromotionsManager::PromotionValidator.call(promotion)
    if error_msg.nil?
      self.price_on_purchase = OrdersManager::PriceAdder.call(cart, promotion)
    else
      self.price_on_purchase = OrdersManager::PriceAdder.call(cart)
    end
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

  def request_payment
    Transaction.request(user_tax_number: self.user.identify_number,
                        order_id: self.id,
                        value: self.price_on_purchase,
                        transaction_type: 'transaction_order')
  end
end
