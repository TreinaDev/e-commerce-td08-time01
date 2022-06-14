require 'rails_helper'

RSpec.describe Price, type: :model do
  context '#valid?' do
    it { should belong_to :product }
    it { should validate_presence_of :price_in_brl}
    it { should validate_presence_of :validity_start}
    it { should validate_numericality_of(:price_in_brl).is_greater_than(0) }
    
    it do
      FactoryBot.create(:price)
      should validate_uniqueness_of(:validity_start)
      .scoped_to(:product_id)
      .with_message('já está cadastrada em outra instância de Price para este produto')
    end

    it 'data estimada de entrega não pode ser retroativa' do
      price = Price.new(validity_start: 1.day.ago)

      price.valid?

      expect(price.errors.include?(:validity_start)).to be true
      expect(price.errors[:validity_start]).to include('deve ser depois de agora.')
    end

  end
end
