require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:brand) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:sku) }
    it { should validate_uniqueness_of(:sku) }
    it { should allow_value('CAT38710').for(:sku) }
    it { should allow_value('7U0330P3JD').for(:sku) }
    it { should_not allow_value('/..?').for(:sku).with_message('deve ter apenas letras e números') }
  end
end
