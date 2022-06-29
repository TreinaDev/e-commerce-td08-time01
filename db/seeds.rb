# Examples:
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


puts "\n----- cria cadastros de usuários ------"

Admin.create(email: 'claudia@mercadores.com.br', password: '123456', name: 'Claudia Ferreira')
admin = Admin.create!(email: 'manoel@mercadores.com.br', password: '123456', name: 'Manoel da Silva')
user = User.create!(email: 'joaquim@meuemail.com.br', password: '123456', name: 'Joaquim Santos', identify_number: '06001818398')

puts '--------- cria taxa de câmbio ---------'

ExchangeRate.create!(rate: 2, registered_at_source_for: 1.day.ago)

puts '----- cria categorias de produtos -----'

eletronicos = ProductCategory.create(name: "Eletrônicos")
  smartphones = ProductCategory.create(name: "Smartphones", parent: eletronicos)
  informatica = ProductCategory.create(name: "Informática", parent: eletronicos)
    desktops = ProductCategory.create(name: "Desktops", parent: informatica)
    notebooks = ProductCategory.create(name: "Notebooks", parent: informatica)
      ultrafinos = ProductCategory.create(name: "Notebooks", parent: notebooks)
        macbook = ProductCategory.create(name: "Notebooks", parent: macbook)

eletrodomesticos = ProductCategory.create(name: "Eletrodomésticos")
  lavar_e_secar = ProductCategory.create(name: "Lavar e Secar", parent: eletrodomesticos)
  geladeiras = ProductCategory.create(name: "Geladeiras", parent: eletrodomesticos)
  fogao = ProductCategory.create(name: "Fogão", parent: eletrodomesticos)
  ar_e_ventilacao = ProductCategory.create(name: "Ar e Ventilação", parent: eletrodomesticos)

moveis = ProductCategory.create(name: "Móveis")
  mesa_escritorio = ProductCategory.create(name: "Mesa de Escritório", parent: moveis)
  guarda_roupa = ProductCategory.create(name: "Guarda-roupa", parent: moveis)

utilidades_domesticas = ProductCategory.create(name: "Utilidades Domésticas")
  cafe_e_cha = ProductCategory.create(name: "Café e Chá", parent: utilidades_domesticas)
    garrafas_termicas = ProductCategory.create(name: "Garrafas Térmicas", parent: cafe_e_cha)
  copos_e_canecas = ProductCategory.create(name: "Copos e Canecas", parent: utilidades_domesticas)
    canecas = ProductCategory.create(name: "Canecas", parent: copos_e_canecas)

vestuario = ProductCategory.create(name: "Vestuário")
  camisas = ProductCategory.create(name: "Camisas", parent: vestuario)
    camisas_basicas = ProductCategory.create(name: "Camisas Básicas", parent: camisas)

puts "---- cria um monte de cacarecos  ------"

names_and_descriptions = [
  # ['', ''], 
  [canecas, 'Caneca Sabre de Luz', 'Caneca em cerâmica com desenho de sabre de luz que se acende quando a caneca está quente.'],
  [cafe_e_cha, 'Xícara Levitadora', 'Par de duas xícaras em vidro transparente com parede dupla. Parece que seu café está flutuando!'],
  [cafe_e_cha, 'Conjunto Tóquio', 'Conjunto para chá em estilo japonês, feito inteiramente em ecoplástico e composto de 4 xícaras pequenas sem alça.'],
  [utilidades_domesticas, 'Pano das Galáxias', 'Pano de prato 100% algodão, na cor preta com desenhos de estrelas e cometas.'],
  [canecas, 'Caneca-bolo', 'Caneca em cerâmica com impressão de receita de bolo de caneca. Acompanha sachê com mistura para bolo, basta acrescentar água.'],
  [copos_e_canecas, 'Copo Sujo', 'Conjunto de 4 copos de 200ml iguaizinhos ao do boteco da esquina.'],
  [copos_e_canecas, 'Copo Sujo Super Power', 'Conjunto de 2 copos como os do boteco da esquina, mas de 400ml.'],
  [utilidades_domesticas, 'Protetor de mesa Bar do Lado', 'Conjunto de 5 protetores de mesa, também conhecidos como coasters, com impressões de rótulos de cervejas famosas'],
  [copos_e_canecas, 'Copo Colapsável EcoOffice', 'Nunca mais fique sem copo no bebedouro de galão! Este copo de 300ml se contrai a um disco que cabe em qualquer bolso. Aproveite esta novidade!'],
  [canecas, 'Codando Loucamente', 'Caneca com os dizeres "Talking is cheap, show me the code" em formatação de código'], 
  [nil, 'Adesivos Grumpy Bear', 'Cartela de adesivos do Brown, o urso rabugento mais fofo que você conhece, e seu novo contatinho Cony a Coelha. Mas não conte pra ninguém que eles estão saindo, ainda é segredo!'], 
  [vestuario, 'Fancy Napkings Silk Edition', 'Um lindo lenço branco rendado, em estilo vintage'], 
  [utilidades_domesticas, 'Love Book - A Luz', 'Fofíssima luminária led para livros, com garra para prender na capa, em forma de coração (que você nunca vai usar mesmo porque o último livro que você leu foi para prestar vestibular)'], 
  [cafe_e_cha, 'Pires Chá das 5', 'Pires de reposição para a Xícara Chá das 5'], 
  [cafe_e_cha, 'Xícara Chá das 5', 'Elegante xícara em fina cerâmica, para momentos elegantes ao tomar chá ou café.'], 
  [copos_e_canecas, 'Moonbucks', 'No melhor estilo das grandes lojas de café, este copo para bebidas quentes tem uma tampa de pequeno orifício, que permite tomar café em movimento sem se sujar.'], 
  [canecas, 'Caneca Coffee Lovers', 'Eu moo, tu fazes o café, nós tomamos! Esta caneca não pode faltar na sua mesa de café da manhã!'], 
  [garrafas_termicas, 'Caneca Térmica Hot Forever', 'Linda caneca térmica em aço inox, para compor um belo ambiente de trabalho na sua mesa de home office e ser ostentada furtivamente durante suas vídeo-conferências'], 
]

brands = ['Pensaminarium', 'Vesúvia', 'TOC & ex-TOC']

names_and_descriptions.each do | info |
  Product.create(status: 'on_shelf',
                product_category: info[0],
                name: info[1], 
                description: info[2], 
                brand: brands[rand(brands.size)],
                sku: ('a'..'z').to_a.shuffle[0..1].join.upcase + (SecureRandom.random_number * 10**7).to_i.to_s,
  ).set_brl_price(14 * (1 + rand(100)/100.0).truncate(2))
end

puts '----- cria mais produtos e preços -----'

product1 = Product.create!(status: 'on_shelf',
  name: 'Caneca Mon Amour', brand: 'TOC & Ex-TOC', sku: 'TOC1234',
  description: 'Caneca em cerâmica com desenho de uma flecha do cupido', product_category: canecas).set_brl_price(10)
  
product2 = Product.create!(status: 'on_shelf',
  name: 'Garrafa Star Wars', brand: 'Zona Criativa', sku: 'ZON0001',
  description: 'Garrafa térmica inox, star wars', product_category: garrafas_termicas)
Price.create!(product: product2, price_in_brl: 25.99, validity_start: Time.current)
Price.create!(product: product2, price_in_brl: 19.99, validity_start: 2.weeks.from_now)
Price.create!(product: product2, price_in_brl: 27.99, validity_start: 3.weeks.from_now)

product3 = Product.create!(status: 'off_shelf',
  name: 'Camisa Blue Sky', sku: 'VES1234', brand: 'Vestil',
  description: 'Camisa de algodão com estampa de céu e nuvens.', product_category: camisas_basicas).set_brl_price(20)

product4 = Product.create!(status: 'draft',
  name: 'Camisa Green Forest', sku: 'VES4321',
  brand: 'Vestil',description: 'Camisa de algodão com estampa de floresta.', product_category: camisas_basicas).set_brl_price(90)

product5 = Product.create!(status: 'on_shelf',
  name: 'Camisa Large Sea', sku: 'VES2321',
  brand: 'Vestil',description: 'Camisa de algodão com estampa do mar com ondas.', product_category: camisas_basicas).set_brl_price(89)

puts '----------- cria pedidos --------------'

CartItem.create!(product: product1, quantity: 5, user: user)
CartItem.create!(product: product2, quantity: 7, user: user)
order1 = Order.new(address: 'Rua da entrega, 75', user: user)
order1.skip_callback = true
order1.save!

CartItem.create!(product: product3, quantity: 1, user: user)
CartItem.create!(product: product4, quantity: 3, user: user)
order2 = Order.new(address: 'Rua da Paz, 42 - Belém, PA', user: user)
order2.skip_callback = true
order2.save!
order2.approved!

CartItem.create!(product: product5, quantity: 6, user: user)
order3 = Order.new(address: 'Rua do Bailão de Domingo - Erechim, RS', user: user)
order3.skip_callback = true
order3.save!
order3.update!(status: 'canceled', error_type: 'insufficient_funds')

puts "\nSumário"
puts "Foram criadas #{ExchangeRate.all.size} taxas de câmbio"
puts "Foram criados #{Admin.all.size} admins"
puts "Foram criados #{User.all.size} cadastros de clientes"
puts "Foram criados #{Product.all.size} produtos"
puts "Foram criados um total de #{Price.all.size} preços para #{Price.select(:product_id).distinct.all.size} produtos"
puts "Foram criadas #{ProductCategory.all.size} categorias de produtos"
puts "Foram colocados #{CartItem.all.size} itens em carrinhos"
puts "Foram criados #{Order.all.size} pedidos"