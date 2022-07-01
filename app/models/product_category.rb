class ProductCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  
  has_ancestry
  has_many :products

  has_many :promotion_categories 
  has_many :promotions, through: :promotion_categories

  def show_with_ancestors
    self.ancestors.map(&:name).join(' > ').to_s + ' > ' + self.name
  end

  def show_ancestors
    self.ancestors.map(&:name).join(' > ').to_s
  end
end
