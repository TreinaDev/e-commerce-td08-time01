require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:sku) }
    it { should allow_value('7U030P3JD').for(:sku) }
    it { should_not allow_value('/_-.?').for(:sku).with_message('deve ter apenas letras e números') }

    context 'with blank brand' do
      it 'should return false if product is on shelf' do
        product = build(:product, brand: '', status: 'on_shelf')

        product.valid?

        expect(product.errors.full_messages).to include('Marca não pode estar em branco')
      end

      it 'should return true if product is a draft' do
        product = build(:product, brand: '', status: 'draft')

        expect(product).to be_valid
      end

      it 'should return true if product is off shelf' do
        product = build(:product, brand: '', status: 'off_shelf')

        expect(product).to be_valid
      end
    end

    context 'with blank description' do
      it 'should return false if product is on shelf' do
        product = build(:product, description: '', status: 'on_shelf')

        product.valid?

        expect(product.errors.full_messages).to include('Descrição não pode estar em branco')
      end

      it 'should return true if product is a draft' do
        product = build(:product, description: '', status: 'draft')

        expect(product).to be_valid
      end

      it 'should return true if product is off shelf' do
        product = build(:product, description: '', status: 'off_shelf')

        expect(product).to be_valid
      end
    end

    context 'with blank sku' do
      it 'should return false if product is on shelf' do
        product = build(:product, sku: '', status: 'on_shelf')

        product.valid?

        expect(product.errors.full_messages).to include('SKU não pode estar em branco')
      end

      it 'should return true if product is a draft' do
        product = build(:product, sku: '', status: 'draft')

        expect(product).to be_valid
      end

      it 'should return true if product is off shelf' do
        product = build(:product, sku: '', status: 'off_shelf')

        expect(product).to be_valid
      end
    end
  end
end
