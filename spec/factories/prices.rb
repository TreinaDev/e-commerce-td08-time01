FactoryBot.define do
  factory :price do
    price_in_brl { "9.99" }
    validity_start { "2022-06-14 09:13:43" }
    product { nil }
  end
end
