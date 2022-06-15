require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe '#valid?' do
    context '#association' do
      it {should belong_to(:product)}
      it {should belong_to(:user)}
    end

    context '#presence' do
      it {should validate_presence_of(:quantity)}
    end

    context '#numericality' do
      it {should validate_numericality_of(:quantity).is_greater_than(0)}
    end
  end
end
