FactoryBot.define do
  factory :cart do
    product
    user
    quantity { 1 }
  end
end
