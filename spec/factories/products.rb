FactoryBot.define do
  factory :product do
    name { "Caneca Mon Amour" }
    brand { "TOC & Ex-TOC" }
    description { "Caneca em cerâmica com desenho de uma flecha do cupido" }
    sku { ('a'..'z').to_a.shuffle[0..1].join.upcase + (SecureRandom.random_number * 10**4).to_i.to_s }
  end
end
