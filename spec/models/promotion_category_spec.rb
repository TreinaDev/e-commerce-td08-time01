require 'rails_helper'

RSpec.describe PromotionCategory, type: :model do
  it { should belong_to(:promotion)}
  it { should belong_to(:product_category)}
end
