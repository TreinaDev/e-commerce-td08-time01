require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  describe '#valid?' do
    it { validate_presence_of(:name) }
    it { validate_uniqueness_of(:name) }
  end

  describe '#subtree' do
    it 'Testa se a subárvore é retornada corretamente' do
      parent_category = ProductCategory.create!(name: 'parent')
      child_category = ProductCategory.create!(name: 'child', parent: parent_category)
      grandchild_category = ProductCategory.create!(name: 'grandchild', parent: child_category)

      expect(parent_category.children.first).to eq(child_category)
      expect(grandchild_category.root).to eq(parent_category)
    end
  end
end
