FactoryBot.define do
  factory :price do
    price_in_brl { "9.99" }
    validity_start { 1.second.ago }
    product
  end
end
