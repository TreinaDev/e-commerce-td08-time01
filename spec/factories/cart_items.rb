FactoryBot.define do
  factory :cart_item do
    product
    user
    quantity { 1 }
  end
end
