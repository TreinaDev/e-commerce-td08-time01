require 'rails_helper'

RSpec.describe OrdersManager::PriceAdder, type: :model do
  describe '#call' do
    context 'when cart has no order' do
      context 'and there is no promotion,' do
        it 'should give current price sum' do
          user = create(:user)
          create(:exchange_rate, rate: 2)
          product_1 = create(:product, name: 'Caneca', status: 'on_shelf').set_brl_price(12)
          product_2 = create(:product, name: 'Garrafa', status: 'on_shelf').set_brl_price(5)
          product_3 = create(:product, name: 'Jarra', status: 'on_shelf').set_brl_price(16)
          create(:cart_item, product: product_1, quantity: 3, user: user)
          create(:cart_item, product: product_2, quantity: 7, user: user)
          create(:cart_item, product: product_3, quantity: 5, user: user)
          cart = CartItem.where(order_id: nil)

          sum = OrdersManager::PriceAdder.call(cart)

          expect(sum).to eq 302
        end
      end

      context 'and there is a promotion,' do
        it 'should give discounted current price sum' do
          user = create(:user)
          create(:exchange_rate, rate: 2)
          category = create(:product_category, name: 'Utensílios')
          promotion = create(:promotion, name: 'Dia das mães', discount_percent: 20, maximum_discount: 100)
          create(:promotion_category, promotion: promotion, product_category: category) 
          product_1 = create(:product, name: 'Caneca', status: 'on_shelf', product_category: category).set_brl_price(12)
          product_2 = create(:product, name: 'Garrafa', status: 'on_shelf', product_category: category).set_brl_price(5)
          product_3 = create(:product, name: 'Peruca Loira', status: 'on_shelf').set_brl_price(16)
          create(:cart_item, product: product_1, quantity: 3, user: user)
          create(:cart_item, product: product_2, quantity: 7, user: user)
          create(:cart_item, product: product_3, quantity: 5, user: user)
          cart = CartItem.where(order_id: nil)

          # 12 × 2 × 0,8 = 19,2 >> 19 × 3 = 57
          # 5 × 2 × 0,8 = 8 >> 8 x 7 = 56
          # 16 × 2 × 5 = 160
          # 160 + 57 + 56 = 273

          sum = OrdersManager::PriceAdder.call(cart, promotion)

          expect(sum).to eq 273
        end

        it 'should give discounted current price sum with limit' do
          user = create(:user)
          create(:exchange_rate, rate: 2)
          category = create(:product_category, name: 'Utensílios')
          promotion = create(:promotion, name: 'Dia das mães', discount_percent: 20, maximum_discount: 5)
          create(:promotion_category, promotion: promotion, product_category: category) 
          product_1 = create(:product, name: 'Caneca', status: 'on_shelf', product_category: category).set_brl_price(25)
          product_2 = create(:product, name: 'Garrafa', status: 'on_shelf', product_category: category).set_brl_price(5)
          product_3 = create(:product, name: 'Peruca Loira', status: 'on_shelf').set_brl_price(16)
          create(:cart_item, product: product_1, quantity: 3, user: user)
          create(:cart_item, product: product_2, quantity: 7, user: user)
          create(:cart_item, product: product_3, quantity: 5, user: user)
          cart = CartItem.where(order_id: nil)

          # 25 × 2 × 0,2 = 10 >> 10 > maximum_discount >> discounted_value = 45 >> 45 x 3 = 135
          # 5 × 2 × 0,8 = 8 >> 8 x 7 = 56
          # 16 × 2 × 5 = 160
          # 160 + 135 + 56 = 351

          sum = OrdersManager::PriceAdder.call(cart, promotion)

          expect(sum).to eq 351
        end
      end
    end

    context 'when cart has a order' do
      it 'should give price on purchase sum' do
        Timecop.freeze(1.week.ago) do
          user = create(:user)
          create(:exchange_rate, rate: 2)
          @product_1 = create(:product, name: 'Caneca', status: 'on_shelf')
          @product_2 = create(:product, name: 'Garrafa', status: 'on_shelf')
          @product_3 = create(:product, name: 'Jarra', status: 'on_shelf')
          Price.delete_all
          create(:price, product: @product_1, price_in_brl: "12")
          create(:price, product: @product_2, price_in_brl: "5")
          create(:price, product: @product_3, price_in_brl: "16")
          create(:cart_item, product: @product_1, quantity: 3, user: user)
          create(:cart_item, product: @product_2, quantity: 7, user: user)
          create(:cart_item, product: @product_3, quantity: 5, user: user)
          fake_response = double('faraday_response', status: 201, body: '{ "transaction_code": "nsurg745n" }')
          allow(Faraday).to receive(:post).and_return(fake_response)
          @order = create(:order, user: user)
        end
        create(:price, product: @product_1, price_in_brl: "6")
        create(:price, product: @product_2, price_in_brl: "2.5")
        create(:price, product: @product_3, price_in_brl: "8")
        
        cart = CartItem.where(order_id: @order.id)
        sum = OrdersManager::PriceAdder.call(cart)

        expect(sum).to eq 302
      end
    end
  end
end