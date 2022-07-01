require 'rails_helper' 

RSpec.describe PromotionsManager::PromotionValidator, type: :model do
  describe "#call" do
    it "should give nil when promotion is valid" do
      promotion = create(:promotion, start_date: 1.second.ago, end_date: 10.days.from_now)

      result = PromotionsManager::PromotionValidator.call(promotion)

      expect(result).to be nil
    end

    context "should give error message" do
      it "when promotion doesn't exist" do
        promotion = nil

        result = PromotionsManager::PromotionValidator.call(promotion)

        expect(result).to eq "Cupom inexistente"
      end

      it "when promotion is not in effect" do
        promotion = create(:promotion, start_date: 1.day.from_now, end_date: 10.days.from_now)

        result = PromotionsManager::PromotionValidator.call(promotion)

        expect(result).to eq "Promoção ainda não entrou em vigor"
      end

      it "when promotion expired" do
        Timecop.freeze(2.days.ago) do
          @promotion = create(:promotion, start_date: 1.second.ago, end_date: 1.day.from_now)
        end

        result = PromotionsManager::PromotionValidator.call(@promotion)

        expect(result).to eq "Promoção expirou"
      end

      it "when the use limit of the promotion has been reached" do
        fake_response = double('faraday_response', status: 201, body: '{ "transaction_code": "nsurg745n" }')
        allow(Faraday).to receive(:post).and_return(fake_response)

        Timecop.freeze(2.days.ago) do
          user = create(:user)
          @promotion = create(:promotion, start_date: 1.second.ago, end_date: 10.days.from_now,
                              absolute_discount_uses: 5)
          @promotion.absolute_discount_uses.times do
            create(:exchange_rate, rate: 2)
            product = create(:product)
            create(:price, product: product, price_in_brl: "11", validity_start: Time.current)
            create(:cart_item, product: product, quantity: 3, user: user)
            create(:order, user: user, promotion_id: @promotion.id)
          end
        end

        result = PromotionsManager::PromotionValidator.call(@promotion)

        expect(result).to eq "Limite de cupons atingido"
      end
    end
  end
end