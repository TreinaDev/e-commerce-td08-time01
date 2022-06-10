# The data can then be loaded with the 
# $ bin/rails db:seed 
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Product.destroy_all

Product.create!(name: 'Caneca Mon Amour', 
                brand: 'TOC & Ex-TOC',
                description: 'Caneca em cerâmica com desenho de uma flecha do cupido',
                sku: 'TOC1234'
)
Product.create!(name: 'Garrafa Star Wars', 
                brand: 'Zona Criativa',
                description: 'Garrafa térmica inox, star wars',
                sku: 'ZON0001'
)

p "Foram criados #{Product.count} produtos"