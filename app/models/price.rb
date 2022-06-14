class Price < ApplicationRecord
  validates :price_in_brl, :validity_start, presence: true
  validates :price_in_brl, numericality: { greater_than: 0 }
  validates :validity_start, uniqueness: { scope: :product_id, message: 'já está cadastrada em outra instância de Price para este produto' }
  validate :validity_start_is_future
  
  belongs_to :product

  private

  def validity_start_is_future
    if validity_start.present? && validity_start < Date.today
      errors.add(:validity_start, 'deve ser depois de agora.')
    end
  end
end
