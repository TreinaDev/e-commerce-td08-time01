FactoryBot.define do
  factory :cart_item do
    product
    user
    order_id { nil }
    quantity { 1 }
  end
end
