require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#valid?' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:brand) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:sku) }
    it { should validate_uniqueness_of(:sku) }
    it { should allow_value('CAT38710').for(:sku) }
    it { should allow_value('7U0330P3JD').for(:sku) }
    it { should_not allow_value('/..?').for(:sku).with_message('deve ter apenas letras e números') }
  end

  describe '#set_price' do
    it 'should create a Price with validity start as now if no datetime is passed' do
      product = create(:product).set_price(15)
      another_product = create(:product).set_price(8.51)

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
      product = create(:product).set_price(51.01, 2.months.from_now)

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
end
