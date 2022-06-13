# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create Admin
admin = Admin.create(email: 'manoel@mercadores.com.br', password: '123456', name: 'Manoel da Silva')
user = User.create(email: 'joaquim@meuemail.com.br', password: '123456', name: 'Joaquim Santos')

# ProductCategory
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



