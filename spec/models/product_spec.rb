require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do
    it { should validate_presence_of(:name) }
    xit { should validate_presence_of(:brand) }
    xit { should validate_presence_of(:description) }
    xit { should validate_presence_of(:sku).on(:build) }
    it { should validate_uniqueness_of(:sku) }
    xit { should_not allow_value('CAT38710').for(:sku) }
    xit { should_not allow_value('7U0330P3JD').for(:sku) }
    it { should_not allow_value('/..?').for(:sku).with_message('deve ter apenas letras e números') }
    xit { should validate_length_of(:sku).is_equal_to(9) } 
  end

  describe '#generate_sku' do
    it 'should generate a random alphanumeric SKU code' do
       sku = Product.new.fill_sku

       expect(sku.length).to be 9
    end

    it 'should automatically add it when a new product is created' do
      hamlet = create(:product, sku: '').sku 
      
      expect(hamlet).to be
    end

    xit 'should not change the SKU if the product already had one' do
      product = create(:product, name: 'Colar amarelo')
      original_product_sku = product.sku
      product.update(name: 'Pulseira verde')
      sku_after_save = product.sku
      expect(original_product_sku).to eq sku_after_save
      it { should validate_uniqueness_of(:sku) }
      it { should allow_value('7U030P3JD').for(:sku) }
      it { should_not allow_value('/_-.?').for(:sku).with_message('deve ter apenas letras e números') }
    end

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
      xit 'should return false if product is on shelf' do
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
