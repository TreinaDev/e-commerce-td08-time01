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

  describe '#set_brl_price' do
    it 'should create a Price with validity start as now if no datetime is passed' do
      product = create(:product).set_brl_price(15)
      another_product = create(:product).set_brl_price(8.51)

      price = Price.first
      another_price = Price.last

      expect(price.price_in_brl).to eq 15
      expect(price.product_id).to be product.id
      expect(product.prices).to include(price)
      expect(product.prices).not_to include(another_price)
      expect(another_price.price_in_brl).to eq 8.51
      expect(another_price.product_id).to be another_product.id
      expect(another_product.prices).to include(another_price)
      expect(another_product.prices).not_to include(price)
    end

    it 'should create a Price with validity start in the future if a datetime is passed' do
      product = create(:product).set_brl_price(51.01, 2.months.from_now)

      price = Price.first
      creation_lag =  2.months.from_now - price.validity_start
      diff_between_time_asked_and_time_persisted = creation_lag < 0 ? creation_lag * (-1) : creation_lag
      # while the creation_lag is always positive, calculating its absolute value helps 
      # expose bugs (ie: asked to create validity_start 2 months from now, created 3 months 
      # from now, diff = - 1 months (negative), which is less than 2 seconds and would pass the test)

      expect(price.price_in_brl).to eq 51.01
      expect(price.product_id).to be product.id
      expect(product.prices).to include(price)
      expect(diff_between_time_asked_and_time_persisted).to be < 2.seconds
    end
  end

  describe '#current_price_in_brl' do
    it 'should choose the correct current Price of a Product' do
      Timecop.freeze(1.year.ago) do
        product = create(:product).set_brl_price(5.99)
        product.set_brl_price(10.51, 11.months.from_now)
      end
      product = Product.first.set_brl_price(14.99, 2.months.from_now)

      expect(product.current_price_in_brl).to eq 10.51
    end

    it 'should return nil if the product has no prices at all' do
      product = create(:product)

      expect(product.prices).to be_empty
      expect(product.current_price_in_brl).to be nil
    end

    it 'should return nil if the product only has prices with validity start in the future' do
      product = create(:product)
      price = create(:price, price_in_brl: 22.22, validity_start: 2.months.from_now, product: product)

      expect(product.prices).to include(price)
      expect(product.current_price_in_brl).to be nil
    end
  end
end
