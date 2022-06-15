require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe '#valid?' do
    it {should belong_to(:product)}
    it {should belong_to(:user)}
    it {should validate_presence_of(:quantity)}
    it {should validate_numericality_of(:quantity).is_greater_than(0)}
  end
end
