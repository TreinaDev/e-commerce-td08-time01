class ProductCategory < ApplicationRecord
  #belongs_to :parent, class_name: 'ProductCategory', optional: true, foreign_key: :product_category_id
  #has_many :children, class_name: 'ProductCategory', dependent: :destroy
  has_ancestry

  validates :name, presence: true
  validates :name, uniqueness: true

  def show_with_ancestors
    self.ancestors.map(&:name).join(' > ').to_s + ' > ' + self.name
  end

  def show_ancestors
    self.ancestors.map(&:name).join(' > ').to_s
  end

end
