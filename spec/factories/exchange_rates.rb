FactoryBot.define do
  factory :exchange_rate do
    rate { 9.99 }
    registered_at_source_for { "2022-06-25" }
  end
end
