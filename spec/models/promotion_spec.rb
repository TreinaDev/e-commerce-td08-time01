require 'rails_helper'

RSpec.describe Promotion, type: :model do
  describe '#valid?' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:discount_percent) }
    it { should validate_presence_of(:maximum_discount) }
    it { should validate_presence_of(:absolute_discount_uses) }

    it { should validate_numericality_of(:discount_percent).is_greater_than(0) }
    it { should validate_numericality_of(:discount_percent).is_less_than(101) }
    it { should validate_numericality_of(:maximum_discount).is_greater_than(0) }
    it { should validate_numericality_of(:absolute_discount_uses).is_greater_than(0) }

    context 'is expected to validate that :start_date'  do
      it 'cannot be set in the distant past' do
        promotion = build(:promotion, start_date: 1.day.ago)

        promotion.valid?

        expect(promotion.errors.include?(:start_date)).to be true
        expect(promotion.errors[:start_date]).to include('não pode estar no passado')
      end

      it 'can be set in the immediate past' do
        promotion = build(:promotion, start_date: 1.second.ago)

        expect(promotion).to be_valid
      end
    end

    context 'is expected to validate that :end_date'  do
      it 'cannot be earlier than the :start_date' do
        promotion = build(:promotion, start_date: 1.second.ago, end_date: 1.day.ago)

        promotion.valid?

        expect(promotion.errors.include?(:end_date)).to be true
        expect(promotion.errors[:end_date]).to include('não pode ser anterior à data de início')
      end

      it 'can be later than the :start_date' do
        promotion = build(:promotion, start_date: 1.second.ago, end_date: 1.second.from_now)

        expect(promotion).to be_valid
      end
    end
  end

  describe '#set_code' do
    it 'is expected to automatically generate an 8 digit code' do
      promotion = create(:promotion)

      expect(promotion.code.length).to be 8
    end
  end
end
