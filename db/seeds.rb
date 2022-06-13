# The data can then be loaded with the 
# $ bin/rails db:seed 
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Clean DB
ProductCategory.destroy_all
Product.destroy_all
User.destroy_all
Admin.destroy_all

# Create products
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

# Create log-ins
admin = Admin.create(email: 'manoel@mercadores.com.br', password: '123456', name: 'Manoel da Silva')
user = User.create(email: 'joaquim@meuemail.com.br', password: '123456', name: 'Joaquim Santos')

# Create ProductCategory
eletronicos = ProductCategory.create(name: "Eletrônicos")
informatica = ProductCategory.create(name: "Informática", parent: eletronicos)
notebooks = ProductCategory.create(name: "Notebooks", parent: informatica)
ultrafinos = ProductCategory.create(name: "Notebooks", parent: notebooks)
macbook = ProductCategory.create(name: "Notebooks", parent: macbook)
desktops = ProductCategory.create(name: "Desktops", parent: informatica)
smartphones = ProductCategory.create(name: "Smartphones", parent: eletronicos)

eletrodomesticos = ProductCategory.create(name: "Eletrodomésticos")
lavar_e_secar = ProductCategory.create(name: "Lavar e Secar", parent: eletrodomesticos)
geladeiras = ProductCategory.create(name: "Geladeiras", parent: eletrodomesticos)
fogao = ProductCategory.create(name: "Fogão", parent: eletrodomesticos)
ar_e_ventilacao = ProductCategory.create(name: "Ar e Ventilação", parent: eletrodomesticos)

moveis = ProductCategory.create(name: "Móveis")
mesa_escritorio = ProductCategory.create(name: "Mesa de Escritório", parent: moveis)
guarda_roupa = ProductCategory.create(name: "Guarda-roupa", parent: moveis)

p "Foram criados #{Admin.count} admins"
p "Foram criados #{User.count} usuários"
p "Foram criados #{Product.count} produtos"
p "Foram criadas #{ProductCategory.count} categorias de produtos"
