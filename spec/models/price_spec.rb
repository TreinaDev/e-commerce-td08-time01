require 'rails_helper'

RSpec.describe Price, type: :model do
  describe '#valid?' do
    it { should belong_to :product }

    context 'regarding presence' do
      it { should validate_presence_of :price_in_brl}
      it { should validate_presence_of :validity_start}
    end

    context 'regarding numericality' do
      it { should validate_numericality_of(:price_in_brl).is_greater_than(0) }
    end

    context 'regarding uniqueness' do
      it 'é falso se já existe um preço para aquela data' do
        FactoryBot.create(:price)
        should validate_uniqueness_of(:validity_start)
        .scoped_to(:product_id)
        .with_message('já está cadastrada em outra instância de Price para este produto')
      end
    end 
    

    it 'é falso se, ao salvar um preço, o início da sua validade está no passado' do
      price = Price.new(validity_start: 1.day.ago, price_in_brl: 5)

      price.valid?

      expect(price.errors.include?(:validity_start)).to be true
      expect(price.errors[:validity_start]).to include('não pode estar no passado')
    end
  end
end
