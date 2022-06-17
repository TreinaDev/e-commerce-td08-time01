require 'rails_helper'

RSpec.describe Price, type: :model do
  it { should belong_to :product }

  context '#valid?' do
    it { should validate_presence_of :price_in_brl}
    it { should validate_presence_of :validity_start}
    it { should validate_numericality_of(:price_in_brl).is_greater_than(0) }

    it 'is expected to validate that :validity_start is unique within the scope of a Product'  do
      FactoryBot.create(:price)
      should validate_uniqueness_of(:validity_start)
        .scoped_to(:product_id)
        .with_message('já está cadastrada em outra instância de Price para este produto')
    end

    it 'is expected to validate that :validity_start cannot be set in the distant past' do
      price = build(:price, validity_start: 1.day.ago, price_in_brl: 5)

      price.valid?

      expect(price.errors.include?(:validity_start)).to be true
      expect(price.errors[:validity_start]).to include('não pode estar no passado')
    end

    it 'is expected to validate that :validity_start can be set up to 2s in the past' do
      price = build(:price, validity_start: Time.current, price_in_brl: 5, product: build(:product))

      expect(price).to be_valid
    end
  end
end
