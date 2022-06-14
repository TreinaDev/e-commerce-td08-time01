require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do

    context 'regarding presence' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:brand) }
      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:sku) }
    end

    context 'regarding uniqueness' do
      it { should validate_uniqueness_of(:sku) }
    end

    context 'regarding format' do
      it { should allow_value('CAT38710').for(:sku) }
      it { should allow_value('7U0330P3JD').for(:sku) }
      it { should_not allow_value('/..?').for(:sku).with_message('deve ter apenas letras e números') }
    end
  end
end
