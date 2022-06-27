FactoryBot.define do
  factory :promotion do
    start_date { 1.day.from_now }
    end_date { 3.days.from_now }
    name { "Dia das mães" }
    discount_percent { 10 }
    maximum_discount { "9.99" }
    absolute_discount_uses { 3000 }
  end
end
