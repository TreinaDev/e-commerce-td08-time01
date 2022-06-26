FactoryBot.define do
  factory :exchange_rate do
    rate { 9.99 }
    registered_at_source_for { 1.day.ago }
  end
end
