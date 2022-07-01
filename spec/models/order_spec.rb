require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it {should belong_to(:user)}
    it {should have_many(:cart_items)}
    it {should validate_presence_of(:address)}

    context 'when cart' do
      it "doesn't exist gives false" do
        order = build(:order)

        expect(order.valid?).to be_falsey
        expect(order.errors.full_messages).to include 'Pedido deve possuir carrinho.' 
      end

      it "exists gives true" do
        user = create(:user)
        product = create(:product)
        create(:price, product: product)
        create(:cart_item, user: user, product: product)
        order = build(:order, user: user)

        expect(order).to be_truthy
      end
    end
  end

  describe '.save' do
    it 'should automatically send a transaction request' do
      fake_response = double('faraday_response', status: 201, 
                                                 body: '{ "code": "nsurg745n" }')
      allow(Faraday).to receive(:post).and_return(fake_response)
      user = create(:user)
      create(:cart_item, user: user)
      order = build(:order, user: user)

      order.save!

      expect(Order.last.transaction_code).to eq 'nsurg745n'
    end
  end

  describe '.value' do
    it 'should return sum of cart without promotion' do
      fake_response = double('faraday_response', status: 201, 
                                                 body: '{ "code": "nsurg745n" }')
      allow(Faraday).to receive(:post).and_return(fake_response)
      user = create(:user)
      category = create(:product_category, name: 'Eletrônicos')
      create(:exchange_rate, rate: 0.5)
      product = create(:product, name: 'Notebook', product_category: category).set_brl_price(25.0) 
      product_2 = create(:product, name: 'Caneca').set_brl_price(50.0)
      create(:cart_item, product: product, user: user, quantity: 2)
      create(:cart_item, product: product_2, user: user)
      promotion = create(:promotion, discount_percent: 20)
      promotion_category = create(:promotion_category, product_category: category, promotion: promotion)
      order = create(:order, promotion_id: promotion.id, user: user)

      value = order.value

      expect(value).to be > order.price_on_purchase
    end
  end
end
