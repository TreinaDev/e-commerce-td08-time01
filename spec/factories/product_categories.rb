FactoryBot.define do
  factory :product_category do
    trait :root do
      name { "Product Root" }
      parent_id { nil }
    end

    trait :child do
      name { "Product Child" }
      parent_id { 1 }
    end
  end
end
