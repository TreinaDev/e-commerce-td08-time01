# Examples:
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

p 'Create products and prices'
product1 = Product.create!(status: 'on_shelf',
  name: 'Caneca Mon Amour', brand: 'TOC & Ex-TOC', sku: 'TOC1234',
  description: 'Caneca em cerâmica com desenho de uma flecha do cupido').set_price(10)

product2 = Product.create!(status: 'on_shelf',
  name: 'Garrafa Star Wars', brand: 'Zona Criativa', sku: 'ZON0001',
  description: 'Garrafa térmica inox, star wars')
Price.create!(product: product2, price_in_brl: 25.99, validity_start: Time.current)
Price.create!(product: product2, price_in_brl: 19.99, validity_start: 2.weeks.from_now)
Price.create!(product: product2, price_in_brl: 27.99, validity_start: 3.weeks.from_now)

product3 = Product.create!(status: 'off_shelf',
  name: 'Camisa Blue Sky', sku: 'VES1234', brand: 'Vestil',
  description: 'Camisa de algodão com estampa de céu e nuvens.').set_price(20)

product4 = Product.create!(status: 'draft',
  name: 'Camisa Green Forest', sku: 'VES4321',
  brand: 'Vestil',description: 'Camisa de algodão com estampa de floresta.').set_price(90)

product5 = Product.create!(status: 'on_shelf',
  name: 'Camisa Large Sea', sku: 'VES2321',
  brand: 'Vestil',description: 'Camisa de algodão com estampa do mar com ondas.').set_price(89)

p 'Create log-ins'
Admin.create(email: 'claudia@mercadores.com.br', password: '123456', name: 'Claudia Ferreira')
admin = Admin.create(email: 'manoel@mercadores.com.br', password: '123456', name: 'Manoel da Silva')
user = User.create(email: 'joaquim@meuemail.com.br', password: '123456', name: 'Joaquim Santos')

p 'Create Product categories'
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

p 'Create Carts and Orders'
CartItem.create!(product: product1, quantity: 5, user: user )
CartItem.create!(product: product2, quantity: 7, user: user )
Order.create!(address: 'Rua da entrega, 75', user: user)
CartItem.create!(product: product3, quantity: 5, user: user )
CartItem.create!(product: product1, quantity: 7, user: user )

p 'Sumário'
p "Foram criados #{Admin.count} admins"
p "Foram criados #{User.count} usuários"
p "Foram criados #{Product.count} produtos"
p "Foram criados um total de #{Price.count} preços para #{Price.select(:product_id).distinct.count} produtos"
p "Foram criadas #{ProductCategory.count} categorias de produtos"
p "Foram criadas #{CartItem.count} instâncias de item de carrinho"
p "Foram criadas #{Order.count} instâncias de pedidos"
