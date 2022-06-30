FactoryBot.define do
  factory :order do
    user 
    address { "Rua da Entrega, 54" }
    price_on_purchase { 100 }
  end
end
