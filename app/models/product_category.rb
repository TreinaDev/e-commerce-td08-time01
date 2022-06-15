class ProductCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  
  has_ancestry

  def show_with_ancestors
    self.ancestors.map(&:name).join(' > ').to_s + ' > ' + self.name
  end

  def show_ancestors
    self.ancestors.map(&:name).join(' > ').to_s
  end
end
