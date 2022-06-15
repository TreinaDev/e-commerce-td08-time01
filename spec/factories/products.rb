FactoryBot.define do
  factory :product do
    name { "Caneca Mon Amour" }
    brand { "TOC & Ex-TOC" }
    description { "Caneca em cerâmica com desenho de uma flecha do cupido" }
    # preciso de id de categoria
    # para isso, preciso criar a categoria
  end
end
