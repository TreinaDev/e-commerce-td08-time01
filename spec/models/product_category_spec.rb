require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  context '#valid?' do
    it { validate_presence_of(:name) }
    it { validate_uniqueness_of(:name) }
  end

  context '#children' do
    it 'returns all subcategories directly connected to a category' do
      parent_category = ProductCategory.create!(name: 'parent')
      child_category1 = ProductCategory.create!(name: 'elder child', parent: parent_category)
      child_category2 = ProductCategory.create!(name: 'younger child', parent: parent_category)
      grandchild_category = ProductCategory.create!(name: 'grandchild', parent: child_category1)
      
      expect(parent_category.children).to include(child_category1)
      expect(parent_category.children).to include(child_category2)
      expect(parent_category.children).not_to include(grandchild_category)
    end
  end

  context '#root' do
    it 'returns the root category in the category tree' do
      parent_category = ProductCategory.create!(name: 'parent')
      child_category = ProductCategory.create!(name: 'child', parent: parent_category)
      grandchild_category = ProductCategory.create!(name: 'grandchild', parent: child_category)
    
      expect(grandchild_category.root).to eq(parent_category)
    end
  end
end
