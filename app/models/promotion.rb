class Promotion < ApplicationRecord
  has_many :promotion_categories 
  has_many :product_categories, through: :promotion_categories
  validates_presence_of :start_date, :end_date, :name, :discount_percent, :maximum_discount, :absolute_discount_uses
  validates :discount_percent, :maximum_discount, :absolute_discount_uses, numericality: { greater_than: 0 }
  validates :discount_percent, numericality: { less_than: 101 }
  validate :start_date_must_not_be_in_the_past, :end_date_must_not_be_earlier_than_start_date

  before_create :set_code

  private

  def set_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def start_date_must_not_be_in_the_past
    if start_date.present? && start_date < 2.seconds.ago
      errors.add(:start_date, 'não pode estar no passado')
    end
  end

  def end_date_must_not_be_earlier_than_start_date
    if end_date.present? && end_date < start_date
      errors.add(:end_date, 'não pode ser anterior à data de início')
    end
  end
end
