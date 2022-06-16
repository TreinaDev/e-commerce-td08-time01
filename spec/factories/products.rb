FactoryBot.define do
  factory :product do
    name { "Caneca Mon Amour" }
    brand { "TOC & Ex-TOC" }
    description { "Caneca em cerâmica com desenho de uma flecha do cupido" }
    sku { "TOC1234" }
    status { "draft" }
  end
end
