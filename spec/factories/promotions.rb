FactoryBot.define do
  factory :promotion do
    start_date { 1.second.ago }
    end_date { 3.days.from_now }
    name { "Dia das mães" }
    discount_percent { 10 }
    maximum_discount { "35.00" }
    absolute_discount_uses { 3000 }
  end
end
