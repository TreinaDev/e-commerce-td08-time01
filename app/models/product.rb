class Product < ApplicationRecord
  validates_presence_of :name, :width, :weight, :depth, :height, :is_fragile
  validates_presence_of :brand, :description, :sku, if: Proc.new { |p| p.on_shelf? }
  validates_uniqueness_of :sku, allow_blank: true
  validates_format_of :sku, with: /\A[A-Z0-9]+\z/, message: 'deve ter apenas letras e números', if: Proc.new { |p| p.sku.present? }

  belongs_to :product_category, optional: true

  has_many :prices, dependent: :destroy
  accepts_nested_attributes_for :prices, allow_destroy: true

  has_one_attached :picture
  has_one_attached :file

  enum is_fragile: { unchecked: 0, checked: 1 }
  enum status: { off_shelf: 0, draft: 5, on_shelf: 9 }

  def set_brl_price(price_in_brl, validity_start = 1.second.ago)
    Price.create!(price_in_brl: price_in_brl,
                  validity_start: validity_start,
                  product_id: self.id)
    return self
  end

  def current_price_in_rubis
    begin
      (self.current_price_in_brl / ExchangeRate.current).ceil
    rescue NoMethodError
      nil
    end
  end

  def current_price_in_brl
   begin
      self.prices
          .where('validity_start <= ?', DateTime.current)
          .order(validity_start: :asc)
          .last
          .price_in_brl
    rescue NoMethodError
      nil
    end
  end
end
