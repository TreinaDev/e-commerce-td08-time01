require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:brand) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:sku).on(:build) }
    it { should validate_uniqueness_of(:sku) }
    it { should_not allow_value('CAT38710').for(:sku) }
    it { should_not allow_value('7U0330P3JD').for(:sku) }
    it { should_not allow_value('/..?').for(:sku).with_message('deve ter apenas letras e números') }
    it { should validate_length_of(:sku).is_equal_to(9) } 
  end
# lembra daquela discussão de deixar o usuário no console decidir. é isso. se não tem isso, o factorybot tá quebrando
  describe '#generate_sku' do
    it 'should generate a random alphanumeric SKU code' do
       sku = Product.new.fill_sku

       expect(sku.length).to be 9
    end

    it 'should automatically add it when a new product is created' do
      hamlet = create(:product, sku: '').sku 
      
      expect(hamlet).to be 
    end

    it 'should not change the SKU if the product already had one' do
      product = create(:product, name: 'Colar amarelo')
      original_product_sku = product.sku
      product.update(name: 'Pulseira verde')
      sku_after_save = product.sku

      expect(original_product_sku).to eq sku_after_save
    end
  end
end
